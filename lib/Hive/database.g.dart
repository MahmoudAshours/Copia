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
      bookmarked: (fields[7] as List)?.cast<int>(),
      id: fields[0] as int,
      insertedDate: fields[5] as DateTime,
      lastSeenDate: fields[6] as DateTime,
      pdfAsset: fields[3] as String,
      pdfName: fields[1] as String,
      thumb: fields[2] as String,
      totalHours: fields[4] as int,
      lastVisitedPage: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PDFDB obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.pdfName)
      ..writeByte(2)
      ..write(obj.thumb)
      ..writeByte(3)
      ..write(obj.pdfAsset)
      ..writeByte(4)
      ..write(obj.totalHours)
      ..writeByte(5)
      ..write(obj.insertedDate)
      ..writeByte(6)
      ..write(obj.lastSeenDate)
      ..writeByte(7)
      ..write(obj.bookmarked)
      ..writeByte(9)
      ..write(obj.lastVisitedPage);
  }
}
