import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get pdfPath => text()();
  TextColumn get thumbPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastOpenedAt => dateTime().nullable()();
  IntColumn get lastPage => integer().withDefault(const Constant(1))();
  IntColumn get totalReadSeconds => integer().withDefault(const Constant(0))();
  BoolColumn get missingFiles => boolean().withDefault(const Constant(false))();
}

class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get documentId =>
      integer().references(Documents, #id, onDelete: KeyAction.cascade)();
  IntColumn get page => integer()();

  @override
  List<String> get customConstraints => const ['UNIQUE(document_id, page)'];
}

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get documentId =>
      integer().references(Documents, #id, onDelete: KeyAction.cascade)();
  IntColumn get page => integer()();
  TextColumn get content => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<String> get customConstraints => const ['UNIQUE(document_id, page)'];
}

class Attachments extends Table {
  IntColumn get documentId =>
      integer().references(Documents, #id, onDelete: KeyAction.cascade)();
  TextColumn get audioPath => text().nullable()();
  TextColumn get docPath => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {documentId};
}

class AnnotationStrokes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get documentId =>
      integer().references(Documents, #id, onDelete: KeyAction.cascade)();
  IntColumn get page => integer()();
  TextColumn get toolType => text()();
  IntColumn get colorValue => integer()();
  RealColumn get width => real()();
  RealColumn get opacity => real()();
  TextColumn get pointsJson => text()();
}

class PageTransforms extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get documentId =>
      integer().references(Documents, #id, onDelete: KeyAction.cascade)();
  IntColumn get page => integer()();
  IntColumn get rotationDegrees => integer().withDefault(const Constant(0))();

  @override
  List<String> get customConstraints => const ['UNIQUE(document_id, page)'];
}

class ReadingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get documentId =>
      integer().references(Documents, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  IntColumn get readSeconds => integer()();
  IntColumn get pagesRead => integer()();
}

class DailyStats extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get day => dateTime()();
  IntColumn get readSeconds => integer().withDefault(const Constant(0))();
  IntColumn get pagesRead => integer().withDefault(const Constant(0))();
  IntColumn get notesCount => integer().withDefault(const Constant(0))();
  IntColumn get bookmarkCount => integer().withDefault(const Constant(0))();
  IntColumn get streakDay => integer().withDefault(const Constant(0))();

  @override
  List<String> get customConstraints => const ['UNIQUE(day)'];
}

class Trophies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()();
  DateTimeColumn get earnedAt => dateTime()();

  @override
  List<String> get customConstraints => const ['UNIQUE(code)'];
}

class NotificationPreferences extends Table {
  IntColumn get id => integer()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  TextColumn get localTime => text().withDefault(const Constant('20:00'))();
  BoolColumn get streakEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get completionEnabled =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Documents,
    Bookmarks,
    Notes,
    Attachments,
    AnnotationStrokes,
    PageTransforms,
    ReadingSessions,
    DailyStats,
    Trophies,
    NotificationPreferences,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  // ignore: use_super_parameters
  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  Future<void> initDefaults() async {
    await into(notificationPreferences).insertOnConflictUpdate(
      const NotificationPreferencesCompanion(id: Value(1)),
    );
  }

  Stream<List<Document>> watchDocuments() {
    final q = select(documents)
      ..orderBy([
        (t) => OrderingTerm.desc(t.lastOpenedAt),
        (t) => OrderingTerm.desc(t.createdAt),
      ]);
    return q.watch();
  }

  Stream<Document?> watchDocument(int id) {
    final q = select(documents)..where((t) => t.id.equals(id));
    return q.watchSingleOrNull();
  }

