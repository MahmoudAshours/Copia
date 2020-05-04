import 'dart:convert';

import 'package:moor_flutter/moor_flutter.dart';
import 'package:json_annotation/json_annotation.dart' as j;

part 'table.g.dart';

class PDFS extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pdfName => text()();
  TextColumn get thumb => text()();
  TextColumn get pdfAsset => text()();
  IntColumn get totalHours => integer()();
  DateTimeColumn get insertedDate => dateTime()();
  DateTimeColumn get lastSeenDate => dateTime().nullable()();
  TextColumn get bookmarked => text().map(const ListConverter()).nullable()();
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

  Future deletePDf(PDFSData data) => (delete(pdfs).delete(data));
}
