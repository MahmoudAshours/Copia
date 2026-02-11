import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import '../db/app_database.dart';
import 'file_storage_service.dart';

class CopiaPackageService {
  CopiaPackageService({
    required AppDatabase database,
    required FileStorageService fileStorageService,
  }) : _database = database,
       _fileStorageService = fileStorageService;

  static const int _manifestVersion = 2;
  static const String _appBuild = '2.0.0+1';

  final AppDatabase _database;
  final FileStorageService _fileStorageService;

  Future<File> exportDocumentPackage(int documentId) async {
    final document = await (_database.select(
      _database.documents,
    )..where((t) => t.id.equals(documentId))).getSingle();
    final attachment = await (_database.select(
      _database.attachments,
    )..where((t) => t.documentId.equals(documentId))).getSingleOrNull();
    final notes = await (_database.select(
      _database.notes,
    )..where((t) => t.documentId.equals(documentId))).get();
    final bookmarks = await (_database.select(
      _database.bookmarks,
    )..where((t) => t.documentId.equals(documentId))).get();
    final strokes = await (_database.select(
      _database.annotationStrokes,
    )..where((t) => t.documentId.equals(documentId))).get();
    final transforms = await (_database.select(
      _database.pageTransforms,
    )..where((t) => t.documentId.equals(documentId))).get();

    final archive = Archive();
    final includedAssets = <String, Map<String, Object>>{};

    void addIfExists(String archivePath, String? filePath) {
      if (filePath == null) {
        return;
      }
      final file = File(filePath);
      if (!file.existsSync()) {
        return;
      }
      final bytes = file.readAsBytesSync();
      archive.addFile(ArchiveFile(archivePath, bytes.length, bytes));
      includedAssets[archivePath] = <String, Object>{
        'bytes': bytes.length,
        'sha256': _sha256(bytes),
        'extension': p.extension(file.path),
      };
    }

    addIfExists('files/document.pdf', document.pdfPath);
    addIfExists(
      'files/thumb${p.extension(document.thumbPath ?? '.png')}',
      document.thumbPath,
    );
    addIfExists(
      'files/audio${p.extension(attachment?.audioPath ?? '.mp3')}',
      attachment?.audioPath,
    );
    addIfExists(
      'files/support${p.extension(attachment?.docPath ?? '.txt')}',
      attachment?.docPath,
    );

    final baseManifest = <String, dynamic>{
      'version': _manifestVersion,
      'appBuild': _appBuild,
      'exportedAt': DateTime.now().toIso8601String(),
      'documentMeta': {
        'title': document.title,
        'lastPage': document.lastPage,
        'totalReadSeconds': document.totalReadSeconds,
      },
      'includedAssets': includedAssets,
      'bookmarks': bookmarks.map((b) => b.page).toList(),
      'notes': notes
          .map(
            (n) => {
              'page': n.page,
              'content': n.content,
              'updatedAt': n.updatedAt.toIso8601String(),
            },
          )
          .toList(),
      'strokes': strokes
          .map(
            (s) => {
              'page': s.page,
              'toolType': s.toolType,
              'colorValue': s.colorValue,
              'width': s.width,
              'opacity': s.opacity,
              'pointsJson': s.pointsJson,
            },
          )
          .toList(),
      'pageTransforms': transforms
          .map((t) => {'page': t.page, 'rotationDegrees': t.rotationDegrees})
          .toList(),
    };

    final manifest = Map<String, dynamic>.from(baseManifest);
    manifest['checksum'] = _manifestChecksum(baseManifest);

    final manifestBytes = utf8.encode(_canonicalJson(manifest));
    archive.addFile(
      ArchiveFile('manifest.json', manifestBytes.length, manifestBytes),
    );

    final bytes = ZipEncoder().encode(archive);
    if (bytes == null) {
      throw StateError('Could not encode .copia package');
    }

    return _fileStorageService.saveBytesToManagedStorage(
      bytes: bytes,
      folder: 'packages',
      extension: '.copia',
    );
  }