  Future<int> createDocument({
    required String title,
    required String pdfPath,
    String? thumbPath,
  }) {
    return into(documents).insert(
      DocumentsCompanion.insert(
        title: title,
        pdfPath: pdfPath,
        thumbPath: Value(thumbPath),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> deleteDocumentById(int id) async {
    await (delete(documents)..where((t) => t.id.equals(id))).go();
  }

  Future<void> updateDocumentOpenState({
    required int documentId,
    required int lastPage,
  }) async {
    await (update(documents)..where((t) => t.id.equals(documentId))).write(
      DocumentsCompanion(
        lastOpenedAt: Value(DateTime.now()),
        lastPage: Value(lastPage),
      ),
    );
  }

  Stream<List<int>> watchBookmarks(int documentId) {
    final q = select(bookmarks)
      ..where((t) => t.documentId.equals(documentId))
      ..orderBy([(t) => OrderingTerm.asc(t.page)]);
    return q.watch().map((rows) => rows.map((e) => e.page).toList());
  }

  Future<void> addBookmark({required int documentId, required int page}) async {
    await into(bookmarks).insert(
      BookmarksCompanion.insert(documentId: documentId, page: page),
      mode: InsertMode.insertOrIgnore,
    );
    await _refreshDailyCounters();
  }

  Future<void> removeBookmark({
    required int documentId,
    required int page,
  }) async {
    await (delete(bookmarks)
          ..where((t) => t.documentId.equals(documentId) & t.page.equals(page)))
        .go();
    await _refreshDailyCounters();
  }

  Stream<List<Note>> watchNotes(int documentId) {
    final q = select(notes)
      ..where((t) => t.documentId.equals(documentId))
      ..orderBy([(t) => OrderingTerm.asc(t.page)]);
    return q.watch();
  }

  Future<Note?> findNote(int documentId, int page) {
    final q = select(notes)
      ..where((t) => t.documentId.equals(documentId) & t.page.equals(page));
    return q.getSingleOrNull();
  }

  Future<void> upsertNote({
    required int documentId,
    required int page,
    required String content,
  }) async {
    final existing = await findNote(documentId, page);
    if (existing == null) {
      await into(notes).insert(
        NotesCompanion.insert(
          documentId: documentId,
          page: page,
          content: content,
          updatedAt: DateTime.now(),
        ),
      );
    } else {
      await (update(notes)..where((t) => t.id.equals(existing.id))).write(
        NotesCompanion(
          content: Value(content),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
    await _refreshDailyCounters();
  }

  Future<void> deleteNote({required int documentId, required int page}) async {
    await (delete(notes)
          ..where((t) => t.documentId.equals(documentId) & t.page.equals(page)))
        .go();
    await _refreshDailyCounters();
  }

  Future<void> _ensureAttachment(int documentId) async {
    final existing = await (select(
      attachments,
    )..where((t) => t.documentId.equals(documentId))).getSingleOrNull();
    if (existing == null) {
      await into(
        attachments,
      ).insert(AttachmentsCompanion.insert(documentId: Value(documentId)));
    }
  }

  Stream<Attachment?> watchAttachment(int documentId) {
    final q = select(attachments)
      ..where((t) => t.documentId.equals(documentId));
    return q.watchSingleOrNull();
  }

  Future<void> setAudioPath(int documentId, String? audioPath) async {
    await _ensureAttachment(documentId);
    await (update(attachments)..where((t) => t.documentId.equals(documentId)))
        .write(AttachmentsCompanion(audioPath: Value(audioPath)));
  }

  Future<void> setDocPath(int documentId, String? docPath) async {
    await _ensureAttachment(documentId);
    await (update(attachments)..where((t) => t.documentId.equals(documentId)))
        .write(AttachmentsCompanion(docPath: Value(docPath)));
  }

  Stream<List<AnnotationStroke>> watchStrokes({
    required int documentId,
    required int page,
  }) {
    final q = select(annotationStrokes)
      ..where((t) => t.documentId.equals(documentId) & t.page.equals(page));
    return q.watch();
  }

  Future<void> addStroke({
    required int documentId,
    required int page,
    required String toolType,
    required int colorValue,
    required double width,
    required double opacity,
    required List<OffsetPoint> points,
  }) {
    final serialized = jsonEncode(points.map((p) => p.toJson()).toList());
    return into(annotationStrokes).insert(
      AnnotationStrokesCompanion.insert(
        documentId: documentId,
        page: page,
        toolType: toolType,
        colorValue: colorValue,
        width: width,
        opacity: opacity,
        pointsJson: serialized,
      ),
    );
  }

  Future<void> clearPageStrokes({required int documentId, required int page}) {
    return (delete(annotationStrokes)
          ..where((t) => t.documentId.equals(documentId) & t.page.equals(page)))
        .go();
  }

  Future<void> clearPageStrokesByTool({
    required int documentId,
    required int page,
    required String toolType,
  }) {
    return (delete(annotationStrokes)..where(
          (t) =>
              t.documentId.equals(documentId) &
              t.page.equals(page) &
              t.toolType.equals(toolType),
        ))
        .go();
  }

  Future<void> deleteLastStroke({
    required int documentId,
    required int page,
  }) async {
    final last =
        await (select(annotationStrokes)
              ..where(
                (t) => t.documentId.equals(documentId) & t.page.equals(page),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.id)]))
            .getSingleOrNull();
    if (last == null) {
      return;
    }
    await (delete(annotationStrokes)..where((t) => t.id.equals(last.id))).go();
  }

  Future<void> deleteLastStrokeByTool({
    required int documentId,
    required int page,
    required String toolType,
  }) async {
    final last =
        await (select(annotationStrokes)
              ..where(
                (t) =>
                    t.documentId.equals(documentId) &
                    t.page.equals(page) &
                    t.toolType.equals(toolType),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.id)]))
            .getSingleOrNull();
    if (last == null) {
      return;
    }
    await (delete(annotationStrokes)..where((t) => t.id.equals(last.id))).go();
  }

  Future<void> deleteStrokeById(int strokeId) {
    return (delete(
      annotationStrokes,
    )..where((t) => t.id.equals(strokeId))).go();
  }

  Future<int> rotationForPage({
    required int documentId,
    required int page,
  }) async {
    final row =
        await (select(pageTransforms)..where(
              (t) => t.documentId.equals(documentId) & t.page.equals(page),
            ))
            .getSingleOrNull();
    return row?.rotationDegrees ?? 0;
  }

  Future<void> setRotationForPage({
    required int documentId,
    required int page,
    required int degrees,
  }) async {
    final existing =
        await (select(pageTransforms)..where(
              (t) => t.documentId.equals(documentId) & t.page.equals(page),
            ))
            .getSingleOrNull();
    if (existing == null) {
      await into(pageTransforms).insert(
        PageTransformsCompanion.insert(
          documentId: documentId,
          page: page,
          rotationDegrees: Value(degrees % 360),
        ),
      );
      return;
    }

    await (update(pageTransforms)..where((t) => t.id.equals(existing.id)))
        .write(PageTransformsCompanion(rotationDegrees: Value(degrees % 360)));
  }

  Stream<List<DailyStat>> watchDailyStats() {
    final q = select(dailyStats)..orderBy([(t) => OrderingTerm.asc(t.day)]);
    return q.watch();
  }

  Stream<List<Trophy>> watchTrophies() {
    final q = select(trophies)..orderBy([(t) => OrderingTerm.desc(t.earnedAt)]);
    return q.watch();
  }

  Future<void> recordReadingSession({
    required int documentId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int pagesRead,
  }) async {
    final seconds = endedAt.difference(startedAt).inSeconds.clamp(0, 1 << 31);
    final day = _normalizeDay(endedAt);

    await transaction(() async {
      await into(readingSessions).insert(
        ReadingSessionsCompanion.insert(
          documentId: documentId,
          startedAt: startedAt,
          endedAt: endedAt,
          readSeconds: seconds,
          pagesRead: pagesRead,
        ),
      );

      final document = await (select(
        documents,
      )..where((t) => t.id.equals(documentId))).getSingle();
      await (update(documents)..where((t) => t.id.equals(documentId))).write(
        DocumentsCompanion(
          totalReadSeconds: Value(document.totalReadSeconds + seconds),
          lastOpenedAt: Value(endedAt),
        ),
      );

      final stat = await (select(
        dailyStats,
      )..where((t) => t.day.equals(day))).getSingleOrNull();

      if (stat == null) {
        await into(dailyStats).insert(
          DailyStatsCompanion.insert(
            day: day,
            readSeconds: Value(seconds),
            pagesRead: Value(pagesRead),
          ),
        );
      } else {
        await (update(dailyStats)..where((t) => t.id.equals(stat.id))).write(
          DailyStatsCompanion(
            readSeconds: Value(stat.readSeconds + seconds),
            pagesRead: Value(stat.pagesRead + pagesRead),
          ),
        );
      }
    });

    await _refreshDailyCounters();
    await _recomputeStreak();
    await _unlockTrophies();
  }

  Future<DashboardStats> getDashboardStats() async {
    final docs = await select(documents).get();
    final stats = await select(dailyStats).get();
    final trophyRows = await select(trophies).get();
    final bookmarksCount = await customSelect(
      'SELECT COUNT(*) AS c FROM bookmarks',
      readsFrom: {bookmarks},
    ).getSingle();
    final notesCount = await customSelect(
      'SELECT COUNT(*) AS c FROM notes',
      readsFrom: {notes},
    ).getSingle();

    final totalSeconds = docs.fold<int>(
      0,
      (acc, doc) => acc + doc.totalReadSeconds,
    );
    final streak = stats.isEmpty ? 0 : stats.last.streakDay;
    final longestStreak = stats.isEmpty
        ? 0
        : stats
              .map((row) => row.streakDay)
              .fold<int>(0, (acc, value) => value > acc ? value : acc);
    final pagesReadTotal = stats.fold<int>(
      0,
      (acc, row) => acc + row.pagesRead,
    );

    return DashboardStats(
      totalDocuments: docs.length,
      totalReadSeconds: totalSeconds,
      totalBookmarks: bookmarksCount.read<int>('c'),
      totalNotes: notesCount.read<int>('c'),
      streakDays: streak,
      longestStreakDays: longestStreak,
      pagesReadTotal: pagesReadTotal,
      trophiesCount: trophyRows.length,
    );
  }

  Future<void> markMissingFiles() async {
    final docs = await select(documents).get();
    for (final doc in docs) {
      final pdfExists = File(doc.pdfPath).existsSync();
      final thumbExists =
          doc.thumbPath == null || File(doc.thumbPath!).existsSync();
      final attach = await (select(
        attachments,
      )..where((t) => t.documentId.equals(doc.id))).getSingleOrNull();
      final audioExists =
          attach?.audioPath == null || File(attach!.audioPath!).existsSync();
      final fileExists =
          attach?.docPath == null || File(attach!.docPath!).existsSync();
      final missing = !(pdfExists && thumbExists && audioExists && fileExists);

      if (doc.missingFiles != missing) {
        await (update(documents)..where((t) => t.id.equals(doc.id))).write(
          DocumentsCompanion(missingFiles: Value(missing)),
        );
      }
    }
  }

  Future<NotificationPreference> getNotificationPreference() async {
    await initDefaults();
    return (select(
      notificationPreferences,
    )..where((t) => t.id.equals(1))).getSingle();
  }

  Future<void> updateNotificationPreference(
    NotificationPreferencesCompanion companion,
  ) async {
    await initDefaults();
    await (update(
      notificationPreferences,
    )..where((t) => t.id.equals(1))).write(companion);
  }

  Future<void> _refreshDailyCounters() async {
    final today = _normalizeDay(DateTime.now());
    final stat = await (select(
      dailyStats,
    )..where((t) => t.day.equals(today))).getSingleOrNull();
    if (stat == null) {
      return;
    }
    final notesCount = await customSelect(
      'SELECT COUNT(*) AS c FROM notes',
      readsFrom: {notes},
    ).getSingle();
    final bookmarkCount = await customSelect(
      'SELECT COUNT(*) AS c FROM bookmarks',
      readsFrom: {bookmarks},
    ).getSingle();

    await (update(dailyStats)..where((t) => t.id.equals(stat.id))).write(
      DailyStatsCompanion(
        notesCount: Value(notesCount.read<int>('c')),
        bookmarkCount: Value(bookmarkCount.read<int>('c')),
      ),
    );
  }

  Future<void> _recomputeStreak() async {
    final rows = await (select(
      dailyStats,
    )..orderBy([(t) => OrderingTerm.asc(t.day)])).get();
    if (rows.isEmpty) {
      return;
    }
    var streak = 0;
    DateTime? previous;
    for (final row in rows) {
      if (previous == null) {
        streak = 1;
      } else {
        final delta = row.day.difference(previous).inDays;
        streak = delta == 1 ? streak + 1 : 1;
      }
      previous = row.day;
      await (update(dailyStats)..where((t) => t.id.equals(row.id))).write(
        DailyStatsCompanion(streakDay: Value(streak)),
      );
    }
  }

  Future<void> _unlockTrophies() async {
    final stats = await getDashboardStats();
    final candidates = <String>[];
    if (stats.streakDays >= 3) {
      candidates.add('streak_3');
    }
    if (stats.streakDays >= 7) {
      candidates.add('streak_7');
    }
    if (stats.totalReadSeconds >= 3600) {
      candidates.add('read_1h');
    }
    if (stats.streakDays >= 14) {
      candidates.add('streak_14');
    }
    if (stats.totalReadSeconds >= 5 * 3600) {
      candidates.add('read_5h');
    }
    if (stats.pagesReadTotal >= 100) {
      candidates.add('pages_100');
    }
    if (stats.totalNotes >= 25) {
      candidates.add('notes_25');
    }
    for (final code in candidates) {
      await into(trophies).insert(
        TrophiesCompanion.insert(code: code, earnedAt: DateTime.now()),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  DateTime _normalizeDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}

class OffsetPoint {
  const OffsetPoint({required this.dx, required this.dy});

  final double dx;
  final double dy;

  factory OffsetPoint.fromJson(Map<String, dynamic> json) {
    return OffsetPoint(
      dx: (json['dx'] as num).toDouble(),
      dy: (json['dy'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'dx': dx, 'dy': dy};
}

class DashboardStats {
  const DashboardStats({
    required this.totalDocuments,
    required this.totalReadSeconds,
    required this.totalBookmarks,
    required this.totalNotes,
    required this.streakDays,
    required this.longestStreakDays,
    required this.pagesReadTotal,
    required this.trophiesCount,
  });

  final int totalDocuments;
  final int totalReadSeconds;
  final int totalBookmarks;
  final int totalNotes;
  final int streakDays;
  final int longestStreakDays;
  final int pagesReadTotal;
  final int trophiesCount;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'copia.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
