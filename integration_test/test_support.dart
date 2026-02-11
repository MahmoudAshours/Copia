import 'dart:io';

import 'package:copia/core/db/app_database.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class SeededDocument {
  const SeededDocument({
    required this.id,
    required this.title,
    required this.pdfPath,
    required this.docPath,
  });

  final int id;
  final String title;
  final String pdfPath;
  final String docPath;
}

Future<void> resetAppState({bool onboardingSeen = true}) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final dbFile = File(p.join(docsDir.path, 'copia.sqlite'));
  if (dbFile.existsSync()) {
    await dbFile.delete();
  }

  final filesRoot = Directory(p.join(docsDir.path, 'copia_files'));
  if (filesRoot.existsSync()) {
    await filesRoot.delete(recursive: true);
  }

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await prefs.setBool('onboarding_seen', onboardingSeen);
}

Future<SeededDocument> seedReaderDocument({
  String title = 'Integration Reader Doc',
}) async {
  await resetAppState();
  final pdfPath = await _createPdfFile(fileName: 'reader_seed.pdf');
  final docPath = await _createTextFile(
    fileName: 'reader_seed.txt',
    text:
        'Chapter One\n\nCopia queue integration text.\n\nChapter Two\n\nMore text.',
  );

  final db = AppDatabase();
  try {
    await db.initDefaults();
    final id = await db.createDocument(title: title, pdfPath: pdfPath);
    await db.setDocPath(id, docPath);
    return SeededDocument(
      id: id,
      title: title,
      pdfPath: pdfPath,
      docPath: docPath,
    );
  } finally {
    await db.close();
  }
}

Future<SeededDocument> seedStatsScenario({
  String title = 'Integration Stats Doc',
}) async {
  await resetAppState();
  final pdfPath = await _createPdfFile(fileName: 'stats_seed.pdf');
  final docPath = await _createTextFile(
    fileName: 'stats_seed.txt',
    text: 'Stats seed text',
  );

  final db = AppDatabase();
  try {
    await db.initDefaults();
    final id = await db.createDocument(title: title, pdfPath: pdfPath);
    await db.setDocPath(id, docPath);
    await db.addBookmark(documentId: id, page: 1);
    await db.upsertNote(documentId: id, page: 1, content: 'stats note');

    final now = DateTime.now();
    for (var daysAgo = 2; daysAgo >= 0; daysAgo--) {
      final end = DateTime(now.year, now.month, now.day - daysAgo, 12, 0);
      final start = end.subtract(const Duration(minutes: 35));
      await db.recordReadingSession(
        documentId: id,
        startedAt: start,
        endedAt: end,
        pagesRead: 12,
      );
    }
    return SeededDocument(
      id: id,
      title: title,
      pdfPath: pdfPath,
      docPath: docPath,
    );
  } finally {
    await db.close();
  }
}

Future<String> _createPdfFile({required String fileName}) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final pdfDir = Directory(p.join(docsDir.path, 'copia_files', 'pdfs'));
  if (!pdfDir.existsSync()) {
    await pdfDir.create(recursive: true);
  }

  final document = PdfDocument();
  for (var i = 0; i < 2; i++) {
    final page = document.pages.add();
    page.graphics.drawString(
      'Copia Integration Page ${i + 1}',
      PdfStandardFont(PdfFontFamily.helvetica, 18),
    );
  }
  final bytes = await document.save();
  document.dispose();

  final file = File(p.join(pdfDir.path, fileName));
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

Future<String> _createTextFile({
  required String fileName,
  required String text,
}) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final docDir = Directory(p.join(docsDir.path, 'copia_files', 'docs'));
  if (!docDir.existsSync()) {
    await docDir.create(recursive: true);
  }
  final file = File(p.join(docDir.path, fileName));
  await file.writeAsString(text, flush: true);
  return file.path;
}