  Future<int> importPackage(String packagePath) async {
    final packageFile = File(packagePath);
    if (!packageFile.existsSync()) {
      throw StateError('Package file does not exist');
    }

    final archive = ZipDecoder().decodeBytes(packageFile.readAsBytesSync());
    final manifestEntry = archive.findFile('manifest.json');
    if (manifestEntry == null) {
      throw StateError('Invalid package: missing manifest');
    }

    final manifestText = utf8.decode(manifestEntry.content as List<int>);
    final manifest = jsonDecode(manifestText) as Map<String, dynamic>;

    _validateManifest(manifest);

    final documentMeta =
        (manifest['documentMeta'] as Map<String, dynamic>?) ??
        <String, dynamic>{};
    final originalTitle =
        (documentMeta['title'] as String?) ??
        (manifest['title'] as String?) ??
        'Imported Copia Document';
    final title = await _resolveKeepBothTitle(originalTitle);

    final includedAssets =
        (manifest['includedAssets'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};

    String? pdfPath;
    String? thumbPath;
    String? audioPath;
    String? docPath;

    for (final file in archive.files) {
      if (!file.isFile) {
        continue;
      }
      final content = file.content as List<int>;
      if (file.name == 'manifest.json') {
        continue;
      }

      _verifyAssetChecksumIfPresent(
        includedAssets: includedAssets,
        archivePath: file.name,
        content: content,
      );

      if (file.name == 'files/document.pdf') {
        pdfPath = (await _fileStorageService.saveBytesToManagedStorage(
          bytes: content,
          folder: 'pdfs',
          extension: '.pdf',
        )).path;
      } else if (file.name.startsWith('files/thumb')) {
        thumbPath = (await _fileStorageService.saveBytesToManagedStorage(
          bytes: content,
          folder: 'thumbs',
          extension: p.extension(file.name),
        )).path;
      } else if (file.name.startsWith('files/audio')) {
        audioPath = (await _fileStorageService.saveBytesToManagedStorage(
          bytes: content,
          folder: 'audio',
          extension: p.extension(file.name),
        )).path;
      } else if (file.name.startsWith('files/support')) {
        docPath = (await _fileStorageService.saveBytesToManagedStorage(
          bytes: content,
          folder: 'docs',
          extension: p.extension(file.name),
        )).path;
      }
    }

    if (pdfPath == null) {
      throw StateError('Invalid package: missing PDF content');
    }

    final importedId = await _database.createDocument(
      title: title,
      pdfPath: pdfPath,
      thumbPath: thumbPath,
    );

    if (audioPath != null) {
      await _database.setAudioPath(importedId, audioPath);
    }
    if (docPath != null) {
      await _database.setDocPath(importedId, docPath);
    }

    final bookmarkPages =
        (manifest['bookmarks'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<int>();
    for (final page in bookmarkPages) {
      await _database.addBookmark(documentId: importedId, page: page);
    }

    final notes = manifest['notes'] as List<dynamic>? ?? const <dynamic>[];
    for (final note in notes) {
      if (note is! Map<String, dynamic>) {
        continue;
      }
      final page = note['page'];
      final content = note['content'];
      if (page is int && content is String) {
        await _database.upsertNote(
          documentId: importedId,
          page: page,
          content: content,
        );
      }
    }

    final strokes = manifest['strokes'] as List<dynamic>? ?? const <dynamic>[];
    for (final stroke in strokes) {
      if (stroke is! Map<String, dynamic>) {
        continue;
      }
      final rawPoints = stroke['pointsJson'];
      final pointsList = <OffsetPoint>[];
      if (rawPoints is String) {
        final decoded = jsonDecode(rawPoints) as List<dynamic>;
        for (final p in decoded) {
          if (p is Map<String, dynamic>) {
            pointsList.add(OffsetPoint.fromJson(p));
          }
        }
      }

      await _database.addStroke(
        documentId: importedId,
        page: stroke['page'] as int? ?? 1,
        toolType: stroke['toolType'] as String? ?? 'marker',
        colorValue: stroke['colorValue'] as int? ?? 0xFFFFEA00,
        width: (stroke['width'] as num?)?.toDouble() ?? 8,
        opacity: (stroke['opacity'] as num?)?.toDouble() ?? 0.5,
        points: pointsList,
      );
    }

    final transforms =
        manifest['pageTransforms'] as List<dynamic>? ?? const <dynamic>[];
    for (final transform in transforms) {
      if (transform is! Map<String, dynamic>) {
        continue;
      }
      final page = transform['page'];
      final rotation = transform['rotationDegrees'];
      if (page is int && rotation is int) {
        await _database.setRotationForPage(
          documentId: importedId,
          page: page,
          degrees: rotation,
        );
      }
    }

    return importedId;
  }

  void _validateManifest(Map<String, dynamic> manifest) {
    final version = manifest['version'];
    if (version is! int) {
      throw StateError('Invalid package manifest: missing version');
    }
    if (version > _manifestVersion) {
      throw StateError(
        'Unsupported package version ($version). Update Copia first.',
      );
    }

    final checksum = manifest['checksum'];
    if (version >= 2) {
      if (checksum is! String || checksum.trim().isEmpty) {
        throw StateError('Invalid package manifest: missing checksum');
      }
      final base = Map<String, dynamic>.from(manifest)..remove('checksum');
      final expected = _manifestChecksum(base);
      if (checksum != expected) {
        throw StateError('Package checksum mismatch. File may be corrupted.');
      }
    }
  }

  void _verifyAssetChecksumIfPresent({
    required Map<String, dynamic> includedAssets,
    required String archivePath,
    required List<int> content,
  }) {
    final meta = includedAssets[archivePath];
    if (meta is! Map<String, dynamic>) {
      return;
    }
    final expectedHash = meta['sha256'];
    if (expectedHash is! String || expectedHash.isEmpty) {
      return;
    }
    final actualHash = _sha256(content);
    if (actualHash != expectedHash) {
      throw StateError(
        'Package asset checksum mismatch for "$archivePath". Import aborted.',
      );
    }
  }

  Future<String> _resolveKeepBothTitle(String baseTitle) async {
    final rows = await _database.select(_database.documents).get();
    final titles = rows.map((e) => e.title).toSet();
    if (!titles.contains(baseTitle)) {
      return baseTitle;
    }
    var i = 2;
    while (titles.contains('$baseTitle (Imported $i)')) {
      i++;
    }
    return '$baseTitle (Imported $i)';
  }

  String _manifestChecksum(Map<String, dynamic> manifestWithoutChecksum) {
    return _sha256(utf8.encode(_canonicalJson(manifestWithoutChecksum)));
  }

  String _sha256(List<int> bytes) => sha256.convert(bytes).toString();

  String _canonicalJson(Object? value) {
    final sorted = _sortedValue(value);
    return jsonEncode(sorted);
  }

  Object? _sortedValue(Object? value) {
    if (value is Map) {
      final sorted = SplayTreeMap<String, Object?>();
      for (final entry in value.entries) {
        sorted[entry.key.toString()] = _sortedValue(entry.value);
      }
      return sorted;
    }
    if (value is List) {
      return value.map(_sortedValue).toList();
    }
    return value;
  }
}
