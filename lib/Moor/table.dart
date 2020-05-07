import 'dart:convert';

import 'package:moor_flutter/moor_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as j;

part 'table.g.dart';

class PDFS extends Table {
  IntColumn get id => integer().autoIncrement().nullable()();
  TextColumn get pdfName => text().nullable()();
  TextColumn get thumb => text().nullable()();
  TextColumn get pdfAsset => text().nullable()();
  IntColumn get totalHours => integer().nullable()();
  DateTimeColumn get insertedDate => dateTime().nullable()();
  DateTimeColumn get lastSeenDate => dateTime().nullable()();
  TextColumn get bookmarked => text().map(const ListConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ListConverter extends TypeConverter<BookmarkList, String> {
  const ListConverter();
  @override
  BookmarkList mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return BookmarkList.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String mapToSql(BookmarkList value) {
    if (value == null) {
      return null;
    }

    return json.encode(value.toJson());
  }
}

@j.JsonSerializable()
class BookmarkList {
  List<int> bookmarked;

  BookmarkList(this.bookmarked);

  factory BookmarkList.fromJson(Map<String, dynamic> json) =>
      _$BookmarkListFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkListToJson(this);
}

@UseMoor(tables: [PDFS])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: "db.sqlite", logStatements: true));

  @override
  int get schemaVersion => 1;

  Future<List<PDFSData>> getAllPDfs() => (select(pdfs).get());

  Stream<List<PDFSData>> watchAllPDfs() => (select(pdfs).watch());

  Future insertPDF(PDFSData data) => (into(pdfs).insert(data));

  Future updatePDF(PDFSData data) => update(pdfs).replace(data);

  Future updates(Insertable<PDFSData> pdf) => update(pdfs).replace(pdf);

  Future deletePDf(PDFSData data) => (delete(pdfs).delete(data));

  Stream<PDFSData> checkLastSeen() => (select(pdfs)
        ..orderBy([
          (t) =>
              OrderingTerm(expression: t.lastSeenDate, mode: OrderingMode.desc)
        ])
        ..limit(1))
      .watchSingle();
}
