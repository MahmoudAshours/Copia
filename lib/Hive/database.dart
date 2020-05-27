import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'database.g.dart';

@HiveType(typeId: 0)
class PDFDB {
  @HiveField(0)
  String pdfName;
  @HiveField(1)
  String thumb;
  @HiveField(2)
  String pdfAsset;
  @HiveField(3)
  int totalHours;
  @HiveField(4)
  DateTime insertedDate;
  @HiveField(5)
  DateTime lastSeenDate;
  @HiveField(6)
  List<int> bookmarked = new List<int>();
  @HiveField(7)
  int lastVisitedPage;
  @HiveField(8)
  Map<int,String> pageNote = Map<int,String>();
  @HiveField(9)
  String soundPath;
  @HiveField(10)
  String documentPath;
  PDFDB(
      {this.pdfName,
      this.thumb,
      this.pdfAsset,
      this.totalHours,
      this.insertedDate,
      this.lastSeenDate,
      this.bookmarked,
      this.lastVisitedPage,
      this.pageNote,
      this.soundPath,
      this.documentPath});

  updatePDf({@required int index, @required PDFDB snapshot}) {
    Hive.box('name').putAt(
      index,
      PDFDB(
        insertedDate: snapshot.insertedDate,
        lastSeenDate: snapshot.lastSeenDate,
        pdfAsset: snapshot.pdfAsset,
        pdfName: snapshot.pdfName,
        totalHours: snapshot.totalHours,
        thumb: snapshot.thumb,
        bookmarked: snapshot.bookmarked,
        documentPath: snapshot.documentPath,
        lastVisitedPage: snapshot.lastVisitedPage,
        pageNote: snapshot.pageNote,
        soundPath: snapshot.soundPath,
      ),
    );
  }
}
