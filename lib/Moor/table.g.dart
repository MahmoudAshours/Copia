// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class PDFSData extends DataClass implements Insertable<PDFSData> {
  final String pdfName;
  final int id;
  final String thumb;
  final String pdfAsset;
  PDFSData(
      {@required this.pdfName,
      @required this.id,
      @required this.thumb,
      @required this.pdfAsset});
  factory PDFSData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    return PDFSData(
      pdfName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}pdf_name']),
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      thumb:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}thumb']),
      pdfAsset: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}pdf_asset']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || pdfName != null) {
      map['pdf_name'] = Variable<String>(pdfName);
    }
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || thumb != null) {
      map['thumb'] = Variable<String>(thumb);
    }
    if (!nullToAbsent || pdfAsset != null) {
      map['pdf_asset'] = Variable<String>(pdfAsset);
    }
    return map;
  }

  factory PDFSData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PDFSData(
      pdfName: serializer.fromJson<String>(json['pdfName']),
      id: serializer.fromJson<int>(json['id']),
      thumb: serializer.fromJson<String>(json['thumb']),
      pdfAsset: serializer.fromJson<String>(json['pdfAsset']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pdfName': serializer.toJson<String>(pdfName),
      'id': serializer.toJson<int>(id),
      'thumb': serializer.toJson<String>(thumb),
      'pdfAsset': serializer.toJson<String>(pdfAsset),
    };
  }

  PDFSData copyWith({String pdfName, int id, String thumb, String pdfAsset}) =>
      PDFSData(
        pdfName: pdfName ?? this.pdfName,
        id: id ?? this.id,
        thumb: thumb ?? this.thumb,
        pdfAsset: pdfAsset ?? this.pdfAsset,
      );
  @override
  String toString() {
    return (StringBuffer('PDFSData(')
          ..write('pdfName: $pdfName, ')
          ..write('id: $id, ')
          ..write('thumb: $thumb, ')
          ..write('pdfAsset: $pdfAsset')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(pdfName.hashCode,
      $mrjc(id.hashCode, $mrjc(thumb.hashCode, pdfAsset.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PDFSData &&
          other.pdfName == this.pdfName &&
          other.id == this.id &&
          other.thumb == this.thumb &&
          other.pdfAsset == this.pdfAsset);
}

class PDFSCompanion extends UpdateCompanion<PDFSData> {
  final Value<String> pdfName;
  final Value<int> id;
  final Value<String> thumb;
  final Value<String> pdfAsset;
  const PDFSCompanion({
    this.pdfName = const Value.absent(),
    this.id = const Value.absent(),
    this.thumb = const Value.absent(),
    this.pdfAsset = const Value.absent(),
  });
  PDFSCompanion.insert({
    @required String pdfName,
    this.id = const Value.absent(),
    @required String thumb,
    @required String pdfAsset,
  })  : pdfName = Value(pdfName),
        thumb = Value(thumb),
        pdfAsset = Value(pdfAsset);
  static Insertable<PDFSData> custom({
    Expression<String> pdfName,
    Expression<int> id,
    Expression<String> thumb,
    Expression<String> pdfAsset,
  }) {
    return RawValuesInsertable({
      if (pdfName != null) 'pdf_name': pdfName,
      if (id != null) 'id': id,
      if (thumb != null) 'thumb': thumb,
      if (pdfAsset != null) 'pdf_asset': pdfAsset,
    });
  }

  PDFSCompanion copyWith(
      {Value<String> pdfName,
      Value<int> id,
      Value<String> thumb,
      Value<String> pdfAsset}) {
    return PDFSCompanion(
      pdfName: pdfName ?? this.pdfName,
      id: id ?? this.id,
      thumb: thumb ?? this.thumb,
      pdfAsset: pdfAsset ?? this.pdfAsset,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pdfName.present) {
      map['pdf_name'] = Variable<String>(pdfName.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (thumb.present) {
      map['thumb'] = Variable<String>(thumb.value);
    }
    if (pdfAsset.present) {
      map['pdf_asset'] = Variable<String>(pdfAsset.value);
    }
    return map;
  }
}

class $PDFSTable extends PDFS with TableInfo<$PDFSTable, PDFSData> {
  final GeneratedDatabase _db;
  final String _alias;
  $PDFSTable(this._db, [this._alias]);
  final VerificationMeta _pdfNameMeta = const VerificationMeta('pdfName');
  GeneratedTextColumn _pdfName;
  @override
  GeneratedTextColumn get pdfName => _pdfName ??= _constructPdfName();
  GeneratedTextColumn _constructPdfName() {
    return GeneratedTextColumn(
      'pdf_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _thumbMeta = const VerificationMeta('thumb');
  GeneratedTextColumn _thumb;
  @override
  GeneratedTextColumn get thumb => _thumb ??= _constructThumb();
  GeneratedTextColumn _constructThumb() {
    return GeneratedTextColumn(
      'thumb',
      $tableName,
      false,
    );
  }

  final VerificationMeta _pdfAssetMeta = const VerificationMeta('pdfAsset');
  GeneratedTextColumn _pdfAsset;
  @override
  GeneratedTextColumn get pdfAsset => _pdfAsset ??= _constructPdfAsset();
  GeneratedTextColumn _constructPdfAsset() {
    return GeneratedTextColumn(
      'pdf_asset',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [pdfName, id, thumb, pdfAsset];
  @override
  $PDFSTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'pdfs';
  @override
  final String actualTableName = 'pdfs';
  @override
  VerificationContext validateIntegrity(Insertable<PDFSData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('pdf_name')) {
      context.handle(_pdfNameMeta,
          pdfName.isAcceptableOrUnknown(data['pdf_name'], _pdfNameMeta));
    } else if (isInserting) {
      context.missing(_pdfNameMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('thumb')) {
      context.handle(
          _thumbMeta, thumb.isAcceptableOrUnknown(data['thumb'], _thumbMeta));
    } else if (isInserting) {
      context.missing(_thumbMeta);
    }
    if (data.containsKey('pdf_asset')) {
      context.handle(_pdfAssetMeta,
          pdfAsset.isAcceptableOrUnknown(data['pdf_asset'], _pdfAssetMeta));
    } else if (isInserting) {
      context.missing(_pdfAssetMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PDFSData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PDFSData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PDFSTable createAlias(String alias) {
    return $PDFSTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $PDFSTable _pdfs;
  $PDFSTable get pdfs => _pdfs ??= $PDFSTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [pdfs];
}
