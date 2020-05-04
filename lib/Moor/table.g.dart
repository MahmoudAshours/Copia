// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class PDFSData extends DataClass implements Insertable<PDFSData> {
  final int id;
  final String pdfName;
  final String thumb;
  final String pdfAsset;
  final int totalHours;
  final DateTime insertedDate;
  final DateTime lastSeenDate;
  PDFSData(
      {@required this.id,
      @required this.pdfName,
      @required this.thumb,
      @required this.pdfAsset,
      @required this.totalHours,
      @required this.insertedDate,
      this.lastSeenDate});
  factory PDFSData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return PDFSData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      pdfName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}pdf_name']),
      thumb:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}thumb']),
      pdfAsset: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}pdf_asset']),
      totalHours: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}total_hours']),
      insertedDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}inserted_date']),
      lastSeenDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_seen_date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || pdfName != null) {
      map['pdf_name'] = Variable<String>(pdfName);
    }
    if (!nullToAbsent || thumb != null) {
      map['thumb'] = Variable<String>(thumb);
    }
    if (!nullToAbsent || pdfAsset != null) {
      map['pdf_asset'] = Variable<String>(pdfAsset);
    }
    if (!nullToAbsent || totalHours != null) {
      map['total_hours'] = Variable<int>(totalHours);
    }
    if (!nullToAbsent || insertedDate != null) {
      map['inserted_date'] = Variable<DateTime>(insertedDate);
    }
    if (!nullToAbsent || lastSeenDate != null) {
      map['last_seen_date'] = Variable<DateTime>(lastSeenDate);
    }
    return map;
  }

  factory PDFSData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return PDFSData(
      id: serializer.fromJson<int>(json['id']),
      pdfName: serializer.fromJson<String>(json['pdfName']),
      thumb: serializer.fromJson<String>(json['thumb']),
      pdfAsset: serializer.fromJson<String>(json['pdfAsset']),
      totalHours: serializer.fromJson<int>(json['totalHours']),
      insertedDate: serializer.fromJson<DateTime>(json['insertedDate']),
      lastSeenDate: serializer.fromJson<DateTime>(json['lastSeenDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pdfName': serializer.toJson<String>(pdfName),
      'thumb': serializer.toJson<String>(thumb),
      'pdfAsset': serializer.toJson<String>(pdfAsset),
      'totalHours': serializer.toJson<int>(totalHours),
      'insertedDate': serializer.toJson<DateTime>(insertedDate),
      'lastSeenDate': serializer.toJson<DateTime>(lastSeenDate),
    };
  }

  PDFSData copyWith(
          {int id,
          String pdfName,
          String thumb,
          String pdfAsset,
          int totalHours,
          DateTime insertedDate,
          DateTime lastSeenDate}) =>
      PDFSData(
        id: id ?? this.id,
        pdfName: pdfName ?? this.pdfName,
        thumb: thumb ?? this.thumb,
        pdfAsset: pdfAsset ?? this.pdfAsset,
        totalHours: totalHours ?? this.totalHours,
        insertedDate: insertedDate ?? this.insertedDate,
        lastSeenDate: lastSeenDate ?? this.lastSeenDate,
      );
  @override
  String toString() {
    return (StringBuffer('PDFSData(')
          ..write('id: $id, ')
          ..write('pdfName: $pdfName, ')
          ..write('thumb: $thumb, ')
          ..write('pdfAsset: $pdfAsset, ')
          ..write('totalHours: $totalHours, ')
          ..write('insertedDate: $insertedDate, ')
          ..write('lastSeenDate: $lastSeenDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          pdfName.hashCode,
          $mrjc(
              thumb.hashCode,
              $mrjc(
                  pdfAsset.hashCode,
                  $mrjc(totalHours.hashCode,
                      $mrjc(insertedDate.hashCode, lastSeenDate.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PDFSData &&
          other.id == this.id &&
          other.pdfName == this.pdfName &&
          other.thumb == this.thumb &&
          other.pdfAsset == this.pdfAsset &&
          other.totalHours == this.totalHours &&
          other.insertedDate == this.insertedDate &&
          other.lastSeenDate == this.lastSeenDate);
}

class PDFSCompanion extends UpdateCompanion<PDFSData> {
  final Value<int> id;
  final Value<String> pdfName;
  final Value<String> thumb;
  final Value<String> pdfAsset;
  final Value<int> totalHours;
  final Value<DateTime> insertedDate;
  final Value<DateTime> lastSeenDate;
  const PDFSCompanion({
    this.id = const Value.absent(),
    this.pdfName = const Value.absent(),
    this.thumb = const Value.absent(),
    this.pdfAsset = const Value.absent(),
    this.totalHours = const Value.absent(),
    this.insertedDate = const Value.absent(),
    this.lastSeenDate = const Value.absent(),
  });
  PDFSCompanion.insert({
    this.id = const Value.absent(),
    @required String pdfName,
    @required String thumb,
    @required String pdfAsset,
    @required int totalHours,
    @required DateTime insertedDate,
    this.lastSeenDate = const Value.absent(),
  })  : pdfName = Value(pdfName),
        thumb = Value(thumb),
        pdfAsset = Value(pdfAsset),
        totalHours = Value(totalHours),
        insertedDate = Value(insertedDate);
  static Insertable<PDFSData> custom({
    Expression<int> id,
    Expression<String> pdfName,
    Expression<String> thumb,
    Expression<String> pdfAsset,
    Expression<int> totalHours,
    Expression<DateTime> insertedDate,
    Expression<DateTime> lastSeenDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pdfName != null) 'pdf_name': pdfName,
      if (thumb != null) 'thumb': thumb,
      if (pdfAsset != null) 'pdf_asset': pdfAsset,
      if (totalHours != null) 'total_hours': totalHours,
      if (insertedDate != null) 'inserted_date': insertedDate,
      if (lastSeenDate != null) 'last_seen_date': lastSeenDate,
    });
  }

  PDFSCompanion copyWith(
      {Value<int> id,
      Value<String> pdfName,
      Value<String> thumb,
      Value<String> pdfAsset,
      Value<int> totalHours,
      Value<DateTime> insertedDate,
      Value<DateTime> lastSeenDate}) {
    return PDFSCompanion(
      id: id ?? this.id,
      pdfName: pdfName ?? this.pdfName,
      thumb: thumb ?? this.thumb,
      pdfAsset: pdfAsset ?? this.pdfAsset,
      totalHours: totalHours ?? this.totalHours,
      insertedDate: insertedDate ?? this.insertedDate,
      lastSeenDate: lastSeenDate ?? this.lastSeenDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pdfName.present) {
      map['pdf_name'] = Variable<String>(pdfName.value);
    }
    if (thumb.present) {
      map['thumb'] = Variable<String>(thumb.value);
    }
    if (pdfAsset.present) {
      map['pdf_asset'] = Variable<String>(pdfAsset.value);
    }
    if (totalHours.present) {
      map['total_hours'] = Variable<int>(totalHours.value);
    }
    if (insertedDate.present) {
      map['inserted_date'] = Variable<DateTime>(insertedDate.value);
    }
    if (lastSeenDate.present) {
      map['last_seen_date'] = Variable<DateTime>(lastSeenDate.value);
    }
    return map;
  }
}

class $PDFSTable extends PDFS with TableInfo<$PDFSTable, PDFSData> {
  final GeneratedDatabase _db;
  final String _alias;
  $PDFSTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

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

  final VerificationMeta _totalHoursMeta = const VerificationMeta('totalHours');
  GeneratedIntColumn _totalHours;
  @override
  GeneratedIntColumn get totalHours => _totalHours ??= _constructTotalHours();
  GeneratedIntColumn _constructTotalHours() {
    return GeneratedIntColumn(
      'total_hours',
      $tableName,
      false,
    );
  }

  final VerificationMeta _insertedDateMeta =
      const VerificationMeta('insertedDate');
  GeneratedDateTimeColumn _insertedDate;
  @override
  GeneratedDateTimeColumn get insertedDate =>
      _insertedDate ??= _constructInsertedDate();
  GeneratedDateTimeColumn _constructInsertedDate() {
    return GeneratedDateTimeColumn(
      'inserted_date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastSeenDateMeta =
      const VerificationMeta('lastSeenDate');
  GeneratedDateTimeColumn _lastSeenDate;
  @override
  GeneratedDateTimeColumn get lastSeenDate =>
      _lastSeenDate ??= _constructLastSeenDate();
  GeneratedDateTimeColumn _constructLastSeenDate() {
    return GeneratedDateTimeColumn(
      'last_seen_date',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, pdfName, thumb, pdfAsset, totalHours, insertedDate, lastSeenDate];
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
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('pdf_name')) {
      context.handle(_pdfNameMeta,
          pdfName.isAcceptableOrUnknown(data['pdf_name'], _pdfNameMeta));
    } else if (isInserting) {
      context.missing(_pdfNameMeta);
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
    if (data.containsKey('total_hours')) {
      context.handle(
          _totalHoursMeta,
          totalHours.isAcceptableOrUnknown(
              data['total_hours'], _totalHoursMeta));
    } else if (isInserting) {
      context.missing(_totalHoursMeta);
    }
    if (data.containsKey('inserted_date')) {
      context.handle(
          _insertedDateMeta,
          insertedDate.isAcceptableOrUnknown(
              data['inserted_date'], _insertedDateMeta));
    } else if (isInserting) {
      context.missing(_insertedDateMeta);
    }
    if (data.containsKey('last_seen_date')) {
      context.handle(
          _lastSeenDateMeta,
          lastSeenDate.isAcceptableOrUnknown(
              data['last_seen_date'], _lastSeenDateMeta));
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
