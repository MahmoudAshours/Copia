// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PDFDBAdapter extends TypeAdapter<PDFDB> {
  @override
  final typeId = 0;

  @override
  PDFDB read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PDFDB(
      pdfName: fields[0] as String,
      thumb: fields[1] as String,
      pdfAsset: fields[2] as String,
      totalHours: fields[3] as int,
      insertedDate: fields[4] as DateTime,
      lastSeenDate: fields[5] as DateTime,
      bookmarked: (fields[6] as List)?.cast<int>(),
      lastVisitedPage: fields[7] as int,
      pageNote: fields[8] as String,
      soundPath: fields[9] as String,
      documentPath: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PDFDB obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.pdfName)
      ..writeByte(1)
      ..write(obj.thumb)
      ..writeByte(2)
      ..write(obj.pdfAsset)
      ..writeByte(3)
      ..write(obj.totalHours)
      ..writeByte(4)
      ..write(obj.insertedDate)
      ..writeByte(5)
      ..write(obj.lastSeenDate)
      ..writeByte(6)
      ..write(obj.bookmarked)
      ..writeByte(7)
      ..write(obj.lastVisitedPage)
      ..writeByte(8)
      ..write(obj.pageNote)
      ..writeByte(9)
      ..write(obj.soundPath)
      ..writeByte(10)
      ..write(obj.documentPath);
  }
}
