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
  String pageNote;
  PDFDB(
      {this.pdfName,
      this.thumb,
      this.pdfAsset,
      this.totalHours,
      this.insertedDate,
      this.lastSeenDate,
      this.bookmarked,
      this.lastVisitedPage,
      this.pageNote});
}
