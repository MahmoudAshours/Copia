import 'package:hive/hive.dart';
part 'database.g.dart';

@HiveType(typeId: 0)
class PDFDB {
  @HiveField(0)
  int id;
  @HiveField(1)
  String pdfName;
  @HiveField(2)
  String thumb;
  @HiveField(3)
  String pdfAsset;
  @HiveField(4)
  int totalHours;
  @HiveField(5)
  DateTime insertedDate;
  @HiveField(6)
  DateTime lastSeenDate;
  @HiveField(7)
  List<int> bookmarked = [];
  PDFDB(
      {this.bookmarked,
      this.id,
      this.insertedDate,
      this.lastSeenDate,
      this.pdfAsset,
      this.pdfName,
      this.thumb,
      this.totalHours});
}
