import 'package:moor_flutter/moor_flutter.dart';
part 'table.g.dart';

class PDFS extends Table {
  TextColumn get pdfName => text()();
  IntColumn get id => integer().autoIncrement()();
  TextColumn get thumb => text()();
  TextColumn get pdfAsset => text()();
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
