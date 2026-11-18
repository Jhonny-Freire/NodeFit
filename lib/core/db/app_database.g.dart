// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GymsTable extends Gyms with TableInfo<$GymsTable, Gym> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GymsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    notes,
    archivedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gyms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Gym> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Gym map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Gym(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GymsTable createAlias(String alias) {
    return $GymsTable(attachedDatabase, alias);
  }
}

class Gym extends DataClass implements Insertable<Gym> {
  final String id;
  final String name;
  final String? notes;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Gym({
    required this.id,
    required this.name,
    this.notes,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GymsCompanion toCompanion(bool nullToAbsent) {
    return GymsCompanion(
      id: Value(id),
      name: Value(name),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Gym.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Gym(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Gym copyWith({
    String? id,
    String? name,
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Gym(
    id: id ?? this.id,
    name: name ?? this.name,
    notes: notes.present ? notes.value : this.notes,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Gym copyWithCompanion(GymsCompanion data) {
    return Gym(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Gym(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, notes, archivedAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Gym &&
          other.id == this.id &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.archivedAt == this.archivedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GymsCompanion extends UpdateCompanion<Gym> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> notes;
  final Value<DateTime?> archivedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GymsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GymsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.notes = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Gym> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<DateTime>? archivedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GymsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? notes,
    Value<DateTime?>? archivedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GymsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GymsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EquipmentTable extends Equipment
    with TableInfo<$EquipmentTable, EquipmentItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _gymIdMeta = const VerificationMeta('gymId');
  @override
  late final GeneratedColumn<String> gymId = GeneratedColumn<String>(
    'gym_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gyms (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EquipmentType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EquipmentType>($EquipmentTable.$convertertype);
  static const VerificationMeta _gymLabelMeta = const VerificationMeta(
    'gymLabel',
  );
  @override
  late final GeneratedColumn<String> gymLabel = GeneratedColumn<String>(
    'gym_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LoadUnit, String> loadUnit =
      GeneratedColumn<String>(
        'load_unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LoadUnit>($EquipmentTable.$converterloadUnit);
  @override
  late final GeneratedColumnWithTypeConverter<LoadBasis, String> loadBasis =
      GeneratedColumn<String>(
        'load_basis',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LoadBasis>($EquipmentTable.$converterloadBasis);
  static const VerificationMeta _incrementMilliMeta = const VerificationMeta(
    'incrementMilli',
  );
  @override
  late final GeneratedColumn<int> incrementMilli = GeneratedColumn<int>(
    'increment_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2500),
  );
  static const VerificationMeta _baseLoadMilliMeta = const VerificationMeta(
    'baseLoadMilli',
  );
  @override
  late final GeneratedColumn<int> baseLoadMilli = GeneratedColumn<int>(
    'base_load_milli',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replacesEquipmentIdMeta =
      const VerificationMeta('replacesEquipmentId');
  @override
  late final GeneratedColumn<String> replacesEquipmentId =
      GeneratedColumn<String>(
        'replaces_equipment_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gymId,
    name,
    type,
    gymLabel,
    photoPath,
    loadUnit,
    loadBasis,
    incrementMilli,
    baseLoadMilli,
    replacesEquipmentId,
    notes,
    archivedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('gym_id')) {
      context.handle(
        _gymIdMeta,
        gymId.isAcceptableOrUnknown(data['gym_id']!, _gymIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gymIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('gym_label')) {
      context.handle(
        _gymLabelMeta,
        gymLabel.isAcceptableOrUnknown(data['gym_label']!, _gymLabelMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('increment_milli')) {
      context.handle(
        _incrementMilliMeta,
        incrementMilli.isAcceptableOrUnknown(
          data['increment_milli']!,
          _incrementMilliMeta,
        ),
      );
    }
    if (data.containsKey('base_load_milli')) {
      context.handle(
        _baseLoadMilliMeta,
        baseLoadMilli.isAcceptableOrUnknown(
          data['base_load_milli']!,
          _baseLoadMilliMeta,
        ),
      );
    }
    if (data.containsKey('replaces_equipment_id')) {
      context.handle(
        _replacesEquipmentIdMeta,
        replacesEquipmentId.isAcceptableOrUnknown(
          data['replaces_equipment_id']!,
          _replacesEquipmentIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      gymId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gym_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $EquipmentTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      gymLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gym_label'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      loadUnit: $EquipmentTable.$converterloadUnit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}load_unit'],
        )!,
      ),
      loadBasis: $EquipmentTable.$converterloadBasis.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}load_basis'],
        )!,
      ),
      incrementMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}increment_milli'],
      )!,
      baseLoadMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_load_milli'],
      ),
      replacesEquipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}replaces_equipment_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EquipmentTable createAlias(String alias) {
    return $EquipmentTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EquipmentType, String, String> $convertertype =
      const EnumNameConverter<EquipmentType>(EquipmentType.values);
  static JsonTypeConverter2<LoadUnit, String, String> $converterloadUnit =
      const EnumNameConverter<LoadUnit>(LoadUnit.values);
  static JsonTypeConverter2<LoadBasis, String, String> $converterloadBasis =
      const EnumNameConverter<LoadBasis>(LoadBasis.values);
}

class EquipmentItem extends DataClass implements Insertable<EquipmentItem> {
  final String id;
  final String gymId;
  final String name;
  final EquipmentType type;

  /// Número ou etiqueta do aparelho na academia ("14").
  final String? gymLabel;
  final String? photoPath;
  final LoadUnit loadUnit;
  final LoadBasis loadBasis;

  /// Menor salto de carga (× 1000). Ex.: 2500 = 2,5 kg; 1000 = 1 placa.
  final int incrementMilli;

  /// Carga do carrinho/barra (× 1000), somada no total em kg.
  final int? baseLoadMilli;

  /// Aparelho que este substituiu (a academia trocou a máquina).
  final String? replacesEquipmentId;
  final String? notes;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const EquipmentItem({
    required this.id,
    required this.gymId,
    required this.name,
    required this.type,
    this.gymLabel,
    this.photoPath,
    required this.loadUnit,
    required this.loadBasis,
    required this.incrementMilli,
    this.baseLoadMilli,
    this.replacesEquipmentId,
    this.notes,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['gym_id'] = Variable<String>(gymId);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>(
        $EquipmentTable.$convertertype.toSql(type),
      );
    }
    if (!nullToAbsent || gymLabel != null) {
      map['gym_label'] = Variable<String>(gymLabel);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    {
      map['load_unit'] = Variable<String>(
        $EquipmentTable.$converterloadUnit.toSql(loadUnit),
      );
    }
    {
      map['load_basis'] = Variable<String>(
        $EquipmentTable.$converterloadBasis.toSql(loadBasis),
      );
    }
    map['increment_milli'] = Variable<int>(incrementMilli);
    if (!nullToAbsent || baseLoadMilli != null) {
      map['base_load_milli'] = Variable<int>(baseLoadMilli);
    }
    if (!nullToAbsent || replacesEquipmentId != null) {
      map['replaces_equipment_id'] = Variable<String>(replacesEquipmentId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EquipmentCompanion toCompanion(bool nullToAbsent) {
    return EquipmentCompanion(
      id: Value(id),
      gymId: Value(gymId),
      name: Value(name),
      type: Value(type),
      gymLabel: gymLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(gymLabel),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      loadUnit: Value(loadUnit),
      loadBasis: Value(loadBasis),
      incrementMilli: Value(incrementMilli),
      baseLoadMilli: baseLoadMilli == null && nullToAbsent
          ? const Value.absent()
          : Value(baseLoadMilli),
      replacesEquipmentId: replacesEquipmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(replacesEquipmentId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EquipmentItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentItem(
      id: serializer.fromJson<String>(json['id']),
      gymId: serializer.fromJson<String>(json['gymId']),
      name: serializer.fromJson<String>(json['name']),
      type: $EquipmentTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      gymLabel: serializer.fromJson<String?>(json['gymLabel']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      loadUnit: $EquipmentTable.$converterloadUnit.fromJson(
        serializer.fromJson<String>(json['loadUnit']),
      ),
      loadBasis: $EquipmentTable.$converterloadBasis.fromJson(
        serializer.fromJson<String>(json['loadBasis']),
      ),
      incrementMilli: serializer.fromJson<int>(json['incrementMilli']),
      baseLoadMilli: serializer.fromJson<int?>(json['baseLoadMilli']),
      replacesEquipmentId: serializer.fromJson<String?>(
        json['replacesEquipmentId'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'gymId': serializer.toJson<String>(gymId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $EquipmentTable.$convertertype.toJson(type),
      ),
      'gymLabel': serializer.toJson<String?>(gymLabel),
      'photoPath': serializer.toJson<String?>(photoPath),
      'loadUnit': serializer.toJson<String>(
        $EquipmentTable.$converterloadUnit.toJson(loadUnit),
      ),
      'loadBasis': serializer.toJson<String>(
        $EquipmentTable.$converterloadBasis.toJson(loadBasis),
      ),
      'incrementMilli': serializer.toJson<int>(incrementMilli),
      'baseLoadMilli': serializer.toJson<int?>(baseLoadMilli),
      'replacesEquipmentId': serializer.toJson<String?>(replacesEquipmentId),
      'notes': serializer.toJson<String?>(notes),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EquipmentItem copyWith({
    String? id,
    String? gymId,
    String? name,
    EquipmentType? type,
    Value<String?> gymLabel = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    LoadUnit? loadUnit,
    LoadBasis? loadBasis,
    int? incrementMilli,
    Value<int?> baseLoadMilli = const Value.absent(),
    Value<String?> replacesEquipmentId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EquipmentItem(
    id: id ?? this.id,
    gymId: gymId ?? this.gymId,
    name: name ?? this.name,
    type: type ?? this.type,
    gymLabel: gymLabel.present ? gymLabel.value : this.gymLabel,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    loadUnit: loadUnit ?? this.loadUnit,
    loadBasis: loadBasis ?? this.loadBasis,
    incrementMilli: incrementMilli ?? this.incrementMilli,
    baseLoadMilli: baseLoadMilli.present
        ? baseLoadMilli.value
        : this.baseLoadMilli,
    replacesEquipmentId: replacesEquipmentId.present
        ? replacesEquipmentId.value
        : this.replacesEquipmentId,
    notes: notes.present ? notes.value : this.notes,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EquipmentItem copyWithCompanion(EquipmentCompanion data) {
    return EquipmentItem(
      id: data.id.present ? data.id.value : this.id,
      gymId: data.gymId.present ? data.gymId.value : this.gymId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      gymLabel: data.gymLabel.present ? data.gymLabel.value : this.gymLabel,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      loadUnit: data.loadUnit.present ? data.loadUnit.value : this.loadUnit,
      loadBasis: data.loadBasis.present ? data.loadBasis.value : this.loadBasis,
      incrementMilli: data.incrementMilli.present
          ? data.incrementMilli.value
          : this.incrementMilli,
      baseLoadMilli: data.baseLoadMilli.present
          ? data.baseLoadMilli.value
          : this.baseLoadMilli,
      replacesEquipmentId: data.replacesEquipmentId.present
          ? data.replacesEquipmentId.value
          : this.replacesEquipmentId,
      notes: data.notes.present ? data.notes.value : this.notes,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentItem(')
          ..write('id: $id, ')
          ..write('gymId: $gymId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('gymLabel: $gymLabel, ')
          ..write('photoPath: $photoPath, ')
          ..write('loadUnit: $loadUnit, ')
          ..write('loadBasis: $loadBasis, ')
          ..write('incrementMilli: $incrementMilli, ')
          ..write('baseLoadMilli: $baseLoadMilli, ')
          ..write('replacesEquipmentId: $replacesEquipmentId, ')
          ..write('notes: $notes, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gymId,
    name,
    type,
    gymLabel,
    photoPath,
    loadUnit,
    loadBasis,
    incrementMilli,
    baseLoadMilli,
    replacesEquipmentId,
    notes,
    archivedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentItem &&
          other.id == this.id &&
          other.gymId == this.gymId &&
          other.name == this.name &&
          other.type == this.type &&
          other.gymLabel == this.gymLabel &&
          other.photoPath == this.photoPath &&
          other.loadUnit == this.loadUnit &&
          other.loadBasis == this.loadBasis &&
          other.incrementMilli == this.incrementMilli &&
          other.baseLoadMilli == this.baseLoadMilli &&
          other.replacesEquipmentId == this.replacesEquipmentId &&
          other.notes == this.notes &&
          other.archivedAt == this.archivedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EquipmentCompanion extends UpdateCompanion<EquipmentItem> {
  final Value<String> id;
  final Value<String> gymId;
  final Value<String> name;
  final Value<EquipmentType> type;
  final Value<String?> gymLabel;
  final Value<String?> photoPath;
  final Value<LoadUnit> loadUnit;
  final Value<LoadBasis> loadBasis;
  final Value<int> incrementMilli;
  final Value<int?> baseLoadMilli;
  final Value<String?> replacesEquipmentId;
  final Value<String?> notes;
  final Value<DateTime?> archivedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EquipmentCompanion({
    this.id = const Value.absent(),
    this.gymId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.gymLabel = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.loadUnit = const Value.absent(),
    this.loadBasis = const Value.absent(),
    this.incrementMilli = const Value.absent(),
    this.baseLoadMilli = const Value.absent(),
    this.replacesEquipmentId = const Value.absent(),
    this.notes = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EquipmentCompanion.insert({
    this.id = const Value.absent(),
    required String gymId,
    required String name,
    required EquipmentType type,
    this.gymLabel = const Value.absent(),
    this.photoPath = const Value.absent(),
    required LoadUnit loadUnit,
    required LoadBasis loadBasis,
    this.incrementMilli = const Value.absent(),
    this.baseLoadMilli = const Value.absent(),
    this.replacesEquipmentId = const Value.absent(),
    this.notes = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : gymId = Value(gymId),
       name = Value(name),
       type = Value(type),
       loadUnit = Value(loadUnit),
       loadBasis = Value(loadBasis);
  static Insertable<EquipmentItem> custom({
    Expression<String>? id,
    Expression<String>? gymId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? gymLabel,
    Expression<String>? photoPath,
    Expression<String>? loadUnit,
    Expression<String>? loadBasis,
    Expression<int>? incrementMilli,
    Expression<int>? baseLoadMilli,
    Expression<String>? replacesEquipmentId,
    Expression<String>? notes,
    Expression<DateTime>? archivedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gymId != null) 'gym_id': gymId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (gymLabel != null) 'gym_label': gymLabel,
      if (photoPath != null) 'photo_path': photoPath,
      if (loadUnit != null) 'load_unit': loadUnit,
      if (loadBasis != null) 'load_basis': loadBasis,
      if (incrementMilli != null) 'increment_milli': incrementMilli,
      if (baseLoadMilli != null) 'base_load_milli': baseLoadMilli,
      if (replacesEquipmentId != null)
        'replaces_equipment_id': replacesEquipmentId,
      if (notes != null) 'notes': notes,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EquipmentCompanion copyWith({
    Value<String>? id,
    Value<String>? gymId,
    Value<String>? name,
    Value<EquipmentType>? type,
    Value<String?>? gymLabel,
    Value<String?>? photoPath,
    Value<LoadUnit>? loadUnit,
    Value<LoadBasis>? loadBasis,
    Value<int>? incrementMilli,
    Value<int?>? baseLoadMilli,
    Value<String?>? replacesEquipmentId,
    Value<String?>? notes,
    Value<DateTime?>? archivedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return EquipmentCompanion(
      id: id ?? this.id,
      gymId: gymId ?? this.gymId,
      name: name ?? this.name,
      type: type ?? this.type,
      gymLabel: gymLabel ?? this.gymLabel,
      photoPath: photoPath ?? this.photoPath,
      loadUnit: loadUnit ?? this.loadUnit,
      loadBasis: loadBasis ?? this.loadBasis,
      incrementMilli: incrementMilli ?? this.incrementMilli,
      baseLoadMilli: baseLoadMilli ?? this.baseLoadMilli,
      replacesEquipmentId: replacesEquipmentId ?? this.replacesEquipmentId,
      notes: notes ?? this.notes,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (gymId.present) {
      map['gym_id'] = Variable<String>(gymId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $EquipmentTable.$convertertype.toSql(type.value),
      );
    }
    if (gymLabel.present) {
      map['gym_label'] = Variable<String>(gymLabel.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (loadUnit.present) {
      map['load_unit'] = Variable<String>(
        $EquipmentTable.$converterloadUnit.toSql(loadUnit.value),
      );
    }
    if (loadBasis.present) {
      map['load_basis'] = Variable<String>(
        $EquipmentTable.$converterloadBasis.toSql(loadBasis.value),
      );
    }
    if (incrementMilli.present) {
      map['increment_milli'] = Variable<int>(incrementMilli.value);
    }
    if (baseLoadMilli.present) {
      map['base_load_milli'] = Variable<int>(baseLoadMilli.value);
    }
    if (replacesEquipmentId.present) {
      map['replaces_equipment_id'] = Variable<String>(
        replacesEquipmentId.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentCompanion(')
          ..write('id: $id, ')
          ..write('gymId: $gymId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('gymLabel: $gymLabel, ')
          ..write('photoPath: $photoPath, ')
          ..write('loadUnit: $loadUnit, ')
          ..write('loadBasis: $loadBasis, ')
          ..write('incrementMilli: $incrementMilli, ')
          ..write('baseLoadMilli: $baseLoadMilli, ')
          ..write('replacesEquipmentId: $replacesEquipmentId, ')
          ..write('notes: $notes, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchTextMeta = const VerificationMeta(
    'searchText',
  );
  @override
  late final GeneratedColumn<String> searchText = GeneratedColumn<String>(
    'search_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aliasesMeta = const VerificationMeta(
    'aliases',
  );
  @override
  late final GeneratedColumn<String> aliases = GeneratedColumn<String>(
    'aliases',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<EquipmentType, String>
  equipmentType = GeneratedColumn<String>(
    'equipment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<EquipmentType>($ExercisesTable.$converterequipmentType);
  @override
  late final GeneratedColumnWithTypeConverter<TrackingType, String> tracking =
      GeneratedColumn<String>(
        'tracking',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(TrackingType.weightReps.name),
      ).withConverter<TrackingType>($ExercisesTable.$convertertracking);
  static const VerificationMeta _primaryMusclesMeta = const VerificationMeta(
    'primaryMuscles',
  );
  @override
  late final GeneratedColumn<String> primaryMuscles = GeneratedColumn<String>(
    'primary_muscles',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _secondaryMusclesMeta = const VerificationMeta(
    'secondaryMuscles',
  );
  @override
  late final GeneratedColumn<String> secondaryMuscles = GeneratedColumn<String>(
    'secondary_muscles',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _seedVersionMeta = const VerificationMeta(
    'seedVersion',
  );
  @override
  late final GeneratedColumn<int> seedVersion = GeneratedColumn<int>(
    'seed_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    searchText,
    aliases,
    equipmentType,
    tracking,
    primaryMuscles,
    secondaryMuscles,
    isCustom,
    seedVersion,
    archivedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('search_text')) {
      context.handle(
        _searchTextMeta,
        searchText.isAcceptableOrUnknown(data['search_text']!, _searchTextMeta),
      );
    } else if (isInserting) {
      context.missing(_searchTextMeta);
    }
    if (data.containsKey('aliases')) {
      context.handle(
        _aliasesMeta,
        aliases.isAcceptableOrUnknown(data['aliases']!, _aliasesMeta),
      );
    }
    if (data.containsKey('primary_muscles')) {
      context.handle(
        _primaryMusclesMeta,
        primaryMuscles.isAcceptableOrUnknown(
          data['primary_muscles']!,
          _primaryMusclesMeta,
        ),
      );
    }
    if (data.containsKey('secondary_muscles')) {
      context.handle(
        _secondaryMusclesMeta,
        secondaryMuscles.isAcceptableOrUnknown(
          data['secondary_muscles']!,
          _secondaryMusclesMeta,
        ),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('seed_version')) {
      context.handle(
        _seedVersionMeta,
        seedVersion.isAcceptableOrUnknown(
          data['seed_version']!,
          _seedVersionMeta,
        ),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      searchText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_text'],
      )!,
      aliases: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aliases'],
      )!,
      equipmentType: $ExercisesTable.$converterequipmentType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}equipment_type'],
        )!,
      ),
      tracking: $ExercisesTable.$convertertracking.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tracking'],
        )!,
      ),
      primaryMuscles: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_muscles'],
      )!,
      secondaryMuscles: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}secondary_muscles'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      seedVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seed_version'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EquipmentType, String, String>
  $converterequipmentType = const EnumNameConverter<EquipmentType>(
    EquipmentType.values,
  );
  static JsonTypeConverter2<TrackingType, String, String> $convertertracking =
      const EnumNameConverter<TrackingType>(TrackingType.values);
}

class Exercise extends DataClass implements Insertable<Exercise> {
  /// Slug nos embarcados ("supino-reto-barra"), UUID nos criados pelo usuário.
  final String id;
  final String name;

  /// Nome + apelidos normalizados (minúsculas, sem acento) para a busca.
  final String searchText;

  /// Apelidos separados por " | ".
  final String aliases;
  final EquipmentType equipmentType;

  /// O que se anota: carga × reps, tempo, ou tempo e distância (schema v2).
  final TrackingType tracking;

  /// Chaves de `Muscle` separadas por vírgula.
  final String primaryMuscles;
  final String secondaryMuscles;
  final bool isCustom;
  final int? seedVersion;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Exercise({
    required this.id,
    required this.name,
    required this.searchText,
    required this.aliases,
    required this.equipmentType,
    required this.tracking,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.isCustom,
    this.seedVersion,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['search_text'] = Variable<String>(searchText);
    map['aliases'] = Variable<String>(aliases);
    {
      map['equipment_type'] = Variable<String>(
        $ExercisesTable.$converterequipmentType.toSql(equipmentType),
      );
    }
    {
      map['tracking'] = Variable<String>(
        $ExercisesTable.$convertertracking.toSql(tracking),
      );
    }
    map['primary_muscles'] = Variable<String>(primaryMuscles);
    map['secondary_muscles'] = Variable<String>(secondaryMuscles);
    map['is_custom'] = Variable<bool>(isCustom);
    if (!nullToAbsent || seedVersion != null) {
      map['seed_version'] = Variable<int>(seedVersion);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      searchText: Value(searchText),
      aliases: Value(aliases),
      equipmentType: Value(equipmentType),
      tracking: Value(tracking),
      primaryMuscles: Value(primaryMuscles),
      secondaryMuscles: Value(secondaryMuscles),
      isCustom: Value(isCustom),
      seedVersion: seedVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(seedVersion),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      searchText: serializer.fromJson<String>(json['searchText']),
      aliases: serializer.fromJson<String>(json['aliases']),
      equipmentType: $ExercisesTable.$converterequipmentType.fromJson(
        serializer.fromJson<String>(json['equipmentType']),
      ),
      tracking: $ExercisesTable.$convertertracking.fromJson(
        serializer.fromJson<String>(json['tracking']),
      ),
      primaryMuscles: serializer.fromJson<String>(json['primaryMuscles']),
      secondaryMuscles: serializer.fromJson<String>(json['secondaryMuscles']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      seedVersion: serializer.fromJson<int?>(json['seedVersion']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'searchText': serializer.toJson<String>(searchText),
      'aliases': serializer.toJson<String>(aliases),
      'equipmentType': serializer.toJson<String>(
        $ExercisesTable.$converterequipmentType.toJson(equipmentType),
      ),
      'tracking': serializer.toJson<String>(
        $ExercisesTable.$convertertracking.toJson(tracking),
      ),
      'primaryMuscles': serializer.toJson<String>(primaryMuscles),
      'secondaryMuscles': serializer.toJson<String>(secondaryMuscles),
      'isCustom': serializer.toJson<bool>(isCustom),
      'seedVersion': serializer.toJson<int?>(seedVersion),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? searchText,
    String? aliases,
    EquipmentType? equipmentType,
    TrackingType? tracking,
    String? primaryMuscles,
    String? secondaryMuscles,
    bool? isCustom,
    Value<int?> seedVersion = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    searchText: searchText ?? this.searchText,
    aliases: aliases ?? this.aliases,
    equipmentType: equipmentType ?? this.equipmentType,
    tracking: tracking ?? this.tracking,
    primaryMuscles: primaryMuscles ?? this.primaryMuscles,
    secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
    isCustom: isCustom ?? this.isCustom,
    seedVersion: seedVersion.present ? seedVersion.value : this.seedVersion,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      searchText: data.searchText.present
          ? data.searchText.value
          : this.searchText,
      aliases: data.aliases.present ? data.aliases.value : this.aliases,
      equipmentType: data.equipmentType.present
          ? data.equipmentType.value
          : this.equipmentType,
      tracking: data.tracking.present ? data.tracking.value : this.tracking,
      primaryMuscles: data.primaryMuscles.present
          ? data.primaryMuscles.value
          : this.primaryMuscles,
      secondaryMuscles: data.secondaryMuscles.present
          ? data.secondaryMuscles.value
          : this.secondaryMuscles,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      seedVersion: data.seedVersion.present
          ? data.seedVersion.value
          : this.seedVersion,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('searchText: $searchText, ')
          ..write('aliases: $aliases, ')
          ..write('equipmentType: $equipmentType, ')
          ..write('tracking: $tracking, ')
          ..write('primaryMuscles: $primaryMuscles, ')
          ..write('secondaryMuscles: $secondaryMuscles, ')
          ..write('isCustom: $isCustom, ')
          ..write('seedVersion: $seedVersion, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    searchText,
    aliases,
    equipmentType,
    tracking,
    primaryMuscles,
    secondaryMuscles,
    isCustom,
    seedVersion,
    archivedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.searchText == this.searchText &&
          other.aliases == this.aliases &&
          other.equipmentType == this.equipmentType &&
          other.tracking == this.tracking &&
          other.primaryMuscles == this.primaryMuscles &&
          other.secondaryMuscles == this.secondaryMuscles &&
          other.isCustom == this.isCustom &&
          other.seedVersion == this.seedVersion &&
          other.archivedAt == this.archivedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> searchText;
  final Value<String> aliases;
  final Value<EquipmentType> equipmentType;
  final Value<TrackingType> tracking;
  final Value<String> primaryMuscles;
  final Value<String> secondaryMuscles;
  final Value<bool> isCustom;
  final Value<int?> seedVersion;
  final Value<DateTime?> archivedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.searchText = const Value.absent(),
    this.aliases = const Value.absent(),
    this.equipmentType = const Value.absent(),
    this.tracking = const Value.absent(),
    this.primaryMuscles = const Value.absent(),
    this.secondaryMuscles = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.seedVersion = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String searchText,
    this.aliases = const Value.absent(),
    required EquipmentType equipmentType,
    this.tracking = const Value.absent(),
    this.primaryMuscles = const Value.absent(),
    this.secondaryMuscles = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.seedVersion = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       searchText = Value(searchText),
       equipmentType = Value(equipmentType);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? searchText,
    Expression<String>? aliases,
    Expression<String>? equipmentType,
    Expression<String>? tracking,
    Expression<String>? primaryMuscles,
    Expression<String>? secondaryMuscles,
    Expression<bool>? isCustom,
    Expression<int>? seedVersion,
    Expression<DateTime>? archivedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (searchText != null) 'search_text': searchText,
      if (aliases != null) 'aliases': aliases,
      if (equipmentType != null) 'equipment_type': equipmentType,
      if (tracking != null) 'tracking': tracking,
      if (primaryMuscles != null) 'primary_muscles': primaryMuscles,
      if (secondaryMuscles != null) 'secondary_muscles': secondaryMuscles,
      if (isCustom != null) 'is_custom': isCustom,
      if (seedVersion != null) 'seed_version': seedVersion,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? searchText,
    Value<String>? aliases,
    Value<EquipmentType>? equipmentType,
    Value<TrackingType>? tracking,
    Value<String>? primaryMuscles,
    Value<String>? secondaryMuscles,
    Value<bool>? isCustom,
    Value<int?>? seedVersion,
    Value<DateTime?>? archivedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      searchText: searchText ?? this.searchText,
      aliases: aliases ?? this.aliases,
      equipmentType: equipmentType ?? this.equipmentType,
      tracking: tracking ?? this.tracking,
      primaryMuscles: primaryMuscles ?? this.primaryMuscles,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      isCustom: isCustom ?? this.isCustom,
      seedVersion: seedVersion ?? this.seedVersion,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (searchText.present) {
      map['search_text'] = Variable<String>(searchText.value);
    }
    if (aliases.present) {
      map['aliases'] = Variable<String>(aliases.value);
    }
    if (equipmentType.present) {
      map['equipment_type'] = Variable<String>(
        $ExercisesTable.$converterequipmentType.toSql(equipmentType.value),
      );
    }
    if (tracking.present) {
      map['tracking'] = Variable<String>(
        $ExercisesTable.$convertertracking.toSql(tracking.value),
      );
    }
    if (primaryMuscles.present) {
      map['primary_muscles'] = Variable<String>(primaryMuscles.value);
    }
    if (secondaryMuscles.present) {
      map['secondary_muscles'] = Variable<String>(secondaryMuscles.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (seedVersion.present) {
      map['seed_version'] = Variable<int>(seedVersion.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('searchText: $searchText, ')
          ..write('aliases: $aliases, ')
          ..write('equipmentType: $equipmentType, ')
          ..write('tracking: $tracking, ')
          ..write('primaryMuscles: $primaryMuscles, ')
          ..write('secondaryMuscles: $secondaryMuscles, ')
          ..write('isCustom: $isCustom, ')
          ..write('seedVersion: $seedVersion, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StationsTable extends Stations with TableInfo<$StationsTable, Station> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _gymIdMeta = const VerificationMeta('gymId');
  @override
  late final GeneratedColumn<String> gymId = GeneratedColumn<String>(
    'gym_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gyms (id)',
    ),
  );
  static const VerificationMeta _equipmentIdMeta = const VerificationMeta(
    'equipmentId',
  );
  @override
  late final GeneratedColumn<String> equipmentId = GeneratedColumn<String>(
    'equipment_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipment (id)',
    ),
  );
  static const VerificationMeta _pinnedNoteMeta = const VerificationMeta(
    'pinnedNote',
  );
  @override
  late final GeneratedColumn<String> pinnedNote = GeneratedColumn<String>(
    'pinned_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseId,
    gymId,
    equipmentId,
    pinnedNote,
    photoPath,
    archivedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Station> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('gym_id')) {
      context.handle(
        _gymIdMeta,
        gymId.isAcceptableOrUnknown(data['gym_id']!, _gymIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gymIdMeta);
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
        _equipmentIdMeta,
        equipmentId.isAcceptableOrUnknown(
          data['equipment_id']!,
          _equipmentIdMeta,
        ),
      );
    }
    if (data.containsKey('pinned_note')) {
      context.handle(
        _pinnedNoteMeta,
        pinnedNote.isAcceptableOrUnknown(data['pinned_note']!, _pinnedNoteMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Station map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Station(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      gymId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gym_id'],
      )!,
      equipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment_id'],
      ),
      pinnedNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pinned_note'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StationsTable createAlias(String alias) {
    return $StationsTable(attachedDatabase, alias);
  }
}

class Station extends DataClass implements Insertable<Station> {
  final String id;
  final String exerciseId;
  final String gymId;

  /// Nulo para exercício sem aparelho (flexão, prancha...).
  final String? equipmentId;
  final String? pinnedNote;
  final String? photoPath;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Station({
    required this.id,
    required this.exerciseId,
    required this.gymId,
    this.equipmentId,
    this.pinnedNote,
    this.photoPath,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['gym_id'] = Variable<String>(gymId);
    if (!nullToAbsent || equipmentId != null) {
      map['equipment_id'] = Variable<String>(equipmentId);
    }
    if (!nullToAbsent || pinnedNote != null) {
      map['pinned_note'] = Variable<String>(pinnedNote);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StationsCompanion toCompanion(bool nullToAbsent) {
    return StationsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      gymId: Value(gymId),
      equipmentId: equipmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentId),
      pinnedNote: pinnedNote == null && nullToAbsent
          ? const Value.absent()
          : Value(pinnedNote),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Station.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Station(
      id: serializer.fromJson<String>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      gymId: serializer.fromJson<String>(json['gymId']),
      equipmentId: serializer.fromJson<String?>(json['equipmentId']),
      pinnedNote: serializer.fromJson<String?>(json['pinnedNote']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'gymId': serializer.toJson<String>(gymId),
      'equipmentId': serializer.toJson<String?>(equipmentId),
      'pinnedNote': serializer.toJson<String?>(pinnedNote),
      'photoPath': serializer.toJson<String?>(photoPath),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Station copyWith({
    String? id,
    String? exerciseId,
    String? gymId,
    Value<String?> equipmentId = const Value.absent(),
    Value<String?> pinnedNote = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Station(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    gymId: gymId ?? this.gymId,
    equipmentId: equipmentId.present ? equipmentId.value : this.equipmentId,
    pinnedNote: pinnedNote.present ? pinnedNote.value : this.pinnedNote,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Station copyWithCompanion(StationsCompanion data) {
    return Station(
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      gymId: data.gymId.present ? data.gymId.value : this.gymId,
      equipmentId: data.equipmentId.present
          ? data.equipmentId.value
          : this.equipmentId,
      pinnedNote: data.pinnedNote.present
          ? data.pinnedNote.value
          : this.pinnedNote,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Station(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('gymId: $gymId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('pinnedNote: $pinnedNote, ')
          ..write('photoPath: $photoPath, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exerciseId,
    gymId,
    equipmentId,
    pinnedNote,
    photoPath,
    archivedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Station &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.gymId == this.gymId &&
          other.equipmentId == this.equipmentId &&
          other.pinnedNote == this.pinnedNote &&
          other.photoPath == this.photoPath &&
          other.archivedAt == this.archivedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StationsCompanion extends UpdateCompanion<Station> {
  final Value<String> id;
  final Value<String> exerciseId;
  final Value<String> gymId;
  final Value<String?> equipmentId;
  final Value<String?> pinnedNote;
  final Value<String?> photoPath;
  final Value<DateTime?> archivedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StationsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.gymId = const Value.absent(),
    this.equipmentId = const Value.absent(),
    this.pinnedNote = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StationsCompanion.insert({
    this.id = const Value.absent(),
    required String exerciseId,
    required String gymId,
    this.equipmentId = const Value.absent(),
    this.pinnedNote = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       gymId = Value(gymId);
  static Insertable<Station> custom({
    Expression<String>? id,
    Expression<String>? exerciseId,
    Expression<String>? gymId,
    Expression<String>? equipmentId,
    Expression<String>? pinnedNote,
    Expression<String>? photoPath,
    Expression<DateTime>? archivedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (gymId != null) 'gym_id': gymId,
      if (equipmentId != null) 'equipment_id': equipmentId,
      if (pinnedNote != null) 'pinned_note': pinnedNote,
      if (photoPath != null) 'photo_path': photoPath,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StationsCompanion copyWith({
    Value<String>? id,
    Value<String>? exerciseId,
    Value<String>? gymId,
    Value<String?>? equipmentId,
    Value<String?>? pinnedNote,
    Value<String?>? photoPath,
    Value<DateTime?>? archivedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StationsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      gymId: gymId ?? this.gymId,
      equipmentId: equipmentId ?? this.equipmentId,
      pinnedNote: pinnedNote ?? this.pinnedNote,
      photoPath: photoPath ?? this.photoPath,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (gymId.present) {
      map['gym_id'] = Variable<String>(gymId.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<String>(equipmentId.value);
    }
    if (pinnedNote.present) {
      map['pinned_note'] = Variable<String>(pinnedNote.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StationsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('gymId: $gymId, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('pinnedNote: $pinnedNote, ')
          ..write('photoPath: $photoPath, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StationSettingsTable extends StationSettings
    with TableInfo<$StationSettingsTable, StationSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StationSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _stationIdMeta = const VerificationMeta(
    'stationId',
  );
  @override
  late final GeneratedColumn<String> stationId = GeneratedColumn<String>(
    'station_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SettingKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SettingKind>($StationSettingsTable.$converterkind);
  static const VerificationMeta _valueNumMeta = const VerificationMeta(
    'valueNum',
  );
  @override
  late final GeneratedColumn<double> valueNum = GeneratedColumn<double>(
    'value_num',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueTextMeta = const VerificationMeta(
    'valueText',
  );
  @override
  late final GeneratedColumn<String> valueText = GeneratedColumn<String>(
    'value_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<double> step = GeneratedColumn<double>(
    'step',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    stationId,
    label,
    kind,
    valueNum,
    valueText,
    step,
    photoPath,
    sortOrder,
    archivedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'station_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<StationSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('station_id')) {
      context.handle(
        _stationIdMeta,
        stationId.isAcceptableOrUnknown(data['station_id']!, _stationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stationIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('value_num')) {
      context.handle(
        _valueNumMeta,
        valueNum.isAcceptableOrUnknown(data['value_num']!, _valueNumMeta),
      );
    }
    if (data.containsKey('value_text')) {
      context.handle(
        _valueTextMeta,
        valueText.isAcceptableOrUnknown(data['value_text']!, _valueTextMeta),
      );
    }
    if (data.containsKey('step')) {
      context.handle(
        _stepMeta,
        step.isAcceptableOrUnknown(data['step']!, _stepMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StationSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StationSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      stationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      kind: $StationSettingsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      valueNum: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value_num'],
      ),
      valueText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_text'],
      ),
      step: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}step'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StationSettingsTable createAlias(String alias) {
    return $StationSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SettingKind, String, String> $converterkind =
      const EnumNameConverter<SettingKind>(SettingKind.values);
}

class StationSetting extends DataClass implements Insertable<StationSetting> {
  final String id;
  final String stationId;
  final String label;
  final SettingKind kind;
  final double? valueNum;
  final String? valueText;
  final double step;
  final String? photoPath;
  final int sortOrder;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const StationSetting({
    required this.id,
    required this.stationId,
    required this.label,
    required this.kind,
    this.valueNum,
    this.valueText,
    required this.step,
    this.photoPath,
    required this.sortOrder,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['station_id'] = Variable<String>(stationId);
    map['label'] = Variable<String>(label);
    {
      map['kind'] = Variable<String>(
        $StationSettingsTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || valueNum != null) {
      map['value_num'] = Variable<double>(valueNum);
    }
    if (!nullToAbsent || valueText != null) {
      map['value_text'] = Variable<String>(valueText);
    }
    map['step'] = Variable<double>(step);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StationSettingsCompanion toCompanion(bool nullToAbsent) {
    return StationSettingsCompanion(
      id: Value(id),
      stationId: Value(stationId),
      label: Value(label),
      kind: Value(kind),
      valueNum: valueNum == null && nullToAbsent
          ? const Value.absent()
          : Value(valueNum),
      valueText: valueText == null && nullToAbsent
          ? const Value.absent()
          : Value(valueText),
      step: Value(step),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      sortOrder: Value(sortOrder),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StationSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StationSetting(
      id: serializer.fromJson<String>(json['id']),
      stationId: serializer.fromJson<String>(json['stationId']),
      label: serializer.fromJson<String>(json['label']),
      kind: $StationSettingsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      valueNum: serializer.fromJson<double?>(json['valueNum']),
      valueText: serializer.fromJson<String?>(json['valueText']),
      step: serializer.fromJson<double>(json['step']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'stationId': serializer.toJson<String>(stationId),
      'label': serializer.toJson<String>(label),
      'kind': serializer.toJson<String>(
        $StationSettingsTable.$converterkind.toJson(kind),
      ),
      'valueNum': serializer.toJson<double?>(valueNum),
      'valueText': serializer.toJson<String?>(valueText),
      'step': serializer.toJson<double>(step),
      'photoPath': serializer.toJson<String?>(photoPath),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StationSetting copyWith({
    String? id,
    String? stationId,
    String? label,
    SettingKind? kind,
    Value<double?> valueNum = const Value.absent(),
    Value<String?> valueText = const Value.absent(),
    double? step,
    Value<String?> photoPath = const Value.absent(),
    int? sortOrder,
    Value<DateTime?> archivedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => StationSetting(
    id: id ?? this.id,
    stationId: stationId ?? this.stationId,
    label: label ?? this.label,
    kind: kind ?? this.kind,
    valueNum: valueNum.present ? valueNum.value : this.valueNum,
    valueText: valueText.present ? valueText.value : this.valueText,
    step: step ?? this.step,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    sortOrder: sortOrder ?? this.sortOrder,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StationSetting copyWithCompanion(StationSettingsCompanion data) {
    return StationSetting(
      id: data.id.present ? data.id.value : this.id,
      stationId: data.stationId.present ? data.stationId.value : this.stationId,
      label: data.label.present ? data.label.value : this.label,
      kind: data.kind.present ? data.kind.value : this.kind,
      valueNum: data.valueNum.present ? data.valueNum.value : this.valueNum,
      valueText: data.valueText.present ? data.valueText.value : this.valueText,
      step: data.step.present ? data.step.value : this.step,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StationSetting(')
          ..write('id: $id, ')
          ..write('stationId: $stationId, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('valueNum: $valueNum, ')
          ..write('valueText: $valueText, ')
          ..write('step: $step, ')
          ..write('photoPath: $photoPath, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    stationId,
    label,
    kind,
    valueNum,
    valueText,
    step,
    photoPath,
    sortOrder,
    archivedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StationSetting &&
          other.id == this.id &&
          other.stationId == this.stationId &&
          other.label == this.label &&
          other.kind == this.kind &&
          other.valueNum == this.valueNum &&
          other.valueText == this.valueText &&
          other.step == this.step &&
          other.photoPath == this.photoPath &&
          other.sortOrder == this.sortOrder &&
          other.archivedAt == this.archivedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StationSettingsCompanion extends UpdateCompanion<StationSetting> {
  final Value<String> id;
  final Value<String> stationId;
  final Value<String> label;
  final Value<SettingKind> kind;
  final Value<double?> valueNum;
  final Value<String?> valueText;
  final Value<double> step;
  final Value<String?> photoPath;
  final Value<int> sortOrder;
  final Value<DateTime?> archivedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StationSettingsCompanion({
    this.id = const Value.absent(),
    this.stationId = const Value.absent(),
    this.label = const Value.absent(),
    this.kind = const Value.absent(),
    this.valueNum = const Value.absent(),
    this.valueText = const Value.absent(),
    this.step = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StationSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String stationId,
    required String label,
    required SettingKind kind,
    this.valueNum = const Value.absent(),
    this.valueText = const Value.absent(),
    this.step = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : stationId = Value(stationId),
       label = Value(label),
       kind = Value(kind);
  static Insertable<StationSetting> custom({
    Expression<String>? id,
    Expression<String>? stationId,
    Expression<String>? label,
    Expression<String>? kind,
    Expression<double>? valueNum,
    Expression<String>? valueText,
    Expression<double>? step,
    Expression<String>? photoPath,
    Expression<int>? sortOrder,
    Expression<DateTime>? archivedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stationId != null) 'station_id': stationId,
      if (label != null) 'label': label,
      if (kind != null) 'kind': kind,
      if (valueNum != null) 'value_num': valueNum,
      if (valueText != null) 'value_text': valueText,
      if (step != null) 'step': step,
      if (photoPath != null) 'photo_path': photoPath,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StationSettingsCompanion copyWith({
    Value<String>? id,
    Value<String>? stationId,
    Value<String>? label,
    Value<SettingKind>? kind,
    Value<double?>? valueNum,
    Value<String?>? valueText,
    Value<double>? step,
    Value<String?>? photoPath,
    Value<int>? sortOrder,
    Value<DateTime?>? archivedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StationSettingsCompanion(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      valueNum: valueNum ?? this.valueNum,
      valueText: valueText ?? this.valueText,
      step: step ?? this.step,
      photoPath: photoPath ?? this.photoPath,
      sortOrder: sortOrder ?? this.sortOrder,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (stationId.present) {
      map['station_id'] = Variable<String>(stationId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $StationSettingsTable.$converterkind.toSql(kind.value),
      );
    }
    if (valueNum.present) {
      map['value_num'] = Variable<double>(valueNum.value);
    }
    if (valueText.present) {
      map['value_text'] = Variable<String>(valueText.value);
    }
    if (step.present) {
      map['step'] = Variable<double>(step.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StationSettingsCompanion(')
          ..write('id: $id, ')
          ..write('stationId: $stationId, ')
          ..write('label: $label, ')
          ..write('kind: $kind, ')
          ..write('valueNum: $valueNum, ')
          ..write('valueText: $valueText, ')
          ..write('step: $step, ')
          ..write('photoPath: $photoPath, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gymIdMeta = const VerificationMeta('gymId');
  @override
  late final GeneratedColumn<String> gymId = GeneratedColumn<String>(
    'gym_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gyms (id)',
    ),
  );
  static const VerificationMeta _trainerMeta = const VerificationMeta(
    'trainer',
  );
  @override
  late final GeneratedColumn<String> trainer = GeneratedColumn<String>(
    'trainer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresOnMeta = const VerificationMeta(
    'expiresOn',
  );
  @override
  late final GeneratedColumn<String> expiresOn = GeneratedColumn<String>(
    'expires_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    label,
    gymId,
    trainer,
    expiresOn,
    notes,
    sortOrder,
    archivedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Routine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('gym_id')) {
      context.handle(
        _gymIdMeta,
        gymId.isAcceptableOrUnknown(data['gym_id']!, _gymIdMeta),
      );
    }
    if (data.containsKey('trainer')) {
      context.handle(
        _trainerMeta,
        trainer.isAcceptableOrUnknown(data['trainer']!, _trainerMeta),
      );
    }
    if (data.containsKey('expires_on')) {
      context.handle(
        _expiresOnMeta,
        expiresOn.isAcceptableOrUnknown(data['expires_on']!, _expiresOnMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      gymId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gym_id'],
      ),
      trainer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trainer'],
      ),
      expiresOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expires_on'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class Routine extends DataClass implements Insertable<Routine> {
  final String id;
  final String name;
  final String? label;
  final String? gymId;
  final String? trainer;

  /// Vencimento da ficha (AAAA-MM-DD).
  final String? expiresOn;
  final String? notes;
  final int sortOrder;
  final DateTime? archivedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Routine({
    required this.id,
    required this.name,
    this.label,
    this.gymId,
    this.trainer,
    this.expiresOn,
    this.notes,
    required this.sortOrder,
    this.archivedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    if (!nullToAbsent || gymId != null) {
      map['gym_id'] = Variable<String>(gymId);
    }
    if (!nullToAbsent || trainer != null) {
      map['trainer'] = Variable<String>(trainer);
    }
    if (!nullToAbsent || expiresOn != null) {
      map['expires_on'] = Variable<String>(expiresOn);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      name: Value(name),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      gymId: gymId == null && nullToAbsent
          ? const Value.absent()
          : Value(gymId),
      trainer: trainer == null && nullToAbsent
          ? const Value.absent()
          : Value(trainer),
      expiresOn: expiresOn == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresOn),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      sortOrder: Value(sortOrder),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Routine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      label: serializer.fromJson<String?>(json['label']),
      gymId: serializer.fromJson<String?>(json['gymId']),
      trainer: serializer.fromJson<String?>(json['trainer']),
      expiresOn: serializer.fromJson<String?>(json['expiresOn']),
      notes: serializer.fromJson<String?>(json['notes']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'label': serializer.toJson<String?>(label),
      'gymId': serializer.toJson<String?>(gymId),
      'trainer': serializer.toJson<String?>(trainer),
      'expiresOn': serializer.toJson<String?>(expiresOn),
      'notes': serializer.toJson<String?>(notes),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Routine copyWith({
    String? id,
    String? name,
    Value<String?> label = const Value.absent(),
    Value<String?> gymId = const Value.absent(),
    Value<String?> trainer = const Value.absent(),
    Value<String?> expiresOn = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? sortOrder,
    Value<DateTime?> archivedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Routine(
    id: id ?? this.id,
    name: name ?? this.name,
    label: label.present ? label.value : this.label,
    gymId: gymId.present ? gymId.value : this.gymId,
    trainer: trainer.present ? trainer.value : this.trainer,
    expiresOn: expiresOn.present ? expiresOn.value : this.expiresOn,
    notes: notes.present ? notes.value : this.notes,
    sortOrder: sortOrder ?? this.sortOrder,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      label: data.label.present ? data.label.value : this.label,
      gymId: data.gymId.present ? data.gymId.value : this.gymId,
      trainer: data.trainer.present ? data.trainer.value : this.trainer,
      expiresOn: data.expiresOn.present ? data.expiresOn.value : this.expiresOn,
      notes: data.notes.present ? data.notes.value : this.notes,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('label: $label, ')
          ..write('gymId: $gymId, ')
          ..write('trainer: $trainer, ')
          ..write('expiresOn: $expiresOn, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    label,
    gymId,
    trainer,
    expiresOn,
    notes,
    sortOrder,
    archivedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.name == this.name &&
          other.label == this.label &&
          other.gymId == this.gymId &&
          other.trainer == this.trainer &&
          other.expiresOn == this.expiresOn &&
          other.notes == this.notes &&
          other.sortOrder == this.sortOrder &&
          other.archivedAt == this.archivedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> label;
  final Value<String?> gymId;
  final Value<String?> trainer;
  final Value<String?> expiresOn;
  final Value<String?> notes;
  final Value<int> sortOrder;
  final Value<DateTime?> archivedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.label = const Value.absent(),
    this.gymId = const Value.absent(),
    this.trainer = const Value.absent(),
    this.expiresOn = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.label = const Value.absent(),
    this.gymId = const Value.absent(),
    this.trainer = const Value.absent(),
    this.expiresOn = const Value.absent(),
    this.notes = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Routine> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? label,
    Expression<String>? gymId,
    Expression<String>? trainer,
    Expression<String>? expiresOn,
    Expression<String>? notes,
    Expression<int>? sortOrder,
    Expression<DateTime>? archivedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (label != null) 'label': label,
      if (gymId != null) 'gym_id': gymId,
      if (trainer != null) 'trainer': trainer,
      if (expiresOn != null) 'expires_on': expiresOn,
      if (notes != null) 'notes': notes,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? label,
    Value<String?>? gymId,
    Value<String?>? trainer,
    Value<String?>? expiresOn,
    Value<String?>? notes,
    Value<int>? sortOrder,
    Value<DateTime?>? archivedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      label: label ?? this.label,
      gymId: gymId ?? this.gymId,
      trainer: trainer ?? this.trainer,
      expiresOn: expiresOn ?? this.expiresOn,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (gymId.present) {
      map['gym_id'] = Variable<String>(gymId.value);
    }
    if (trainer.present) {
      map['trainer'] = Variable<String>(trainer.value);
    }
    if (expiresOn.present) {
      map['expires_on'] = Variable<String>(expiresOn.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('label: $label, ')
          ..write('gymId: $gymId, ')
          ..write('trainer: $trainer, ')
          ..write('expiresOn: $expiresOn, ')
          ..write('notes: $notes, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _gymIdMeta = const VerificationMeta('gymId');
  @override
  late final GeneratedColumn<String> gymId = GeneratedColumn<String>(
    'gym_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gyms (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restEndsAtMeta = const VerificationMeta(
    'restEndsAt',
  );
  @override
  late final GeneratedColumn<DateTime> restEndsAt = GeneratedColumn<DateTime>(
    'rest_ends_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routineId,
    gymId,
    title,
    startedAt,
    endedAt,
    localDate,
    restEndsAt,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    }
    if (data.containsKey('gym_id')) {
      context.handle(
        _gymIdMeta,
        gymId.isAcceptableOrUnknown(data['gym_id']!, _gymIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gymIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('rest_ends_at')) {
      context.handle(
        _restEndsAtMeta,
        restEndsAt.isAcceptableOrUnknown(
          data['rest_ends_at']!,
          _restEndsAtMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      ),
      gymId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gym_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      restEndsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}rest_ends_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final String id;
  final String? routineId;
  final String gymId;

  /// Cópia do nome da ficha naquele dia ("Treino livre" se não houver).
  final String title;
  final DateTime startedAt;

  /// Nulo enquanto o treino está em andamento.
  final DateTime? endedAt;
  final String localDate;

  /// Instante absoluto em que o descanso atual termina. A tela calcula
  /// `restante = restEndsAt − agora`, então o timer sobrevive ao app fechar.
  final DateTime? restEndsAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WorkoutSession({
    required this.id,
    this.routineId,
    required this.gymId,
    required this.title,
    required this.startedAt,
    this.endedAt,
    required this.localDate,
    this.restEndsAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || routineId != null) {
      map['routine_id'] = Variable<String>(routineId);
    }
    map['gym_id'] = Variable<String>(gymId);
    map['title'] = Variable<String>(title);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['local_date'] = Variable<String>(localDate);
    if (!nullToAbsent || restEndsAt != null) {
      map['rest_ends_at'] = Variable<DateTime>(restEndsAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      routineId: routineId == null && nullToAbsent
          ? const Value.absent()
          : Value(routineId),
      gymId: Value(gymId),
      title: Value(title),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      localDate: Value(localDate),
      restEndsAt: restEndsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(restEndsAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<String>(json['id']),
      routineId: serializer.fromJson<String?>(json['routineId']),
      gymId: serializer.fromJson<String>(json['gymId']),
      title: serializer.fromJson<String>(json['title']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      localDate: serializer.fromJson<String>(json['localDate']),
      restEndsAt: serializer.fromJson<DateTime?>(json['restEndsAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineId': serializer.toJson<String?>(routineId),
      'gymId': serializer.toJson<String>(gymId),
      'title': serializer.toJson<String>(title),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'localDate': serializer.toJson<String>(localDate),
      'restEndsAt': serializer.toJson<DateTime?>(restEndsAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkoutSession copyWith({
    String? id,
    Value<String?> routineId = const Value.absent(),
    String? gymId,
    String? title,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    String? localDate,
    Value<DateTime?> restEndsAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WorkoutSession(
    id: id ?? this.id,
    routineId: routineId.present ? routineId.value : this.routineId,
    gymId: gymId ?? this.gymId,
    title: title ?? this.title,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    localDate: localDate ?? this.localDate,
    restEndsAt: restEndsAt.present ? restEndsAt.value : this.restEndsAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      gymId: data.gymId.present ? data.gymId.value : this.gymId,
      title: data.title.present ? data.title.value : this.title,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      restEndsAt: data.restEndsAt.present
          ? data.restEndsAt.value
          : this.restEndsAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('gymId: $gymId, ')
          ..write('title: $title, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('localDate: $localDate, ')
          ..write('restEndsAt: $restEndsAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    routineId,
    gymId,
    title,
    startedAt,
    endedAt,
    localDate,
    restEndsAt,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.gymId == this.gymId &&
          other.title == this.title &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.localDate == this.localDate &&
          other.restEndsAt == this.restEndsAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<String> id;
  final Value<String?> routineId;
  final Value<String> gymId;
  final Value<String> title;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String> localDate;
  final Value<DateTime?> restEndsAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.gymId = const Value.absent(),
    this.title = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.localDate = const Value.absent(),
    this.restEndsAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    required String gymId,
    required String title,
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    required String localDate,
    this.restEndsAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : gymId = Value(gymId),
       title = Value(title),
       localDate = Value(localDate);
  static Insertable<WorkoutSession> custom({
    Expression<String>? id,
    Expression<String>? routineId,
    Expression<String>? gymId,
    Expression<String>? title,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? localDate,
    Expression<DateTime>? restEndsAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (gymId != null) 'gym_id': gymId,
      if (title != null) 'title': title,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (localDate != null) 'local_date': localDate,
      if (restEndsAt != null) 'rest_ends_at': restEndsAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<String?>? routineId,
    Value<String>? gymId,
    Value<String>? title,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String>? localDate,
    Value<DateTime?>? restEndsAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      gymId: gymId ?? this.gymId,
      title: title ?? this.title,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      localDate: localDate ?? this.localDate,
      restEndsAt: restEndsAt ?? this.restEndsAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (gymId.present) {
      map['gym_id'] = Variable<String>(gymId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (restEndsAt.present) {
      map['rest_ends_at'] = Variable<DateTime>(restEndsAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('gymId: $gymId, ')
          ..write('title: $title, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('localDate: $localDate, ')
          ..write('restEndsAt: $restEndsAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StationSettingChangesTable extends StationSettingChanges
    with TableInfo<$StationSettingChangesTable, StationSettingChange> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StationSettingChangesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _settingIdMeta = const VerificationMeta(
    'settingId',
  );
  @override
  late final GeneratedColumn<String> settingId = GeneratedColumn<String>(
    'setting_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES station_settings (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _oldValueMeta = const VerificationMeta(
    'oldValue',
  );
  @override
  late final GeneratedColumn<String> oldValue = GeneratedColumn<String>(
    'old_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _newValueMeta = const VerificationMeta(
    'newValue',
  );
  @override
  late final GeneratedColumn<String> newValue = GeneratedColumn<String>(
    'new_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    settingId,
    oldValue,
    newValue,
    sessionId,
    changedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'station_setting_changes';
  @override
  VerificationContext validateIntegrity(
    Insertable<StationSettingChange> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('setting_id')) {
      context.handle(
        _settingIdMeta,
        settingId.isAcceptableOrUnknown(data['setting_id']!, _settingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_settingIdMeta);
    }
    if (data.containsKey('old_value')) {
      context.handle(
        _oldValueMeta,
        oldValue.isAcceptableOrUnknown(data['old_value']!, _oldValueMeta),
      );
    }
    if (data.containsKey('new_value')) {
      context.handle(
        _newValueMeta,
        newValue.isAcceptableOrUnknown(data['new_value']!, _newValueMeta),
      );
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StationSettingChange map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StationSettingChange(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      settingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_id'],
      )!,
      oldValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}old_value'],
      ),
      newValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_value'],
      ),
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}changed_at'],
      )!,
    );
  }

  @override
  $StationSettingChangesTable createAlias(String alias) {
    return $StationSettingChangesTable(attachedDatabase, alias);
  }
}

class StationSettingChange extends DataClass
    implements Insertable<StationSettingChange> {
  final String id;
  final String settingId;
  final String? oldValue;
  final String? newValue;
  final String? sessionId;
  final DateTime changedAt;
  const StationSettingChange({
    required this.id,
    required this.settingId,
    this.oldValue,
    this.newValue,
    this.sessionId,
    required this.changedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['setting_id'] = Variable<String>(settingId);
    if (!nullToAbsent || oldValue != null) {
      map['old_value'] = Variable<String>(oldValue);
    }
    if (!nullToAbsent || newValue != null) {
      map['new_value'] = Variable<String>(newValue);
    }
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['changed_at'] = Variable<DateTime>(changedAt);
    return map;
  }

  StationSettingChangesCompanion toCompanion(bool nullToAbsent) {
    return StationSettingChangesCompanion(
      id: Value(id),
      settingId: Value(settingId),
      oldValue: oldValue == null && nullToAbsent
          ? const Value.absent()
          : Value(oldValue),
      newValue: newValue == null && nullToAbsent
          ? const Value.absent()
          : Value(newValue),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      changedAt: Value(changedAt),
    );
  }

  factory StationSettingChange.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StationSettingChange(
      id: serializer.fromJson<String>(json['id']),
      settingId: serializer.fromJson<String>(json['settingId']),
      oldValue: serializer.fromJson<String?>(json['oldValue']),
      newValue: serializer.fromJson<String?>(json['newValue']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'settingId': serializer.toJson<String>(settingId),
      'oldValue': serializer.toJson<String?>(oldValue),
      'newValue': serializer.toJson<String?>(newValue),
      'sessionId': serializer.toJson<String?>(sessionId),
      'changedAt': serializer.toJson<DateTime>(changedAt),
    };
  }

  StationSettingChange copyWith({
    String? id,
    String? settingId,
    Value<String?> oldValue = const Value.absent(),
    Value<String?> newValue = const Value.absent(),
    Value<String?> sessionId = const Value.absent(),
    DateTime? changedAt,
  }) => StationSettingChange(
    id: id ?? this.id,
    settingId: settingId ?? this.settingId,
    oldValue: oldValue.present ? oldValue.value : this.oldValue,
    newValue: newValue.present ? newValue.value : this.newValue,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    changedAt: changedAt ?? this.changedAt,
  );
  StationSettingChange copyWithCompanion(StationSettingChangesCompanion data) {
    return StationSettingChange(
      id: data.id.present ? data.id.value : this.id,
      settingId: data.settingId.present ? data.settingId.value : this.settingId,
      oldValue: data.oldValue.present ? data.oldValue.value : this.oldValue,
      newValue: data.newValue.present ? data.newValue.value : this.newValue,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StationSettingChange(')
          ..write('id: $id, ')
          ..write('settingId: $settingId, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue, ')
          ..write('sessionId: $sessionId, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, settingId, oldValue, newValue, sessionId, changedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StationSettingChange &&
          other.id == this.id &&
          other.settingId == this.settingId &&
          other.oldValue == this.oldValue &&
          other.newValue == this.newValue &&
          other.sessionId == this.sessionId &&
          other.changedAt == this.changedAt);
}

class StationSettingChangesCompanion
    extends UpdateCompanion<StationSettingChange> {
  final Value<String> id;
  final Value<String> settingId;
  final Value<String?> oldValue;
  final Value<String?> newValue;
  final Value<String?> sessionId;
  final Value<DateTime> changedAt;
  final Value<int> rowid;
  const StationSettingChangesCompanion({
    this.id = const Value.absent(),
    this.settingId = const Value.absent(),
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StationSettingChangesCompanion.insert({
    this.id = const Value.absent(),
    required String settingId,
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : settingId = Value(settingId);
  static Insertable<StationSettingChange> custom({
    Expression<String>? id,
    Expression<String>? settingId,
    Expression<String>? oldValue,
    Expression<String>? newValue,
    Expression<String>? sessionId,
    Expression<DateTime>? changedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (settingId != null) 'setting_id': settingId,
      if (oldValue != null) 'old_value': oldValue,
      if (newValue != null) 'new_value': newValue,
      if (sessionId != null) 'session_id': sessionId,
      if (changedAt != null) 'changed_at': changedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StationSettingChangesCompanion copyWith({
    Value<String>? id,
    Value<String>? settingId,
    Value<String?>? oldValue,
    Value<String?>? newValue,
    Value<String?>? sessionId,
    Value<DateTime>? changedAt,
    Value<int>? rowid,
  }) {
    return StationSettingChangesCompanion(
      id: id ?? this.id,
      settingId: settingId ?? this.settingId,
      oldValue: oldValue ?? this.oldValue,
      newValue: newValue ?? this.newValue,
      sessionId: sessionId ?? this.sessionId,
      changedAt: changedAt ?? this.changedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (settingId.present) {
      map['setting_id'] = Variable<String>(settingId.value);
    }
    if (oldValue.present) {
      map['old_value'] = Variable<String>(oldValue.value);
    }
    if (newValue.present) {
      map['new_value'] = Variable<String>(newValue.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StationSettingChangesCompanion(')
          ..write('id: $id, ')
          ..write('settingId: $settingId, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue, ')
          ..write('sessionId: $sessionId, ')
          ..write('changedAt: $changedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineExercisesTable extends RoutineExercises
    with TableInfo<$RoutineExercisesTable, RoutineExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES routines (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _preferredEquipmentIdMeta =
      const VerificationMeta('preferredEquipmentId');
  @override
  late final GeneratedColumn<String> preferredEquipmentId =
      GeneratedColumn<String>(
        'preferred_equipment_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES equipment (id)',
        ),
      );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _repMinMeta = const VerificationMeta('repMin');
  @override
  late final GeneratedColumn<int> repMin = GeneratedColumn<int>(
    'rep_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repMaxMeta = const VerificationMeta('repMax');
  @override
  late final GeneratedColumn<int> repMax = GeneratedColumn<int>(
    'rep_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetRirMeta = const VerificationMeta(
    'targetRir',
  );
  @override
  late final GeneratedColumn<int> targetRir = GeneratedColumn<int>(
    'target_rir',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecMeta = const VerificationMeta(
    'restSec',
  );
  @override
  late final GeneratedColumn<int> restSec = GeneratedColumn<int>(
    'rest_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _warmupSetsMeta = const VerificationMeta(
    'warmupSets',
  );
  @override
  late final GeneratedColumn<int> warmupSets = GeneratedColumn<int>(
    'warmup_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tempoMeta = const VerificationMeta('tempo');
  @override
  late final GeneratedColumn<String> tempo = GeneratedColumn<String>(
    'tempo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supersetGroupMeta = const VerificationMeta(
    'supersetGroup',
  );
  @override
  late final GeneratedColumn<int> supersetGroup = GeneratedColumn<int>(
    'superset_group',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routineId,
    exerciseId,
    preferredEquipmentId,
    position,
    targetSets,
    repMin,
    repMax,
    targetRir,
    restSec,
    warmupSets,
    tempo,
    notes,
    supersetGroup,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('preferred_equipment_id')) {
      context.handle(
        _preferredEquipmentIdMeta,
        preferredEquipmentId.isAcceptableOrUnknown(
          data['preferred_equipment_id']!,
          _preferredEquipmentIdMeta,
        ),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    }
    if (data.containsKey('rep_min')) {
      context.handle(
        _repMinMeta,
        repMin.isAcceptableOrUnknown(data['rep_min']!, _repMinMeta),
      );
    }
    if (data.containsKey('rep_max')) {
      context.handle(
        _repMaxMeta,
        repMax.isAcceptableOrUnknown(data['rep_max']!, _repMaxMeta),
      );
    }
    if (data.containsKey('target_rir')) {
      context.handle(
        _targetRirMeta,
        targetRir.isAcceptableOrUnknown(data['target_rir']!, _targetRirMeta),
      );
    }
    if (data.containsKey('rest_sec')) {
      context.handle(
        _restSecMeta,
        restSec.isAcceptableOrUnknown(data['rest_sec']!, _restSecMeta),
      );
    }
    if (data.containsKey('warmup_sets')) {
      context.handle(
        _warmupSetsMeta,
        warmupSets.isAcceptableOrUnknown(data['warmup_sets']!, _warmupSetsMeta),
      );
    }
    if (data.containsKey('tempo')) {
      context.handle(
        _tempoMeta,
        tempo.isAcceptableOrUnknown(data['tempo']!, _tempoMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('superset_group')) {
      context.handle(
        _supersetGroupMeta,
        supersetGroup.isAcceptableOrUnknown(
          data['superset_group']!,
          _supersetGroupMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      preferredEquipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_equipment_id'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      )!,
      repMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rep_min'],
      ),
      repMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rep_max'],
      ),
      targetRir: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_rir'],
      ),
      restSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_sec'],
      ),
      warmupSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}warmup_sets'],
      )!,
      tempo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tempo'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      supersetGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}superset_group'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RoutineExercisesTable createAlias(String alias) {
    return $RoutineExercisesTable(attachedDatabase, alias);
  }
}

class RoutineExercise extends DataClass implements Insertable<RoutineExercise> {
  final String id;
  final String routineId;
  final String exerciseId;
  final String? preferredEquipmentId;
  final int position;
  final int targetSets;
  final int? repMin;
  final int? repMax;
  final int? targetRir;
  final int? restSec;
  final int warmupSets;

  /// Cadência prescrita ("3-1-1-0"). Não se digita por série.
  final String? tempo;
  final String? notes;
  final int? supersetGroup;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RoutineExercise({
    required this.id,
    required this.routineId,
    required this.exerciseId,
    this.preferredEquipmentId,
    required this.position,
    required this.targetSets,
    this.repMin,
    this.repMax,
    this.targetRir,
    this.restSec,
    required this.warmupSets,
    this.tempo,
    this.notes,
    this.supersetGroup,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['routine_id'] = Variable<String>(routineId);
    map['exercise_id'] = Variable<String>(exerciseId);
    if (!nullToAbsent || preferredEquipmentId != null) {
      map['preferred_equipment_id'] = Variable<String>(preferredEquipmentId);
    }
    map['position'] = Variable<int>(position);
    map['target_sets'] = Variable<int>(targetSets);
    if (!nullToAbsent || repMin != null) {
      map['rep_min'] = Variable<int>(repMin);
    }
    if (!nullToAbsent || repMax != null) {
      map['rep_max'] = Variable<int>(repMax);
    }
    if (!nullToAbsent || targetRir != null) {
      map['target_rir'] = Variable<int>(targetRir);
    }
    if (!nullToAbsent || restSec != null) {
      map['rest_sec'] = Variable<int>(restSec);
    }
    map['warmup_sets'] = Variable<int>(warmupSets);
    if (!nullToAbsent || tempo != null) {
      map['tempo'] = Variable<String>(tempo);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || supersetGroup != null) {
      map['superset_group'] = Variable<int>(supersetGroup);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RoutineExercisesCompanion toCompanion(bool nullToAbsent) {
    return RoutineExercisesCompanion(
      id: Value(id),
      routineId: Value(routineId),
      exerciseId: Value(exerciseId),
      preferredEquipmentId: preferredEquipmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredEquipmentId),
      position: Value(position),
      targetSets: Value(targetSets),
      repMin: repMin == null && nullToAbsent
          ? const Value.absent()
          : Value(repMin),
      repMax: repMax == null && nullToAbsent
          ? const Value.absent()
          : Value(repMax),
      targetRir: targetRir == null && nullToAbsent
          ? const Value.absent()
          : Value(targetRir),
      restSec: restSec == null && nullToAbsent
          ? const Value.absent()
          : Value(restSec),
      warmupSets: Value(warmupSets),
      tempo: tempo == null && nullToAbsent
          ? const Value.absent()
          : Value(tempo),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      supersetGroup: supersetGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(supersetGroup),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RoutineExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineExercise(
      id: serializer.fromJson<String>(json['id']),
      routineId: serializer.fromJson<String>(json['routineId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      preferredEquipmentId: serializer.fromJson<String?>(
        json['preferredEquipmentId'],
      ),
      position: serializer.fromJson<int>(json['position']),
      targetSets: serializer.fromJson<int>(json['targetSets']),
      repMin: serializer.fromJson<int?>(json['repMin']),
      repMax: serializer.fromJson<int?>(json['repMax']),
      targetRir: serializer.fromJson<int?>(json['targetRir']),
      restSec: serializer.fromJson<int?>(json['restSec']),
      warmupSets: serializer.fromJson<int>(json['warmupSets']),
      tempo: serializer.fromJson<String?>(json['tempo']),
      notes: serializer.fromJson<String?>(json['notes']),
      supersetGroup: serializer.fromJson<int?>(json['supersetGroup']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineId': serializer.toJson<String>(routineId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'preferredEquipmentId': serializer.toJson<String?>(preferredEquipmentId),
      'position': serializer.toJson<int>(position),
      'targetSets': serializer.toJson<int>(targetSets),
      'repMin': serializer.toJson<int?>(repMin),
      'repMax': serializer.toJson<int?>(repMax),
      'targetRir': serializer.toJson<int?>(targetRir),
      'restSec': serializer.toJson<int?>(restSec),
      'warmupSets': serializer.toJson<int>(warmupSets),
      'tempo': serializer.toJson<String?>(tempo),
      'notes': serializer.toJson<String?>(notes),
      'supersetGroup': serializer.toJson<int?>(supersetGroup),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RoutineExercise copyWith({
    String? id,
    String? routineId,
    String? exerciseId,
    Value<String?> preferredEquipmentId = const Value.absent(),
    int? position,
    int? targetSets,
    Value<int?> repMin = const Value.absent(),
    Value<int?> repMax = const Value.absent(),
    Value<int?> targetRir = const Value.absent(),
    Value<int?> restSec = const Value.absent(),
    int? warmupSets,
    Value<String?> tempo = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<int?> supersetGroup = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RoutineExercise(
    id: id ?? this.id,
    routineId: routineId ?? this.routineId,
    exerciseId: exerciseId ?? this.exerciseId,
    preferredEquipmentId: preferredEquipmentId.present
        ? preferredEquipmentId.value
        : this.preferredEquipmentId,
    position: position ?? this.position,
    targetSets: targetSets ?? this.targetSets,
    repMin: repMin.present ? repMin.value : this.repMin,
    repMax: repMax.present ? repMax.value : this.repMax,
    targetRir: targetRir.present ? targetRir.value : this.targetRir,
    restSec: restSec.present ? restSec.value : this.restSec,
    warmupSets: warmupSets ?? this.warmupSets,
    tempo: tempo.present ? tempo.value : this.tempo,
    notes: notes.present ? notes.value : this.notes,
    supersetGroup: supersetGroup.present
        ? supersetGroup.value
        : this.supersetGroup,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RoutineExercise copyWithCompanion(RoutineExercisesCompanion data) {
    return RoutineExercise(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      preferredEquipmentId: data.preferredEquipmentId.present
          ? data.preferredEquipmentId.value
          : this.preferredEquipmentId,
      position: data.position.present ? data.position.value : this.position,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      repMin: data.repMin.present ? data.repMin.value : this.repMin,
      repMax: data.repMax.present ? data.repMax.value : this.repMax,
      targetRir: data.targetRir.present ? data.targetRir.value : this.targetRir,
      restSec: data.restSec.present ? data.restSec.value : this.restSec,
      warmupSets: data.warmupSets.present
          ? data.warmupSets.value
          : this.warmupSets,
      tempo: data.tempo.present ? data.tempo.value : this.tempo,
      notes: data.notes.present ? data.notes.value : this.notes,
      supersetGroup: data.supersetGroup.present
          ? data.supersetGroup.value
          : this.supersetGroup,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineExercise(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('preferredEquipmentId: $preferredEquipmentId, ')
          ..write('position: $position, ')
          ..write('targetSets: $targetSets, ')
          ..write('repMin: $repMin, ')
          ..write('repMax: $repMax, ')
          ..write('targetRir: $targetRir, ')
          ..write('restSec: $restSec, ')
          ..write('warmupSets: $warmupSets, ')
          ..write('tempo: $tempo, ')
          ..write('notes: $notes, ')
          ..write('supersetGroup: $supersetGroup, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    routineId,
    exerciseId,
    preferredEquipmentId,
    position,
    targetSets,
    repMin,
    repMax,
    targetRir,
    restSec,
    warmupSets,
    tempo,
    notes,
    supersetGroup,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineExercise &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.exerciseId == this.exerciseId &&
          other.preferredEquipmentId == this.preferredEquipmentId &&
          other.position == this.position &&
          other.targetSets == this.targetSets &&
          other.repMin == this.repMin &&
          other.repMax == this.repMax &&
          other.targetRir == this.targetRir &&
          other.restSec == this.restSec &&
          other.warmupSets == this.warmupSets &&
          other.tempo == this.tempo &&
          other.notes == this.notes &&
          other.supersetGroup == this.supersetGroup &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutineExercisesCompanion extends UpdateCompanion<RoutineExercise> {
  final Value<String> id;
  final Value<String> routineId;
  final Value<String> exerciseId;
  final Value<String?> preferredEquipmentId;
  final Value<int> position;
  final Value<int> targetSets;
  final Value<int?> repMin;
  final Value<int?> repMax;
  final Value<int?> targetRir;
  final Value<int?> restSec;
  final Value<int> warmupSets;
  final Value<String?> tempo;
  final Value<String?> notes;
  final Value<int?> supersetGroup;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RoutineExercisesCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.preferredEquipmentId = const Value.absent(),
    this.position = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.repMin = const Value.absent(),
    this.repMax = const Value.absent(),
    this.targetRir = const Value.absent(),
    this.restSec = const Value.absent(),
    this.warmupSets = const Value.absent(),
    this.tempo = const Value.absent(),
    this.notes = const Value.absent(),
    this.supersetGroup = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String routineId,
    required String exerciseId,
    this.preferredEquipmentId = const Value.absent(),
    required int position,
    this.targetSets = const Value.absent(),
    this.repMin = const Value.absent(),
    this.repMax = const Value.absent(),
    this.targetRir = const Value.absent(),
    this.restSec = const Value.absent(),
    this.warmupSets = const Value.absent(),
    this.tempo = const Value.absent(),
    this.notes = const Value.absent(),
    this.supersetGroup = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : routineId = Value(routineId),
       exerciseId = Value(exerciseId),
       position = Value(position);
  static Insertable<RoutineExercise> custom({
    Expression<String>? id,
    Expression<String>? routineId,
    Expression<String>? exerciseId,
    Expression<String>? preferredEquipmentId,
    Expression<int>? position,
    Expression<int>? targetSets,
    Expression<int>? repMin,
    Expression<int>? repMax,
    Expression<int>? targetRir,
    Expression<int>? restSec,
    Expression<int>? warmupSets,
    Expression<String>? tempo,
    Expression<String>? notes,
    Expression<int>? supersetGroup,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (preferredEquipmentId != null)
        'preferred_equipment_id': preferredEquipmentId,
      if (position != null) 'position': position,
      if (targetSets != null) 'target_sets': targetSets,
      if (repMin != null) 'rep_min': repMin,
      if (repMax != null) 'rep_max': repMax,
      if (targetRir != null) 'target_rir': targetRir,
      if (restSec != null) 'rest_sec': restSec,
      if (warmupSets != null) 'warmup_sets': warmupSets,
      if (tempo != null) 'tempo': tempo,
      if (notes != null) 'notes': notes,
      if (supersetGroup != null) 'superset_group': supersetGroup,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? routineId,
    Value<String>? exerciseId,
    Value<String?>? preferredEquipmentId,
    Value<int>? position,
    Value<int>? targetSets,
    Value<int?>? repMin,
    Value<int?>? repMax,
    Value<int?>? targetRir,
    Value<int?>? restSec,
    Value<int>? warmupSets,
    Value<String?>? tempo,
    Value<String?>? notes,
    Value<int?>? supersetGroup,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RoutineExercisesCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      exerciseId: exerciseId ?? this.exerciseId,
      preferredEquipmentId: preferredEquipmentId ?? this.preferredEquipmentId,
      position: position ?? this.position,
      targetSets: targetSets ?? this.targetSets,
      repMin: repMin ?? this.repMin,
      repMax: repMax ?? this.repMax,
      targetRir: targetRir ?? this.targetRir,
      restSec: restSec ?? this.restSec,
      warmupSets: warmupSets ?? this.warmupSets,
      tempo: tempo ?? this.tempo,
      notes: notes ?? this.notes,
      supersetGroup: supersetGroup ?? this.supersetGroup,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (preferredEquipmentId.present) {
      map['preferred_equipment_id'] = Variable<String>(
        preferredEquipmentId.value,
      );
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (repMin.present) {
      map['rep_min'] = Variable<int>(repMin.value);
    }
    if (repMax.present) {
      map['rep_max'] = Variable<int>(repMax.value);
    }
    if (targetRir.present) {
      map['target_rir'] = Variable<int>(targetRir.value);
    }
    if (restSec.present) {
      map['rest_sec'] = Variable<int>(restSec.value);
    }
    if (warmupSets.present) {
      map['warmup_sets'] = Variable<int>(warmupSets.value);
    }
    if (tempo.present) {
      map['tempo'] = Variable<String>(tempo.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (supersetGroup.present) {
      map['superset_group'] = Variable<int>(supersetGroup.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineExercisesCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('preferredEquipmentId: $preferredEquipmentId, ')
          ..write('position: $position, ')
          ..write('targetSets: $targetSets, ')
          ..write('repMin: $repMin, ')
          ..write('repMax: $repMax, ')
          ..write('targetRir: $targetRir, ')
          ..write('restSec: $restSec, ')
          ..write('warmupSets: $warmupSets, ')
          ..write('tempo: $tempo, ')
          ..write('notes: $notes, ')
          ..write('supersetGroup: $supersetGroup, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionExercisesTable extends SessionExercises
    with TableInfo<$SessionExercisesTable, SessionExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _stationIdMeta = const VerificationMeta(
    'stationId',
  );
  @override
  late final GeneratedColumn<String> stationId = GeneratedColumn<String>(
    'station_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stations (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _routineExerciseIdMeta = const VerificationMeta(
    'routineExerciseId',
  );
  @override
  late final GeneratedColumn<String> routineExerciseId =
      GeneratedColumn<String>(
        'routine_exercise_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES routine_exercises (id) ON DELETE SET NULL',
        ),
      );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LoadUnit, String> loadUnit =
      GeneratedColumn<String>(
        'load_unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LoadUnit>($SessionExercisesTable.$converterloadUnit);
  @override
  late final GeneratedColumnWithTypeConverter<LoadBasis, String> loadBasis =
      GeneratedColumn<String>(
        'load_basis',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LoadBasis>($SessionExercisesTable.$converterloadBasis);
  static const VerificationMeta _incrementMilliMeta = const VerificationMeta(
    'incrementMilli',
  );
  @override
  late final GeneratedColumn<int> incrementMilli = GeneratedColumn<int>(
    'increment_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repMinMeta = const VerificationMeta('repMin');
  @override
  late final GeneratedColumn<int> repMin = GeneratedColumn<int>(
    'rep_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repMaxMeta = const VerificationMeta('repMax');
  @override
  late final GeneratedColumn<int> repMax = GeneratedColumn<int>(
    'rep_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecMeta = const VerificationMeta(
    'restSec',
  );
  @override
  late final GeneratedColumn<int> restSec = GeneratedColumn<int>(
    'rest_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _howItWentMeta = const VerificationMeta(
    'howItWent',
  );
  @override
  late final GeneratedColumn<String> howItWent = GeneratedColumn<String>(
    'how_it_went',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EffortTag?, String> effortTag =
      GeneratedColumn<String>(
        'effort_tag',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<EffortTag?>($SessionExercisesTable.$convertereffortTagn);
  static const VerificationMeta _painMeta = const VerificationMeta('pain');
  @override
  late final GeneratedColumn<bool> pain = GeneratedColumn<bool>(
    'pain',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pain" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _supersetGroupMeta = const VerificationMeta(
    'supersetGroup',
  );
  @override
  late final GeneratedColumn<int> supersetGroup = GeneratedColumn<int>(
    'superset_group',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    stationId,
    exerciseId,
    routineExerciseId,
    position,
    loadUnit,
    loadBasis,
    incrementMilli,
    targetSets,
    repMin,
    repMax,
    restSec,
    howItWent,
    effortTag,
    pain,
    supersetGroup,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('station_id')) {
      context.handle(
        _stationIdMeta,
        stationId.isAcceptableOrUnknown(data['station_id']!, _stationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stationIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('routine_exercise_id')) {
      context.handle(
        _routineExerciseIdMeta,
        routineExerciseId.isAcceptableOrUnknown(
          data['routine_exercise_id']!,
          _routineExerciseIdMeta,
        ),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('increment_milli')) {
      context.handle(
        _incrementMilliMeta,
        incrementMilli.isAcceptableOrUnknown(
          data['increment_milli']!,
          _incrementMilliMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incrementMilliMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    }
    if (data.containsKey('rep_min')) {
      context.handle(
        _repMinMeta,
        repMin.isAcceptableOrUnknown(data['rep_min']!, _repMinMeta),
      );
    }
    if (data.containsKey('rep_max')) {
      context.handle(
        _repMaxMeta,
        repMax.isAcceptableOrUnknown(data['rep_max']!, _repMaxMeta),
      );
    }
    if (data.containsKey('rest_sec')) {
      context.handle(
        _restSecMeta,
        restSec.isAcceptableOrUnknown(data['rest_sec']!, _restSecMeta),
      );
    } else if (isInserting) {
      context.missing(_restSecMeta);
    }
    if (data.containsKey('how_it_went')) {
      context.handle(
        _howItWentMeta,
        howItWent.isAcceptableOrUnknown(data['how_it_went']!, _howItWentMeta),
      );
    }
    if (data.containsKey('pain')) {
      context.handle(
        _painMeta,
        pain.isAcceptableOrUnknown(data['pain']!, _painMeta),
      );
    }
    if (data.containsKey('superset_group')) {
      context.handle(
        _supersetGroupMeta,
        supersetGroup.isAcceptableOrUnknown(
          data['superset_group']!,
          _supersetGroupMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      stationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      routineExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_exercise_id'],
      ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      loadUnit: $SessionExercisesTable.$converterloadUnit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}load_unit'],
        )!,
      ),
      loadBasis: $SessionExercisesTable.$converterloadBasis.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}load_basis'],
        )!,
      ),
      incrementMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}increment_milli'],
      )!,
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      ),
      repMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rep_min'],
      ),
      repMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rep_max'],
      ),
      restSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_sec'],
      )!,
      howItWent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}how_it_went'],
      ),
      effortTag: $SessionExercisesTable.$convertereffortTagn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}effort_tag'],
        ),
      ),
      pain: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pain'],
      )!,
      supersetGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}superset_group'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SessionExercisesTable createAlias(String alias) {
    return $SessionExercisesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LoadUnit, String, String> $converterloadUnit =
      const EnumNameConverter<LoadUnit>(LoadUnit.values);
  static JsonTypeConverter2<LoadBasis, String, String> $converterloadBasis =
      const EnumNameConverter<LoadBasis>(LoadBasis.values);
  static JsonTypeConverter2<EffortTag, String, String> $convertereffortTag =
      const EnumNameConverter<EffortTag>(EffortTag.values);
  static JsonTypeConverter2<EffortTag?, String?, String?> $convertereffortTagn =
      JsonTypeConverter2.asNullable($convertereffortTag);
}

class SessionExercise extends DataClass implements Insertable<SessionExercise> {
  final String id;
  final String sessionId;
  final String stationId;
  final String exerciseId;
  final String? routineExerciseId;
  final int position;
  final LoadUnit loadUnit;
  final LoadBasis loadBasis;
  final int incrementMilli;
  final int? targetSets;
  final int? repMin;
  final int? repMax;
  final int restSec;

  /// "Como foi" — volta em cinza na próxima vez nesta estação.
  final String? howItWent;
  final EffortTag? effortTag;
  final bool pain;
  final int? supersetGroup;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SessionExercise({
    required this.id,
    required this.sessionId,
    required this.stationId,
    required this.exerciseId,
    this.routineExerciseId,
    required this.position,
    required this.loadUnit,
    required this.loadBasis,
    required this.incrementMilli,
    this.targetSets,
    this.repMin,
    this.repMax,
    required this.restSec,
    this.howItWent,
    this.effortTag,
    required this.pain,
    this.supersetGroup,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['station_id'] = Variable<String>(stationId);
    map['exercise_id'] = Variable<String>(exerciseId);
    if (!nullToAbsent || routineExerciseId != null) {
      map['routine_exercise_id'] = Variable<String>(routineExerciseId);
    }
    map['position'] = Variable<int>(position);
    {
      map['load_unit'] = Variable<String>(
        $SessionExercisesTable.$converterloadUnit.toSql(loadUnit),
      );
    }
    {
      map['load_basis'] = Variable<String>(
        $SessionExercisesTable.$converterloadBasis.toSql(loadBasis),
      );
    }
    map['increment_milli'] = Variable<int>(incrementMilli);
    if (!nullToAbsent || targetSets != null) {
      map['target_sets'] = Variable<int>(targetSets);
    }
    if (!nullToAbsent || repMin != null) {
      map['rep_min'] = Variable<int>(repMin);
    }
    if (!nullToAbsent || repMax != null) {
      map['rep_max'] = Variable<int>(repMax);
    }
    map['rest_sec'] = Variable<int>(restSec);
    if (!nullToAbsent || howItWent != null) {
      map['how_it_went'] = Variable<String>(howItWent);
    }
    if (!nullToAbsent || effortTag != null) {
      map['effort_tag'] = Variable<String>(
        $SessionExercisesTable.$convertereffortTagn.toSql(effortTag),
      );
    }
    map['pain'] = Variable<bool>(pain);
    if (!nullToAbsent || supersetGroup != null) {
      map['superset_group'] = Variable<int>(supersetGroup);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SessionExercisesCompanion toCompanion(bool nullToAbsent) {
    return SessionExercisesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      stationId: Value(stationId),
      exerciseId: Value(exerciseId),
      routineExerciseId: routineExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(routineExerciseId),
      position: Value(position),
      loadUnit: Value(loadUnit),
      loadBasis: Value(loadBasis),
      incrementMilli: Value(incrementMilli),
      targetSets: targetSets == null && nullToAbsent
          ? const Value.absent()
          : Value(targetSets),
      repMin: repMin == null && nullToAbsent
          ? const Value.absent()
          : Value(repMin),
      repMax: repMax == null && nullToAbsent
          ? const Value.absent()
          : Value(repMax),
      restSec: Value(restSec),
      howItWent: howItWent == null && nullToAbsent
          ? const Value.absent()
          : Value(howItWent),
      effortTag: effortTag == null && nullToAbsent
          ? const Value.absent()
          : Value(effortTag),
      pain: Value(pain),
      supersetGroup: supersetGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(supersetGroup),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SessionExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionExercise(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      stationId: serializer.fromJson<String>(json['stationId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      routineExerciseId: serializer.fromJson<String?>(
        json['routineExerciseId'],
      ),
      position: serializer.fromJson<int>(json['position']),
      loadUnit: $SessionExercisesTable.$converterloadUnit.fromJson(
        serializer.fromJson<String>(json['loadUnit']),
      ),
      loadBasis: $SessionExercisesTable.$converterloadBasis.fromJson(
        serializer.fromJson<String>(json['loadBasis']),
      ),
      incrementMilli: serializer.fromJson<int>(json['incrementMilli']),
      targetSets: serializer.fromJson<int?>(json['targetSets']),
      repMin: serializer.fromJson<int?>(json['repMin']),
      repMax: serializer.fromJson<int?>(json['repMax']),
      restSec: serializer.fromJson<int>(json['restSec']),
      howItWent: serializer.fromJson<String?>(json['howItWent']),
      effortTag: $SessionExercisesTable.$convertereffortTagn.fromJson(
        serializer.fromJson<String?>(json['effortTag']),
      ),
      pain: serializer.fromJson<bool>(json['pain']),
      supersetGroup: serializer.fromJson<int?>(json['supersetGroup']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'stationId': serializer.toJson<String>(stationId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'routineExerciseId': serializer.toJson<String?>(routineExerciseId),
      'position': serializer.toJson<int>(position),
      'loadUnit': serializer.toJson<String>(
        $SessionExercisesTable.$converterloadUnit.toJson(loadUnit),
      ),
      'loadBasis': serializer.toJson<String>(
        $SessionExercisesTable.$converterloadBasis.toJson(loadBasis),
      ),
      'incrementMilli': serializer.toJson<int>(incrementMilli),
      'targetSets': serializer.toJson<int?>(targetSets),
      'repMin': serializer.toJson<int?>(repMin),
      'repMax': serializer.toJson<int?>(repMax),
      'restSec': serializer.toJson<int>(restSec),
      'howItWent': serializer.toJson<String?>(howItWent),
      'effortTag': serializer.toJson<String?>(
        $SessionExercisesTable.$convertereffortTagn.toJson(effortTag),
      ),
      'pain': serializer.toJson<bool>(pain),
      'supersetGroup': serializer.toJson<int?>(supersetGroup),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SessionExercise copyWith({
    String? id,
    String? sessionId,
    String? stationId,
    String? exerciseId,
    Value<String?> routineExerciseId = const Value.absent(),
    int? position,
    LoadUnit? loadUnit,
    LoadBasis? loadBasis,
    int? incrementMilli,
    Value<int?> targetSets = const Value.absent(),
    Value<int?> repMin = const Value.absent(),
    Value<int?> repMax = const Value.absent(),
    int? restSec,
    Value<String?> howItWent = const Value.absent(),
    Value<EffortTag?> effortTag = const Value.absent(),
    bool? pain,
    Value<int?> supersetGroup = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SessionExercise(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    stationId: stationId ?? this.stationId,
    exerciseId: exerciseId ?? this.exerciseId,
    routineExerciseId: routineExerciseId.present
        ? routineExerciseId.value
        : this.routineExerciseId,
    position: position ?? this.position,
    loadUnit: loadUnit ?? this.loadUnit,
    loadBasis: loadBasis ?? this.loadBasis,
    incrementMilli: incrementMilli ?? this.incrementMilli,
    targetSets: targetSets.present ? targetSets.value : this.targetSets,
    repMin: repMin.present ? repMin.value : this.repMin,
    repMax: repMax.present ? repMax.value : this.repMax,
    restSec: restSec ?? this.restSec,
    howItWent: howItWent.present ? howItWent.value : this.howItWent,
    effortTag: effortTag.present ? effortTag.value : this.effortTag,
    pain: pain ?? this.pain,
    supersetGroup: supersetGroup.present
        ? supersetGroup.value
        : this.supersetGroup,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SessionExercise copyWithCompanion(SessionExercisesCompanion data) {
    return SessionExercise(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      stationId: data.stationId.present ? data.stationId.value : this.stationId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      routineExerciseId: data.routineExerciseId.present
          ? data.routineExerciseId.value
          : this.routineExerciseId,
      position: data.position.present ? data.position.value : this.position,
      loadUnit: data.loadUnit.present ? data.loadUnit.value : this.loadUnit,
      loadBasis: data.loadBasis.present ? data.loadBasis.value : this.loadBasis,
      incrementMilli: data.incrementMilli.present
          ? data.incrementMilli.value
          : this.incrementMilli,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      repMin: data.repMin.present ? data.repMin.value : this.repMin,
      repMax: data.repMax.present ? data.repMax.value : this.repMax,
      restSec: data.restSec.present ? data.restSec.value : this.restSec,
      howItWent: data.howItWent.present ? data.howItWent.value : this.howItWent,
      effortTag: data.effortTag.present ? data.effortTag.value : this.effortTag,
      pain: data.pain.present ? data.pain.value : this.pain,
      supersetGroup: data.supersetGroup.present
          ? data.supersetGroup.value
          : this.supersetGroup,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionExercise(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('stationId: $stationId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('routineExerciseId: $routineExerciseId, ')
          ..write('position: $position, ')
          ..write('loadUnit: $loadUnit, ')
          ..write('loadBasis: $loadBasis, ')
          ..write('incrementMilli: $incrementMilli, ')
          ..write('targetSets: $targetSets, ')
          ..write('repMin: $repMin, ')
          ..write('repMax: $repMax, ')
          ..write('restSec: $restSec, ')
          ..write('howItWent: $howItWent, ')
          ..write('effortTag: $effortTag, ')
          ..write('pain: $pain, ')
          ..write('supersetGroup: $supersetGroup, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    stationId,
    exerciseId,
    routineExerciseId,
    position,
    loadUnit,
    loadBasis,
    incrementMilli,
    targetSets,
    repMin,
    repMax,
    restSec,
    howItWent,
    effortTag,
    pain,
    supersetGroup,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionExercise &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.stationId == this.stationId &&
          other.exerciseId == this.exerciseId &&
          other.routineExerciseId == this.routineExerciseId &&
          other.position == this.position &&
          other.loadUnit == this.loadUnit &&
          other.loadBasis == this.loadBasis &&
          other.incrementMilli == this.incrementMilli &&
          other.targetSets == this.targetSets &&
          other.repMin == this.repMin &&
          other.repMax == this.repMax &&
          other.restSec == this.restSec &&
          other.howItWent == this.howItWent &&
          other.effortTag == this.effortTag &&
          other.pain == this.pain &&
          other.supersetGroup == this.supersetGroup &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SessionExercisesCompanion extends UpdateCompanion<SessionExercise> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> stationId;
  final Value<String> exerciseId;
  final Value<String?> routineExerciseId;
  final Value<int> position;
  final Value<LoadUnit> loadUnit;
  final Value<LoadBasis> loadBasis;
  final Value<int> incrementMilli;
  final Value<int?> targetSets;
  final Value<int?> repMin;
  final Value<int?> repMax;
  final Value<int> restSec;
  final Value<String?> howItWent;
  final Value<EffortTag?> effortTag;
  final Value<bool> pain;
  final Value<int?> supersetGroup;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SessionExercisesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.stationId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.routineExerciseId = const Value.absent(),
    this.position = const Value.absent(),
    this.loadUnit = const Value.absent(),
    this.loadBasis = const Value.absent(),
    this.incrementMilli = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.repMin = const Value.absent(),
    this.repMax = const Value.absent(),
    this.restSec = const Value.absent(),
    this.howItWent = const Value.absent(),
    this.effortTag = const Value.absent(),
    this.pain = const Value.absent(),
    this.supersetGroup = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String sessionId,
    required String stationId,
    required String exerciseId,
    this.routineExerciseId = const Value.absent(),
    required int position,
    required LoadUnit loadUnit,
    required LoadBasis loadBasis,
    required int incrementMilli,
    this.targetSets = const Value.absent(),
    this.repMin = const Value.absent(),
    this.repMax = const Value.absent(),
    required int restSec,
    this.howItWent = const Value.absent(),
    this.effortTag = const Value.absent(),
    this.pain = const Value.absent(),
    this.supersetGroup = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       stationId = Value(stationId),
       exerciseId = Value(exerciseId),
       position = Value(position),
       loadUnit = Value(loadUnit),
       loadBasis = Value(loadBasis),
       incrementMilli = Value(incrementMilli),
       restSec = Value(restSec);
  static Insertable<SessionExercise> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? stationId,
    Expression<String>? exerciseId,
    Expression<String>? routineExerciseId,
    Expression<int>? position,
    Expression<String>? loadUnit,
    Expression<String>? loadBasis,
    Expression<int>? incrementMilli,
    Expression<int>? targetSets,
    Expression<int>? repMin,
    Expression<int>? repMax,
    Expression<int>? restSec,
    Expression<String>? howItWent,
    Expression<String>? effortTag,
    Expression<bool>? pain,
    Expression<int>? supersetGroup,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (stationId != null) 'station_id': stationId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (routineExerciseId != null) 'routine_exercise_id': routineExerciseId,
      if (position != null) 'position': position,
      if (loadUnit != null) 'load_unit': loadUnit,
      if (loadBasis != null) 'load_basis': loadBasis,
      if (incrementMilli != null) 'increment_milli': incrementMilli,
      if (targetSets != null) 'target_sets': targetSets,
      if (repMin != null) 'rep_min': repMin,
      if (repMax != null) 'rep_max': repMax,
      if (restSec != null) 'rest_sec': restSec,
      if (howItWent != null) 'how_it_went': howItWent,
      if (effortTag != null) 'effort_tag': effortTag,
      if (pain != null) 'pain': pain,
      if (supersetGroup != null) 'superset_group': supersetGroup,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? stationId,
    Value<String>? exerciseId,
    Value<String?>? routineExerciseId,
    Value<int>? position,
    Value<LoadUnit>? loadUnit,
    Value<LoadBasis>? loadBasis,
    Value<int>? incrementMilli,
    Value<int?>? targetSets,
    Value<int?>? repMin,
    Value<int?>? repMax,
    Value<int>? restSec,
    Value<String?>? howItWent,
    Value<EffortTag?>? effortTag,
    Value<bool>? pain,
    Value<int?>? supersetGroup,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SessionExercisesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      stationId: stationId ?? this.stationId,
      exerciseId: exerciseId ?? this.exerciseId,
      routineExerciseId: routineExerciseId ?? this.routineExerciseId,
      position: position ?? this.position,
      loadUnit: loadUnit ?? this.loadUnit,
      loadBasis: loadBasis ?? this.loadBasis,
      incrementMilli: incrementMilli ?? this.incrementMilli,
      targetSets: targetSets ?? this.targetSets,
      repMin: repMin ?? this.repMin,
      repMax: repMax ?? this.repMax,
      restSec: restSec ?? this.restSec,
      howItWent: howItWent ?? this.howItWent,
      effortTag: effortTag ?? this.effortTag,
      pain: pain ?? this.pain,
      supersetGroup: supersetGroup ?? this.supersetGroup,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (stationId.present) {
      map['station_id'] = Variable<String>(stationId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (routineExerciseId.present) {
      map['routine_exercise_id'] = Variable<String>(routineExerciseId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (loadUnit.present) {
      map['load_unit'] = Variable<String>(
        $SessionExercisesTable.$converterloadUnit.toSql(loadUnit.value),
      );
    }
    if (loadBasis.present) {
      map['load_basis'] = Variable<String>(
        $SessionExercisesTable.$converterloadBasis.toSql(loadBasis.value),
      );
    }
    if (incrementMilli.present) {
      map['increment_milli'] = Variable<int>(incrementMilli.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (repMin.present) {
      map['rep_min'] = Variable<int>(repMin.value);
    }
    if (repMax.present) {
      map['rep_max'] = Variable<int>(repMax.value);
    }
    if (restSec.present) {
      map['rest_sec'] = Variable<int>(restSec.value);
    }
    if (howItWent.present) {
      map['how_it_went'] = Variable<String>(howItWent.value);
    }
    if (effortTag.present) {
      map['effort_tag'] = Variable<String>(
        $SessionExercisesTable.$convertereffortTagn.toSql(effortTag.value),
      );
    }
    if (pain.present) {
      map['pain'] = Variable<bool>(pain.value);
    }
    if (supersetGroup.present) {
      map['superset_group'] = Variable<int>(supersetGroup.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionExercisesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('stationId: $stationId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('routineExerciseId: $routineExerciseId, ')
          ..write('position: $position, ')
          ..write('loadUnit: $loadUnit, ')
          ..write('loadBasis: $loadBasis, ')
          ..write('incrementMilli: $incrementMilli, ')
          ..write('targetSets: $targetSets, ')
          ..write('repMin: $repMin, ')
          ..write('repMax: $repMax, ')
          ..write('restSec: $restSec, ')
          ..write('howItWent: $howItWent, ')
          ..write('effortTag: $effortTag, ')
          ..write('pain: $pain, ')
          ..write('supersetGroup: $supersetGroup, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _sessionExerciseIdMeta = const VerificationMeta(
    'sessionExerciseId',
  );
  @override
  late final GeneratedColumn<String> sessionExerciseId =
      GeneratedColumn<String>(
        'session_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES session_exercises (id) ON DELETE CASCADE',
        ),
      );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SetType, String> setType =
      GeneratedColumn<String>(
        'set_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SetType>($WorkoutSetsTable.$convertersetType);
  static const VerificationMeta _loadMilliMeta = const VerificationMeta(
    'loadMilli',
  );
  @override
  late final GeneratedColumn<int> loadMilli = GeneratedColumn<int>(
    'load_milli',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecMeta = const VerificationMeta(
    'durationSec',
  );
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
    'duration_sec',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMMeta = const VerificationMeta(
    'distanceM',
  );
  @override
  late final GeneratedColumn<int> distanceM = GeneratedColumn<int>(
    'distance_m',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rirMeta = const VerificationMeta('rir');
  @override
  late final GeneratedColumn<double> rir = GeneratedColumn<double>(
    'rir',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionExerciseId,
    position,
    setType,
    loadMilli,
    reps,
    durationSec,
    distanceM,
    rir,
    completedAt,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_exercise_id')) {
      context.handle(
        _sessionExerciseIdMeta,
        sessionExerciseId.isAcceptableOrUnknown(
          data['session_exercise_id']!,
          _sessionExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionExerciseIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('load_milli')) {
      context.handle(
        _loadMilliMeta,
        loadMilli.isAcceptableOrUnknown(data['load_milli']!, _loadMilliMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
        _durationSecMeta,
        durationSec.isAcceptableOrUnknown(
          data['duration_sec']!,
          _durationSecMeta,
        ),
      );
    }
    if (data.containsKey('distance_m')) {
      context.handle(
        _distanceMMeta,
        distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta),
      );
    }
    if (data.containsKey('rir')) {
      context.handle(
        _rirMeta,
        rir.isAcceptableOrUnknown(data['rir']!, _rirMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_exercise_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      setType: $WorkoutSetsTable.$convertersetType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}set_type'],
        )!,
      ),
      loadMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}load_milli'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      durationSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_sec'],
      ),
      distanceM: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distance_m'],
      ),
      rir: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rir'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SetType, String, String> $convertersetType =
      const EnumNameConverter<SetType>(SetType.values);
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final String id;
  final String sessionExerciseId;
  final int position;
  final SetType setType;

  /// Valor mostrado na máquina × 1000, na unidade da sessão.
  final int? loadMilli;
  final int? reps;

  /// Tempo da série em segundos (prancha, esteira) — schema v2.
  final int? durationSec;

  /// Distância em metros (esteira, bicicleta) — schema v2.
  final int? distanceM;

  /// Repetições na reserva (aceita 0,5). RPE = 10 − RIR.
  final double? rir;

  /// Nulo = série só planejada; preenchido = concluída.
  final DateTime? completedAt;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WorkoutSet({
    required this.id,
    required this.sessionExerciseId,
    required this.position,
    required this.setType,
    this.loadMilli,
    this.reps,
    this.durationSec,
    this.distanceM,
    this.rir,
    this.completedAt,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_exercise_id'] = Variable<String>(sessionExerciseId);
    map['position'] = Variable<int>(position);
    {
      map['set_type'] = Variable<String>(
        $WorkoutSetsTable.$convertersetType.toSql(setType),
      );
    }
    if (!nullToAbsent || loadMilli != null) {
      map['load_milli'] = Variable<int>(loadMilli);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || durationSec != null) {
      map['duration_sec'] = Variable<int>(durationSec);
    }
    if (!nullToAbsent || distanceM != null) {
      map['distance_m'] = Variable<int>(distanceM);
    }
    if (!nullToAbsent || rir != null) {
      map['rir'] = Variable<double>(rir);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      sessionExerciseId: Value(sessionExerciseId),
      position: Value(position),
      setType: Value(setType),
      loadMilli: loadMilli == null && nullToAbsent
          ? const Value.absent()
          : Value(loadMilli),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      durationSec: durationSec == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSec),
      distanceM: distanceM == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceM),
      rir: rir == null && nullToAbsent ? const Value.absent() : Value(rir),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkoutSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<String>(json['id']),
      sessionExerciseId: serializer.fromJson<String>(json['sessionExerciseId']),
      position: serializer.fromJson<int>(json['position']),
      setType: $WorkoutSetsTable.$convertersetType.fromJson(
        serializer.fromJson<String>(json['setType']),
      ),
      loadMilli: serializer.fromJson<int?>(json['loadMilli']),
      reps: serializer.fromJson<int?>(json['reps']),
      durationSec: serializer.fromJson<int?>(json['durationSec']),
      distanceM: serializer.fromJson<int?>(json['distanceM']),
      rir: serializer.fromJson<double?>(json['rir']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionExerciseId': serializer.toJson<String>(sessionExerciseId),
      'position': serializer.toJson<int>(position),
      'setType': serializer.toJson<String>(
        $WorkoutSetsTable.$convertersetType.toJson(setType),
      ),
      'loadMilli': serializer.toJson<int?>(loadMilli),
      'reps': serializer.toJson<int?>(reps),
      'durationSec': serializer.toJson<int?>(durationSec),
      'distanceM': serializer.toJson<int?>(distanceM),
      'rir': serializer.toJson<double?>(rir),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkoutSet copyWith({
    String? id,
    String? sessionExerciseId,
    int? position,
    SetType? setType,
    Value<int?> loadMilli = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    Value<int?> durationSec = const Value.absent(),
    Value<int?> distanceM = const Value.absent(),
    Value<double?> rir = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WorkoutSet(
    id: id ?? this.id,
    sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
    position: position ?? this.position,
    setType: setType ?? this.setType,
    loadMilli: loadMilli.present ? loadMilli.value : this.loadMilli,
    reps: reps.present ? reps.value : this.reps,
    durationSec: durationSec.present ? durationSec.value : this.durationSec,
    distanceM: distanceM.present ? distanceM.value : this.distanceM,
    rir: rir.present ? rir.value : this.rir,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WorkoutSet copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSet(
      id: data.id.present ? data.id.value : this.id,
      sessionExerciseId: data.sessionExerciseId.present
          ? data.sessionExerciseId.value
          : this.sessionExerciseId,
      position: data.position.present ? data.position.value : this.position,
      setType: data.setType.present ? data.setType.value : this.setType,
      loadMilli: data.loadMilli.present ? data.loadMilli.value : this.loadMilli,
      reps: data.reps.present ? data.reps.value : this.reps,
      durationSec: data.durationSec.present
          ? data.durationSec.value
          : this.durationSec,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      rir: data.rir.present ? data.rir.value : this.rir,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('position: $position, ')
          ..write('setType: $setType, ')
          ..write('loadMilli: $loadMilli, ')
          ..write('reps: $reps, ')
          ..write('durationSec: $durationSec, ')
          ..write('distanceM: $distanceM, ')
          ..write('rir: $rir, ')
          ..write('completedAt: $completedAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionExerciseId,
    position,
    setType,
    loadMilli,
    reps,
    durationSec,
    distanceM,
    rir,
    completedAt,
    note,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.sessionExerciseId == this.sessionExerciseId &&
          other.position == this.position &&
          other.setType == this.setType &&
          other.loadMilli == this.loadMilli &&
          other.reps == this.reps &&
          other.durationSec == this.durationSec &&
          other.distanceM == this.distanceM &&
          other.rir == this.rir &&
          other.completedAt == this.completedAt &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<String> id;
  final Value<String> sessionExerciseId;
  final Value<int> position;
  final Value<SetType> setType;
  final Value<int?> loadMilli;
  final Value<int?> reps;
  final Value<int?> durationSec;
  final Value<int?> distanceM;
  final Value<double?> rir;
  final Value<DateTime?> completedAt;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.sessionExerciseId = const Value.absent(),
    this.position = const Value.absent(),
    this.setType = const Value.absent(),
    this.loadMilli = const Value.absent(),
    this.reps = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.rir = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    this.id = const Value.absent(),
    required String sessionExerciseId,
    required int position,
    required SetType setType,
    this.loadMilli = const Value.absent(),
    this.reps = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.rir = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : sessionExerciseId = Value(sessionExerciseId),
       position = Value(position),
       setType = Value(setType);
  static Insertable<WorkoutSet> custom({
    Expression<String>? id,
    Expression<String>? sessionExerciseId,
    Expression<int>? position,
    Expression<String>? setType,
    Expression<int>? loadMilli,
    Expression<int>? reps,
    Expression<int>? durationSec,
    Expression<int>? distanceM,
    Expression<double>? rir,
    Expression<DateTime>? completedAt,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionExerciseId != null) 'session_exercise_id': sessionExerciseId,
      if (position != null) 'position': position,
      if (setType != null) 'set_type': setType,
      if (loadMilli != null) 'load_milli': loadMilli,
      if (reps != null) 'reps': reps,
      if (durationSec != null) 'duration_sec': durationSec,
      if (distanceM != null) 'distance_m': distanceM,
      if (rir != null) 'rir': rir,
      if (completedAt != null) 'completed_at': completedAt,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionExerciseId,
    Value<int>? position,
    Value<SetType>? setType,
    Value<int?>? loadMilli,
    Value<int?>? reps,
    Value<int?>? durationSec,
    Value<int?>? distanceM,
    Value<double?>? rir,
    Value<DateTime?>? completedAt,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      sessionExerciseId: sessionExerciseId ?? this.sessionExerciseId,
      position: position ?? this.position,
      setType: setType ?? this.setType,
      loadMilli: loadMilli ?? this.loadMilli,
      reps: reps ?? this.reps,
      durationSec: durationSec ?? this.durationSec,
      distanceM: distanceM ?? this.distanceM,
      rir: rir ?? this.rir,
      completedAt: completedAt ?? this.completedAt,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionExerciseId.present) {
      map['session_exercise_id'] = Variable<String>(sessionExerciseId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(
        $WorkoutSetsTable.$convertersetType.toSql(setType.value),
      );
    }
    if (loadMilli.present) {
      map['load_milli'] = Variable<int>(loadMilli.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<int>(distanceM.value);
    }
    if (rir.present) {
      map['rir'] = Variable<double>(rir.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('sessionExerciseId: $sessionExerciseId, ')
          ..write('position: $position, ')
          ..write('setType: $setType, ')
          ..write('loadMilli: $loadMilli, ')
          ..write('reps: $reps, ')
          ..write('durationSec: $durationSec, ')
          ..write('distanceM: $distanceM, ')
          ..write('rir: $rir, ')
          ..write('completedAt: $completedAt, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BodyCheckinsTable extends BodyCheckins
    with TableInfo<$BodyCheckinsTable, BodyCheckin> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyCheckinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    takenAt,
    localDate,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_checkins';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyCheckin> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyCheckin map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyCheckin(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BodyCheckinsTable createAlias(String alias) {
    return $BodyCheckinsTable(attachedDatabase, alias);
  }
}

class BodyCheckin extends DataClass implements Insertable<BodyCheckin> {
  final String id;
  final DateTime takenAt;
  final String localDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BodyCheckin({
    required this.id,
    required this.takenAt,
    required this.localDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['taken_at'] = Variable<DateTime>(takenAt);
    map['local_date'] = Variable<String>(localDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BodyCheckinsCompanion toCompanion(bool nullToAbsent) {
    return BodyCheckinsCompanion(
      id: Value(id),
      takenAt: Value(takenAt),
      localDate: Value(localDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BodyCheckin.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyCheckin(
      id: serializer.fromJson<String>(json['id']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      localDate: serializer.fromJson<String>(json['localDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'localDate': serializer.toJson<String>(localDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BodyCheckin copyWith({
    String? id,
    DateTime? takenAt,
    String? localDate,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BodyCheckin(
    id: id ?? this.id,
    takenAt: takenAt ?? this.takenAt,
    localDate: localDate ?? this.localDate,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BodyCheckin copyWithCompanion(BodyCheckinsCompanion data) {
    return BodyCheckin(
      id: data.id.present ? data.id.value : this.id,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyCheckin(')
          ..write('id: $id, ')
          ..write('takenAt: $takenAt, ')
          ..write('localDate: $localDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, takenAt, localDate, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyCheckin &&
          other.id == this.id &&
          other.takenAt == this.takenAt &&
          other.localDate == this.localDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BodyCheckinsCompanion extends UpdateCompanion<BodyCheckin> {
  final Value<String> id;
  final Value<DateTime> takenAt;
  final Value<String> localDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BodyCheckinsCompanion({
    this.id = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.localDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BodyCheckinsCompanion.insert({
    this.id = const Value.absent(),
    this.takenAt = const Value.absent(),
    required String localDate,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localDate = Value(localDate);
  static Insertable<BodyCheckin> custom({
    Expression<String>? id,
    Expression<DateTime>? takenAt,
    Expression<String>? localDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (takenAt != null) 'taken_at': takenAt,
      if (localDate != null) 'local_date': localDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BodyCheckinsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? takenAt,
    Value<String>? localDate,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BodyCheckinsCompanion(
      id: id ?? this.id,
      takenAt: takenAt ?? this.takenAt,
      localDate: localDate ?? this.localDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyCheckinsCompanion(')
          ..write('id: $id, ')
          ..write('takenAt: $takenAt, ')
          ..write('localDate: $localDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BodyValuesTable extends BodyValues
    with TableInfo<$BodyValuesTable, BodyValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _checkinIdMeta = const VerificationMeta(
    'checkinId',
  );
  @override
  late final GeneratedColumn<String> checkinId = GeneratedColumn<String>(
    'checkin_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES body_checkins (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<BodyMetric, String> metric =
      GeneratedColumn<String>(
        'metric',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<BodyMetric>($BodyValuesTable.$convertermetric);
  static const VerificationMeta _valueMilliMeta = const VerificationMeta(
    'valueMilli',
  );
  @override
  late final GeneratedColumn<int> valueMilli = GeneratedColumn<int>(
    'value_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BodySource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(BodySource.manual.name),
      ).withConverter<BodySource>($BodyValuesTable.$convertersource);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    checkinId,
    metric,
    valueMilli,
    source,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyValue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('checkin_id')) {
      context.handle(
        _checkinIdMeta,
        checkinId.isAcceptableOrUnknown(data['checkin_id']!, _checkinIdMeta),
      );
    } else if (isInserting) {
      context.missing(_checkinIdMeta);
    }
    if (data.containsKey('value_milli')) {
      context.handle(
        _valueMilliMeta,
        valueMilli.isAcceptableOrUnknown(data['value_milli']!, _valueMilliMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMilliMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {checkinId, metric},
  ];
  @override
  BodyValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyValue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      checkinId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkin_id'],
      )!,
      metric: $BodyValuesTable.$convertermetric.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}metric'],
        )!,
      ),
      valueMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value_milli'],
      )!,
      source: $BodyValuesTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BodyValuesTable createAlias(String alias) {
    return $BodyValuesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BodyMetric, String, String> $convertermetric =
      const EnumNameConverter<BodyMetric>(BodyMetric.values);
  static JsonTypeConverter2<BodySource, String, String> $convertersource =
      const EnumNameConverter<BodySource>(BodySource.values);
}

class BodyValue extends DataClass implements Insertable<BodyValue> {
  final String id;
  final String checkinId;
  final BodyMetric metric;
  final int valueMilli;
  final BodySource source;
  final DateTime createdAt;
  const BodyValue({
    required this.id,
    required this.checkinId,
    required this.metric,
    required this.valueMilli,
    required this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['checkin_id'] = Variable<String>(checkinId);
    {
      map['metric'] = Variable<String>(
        $BodyValuesTable.$convertermetric.toSql(metric),
      );
    }
    map['value_milli'] = Variable<int>(valueMilli);
    {
      map['source'] = Variable<String>(
        $BodyValuesTable.$convertersource.toSql(source),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BodyValuesCompanion toCompanion(bool nullToAbsent) {
    return BodyValuesCompanion(
      id: Value(id),
      checkinId: Value(checkinId),
      metric: Value(metric),
      valueMilli: Value(valueMilli),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory BodyValue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyValue(
      id: serializer.fromJson<String>(json['id']),
      checkinId: serializer.fromJson<String>(json['checkinId']),
      metric: $BodyValuesTable.$convertermetric.fromJson(
        serializer.fromJson<String>(json['metric']),
      ),
      valueMilli: serializer.fromJson<int>(json['valueMilli']),
      source: $BodyValuesTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'checkinId': serializer.toJson<String>(checkinId),
      'metric': serializer.toJson<String>(
        $BodyValuesTable.$convertermetric.toJson(metric),
      ),
      'valueMilli': serializer.toJson<int>(valueMilli),
      'source': serializer.toJson<String>(
        $BodyValuesTable.$convertersource.toJson(source),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BodyValue copyWith({
    String? id,
    String? checkinId,
    BodyMetric? metric,
    int? valueMilli,
    BodySource? source,
    DateTime? createdAt,
  }) => BodyValue(
    id: id ?? this.id,
    checkinId: checkinId ?? this.checkinId,
    metric: metric ?? this.metric,
    valueMilli: valueMilli ?? this.valueMilli,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  BodyValue copyWithCompanion(BodyValuesCompanion data) {
    return BodyValue(
      id: data.id.present ? data.id.value : this.id,
      checkinId: data.checkinId.present ? data.checkinId.value : this.checkinId,
      metric: data.metric.present ? data.metric.value : this.metric,
      valueMilli: data.valueMilli.present
          ? data.valueMilli.value
          : this.valueMilli,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyValue(')
          ..write('id: $id, ')
          ..write('checkinId: $checkinId, ')
          ..write('metric: $metric, ')
          ..write('valueMilli: $valueMilli, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, checkinId, metric, valueMilli, source, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyValue &&
          other.id == this.id &&
          other.checkinId == this.checkinId &&
          other.metric == this.metric &&
          other.valueMilli == this.valueMilli &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class BodyValuesCompanion extends UpdateCompanion<BodyValue> {
  final Value<String> id;
  final Value<String> checkinId;
  final Value<BodyMetric> metric;
  final Value<int> valueMilli;
  final Value<BodySource> source;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BodyValuesCompanion({
    this.id = const Value.absent(),
    this.checkinId = const Value.absent(),
    this.metric = const Value.absent(),
    this.valueMilli = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BodyValuesCompanion.insert({
    this.id = const Value.absent(),
    required String checkinId,
    required BodyMetric metric,
    required int valueMilli,
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : checkinId = Value(checkinId),
       metric = Value(metric),
       valueMilli = Value(valueMilli);
  static Insertable<BodyValue> custom({
    Expression<String>? id,
    Expression<String>? checkinId,
    Expression<String>? metric,
    Expression<int>? valueMilli,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checkinId != null) 'checkin_id': checkinId,
      if (metric != null) 'metric': metric,
      if (valueMilli != null) 'value_milli': valueMilli,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BodyValuesCompanion copyWith({
    Value<String>? id,
    Value<String>? checkinId,
    Value<BodyMetric>? metric,
    Value<int>? valueMilli,
    Value<BodySource>? source,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BodyValuesCompanion(
      id: id ?? this.id,
      checkinId: checkinId ?? this.checkinId,
      metric: metric ?? this.metric,
      valueMilli: valueMilli ?? this.valueMilli,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (checkinId.present) {
      map['checkin_id'] = Variable<String>(checkinId.value);
    }
    if (metric.present) {
      map['metric'] = Variable<String>(
        $BodyValuesTable.$convertermetric.toSql(metric.value),
      );
    }
    if (valueMilli.present) {
      map['value_milli'] = Variable<int>(valueMilli.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $BodyValuesTable.$convertersource.toSql(source.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyValuesCompanion(')
          ..write('id: $id, ')
          ..write('checkinId: $checkinId, ')
          ..write('metric: $metric, ')
          ..write('valueMilli: $valueMilli, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BodyPhotosTable extends BodyPhotos
    with TableInfo<$BodyPhotosTable, BodyPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _checkinIdMeta = const VerificationMeta(
    'checkinId',
  );
  @override
  late final GeneratedColumn<String> checkinId = GeneratedColumn<String>(
    'checkin_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES body_checkins (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PhotoPose, String> pose =
      GeneratedColumn<String>(
        'pose',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PhotoPose>($BodyPhotosTable.$converterpose);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [id, checkinId, pose, path, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('checkin_id')) {
      context.handle(
        _checkinIdMeta,
        checkinId.isAcceptableOrUnknown(data['checkin_id']!, _checkinIdMeta),
      );
    } else if (isInserting) {
      context.missing(_checkinIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      checkinId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkin_id'],
      )!,
      pose: $BodyPhotosTable.$converterpose.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}pose'],
        )!,
      ),
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BodyPhotosTable createAlias(String alias) {
    return $BodyPhotosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PhotoPose, String, String> $converterpose =
      const EnumNameConverter<PhotoPose>(PhotoPose.values);
}

class BodyPhoto extends DataClass implements Insertable<BodyPhoto> {
  final String id;
  final String checkinId;
  final PhotoPose pose;

  /// Relativo à pasta de suporte do app (ex.: "photos/body/abc.jpg"), para
  /// sobreviver ao backup/restauração.
  final String path;
  final DateTime createdAt;
  const BodyPhoto({
    required this.id,
    required this.checkinId,
    required this.pose,
    required this.path,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['checkin_id'] = Variable<String>(checkinId);
    {
      map['pose'] = Variable<String>(
        $BodyPhotosTable.$converterpose.toSql(pose),
      );
    }
    map['path'] = Variable<String>(path);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BodyPhotosCompanion toCompanion(bool nullToAbsent) {
    return BodyPhotosCompanion(
      id: Value(id),
      checkinId: Value(checkinId),
      pose: Value(pose),
      path: Value(path),
      createdAt: Value(createdAt),
    );
  }

  factory BodyPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyPhoto(
      id: serializer.fromJson<String>(json['id']),
      checkinId: serializer.fromJson<String>(json['checkinId']),
      pose: $BodyPhotosTable.$converterpose.fromJson(
        serializer.fromJson<String>(json['pose']),
      ),
      path: serializer.fromJson<String>(json['path']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'checkinId': serializer.toJson<String>(checkinId),
      'pose': serializer.toJson<String>(
        $BodyPhotosTable.$converterpose.toJson(pose),
      ),
      'path': serializer.toJson<String>(path),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BodyPhoto copyWith({
    String? id,
    String? checkinId,
    PhotoPose? pose,
    String? path,
    DateTime? createdAt,
  }) => BodyPhoto(
    id: id ?? this.id,
    checkinId: checkinId ?? this.checkinId,
    pose: pose ?? this.pose,
    path: path ?? this.path,
    createdAt: createdAt ?? this.createdAt,
  );
  BodyPhoto copyWithCompanion(BodyPhotosCompanion data) {
    return BodyPhoto(
      id: data.id.present ? data.id.value : this.id,
      checkinId: data.checkinId.present ? data.checkinId.value : this.checkinId,
      pose: data.pose.present ? data.pose.value : this.pose,
      path: data.path.present ? data.path.value : this.path,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyPhoto(')
          ..write('id: $id, ')
          ..write('checkinId: $checkinId, ')
          ..write('pose: $pose, ')
          ..write('path: $path, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, checkinId, pose, path, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyPhoto &&
          other.id == this.id &&
          other.checkinId == this.checkinId &&
          other.pose == this.pose &&
          other.path == this.path &&
          other.createdAt == this.createdAt);
}

class BodyPhotosCompanion extends UpdateCompanion<BodyPhoto> {
  final Value<String> id;
  final Value<String> checkinId;
  final Value<PhotoPose> pose;
  final Value<String> path;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BodyPhotosCompanion({
    this.id = const Value.absent(),
    this.checkinId = const Value.absent(),
    this.pose = const Value.absent(),
    this.path = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BodyPhotosCompanion.insert({
    this.id = const Value.absent(),
    required String checkinId,
    required PhotoPose pose,
    required String path,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : checkinId = Value(checkinId),
       pose = Value(pose),
       path = Value(path);
  static Insertable<BodyPhoto> custom({
    Expression<String>? id,
    Expression<String>? checkinId,
    Expression<String>? pose,
    Expression<String>? path,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checkinId != null) 'checkin_id': checkinId,
      if (pose != null) 'pose': pose,
      if (path != null) 'path': path,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BodyPhotosCompanion copyWith({
    Value<String>? id,
    Value<String>? checkinId,
    Value<PhotoPose>? pose,
    Value<String>? path,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BodyPhotosCompanion(
      id: id ?? this.id,
      checkinId: checkinId ?? this.checkinId,
      pose: pose ?? this.pose,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (checkinId.present) {
      map['checkin_id'] = Variable<String>(checkinId.value);
    }
    if (pose.present) {
      map['pose'] = Variable<String>(
        $BodyPhotosTable.$converterpose.toSql(pose.value),
      );
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyPhotosCompanion(')
          ..write('id: $id, ')
          ..write('checkinId: $checkinId, ')
          ..write('pose: $pose, ')
          ..write('path: $path, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppPrefsTable extends AppPrefs with TableInfo<$AppPrefsTable, AppPref> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppPrefsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_prefs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppPref> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppPref map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppPref(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppPrefsTable createAlias(String alias) {
    return $AppPrefsTable(attachedDatabase, alias);
  }
}

class AppPref extends DataClass implements Insertable<AppPref> {
  final String key;
  final String value;
  const AppPref({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppPrefsCompanion toCompanion(bool nullToAbsent) {
    return AppPrefsCompanion(key: Value(key), value: Value(value));
  }

  factory AppPref.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppPref(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppPref copyWith({String? key, String? value}) =>
      AppPref(key: key ?? this.key, value: value ?? this.value);
  AppPref copyWithCompanion(AppPrefsCompanion data) {
    return AppPref(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppPref(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppPref && other.key == this.key && other.value == this.value);
}

class AppPrefsCompanion extends UpdateCompanion<AppPref> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppPrefsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppPrefsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppPref> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppPrefsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppPrefsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppPrefsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, AppUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordSaltMeta = const VerificationMeta(
    'passwordSalt',
  );
  @override
  late final GeneratedColumn<String> passwordSalt = GeneratedColumn<String>(
    'password_salt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    passwordHash,
    passwordSalt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppUser> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('password_salt')) {
      context.handle(
        _passwordSaltMeta,
        passwordSalt.isAcceptableOrUnknown(
          data['password_salt']!,
          _passwordSaltMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordSaltMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppUser(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      passwordSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_salt'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class AppUser extends DataClass implements Insertable<AppUser> {
  final String id;
  final String name;
  final String email;
  final String passwordHash;
  final String passwordSalt;
  final DateTime createdAt;
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.passwordSalt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    map['password_hash'] = Variable<String>(passwordHash);
    map['password_salt'] = Variable<String>(passwordSalt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      passwordHash: Value(passwordHash),
      passwordSalt: Value(passwordSalt),
      createdAt: Value(createdAt),
    );
  }

  factory AppUser.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppUser(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      passwordSalt: serializer.fromJson<String>(json['passwordSalt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'passwordSalt': serializer.toJson<String>(passwordSalt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? passwordHash,
    String? passwordSalt,
    DateTime? createdAt,
  }) => AppUser(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    passwordHash: passwordHash ?? this.passwordHash,
    passwordSalt: passwordSalt ?? this.passwordSalt,
    createdAt: createdAt ?? this.createdAt,
  );
  AppUser copyWithCompanion(UsersCompanion data) {
    return AppUser(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      passwordSalt: data.passwordSalt.present
          ? data.passwordSalt.value
          : this.passwordSalt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppUser(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, email, passwordHash, passwordSalt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppUser &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.passwordSalt == this.passwordSalt &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<AppUser> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String> passwordHash;
  final Value<String> passwordSalt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.passwordSalt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    required String passwordHash,
    required String passwordSalt,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       email = Value(email),
       passwordHash = Value(passwordHash),
       passwordSalt = Value(passwordSalt);
  static Insertable<AppUser> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? passwordSalt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (passwordSalt != null) 'password_salt': passwordSalt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String>? passwordHash,
    Value<String>? passwordSalt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (passwordSalt.present) {
      map['password_salt'] = Variable<String>(passwordSalt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('passwordSalt: $passwordSalt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GymsTable gyms = $GymsTable(this);
  late final $EquipmentTable equipment = $EquipmentTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $StationsTable stations = $StationsTable(this);
  late final $StationSettingsTable stationSettings = $StationSettingsTable(
    this,
  );
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $StationSettingChangesTable stationSettingChanges =
      $StationSettingChangesTable(this);
  late final $RoutineExercisesTable routineExercises = $RoutineExercisesTable(
    this,
  );
  late final $SessionExercisesTable sessionExercises = $SessionExercisesTable(
    this,
  );
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $BodyCheckinsTable bodyCheckins = $BodyCheckinsTable(this);
  late final $BodyValuesTable bodyValues = $BodyValuesTable(this);
  late final $BodyPhotosTable bodyPhotos = $BodyPhotosTable(this);
  late final $AppPrefsTable appPrefs = $AppPrefsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final Index idxEquipmentGym = Index(
    'idx_equipment_gym',
    'CREATE INDEX idx_equipment_gym ON equipment (gym_id)',
  );
  late final Index idxExercisesSearch = Index(
    'idx_exercises_search',
    'CREATE INDEX idx_exercises_search ON exercises (search_text)',
  );
  late final Index idxStationsLookup = Index(
    'idx_stations_lookup',
    'CREATE INDEX idx_stations_lookup ON stations (exercise_id, gym_id, equipment_id)',
  );
  late final Index idxSettingsStation = Index(
    'idx_settings_station',
    'CREATE INDEX idx_settings_station ON station_settings (station_id, sort_order)',
  );
  late final Index idxSettingChanges = Index(
    'idx_setting_changes',
    'CREATE INDEX idx_setting_changes ON station_setting_changes (setting_id, changed_at)',
  );
  late final Index idxRoutineExercises = Index(
    'idx_routine_exercises',
    'CREATE INDEX idx_routine_exercises ON routine_exercises (routine_id, position)',
  );
  late final Index idxSessionsStarted = Index(
    'idx_sessions_started',
    'CREATE INDEX idx_sessions_started ON workout_sessions (started_at)',
  );
  late final Index idxSessionExercisesSession = Index(
    'idx_session_exercises_session',
    'CREATE INDEX idx_session_exercises_session ON session_exercises (session_id)',
  );
  late final Index idxSessionExercisesStation = Index(
    'idx_session_exercises_station',
    'CREATE INDEX idx_session_exercises_station ON session_exercises (station_id)',
  );
  late final Index idxSetsSessionExercise = Index(
    'idx_sets_session_exercise',
    'CREATE INDEX idx_sets_session_exercise ON workout_sets (session_exercise_id, position)',
  );
  late final Index idxBodyCheckinsTaken = Index(
    'idx_body_checkins_taken',
    'CREATE INDEX idx_body_checkins_taken ON body_checkins (taken_at)',
  );
  late final Index idxBodyValuesMetric = Index(
    'idx_body_values_metric',
    'CREATE INDEX idx_body_values_metric ON body_values (metric)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    gyms,
    equipment,
    exercises,
    stations,
    stationSettings,
    routines,
    workoutSessions,
    stationSettingChanges,
    routineExercises,
    sessionExercises,
    workoutSets,
    bodyCheckins,
    bodyValues,
    bodyPhotos,
    appPrefs,
    users,
    idxEquipmentGym,
    idxExercisesSearch,
    idxStationsLookup,
    idxSettingsStation,
    idxSettingChanges,
    idxRoutineExercises,
    idxSessionsStarted,
    idxSessionExercisesSession,
    idxSessionExercisesStation,
    idxSetsSessionExercise,
    idxBodyCheckinsTaken,
    idxBodyValuesMetric,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('station_settings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routines',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sessions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'station_settings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('station_setting_changes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('station_setting_changes', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routines',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('routine_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'routine_exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_exercises', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'session_exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'body_checkins',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('body_values', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'body_checkins',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('body_photos', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$GymsTableCreateCompanionBuilder = GymsCompanion Function({
  Value<String> id,
  required String name,
  Value<String?> notes,
  Value<DateTime?> archivedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$GymsTableUpdateCompanionBuilder = GymsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> notes,
  Value<DateTime?> archivedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$GymsTableReferences
    extends BaseReferences<_$AppDatabase, $GymsTable, Gym> {
  $$GymsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EquipmentTable, List<EquipmentItem>>
  _equipmentRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.equipment,
    aliasName: 'gyms__id__equipment__gym_id',
  );

  $$EquipmentTableProcessedTableManager get equipmentRefs {
    final manager = $$EquipmentTableTableManager(
      $_db,
      $_db.equipment,
    ).filter((f) => f.gymId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_equipmentRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StationsTable, List<Station>> _stationsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.stations,
    aliasName: 'gyms__id__stations__gym_id',
  );

  $$StationsTableProcessedTableManager get stationsRefs {
    final manager = $$StationsTableTableManager(
      $_db,
      $_db.stations,
    ).filter((f) => f.gymId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoutinesTable, List<Routine>> _routinesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.routines,
    aliasName: 'gyms__id__routines__gym_id',
  );

  $$RoutinesTableProcessedTableManager get routinesRefs {
    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.gymId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_routinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorkoutSessionsTable, List<WorkoutSession>>
  _workoutSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSessions,
    aliasName: 'gyms__id__workout_sessions__gym_id',
  );

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionsRefs {
    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.gymId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GymsTableFilterComposer extends Composer<_$AppDatabase, $GymsTable> {
  $$GymsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> equipmentRefs(
    Expression<bool> Function($$EquipmentTableFilterComposer f) f,
  ) {
    final $$EquipmentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.gymId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableFilterComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stationsRefs(
    Expression<bool> Function($$StationsTableFilterComposer f) f,
  ) {
    final $$StationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.gymId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableFilterComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> routinesRefs(
    Expression<bool> Function($$RoutinesTableFilterComposer f) f,
  ) {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.gymId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutSessionsRefs(
    Expression<bool> Function($$WorkoutSessionsTableFilterComposer f) f,
  ) {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.gymId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GymsTableOrderingComposer extends Composer<_$AppDatabase, $GymsTable> {
  $$GymsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GymsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GymsTable> {
  $$GymsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> equipmentRefs<T extends Object>(
    Expression<T> Function($$EquipmentTableAnnotationComposer a) f,
  ) {
    final $$EquipmentTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.gymId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableAnnotationComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stationsRefs<T extends Object>(
    Expression<T> Function($$StationsTableAnnotationComposer a) f,
  ) {
    final $$StationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.gymId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableAnnotationComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> routinesRefs<T extends Object>(
    Expression<T> Function($$RoutinesTableAnnotationComposer a) f,
  ) {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.gymId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutSessionsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSessionsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.gymId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GymsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GymsTable,
          Gym,
          $$GymsTableFilterComposer,
          $$GymsTableOrderingComposer,
          $$GymsTableAnnotationComposer,
          $$GymsTableCreateCompanionBuilder,
          $$GymsTableUpdateCompanionBuilder,
          (Gym, $$GymsTableReferences),
          Gym,
          PrefetchHooks Function({
            bool equipmentRefs,
            bool stationsRefs,
            bool routinesRefs,
            bool workoutSessionsRefs,
          })
        > {
  $$GymsTableTableManager(_$AppDatabase db, $GymsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GymsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GymsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GymsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GymsCompanion(
                id: id,
                name: name,
                notes: notes,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GymsCompanion.insert(
                id: id,
                name: name,
                notes: notes,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GymsTable, Gym>(table),
                  $$GymsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                equipmentRefs = false,
                stationsRefs = false,
                routinesRefs = false,
                workoutSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (equipmentRefs) db.equipment,
                    if (stationsRefs) db.stations,
                    if (routinesRefs) db.routines,
                    if (workoutSessionsRefs) db.workoutSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (equipmentRefs)
                        await $_getPrefetchedData<
                          Gym,
                          $GymsTable,
                          EquipmentItem
                        >(
                          currentTable: table,
                          referencedTable: $$GymsTableReferences
                              ._equipmentRefsTable(db),
                          managerFromTypedResult: (p0) => $$GymsTableReferences(
                            db,
                            table,
                            p0,
                          ).equipmentRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.gymId == item.id),
                          typedResults: items,
                        ),
                      if (stationsRefs)
                        await $_getPrefetchedData<Gym, $GymsTable, Station>(
                          currentTable: table,
                          referencedTable: $$GymsTableReferences
                              ._stationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GymsTableReferences(db, table, p0).stationsRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.gymId == item.id),
                          typedResults: items,
                        ),
                      if (routinesRefs)
                        await $_getPrefetchedData<Gym, $GymsTable, Routine>(
                          currentTable: table,
                          referencedTable: $$GymsTableReferences
                              ._routinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GymsTableReferences(db, table, p0).routinesRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.gymId == item.id),
                          typedResults: items,
                        ),
                      if (workoutSessionsRefs)
                        await $_getPrefetchedData<
                          Gym,
                          $GymsTable,
                          WorkoutSession
                        >(
                          currentTable: table,
                          referencedTable: $$GymsTableReferences
                              ._workoutSessionsRefsTable(db),
                          managerFromTypedResult: (p0) => $$GymsTableReferences(
                            db,
                            table,
                            p0,
                          ).workoutSessionsRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.gymId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GymsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GymsTable,
      Gym,
      $$GymsTableFilterComposer,
      $$GymsTableOrderingComposer,
      $$GymsTableAnnotationComposer,
      $$GymsTableCreateCompanionBuilder,
      $$GymsTableUpdateCompanionBuilder,
      (Gym, $$GymsTableReferences),
      Gym,
      PrefetchHooks Function({
        bool equipmentRefs,
        bool stationsRefs,
        bool routinesRefs,
        bool workoutSessionsRefs,
      })
    >;
typedef $$EquipmentTableCreateCompanionBuilder = EquipmentCompanion Function({
  Value<String> id,
  required String gymId,
  required String name,
  required EquipmentType type,
  Value<String?> gymLabel,
  Value<String?> photoPath,
  required LoadUnit loadUnit,
  required LoadBasis loadBasis,
  Value<int> incrementMilli,
  Value<int?> baseLoadMilli,
  Value<String?> replacesEquipmentId,
  Value<String?> notes,
  Value<DateTime?> archivedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$EquipmentTableUpdateCompanionBuilder = EquipmentCompanion Function({
  Value<String> id,
  Value<String> gymId,
  Value<String> name,
  Value<EquipmentType> type,
  Value<String?> gymLabel,
  Value<String?> photoPath,
  Value<LoadUnit> loadUnit,
  Value<LoadBasis> loadBasis,
  Value<int> incrementMilli,
  Value<int?> baseLoadMilli,
  Value<String?> replacesEquipmentId,
  Value<String?> notes,
  Value<DateTime?> archivedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$EquipmentTableReferences
    extends BaseReferences<_$AppDatabase, $EquipmentTable, EquipmentItem> {
  $$EquipmentTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GymsTable _gymIdTable(_$AppDatabase db) =>
      db.gyms.createAlias('equipment__gym_id__gyms__id');

  $$GymsTableProcessedTableManager get gymId {
    final $_column = $_itemColumn<String>('gym_id')!;

    final manager = $$GymsTableTableManager(
      $_db,
      $_db.gyms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gymIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StationsTable, List<Station>> _stationsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.stations,
    aliasName: 'equipment__id__stations__equipment_id',
  );

  $$StationsTableProcessedTableManager get stationsRefs {
    final manager = $$StationsTableTableManager(
      $_db,
      $_db.stations,
    ).filter((f) => f.equipmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoutineExercisesTable, List<RoutineExercise>>
  _routineExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineExercises,
    aliasName: 'equipment__id__routine_exercises__preferred_equipment_id',
  );

  $$RoutineExercisesTableProcessedTableManager get routineExercisesRefs {
    final manager =
        $$RoutineExercisesTableTableManager($_db, $_db.routineExercises).filter(
          (f) =>
              f.preferredEquipmentId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _routineExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EquipmentTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EquipmentType, EquipmentType, String>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get gymLabel => $composableBuilder(
    column: $table.gymLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LoadUnit, LoadUnit, String> get loadUnit =>
      $composableBuilder(
        column: $table.loadUnit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<LoadBasis, LoadBasis, String> get loadBasis =>
      $composableBuilder(
        column: $table.loadBasis,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get incrementMilli => $composableBuilder(
    column: $table.incrementMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseLoadMilli => $composableBuilder(
    column: $table.baseLoadMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replacesEquipmentId => $composableBuilder(
    column: $table.replacesEquipmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GymsTableFilterComposer get gymId {
    final $$GymsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableFilterComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> stationsRefs(
    Expression<bool> Function($$StationsTableFilterComposer f) f,
  ) {
    final $$StationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.equipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableFilterComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> routineExercisesRefs(
    Expression<bool> Function($$RoutineExercisesTableFilterComposer f) f,
  ) {
    final $$RoutineExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.preferredEquipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableFilterComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gymLabel => $composableBuilder(
    column: $table.gymLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loadUnit => $composableBuilder(
    column: $table.loadUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loadBasis => $composableBuilder(
    column: $table.loadBasis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incrementMilli => $composableBuilder(
    column: $table.incrementMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseLoadMilli => $composableBuilder(
    column: $table.baseLoadMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replacesEquipmentId => $composableBuilder(
    column: $table.replacesEquipmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GymsTableOrderingComposer get gymId {
    final $$GymsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableOrderingComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EquipmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EquipmentType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get gymLabel =>
      $composableBuilder(column: $table.gymLabel, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LoadUnit, String> get loadUnit =>
      $composableBuilder(column: $table.loadUnit, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LoadBasis, String> get loadBasis =>
      $composableBuilder(column: $table.loadBasis, builder: (column) => column);

  GeneratedColumn<int> get incrementMilli => $composableBuilder(
    column: $table.incrementMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseLoadMilli => $composableBuilder(
    column: $table.baseLoadMilli,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replacesEquipmentId => $composableBuilder(
    column: $table.replacesEquipmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GymsTableAnnotationComposer get gymId {
    final $$GymsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableAnnotationComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> stationsRefs<T extends Object>(
    Expression<T> Function($$StationsTableAnnotationComposer a) f,
  ) {
    final $$StationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.equipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableAnnotationComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> routineExercisesRefs<T extends Object>(
    Expression<T> Function($$RoutineExercisesTableAnnotationComposer a) f,
  ) {
    final $$RoutineExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.preferredEquipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentTable,
          EquipmentItem,
          $$EquipmentTableFilterComposer,
          $$EquipmentTableOrderingComposer,
          $$EquipmentTableAnnotationComposer,
          $$EquipmentTableCreateCompanionBuilder,
          $$EquipmentTableUpdateCompanionBuilder,
          (EquipmentItem, $$EquipmentTableReferences),
          EquipmentItem,
          PrefetchHooks Function({
            bool gymId,
            bool stationsRefs,
            bool routineExercisesRefs,
          })
        > {
  $$EquipmentTableTableManager(_$AppDatabase db, $EquipmentTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> gymId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<EquipmentType> type = const Value.absent(),
                Value<String?> gymLabel = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<LoadUnit> loadUnit = const Value.absent(),
                Value<LoadBasis> loadBasis = const Value.absent(),
                Value<int> incrementMilli = const Value.absent(),
                Value<int?> baseLoadMilli = const Value.absent(),
                Value<String?> replacesEquipmentId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentCompanion(
                id: id,
                gymId: gymId,
                name: name,
                type: type,
                gymLabel: gymLabel,
                photoPath: photoPath,
                loadUnit: loadUnit,
                loadBasis: loadBasis,
                incrementMilli: incrementMilli,
                baseLoadMilli: baseLoadMilli,
                replacesEquipmentId: replacesEquipmentId,
                notes: notes,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String gymId,
                required String name,
                required EquipmentType type,
                Value<String?> gymLabel = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                required LoadUnit loadUnit,
                required LoadBasis loadBasis,
                Value<int> incrementMilli = const Value.absent(),
                Value<int?> baseLoadMilli = const Value.absent(),
                Value<String?> replacesEquipmentId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EquipmentCompanion.insert(
                id: id,
                gymId: gymId,
                name: name,
                type: type,
                gymLabel: gymLabel,
                photoPath: photoPath,
                loadUnit: loadUnit,
                loadBasis: loadBasis,
                incrementMilli: incrementMilli,
                baseLoadMilli: baseLoadMilli,
                replacesEquipmentId: replacesEquipmentId,
                notes: notes,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EquipmentTable, EquipmentItem>(table),
                  $$EquipmentTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                gymId = false,
                stationsRefs = false,
                routineExercisesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stationsRefs) db.stations,
                    if (routineExercisesRefs) db.routineExercises,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gymId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gymId,
                            referencedTable: $$EquipmentTableReferences
                                ._gymIdTable(db),
                            referencedColumn: $$EquipmentTableReferences
                                ._gymIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stationsRefs)
                        await $_getPrefetchedData<
                          EquipmentItem,
                          $EquipmentTable,
                          Station
                        >(
                          currentTable: table,
                          referencedTable: $$EquipmentTableReferences
                              ._stationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquipmentTableReferences(
                                db,
                                table,
                                p0,
                              ).stationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.equipmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (routineExercisesRefs)
                        await $_getPrefetchedData<
                          EquipmentItem,
                          $EquipmentTable,
                          RoutineExercise
                        >(
                          currentTable: table,
                          referencedTable: $$EquipmentTableReferences
                              ._routineExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EquipmentTableReferences(
                                db,
                                table,
                                p0,
                              ).routineExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.preferredEquipmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EquipmentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentTable,
      EquipmentItem,
      $$EquipmentTableFilterComposer,
      $$EquipmentTableOrderingComposer,
      $$EquipmentTableAnnotationComposer,
      $$EquipmentTableCreateCompanionBuilder,
      $$EquipmentTableUpdateCompanionBuilder,
      (EquipmentItem, $$EquipmentTableReferences),
      EquipmentItem,
      PrefetchHooks Function({
        bool gymId,
        bool stationsRefs,
        bool routineExercisesRefs,
      })
    >;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<String> id,
  required String name,
  required String searchText,
  Value<String> aliases,
  required EquipmentType equipmentType,
  Value<TrackingType> tracking,
  Value<String> primaryMuscles,
  Value<String> secondaryMuscles,
  Value<bool> isCustom,
  Value<int?> seedVersion,
  Value<DateTime?> archivedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> searchText,
  Value<String> aliases,
  Value<EquipmentType> equipmentType,
  Value<TrackingType> tracking,
  Value<String> primaryMuscles,
  Value<String> secondaryMuscles,
  Value<bool> isCustom,
  Value<int?> seedVersion,
  Value<DateTime?> archivedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StationsTable, List<Station>> _stationsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.stations,
    aliasName: 'exercises__id__stations__exercise_id',
  );

  $$StationsTableProcessedTableManager get stationsRefs {
    final manager = $$StationsTableTableManager(
      $_db,
      $_db.stations,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoutineExercisesTable, List<RoutineExercise>>
  _routineExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineExercises,
    aliasName: 'exercises__id__routine_exercises__exercise_id',
  );

  $$RoutineExercisesTableProcessedTableManager get routineExercisesRefs {
    final manager = $$RoutineExercisesTableTableManager(
      $_db,
      $_db.routineExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
  _sessionExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionExercises,
    aliasName: 'exercises__id__session_exercises__exercise_id',
  );

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EquipmentType, EquipmentType, String>
  get equipmentType => $composableBuilder(
    column: $table.equipmentType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<TrackingType, TrackingType, String>
  get tracking => $composableBuilder(
    column: $table.tracking,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get primaryMuscles => $composableBuilder(
    column: $table.primaryMuscles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get secondaryMuscles => $composableBuilder(
    column: $table.secondaryMuscles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seedVersion => $composableBuilder(
    column: $table.seedVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> stationsRefs(
    Expression<bool> Function($$StationsTableFilterComposer f) f,
  ) {
    final $$StationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableFilterComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> routineExercisesRefs(
    Expression<bool> Function($$RoutineExercisesTableFilterComposer f) f,
  ) {
    final $$RoutineExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableFilterComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionExercisesRefs(
    Expression<bool> Function($$SessionExercisesTableFilterComposer f) f,
  ) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aliases => $composableBuilder(
    column: $table.aliases,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipmentType => $composableBuilder(
    column: $table.equipmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tracking => $composableBuilder(
    column: $table.tracking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryMuscles => $composableBuilder(
    column: $table.primaryMuscles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryMuscles => $composableBuilder(
    column: $table.secondaryMuscles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seedVersion => $composableBuilder(
    column: $table.seedVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get searchText => $composableBuilder(
    column: $table.searchText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get aliases =>
      $composableBuilder(column: $table.aliases, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EquipmentType, String> get equipmentType =>
      $composableBuilder(
        column: $table.equipmentType,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<TrackingType, String> get tracking =>
      $composableBuilder(column: $table.tracking, builder: (column) => column);

  GeneratedColumn<String> get primaryMuscles => $composableBuilder(
    column: $table.primaryMuscles,
    builder: (column) => column,
  );

  GeneratedColumn<String> get secondaryMuscles => $composableBuilder(
    column: $table.secondaryMuscles,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<int> get seedVersion => $composableBuilder(
    column: $table.seedVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> stationsRefs<T extends Object>(
    Expression<T> Function($$StationsTableAnnotationComposer a) f,
  ) {
    final $$StationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableAnnotationComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> routineExercisesRefs<T extends Object>(
    Expression<T> Function($$RoutineExercisesTableAnnotationComposer a) f,
  ) {
    final $$RoutineExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionExercisesRefs<T extends Object>(
    Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f,
  ) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({
            bool stationsRefs,
            bool routineExercisesRefs,
            bool sessionExercisesRefs,
          })
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> searchText = const Value.absent(),
                Value<String> aliases = const Value.absent(),
                Value<EquipmentType> equipmentType = const Value.absent(),
                Value<TrackingType> tracking = const Value.absent(),
                Value<String> primaryMuscles = const Value.absent(),
                Value<String> secondaryMuscles = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int?> seedVersion = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                searchText: searchText,
                aliases: aliases,
                equipmentType: equipmentType,
                tracking: tracking,
                primaryMuscles: primaryMuscles,
                secondaryMuscles: secondaryMuscles,
                isCustom: isCustom,
                seedVersion: seedVersion,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                required String searchText,
                Value<String> aliases = const Value.absent(),
                required EquipmentType equipmentType,
                Value<TrackingType> tracking = const Value.absent(),
                Value<String> primaryMuscles = const Value.absent(),
                Value<String> secondaryMuscles = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int?> seedVersion = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                searchText: searchText,
                aliases: aliases,
                equipmentType: equipmentType,
                tracking: tracking,
                primaryMuscles: primaryMuscles,
                secondaryMuscles: secondaryMuscles,
                isCustom: isCustom,
                seedVersion: seedVersion,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExercisesTable, Exercise>(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                stationsRefs = false,
                routineExercisesRefs = false,
                sessionExercisesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stationsRefs) db.stations,
                    if (routineExercisesRefs) db.routineExercises,
                    if (sessionExercisesRefs) db.sessionExercises,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stationsRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          Station
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._stationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).stationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (routineExercisesRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          RoutineExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._routineExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).routineExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionExercisesRefs)
                        await $_getPrefetchedData<
                          Exercise,
                          $ExercisesTable,
                          SessionExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ExercisesTableReferences
                              ._sessionExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({
        bool stationsRefs,
        bool routineExercisesRefs,
        bool sessionExercisesRefs,
      })
    >;
typedef $$StationsTableCreateCompanionBuilder = StationsCompanion Function({
  Value<String> id,
  required String exerciseId,
  required String gymId,
  Value<String?> equipmentId,
  Value<String?> pinnedNote,
  Value<String?> photoPath,
  Value<DateTime?> archivedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$StationsTableUpdateCompanionBuilder = StationsCompanion Function({
  Value<String> id,
  Value<String> exerciseId,
  Value<String> gymId,
  Value<String?> equipmentId,
  Value<String?> pinnedNote,
  Value<String?> photoPath,
  Value<DateTime?> archivedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$StationsTableReferences
    extends BaseReferences<_$AppDatabase, $StationsTable, Station> {
  $$StationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('stations__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GymsTable _gymIdTable(_$AppDatabase db) =>
      db.gyms.createAlias('stations__gym_id__gyms__id');

  $$GymsTableProcessedTableManager get gymId {
    final $_column = $_itemColumn<String>('gym_id')!;

    final manager = $$GymsTableTableManager(
      $_db,
      $_db.gyms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gymIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquipmentTable _equipmentIdTable(_$AppDatabase db) =>
      db.equipment.createAlias('stations__equipment_id__equipment__id');

  $$EquipmentTableProcessedTableManager? get equipmentId {
    final $_column = $_itemColumn<String>('equipment_id');
    if ($_column == null) return null;
    final manager = $$EquipmentTableTableManager(
      $_db,
      $_db.equipment,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StationSettingsTable, List<StationSetting>>
  _stationSettingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stationSettings,
    aliasName: 'stations__id__station_settings__station_id',
  );

  $$StationSettingsTableProcessedTableManager get stationSettingsRefs {
    final manager = $$StationSettingsTableTableManager(
      $_db,
      $_db.stationSettings,
    ).filter((f) => f.stationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stationSettingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
  _sessionExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionExercises,
    aliasName: 'stations__id__session_exercises__station_id',
  );

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.stationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StationsTableFilterComposer
    extends Composer<_$AppDatabase, $StationsTable> {
  $$StationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinnedNote => $composableBuilder(
    column: $table.pinnedNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GymsTableFilterComposer get gymId {
    final $$GymsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableFilterComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentTableFilterComposer get equipmentId {
    final $$EquipmentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableFilterComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> stationSettingsRefs(
    Expression<bool> Function($$StationSettingsTableFilterComposer f) f,
  ) {
    final $$StationSettingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stationSettings,
      getReferencedColumn: (t) => t.stationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationSettingsTableFilterComposer(
            $db: $db,
            $table: $db.stationSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionExercisesRefs(
    Expression<bool> Function($$SessionExercisesTableFilterComposer f) f,
  ) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.stationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StationsTableOrderingComposer
    extends Composer<_$AppDatabase, $StationsTable> {
  $$StationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinnedNote => $composableBuilder(
    column: $table.pinnedNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GymsTableOrderingComposer get gymId {
    final $$GymsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableOrderingComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentTableOrderingComposer get equipmentId {
    final $$EquipmentTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableOrderingComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StationsTable> {
  $$StationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pinnedNote => $composableBuilder(
    column: $table.pinnedNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GymsTableAnnotationComposer get gymId {
    final $$GymsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableAnnotationComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentTableAnnotationComposer get equipmentId {
    final $$EquipmentTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableAnnotationComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> stationSettingsRefs<T extends Object>(
    Expression<T> Function($$StationSettingsTableAnnotationComposer a) f,
  ) {
    final $$StationSettingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stationSettings,
      getReferencedColumn: (t) => t.stationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationSettingsTableAnnotationComposer(
            $db: $db,
            $table: $db.stationSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionExercisesRefs<T extends Object>(
    Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f,
  ) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.stationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StationsTable,
          Station,
          $$StationsTableFilterComposer,
          $$StationsTableOrderingComposer,
          $$StationsTableAnnotationComposer,
          $$StationsTableCreateCompanionBuilder,
          $$StationsTableUpdateCompanionBuilder,
          (Station, $$StationsTableReferences),
          Station,
          PrefetchHooks Function({
            bool exerciseId,
            bool gymId,
            bool equipmentId,
            bool stationSettingsRefs,
            bool sessionExercisesRefs,
          })
        > {
  $$StationsTableTableManager(_$AppDatabase db, $StationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String> gymId = const Value.absent(),
                Value<String?> equipmentId = const Value.absent(),
                Value<String?> pinnedNote = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StationsCompanion(
                id: id,
                exerciseId: exerciseId,
                gymId: gymId,
                equipmentId: equipmentId,
                pinnedNote: pinnedNote,
                photoPath: photoPath,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String exerciseId,
                required String gymId,
                Value<String?> equipmentId = const Value.absent(),
                Value<String?> pinnedNote = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StationsCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                gymId: gymId,
                equipmentId: equipmentId,
                pinnedNote: pinnedNote,
                photoPath: photoPath,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StationsTable, Station>(table),
                  $$StationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                exerciseId = false,
                gymId = false,
                equipmentId = false,
                stationSettingsRefs = false,
                sessionExercisesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stationSettingsRefs) db.stationSettings,
                    if (sessionExercisesRefs) db.sessionExercises,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (exerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$StationsTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn: $$StationsTableReferences
                                ._exerciseIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (gymId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gymId,
                            referencedTable: $$StationsTableReferences
                                ._gymIdTable(db),
                            referencedColumn: $$StationsTableReferences
                                ._gymIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (equipmentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.equipmentId,
                            referencedTable: $$StationsTableReferences
                                ._equipmentIdTable(db),
                            referencedColumn: $$StationsTableReferences
                                ._equipmentIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stationSettingsRefs)
                        await $_getPrefetchedData<
                          Station,
                          $StationsTable,
                          StationSetting
                        >(
                          currentTable: table,
                          referencedTable: $$StationsTableReferences
                              ._stationSettingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StationsTableReferences(
                                db,
                                table,
                                p0,
                              ).stationSettingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.stationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionExercisesRefs)
                        await $_getPrefetchedData<
                          Station,
                          $StationsTable,
                          SessionExercise
                        >(
                          currentTable: table,
                          referencedTable: $$StationsTableReferences
                              ._sessionExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StationsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.stationId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StationsTable,
      Station,
      $$StationsTableFilterComposer,
      $$StationsTableOrderingComposer,
      $$StationsTableAnnotationComposer,
      $$StationsTableCreateCompanionBuilder,
      $$StationsTableUpdateCompanionBuilder,
      (Station, $$StationsTableReferences),
      Station,
      PrefetchHooks Function({
        bool exerciseId,
        bool gymId,
        bool equipmentId,
        bool stationSettingsRefs,
        bool sessionExercisesRefs,
      })
    >;
typedef $$StationSettingsTableCreateCompanionBuilder =
    StationSettingsCompanion Function({
      Value<String> id,
      required String stationId,
      required String label,
      required SettingKind kind,
      Value<double?> valueNum,
      Value<String?> valueText,
      Value<double> step,
      Value<String?> photoPath,
      Value<int> sortOrder,
      Value<DateTime?> archivedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$StationSettingsTableUpdateCompanionBuilder =
    StationSettingsCompanion Function({
      Value<String> id,
      Value<String> stationId,
      Value<String> label,
      Value<SettingKind> kind,
      Value<double?> valueNum,
      Value<String?> valueText,
      Value<double> step,
      Value<String?> photoPath,
      Value<int> sortOrder,
      Value<DateTime?> archivedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$StationSettingsTableReferences
    extends
        BaseReferences<_$AppDatabase, $StationSettingsTable, StationSetting> {
  $$StationSettingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StationsTable _stationIdTable(_$AppDatabase db) =>
      db.stations.createAlias('station_settings__station_id__stations__id');

  $$StationsTableProcessedTableManager get stationId {
    final $_column = $_itemColumn<String>('station_id')!;

    final manager = $$StationsTableTableManager(
      $_db,
      $_db.stations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $StationSettingChangesTable,
    List<StationSettingChange>
  >
  _stationSettingChangesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.stationSettingChanges,
        aliasName: 'station_settings__id__station_setting_changes__setting_id',
      );

  $$StationSettingChangesTableProcessedTableManager
  get stationSettingChangesRefs {
    final manager = $$StationSettingChangesTableTableManager(
      $_db,
      $_db.stationSettingChanges,
    ).filter((f) => f.settingId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stationSettingChangesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StationSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $StationSettingsTable> {
  $$StationSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SettingKind, SettingKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get valueNum => $composableBuilder(
    column: $table.valueNum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueText => $composableBuilder(
    column: $table.valueText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StationsTableFilterComposer get stationId {
    final $$StationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stationId,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableFilterComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> stationSettingChangesRefs(
    Expression<bool> Function($$StationSettingChangesTableFilterComposer f) f,
  ) {
    final $$StationSettingChangesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.stationSettingChanges,
          getReferencedColumn: (t) => t.settingId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StationSettingChangesTableFilterComposer(
                $db: $db,
                $table: $db.stationSettingChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StationSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $StationSettingsTable> {
  $$StationSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valueNum => $composableBuilder(
    column: $table.valueNum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueText => $composableBuilder(
    column: $table.valueText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StationsTableOrderingComposer get stationId {
    final $$StationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stationId,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableOrderingComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StationSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StationSettingsTable> {
  $$StationSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SettingKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<double> get valueNum =>
      $composableBuilder(column: $table.valueNum, builder: (column) => column);

  GeneratedColumn<String> get valueText =>
      $composableBuilder(column: $table.valueText, builder: (column) => column);

  GeneratedColumn<double> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$StationsTableAnnotationComposer get stationId {
    final $$StationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stationId,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableAnnotationComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> stationSettingChangesRefs<T extends Object>(
    Expression<T> Function($$StationSettingChangesTableAnnotationComposer a) f,
  ) {
    final $$StationSettingChangesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.stationSettingChanges,
          getReferencedColumn: (t) => t.settingId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StationSettingChangesTableAnnotationComposer(
                $db: $db,
                $table: $db.stationSettingChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$StationSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StationSettingsTable,
          StationSetting,
          $$StationSettingsTableFilterComposer,
          $$StationSettingsTableOrderingComposer,
          $$StationSettingsTableAnnotationComposer,
          $$StationSettingsTableCreateCompanionBuilder,
          $$StationSettingsTableUpdateCompanionBuilder,
          (StationSetting, $$StationSettingsTableReferences),
          StationSetting,
          PrefetchHooks Function({
            bool stationId,
            bool stationSettingChangesRefs,
          })
        > {
  $$StationSettingsTableTableManager(
    _$AppDatabase db,
    $StationSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StationSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StationSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StationSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> stationId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<SettingKind> kind = const Value.absent(),
                Value<double?> valueNum = const Value.absent(),
                Value<String?> valueText = const Value.absent(),
                Value<double> step = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StationSettingsCompanion(
                id: id,
                stationId: stationId,
                label: label,
                kind: kind,
                valueNum: valueNum,
                valueText: valueText,
                step: step,
                photoPath: photoPath,
                sortOrder: sortOrder,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String stationId,
                required String label,
                required SettingKind kind,
                Value<double?> valueNum = const Value.absent(),
                Value<String?> valueText = const Value.absent(),
                Value<double> step = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StationSettingsCompanion.insert(
                id: id,
                stationId: stationId,
                label: label,
                kind: kind,
                valueNum: valueNum,
                valueText: valueText,
                step: step,
                photoPath: photoPath,
                sortOrder: sortOrder,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StationSettingsTable, StationSetting>(table),
                  $$StationSettingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({stationId = false, stationSettingChangesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stationSettingChangesRefs) db.stationSettingChanges,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (stationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.stationId,
                            referencedTable: $$StationSettingsTableReferences
                                ._stationIdTable(db),
                            referencedColumn: $$StationSettingsTableReferences
                                ._stationIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stationSettingChangesRefs)
                        await $_getPrefetchedData<
                          StationSetting,
                          $StationSettingsTable,
                          StationSettingChange
                        >(
                          currentTable: table,
                          referencedTable: $$StationSettingsTableReferences
                              ._stationSettingChangesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StationSettingsTableReferences(
                                db,
                                table,
                                p0,
                              ).stationSettingChangesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.settingId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StationSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StationSettingsTable,
      StationSetting,
      $$StationSettingsTableFilterComposer,
      $$StationSettingsTableOrderingComposer,
      $$StationSettingsTableAnnotationComposer,
      $$StationSettingsTableCreateCompanionBuilder,
      $$StationSettingsTableUpdateCompanionBuilder,
      (StationSetting, $$StationSettingsTableReferences),
      StationSetting,
      PrefetchHooks Function({bool stationId, bool stationSettingChangesRefs})
    >;
typedef $$RoutinesTableCreateCompanionBuilder = RoutinesCompanion Function({
  Value<String> id,
  required String name,
  Value<String?> label,
  Value<String?> gymId,
  Value<String?> trainer,
  Value<String?> expiresOn,
  Value<String?> notes,
  Value<int> sortOrder,
  Value<DateTime?> archivedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> label,
  Value<String?> gymId,
  Value<String?> trainer,
  Value<String?> expiresOn,
  Value<String?> notes,
  Value<int> sortOrder,
  Value<DateTime?> archivedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$RoutinesTableReferences
    extends BaseReferences<_$AppDatabase, $RoutinesTable, Routine> {
  $$RoutinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GymsTable _gymIdTable(_$AppDatabase db) =>
      db.gyms.createAlias('routines__gym_id__gyms__id');

  $$GymsTableProcessedTableManager? get gymId {
    final $_column = $_itemColumn<String>('gym_id');
    if ($_column == null) return null;
    final manager = $$GymsTableTableManager(
      $_db,
      $_db.gyms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gymIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSessionsTable, List<WorkoutSession>>
  _workoutSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSessions,
    aliasName: 'routines__id__workout_sessions__routine_id',
  );

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionsRefs {
    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RoutineExercisesTable, List<RoutineExercise>>
  _routineExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.routineExercises,
    aliasName: 'routines__id__routine_exercises__routine_id',
  );

  $$RoutineExercisesTableProcessedTableManager get routineExercisesRefs {
    final manager = $$RoutineExercisesTableTableManager(
      $_db,
      $_db.routineExercises,
    ).filter((f) => f.routineId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _routineExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trainer => $composableBuilder(
    column: $table.trainer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expiresOn => $composableBuilder(
    column: $table.expiresOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GymsTableFilterComposer get gymId {
    final $$GymsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableFilterComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSessionsRefs(
    Expression<bool> Function($$WorkoutSessionsTableFilterComposer f) f,
  ) {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> routineExercisesRefs(
    Expression<bool> Function($$RoutineExercisesTableFilterComposer f) f,
  ) {
    final $$RoutineExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableFilterComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trainer => $composableBuilder(
    column: $table.trainer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expiresOn => $composableBuilder(
    column: $table.expiresOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GymsTableOrderingComposer get gymId {
    final $$GymsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableOrderingComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get trainer =>
      $composableBuilder(column: $table.trainer, builder: (column) => column);

  GeneratedColumn<String> get expiresOn =>
      $composableBuilder(column: $table.expiresOn, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GymsTableAnnotationComposer get gymId {
    final $$GymsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableAnnotationComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSessionsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSessionsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> routineExercisesRefs<T extends Object>(
    Expression<T> Function($$RoutineExercisesTableAnnotationComposer a) f,
  ) {
    final $$RoutineExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.routineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          Routine,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (Routine, $$RoutinesTableReferences),
          Routine,
          PrefetchHooks Function({
            bool gymId,
            bool workoutSessionsRefs,
            bool routineExercisesRefs,
          })
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<String?> gymId = const Value.absent(),
                Value<String?> trainer = const Value.absent(),
                Value<String?> expiresOn = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                name: name,
                label: label,
                gymId: gymId,
                trainer: trainer,
                expiresOn: expiresOn,
                notes: notes,
                sortOrder: sortOrder,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<String?> label = const Value.absent(),
                Value<String?> gymId = const Value.absent(),
                Value<String?> trainer = const Value.absent(),
                Value<String?> expiresOn = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                name: name,
                label: label,
                gymId: gymId,
                trainer: trainer,
                expiresOn: expiresOn,
                notes: notes,
                sortOrder: sortOrder,
                archivedAt: archivedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutinesTable, Routine>(table),
                  $$RoutinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                gymId = false,
                workoutSessionsRefs = false,
                routineExercisesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSessionsRefs) db.workoutSessions,
                    if (routineExercisesRefs) db.routineExercises,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (gymId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gymId,
                            referencedTable: $$RoutinesTableReferences
                                ._gymIdTable(db),
                            referencedColumn: $$RoutinesTableReferences
                                ._gymIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSessionsRefs)
                        await $_getPrefetchedData<
                          Routine,
                          $RoutinesTable,
                          WorkoutSession
                        >(
                          currentTable: table,
                          referencedTable: $$RoutinesTableReferences
                              ._workoutSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutinesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.routineId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (routineExercisesRefs)
                        await $_getPrefetchedData<
                          Routine,
                          $RoutinesTable,
                          RoutineExercise
                        >(
                          currentTable: table,
                          referencedTable: $$RoutinesTableReferences
                              ._routineExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutinesTableReferences(
                                db,
                                table,
                                p0,
                              ).routineExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.routineId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      Routine,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (Routine, $$RoutinesTableReferences),
      Routine,
      PrefetchHooks Function({
        bool gymId,
        bool workoutSessionsRefs,
        bool routineExercisesRefs,
      })
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<String> id,
      Value<String?> routineId,
      required String gymId,
      required String title,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      required String localDate,
      Value<DateTime?> restEndsAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<String> id,
      Value<String?> routineId,
      Value<String> gymId,
      Value<String> title,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<String> localDate,
      Value<DateTime?> restEndsAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('workout_sessions__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager? get routineId {
    final $_column = $_itemColumn<String>('routine_id');
    if ($_column == null) return null;
    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $GymsTable _gymIdTable(_$AppDatabase db) =>
      db.gyms.createAlias('workout_sessions__gym_id__gyms__id');

  $$GymsTableProcessedTableManager get gymId {
    final $_column = $_itemColumn<String>('gym_id')!;

    final manager = $$GymsTableTableManager(
      $_db,
      $_db.gyms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gymIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $StationSettingChangesTable,
    List<StationSettingChange>
  >
  _stationSettingChangesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.stationSettingChanges,
        aliasName: 'workout_sessions__id__station_setting_changes__session_id',
      );

  $$StationSettingChangesTableProcessedTableManager
  get stationSettingChangesRefs {
    final manager = $$StationSettingChangesTableTableManager(
      $_db,
      $_db.stationSettingChanges,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stationSettingChangesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
  _sessionExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionExercises,
    aliasName: 'workout_sessions__id__session_exercises__session_id',
  );

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _sessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GymsTableFilterComposer get gymId {
    final $$GymsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableFilterComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> stationSettingChangesRefs(
    Expression<bool> Function($$StationSettingChangesTableFilterComposer f) f,
  ) {
    final $$StationSettingChangesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.stationSettingChanges,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StationSettingChangesTableFilterComposer(
                $db: $db,
                $table: $db.stationSettingChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> sessionExercisesRefs(
    Expression<bool> Function($$SessionExercisesTableFilterComposer f) f,
  ) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GymsTableOrderingComposer get gymId {
    final $$GymsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableOrderingComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<DateTime> get restEndsAt => $composableBuilder(
    column: $table.restEndsAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$GymsTableAnnotationComposer get gymId {
    final $$GymsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gymId,
      referencedTable: $db.gyms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GymsTableAnnotationComposer(
            $db: $db,
            $table: $db.gyms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> stationSettingChangesRefs<T extends Object>(
    Expression<T> Function($$StationSettingChangesTableAnnotationComposer a) f,
  ) {
    final $$StationSettingChangesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.stationSettingChanges,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StationSettingChangesTableAnnotationComposer(
                $db: $db,
                $table: $db.stationSettingChanges,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> sessionExercisesRefs<T extends Object>(
    Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f,
  ) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({
            bool routineId,
            bool gymId,
            bool stationSettingChangesRefs,
            bool sessionExercisesRefs,
          })
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> routineId = const Value.absent(),
                Value<String> gymId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<DateTime?> restEndsAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                routineId: routineId,
                gymId: gymId,
                title: title,
                startedAt: startedAt,
                endedAt: endedAt,
                localDate: localDate,
                restEndsAt: restEndsAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> routineId = const Value.absent(),
                required String gymId,
                required String title,
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                required String localDate,
                Value<DateTime?> restEndsAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                routineId: routineId,
                gymId: gymId,
                title: title,
                startedAt: startedAt,
                endedAt: endedAt,
                localDate: localDate,
                restEndsAt: restEndsAt,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSessionsTable, WorkoutSession>(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                routineId = false,
                gymId = false,
                stationSettingChangesRefs = false,
                sessionExercisesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stationSettingChangesRefs) db.stationSettingChanges,
                    if (sessionExercisesRefs) db.sessionExercises,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (routineId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.routineId,
                            referencedTable: $$WorkoutSessionsTableReferences
                                ._routineIdTable(db),
                            referencedColumn: $$WorkoutSessionsTableReferences
                                ._routineIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (gymId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.gymId,
                            referencedTable: $$WorkoutSessionsTableReferences
                                ._gymIdTable(db),
                            referencedColumn: $$WorkoutSessionsTableReferences
                                ._gymIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stationSettingChangesRefs)
                        await $_getPrefetchedData<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          StationSettingChange
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._stationSettingChangesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).stationSettingChangesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionExercisesRefs)
                        await $_getPrefetchedData<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          SessionExercise
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._sessionExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({
        bool routineId,
        bool gymId,
        bool stationSettingChangesRefs,
        bool sessionExercisesRefs,
      })
    >;
typedef $$StationSettingChangesTableCreateCompanionBuilder =
    StationSettingChangesCompanion Function({
      Value<String> id,
      required String settingId,
      Value<String?> oldValue,
      Value<String?> newValue,
      Value<String?> sessionId,
      Value<DateTime> changedAt,
      Value<int> rowid,
    });
typedef $$StationSettingChangesTableUpdateCompanionBuilder =
    StationSettingChangesCompanion Function({
      Value<String> id,
      Value<String> settingId,
      Value<String?> oldValue,
      Value<String?> newValue,
      Value<String?> sessionId,
      Value<DateTime> changedAt,
      Value<int> rowid,
    });

final class $$StationSettingChangesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StationSettingChangesTable,
          StationSettingChange
        > {
  $$StationSettingChangesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StationSettingsTable _settingIdTable(_$AppDatabase db) => db
      .stationSettings
      .createAlias('station_setting_changes__setting_id__station_settings__id');

  $$StationSettingsTableProcessedTableManager get settingId {
    final $_column = $_itemColumn<String>('setting_id')!;

    final manager = $$StationSettingsTableTableManager(
      $_db,
      $_db.stationSettings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_settingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('station_setting_changes__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager? get sessionId {
    final $_column = $_itemColumn<String>('session_id');
    if ($_column == null) return null;
    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StationSettingChangesTableFilterComposer
    extends Composer<_$AppDatabase, $StationSettingChangesTable> {
  $$StationSettingChangesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oldValue => $composableBuilder(
    column: $table.oldValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StationSettingsTableFilterComposer get settingId {
    final $$StationSettingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.settingId,
      referencedTable: $db.stationSettings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationSettingsTableFilterComposer(
            $db: $db,
            $table: $db.stationSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StationSettingChangesTableOrderingComposer
    extends Composer<_$AppDatabase, $StationSettingChangesTable> {
  $$StationSettingChangesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oldValue => $composableBuilder(
    column: $table.oldValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StationSettingsTableOrderingComposer get settingId {
    final $$StationSettingsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.settingId,
      referencedTable: $db.stationSettings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationSettingsTableOrderingComposer(
            $db: $db,
            $table: $db.stationSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StationSettingChangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StationSettingChangesTable> {
  $$StationSettingChangesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get oldValue =>
      $composableBuilder(column: $table.oldValue, builder: (column) => column);

  GeneratedColumn<String> get newValue =>
      $composableBuilder(column: $table.newValue, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  $$StationSettingsTableAnnotationComposer get settingId {
    final $$StationSettingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.settingId,
      referencedTable: $db.stationSettings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationSettingsTableAnnotationComposer(
            $db: $db,
            $table: $db.stationSettings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StationSettingChangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StationSettingChangesTable,
          StationSettingChange,
          $$StationSettingChangesTableFilterComposer,
          $$StationSettingChangesTableOrderingComposer,
          $$StationSettingChangesTableAnnotationComposer,
          $$StationSettingChangesTableCreateCompanionBuilder,
          $$StationSettingChangesTableUpdateCompanionBuilder,
          (StationSettingChange, $$StationSettingChangesTableReferences),
          StationSettingChange,
          PrefetchHooks Function({bool settingId, bool sessionId})
        > {
  $$StationSettingChangesTableTableManager(
    _$AppDatabase db,
    $StationSettingChangesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StationSettingChangesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StationSettingChangesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StationSettingChangesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> settingId = const Value.absent(),
                Value<String?> oldValue = const Value.absent(),
                Value<String?> newValue = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StationSettingChangesCompanion(
                id: id,
                settingId: settingId,
                oldValue: oldValue,
                newValue: newValue,
                sessionId: sessionId,
                changedAt: changedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String settingId,
                Value<String?> oldValue = const Value.absent(),
                Value<String?> newValue = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StationSettingChangesCompanion.insert(
                id: id,
                settingId: settingId,
                oldValue: oldValue,
                newValue: newValue,
                sessionId: sessionId,
                changedAt: changedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $StationSettingChangesTable,
                    StationSettingChange
                  >(table),
                  $$StationSettingChangesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({settingId = false, sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (settingId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.settingId,
                        referencedTable: $$StationSettingChangesTableReferences
                            ._settingIdTable(db),
                        referencedColumn: $$StationSettingChangesTableReferences
                            ._settingIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$StationSettingChangesTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$StationSettingChangesTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StationSettingChangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StationSettingChangesTable,
      StationSettingChange,
      $$StationSettingChangesTableFilterComposer,
      $$StationSettingChangesTableOrderingComposer,
      $$StationSettingChangesTableAnnotationComposer,
      $$StationSettingChangesTableCreateCompanionBuilder,
      $$StationSettingChangesTableUpdateCompanionBuilder,
      (StationSettingChange, $$StationSettingChangesTableReferences),
      StationSettingChange,
      PrefetchHooks Function({bool settingId, bool sessionId})
    >;
typedef $$RoutineExercisesTableCreateCompanionBuilder =
    RoutineExercisesCompanion Function({
      Value<String> id,
      required String routineId,
      required String exerciseId,
      Value<String?> preferredEquipmentId,
      required int position,
      Value<int> targetSets,
      Value<int?> repMin,
      Value<int?> repMax,
      Value<int?> targetRir,
      Value<int?> restSec,
      Value<int> warmupSets,
      Value<String?> tempo,
      Value<String?> notes,
      Value<int?> supersetGroup,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$RoutineExercisesTableUpdateCompanionBuilder =
    RoutineExercisesCompanion Function({
      Value<String> id,
      Value<String> routineId,
      Value<String> exerciseId,
      Value<String?> preferredEquipmentId,
      Value<int> position,
      Value<int> targetSets,
      Value<int?> repMin,
      Value<int?> repMax,
      Value<int?> targetRir,
      Value<int?> restSec,
      Value<int> warmupSets,
      Value<String?> tempo,
      Value<String?> notes,
      Value<int?> supersetGroup,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RoutineExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $RoutineExercisesTable, RoutineExercise> {
  $$RoutineExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RoutinesTable _routineIdTable(_$AppDatabase db) =>
      db.routines.createAlias('routine_exercises__routine_id__routines__id');

  $$RoutinesTableProcessedTableManager get routineId {
    final $_column = $_itemColumn<String>('routine_id')!;

    final manager = $$RoutinesTableTableManager(
      $_db,
      $_db.routines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('routine_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EquipmentTable _preferredEquipmentIdTable(_$AppDatabase db) => db
      .equipment
      .createAlias('routine_exercises__preferred_equipment_id__equipment__id');

  $$EquipmentTableProcessedTableManager? get preferredEquipmentId {
    final $_column = $_itemColumn<String>('preferred_equipment_id');
    if ($_column == null) return null;
    final manager = $$EquipmentTableTableManager(
      $_db,
      $_db.equipment,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _preferredEquipmentIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SessionExercisesTable, List<SessionExercise>>
  _sessionExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionExercises,
    aliasName: 'routine_exercises__id__session_exercises__routine_exercise_id',
  );

  $$SessionExercisesTableProcessedTableManager get sessionExercisesRefs {
    final manager =
        $$SessionExercisesTableTableManager($_db, $_db.sessionExercises).filter(
          (f) => f.routineExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _sessionExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RoutineExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTable> {
  $$RoutineExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repMin => $composableBuilder(
    column: $table.repMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repMax => $composableBuilder(
    column: $table.repMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetRir => $composableBuilder(
    column: $table.targetRir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSec => $composableBuilder(
    column: $table.restSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get warmupSets => $composableBuilder(
    column: $table.warmupSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tempo => $composableBuilder(
    column: $table.tempo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get supersetGroup => $composableBuilder(
    column: $table.supersetGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RoutinesTableFilterComposer get routineId {
    final $$RoutinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableFilterComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentTableFilterComposer get preferredEquipmentId {
    final $$EquipmentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.preferredEquipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableFilterComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> sessionExercisesRefs(
    Expression<bool> Function($$SessionExercisesTableFilterComposer f) f,
  ) {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.routineExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTable> {
  $$RoutineExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repMin => $composableBuilder(
    column: $table.repMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repMax => $composableBuilder(
    column: $table.repMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetRir => $composableBuilder(
    column: $table.targetRir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSec => $composableBuilder(
    column: $table.restSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get warmupSets => $composableBuilder(
    column: $table.warmupSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tempo => $composableBuilder(
    column: $table.tempo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get supersetGroup => $composableBuilder(
    column: $table.supersetGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RoutinesTableOrderingComposer get routineId {
    final $$RoutinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableOrderingComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentTableOrderingComposer get preferredEquipmentId {
    final $$EquipmentTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.preferredEquipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableOrderingComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RoutineExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineExercisesTable> {
  $$RoutineExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repMin =>
      $composableBuilder(column: $table.repMin, builder: (column) => column);

  GeneratedColumn<int> get repMax =>
      $composableBuilder(column: $table.repMax, builder: (column) => column);

  GeneratedColumn<int> get targetRir =>
      $composableBuilder(column: $table.targetRir, builder: (column) => column);

  GeneratedColumn<int> get restSec =>
      $composableBuilder(column: $table.restSec, builder: (column) => column);

  GeneratedColumn<int> get warmupSets => $composableBuilder(
    column: $table.warmupSets,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tempo =>
      $composableBuilder(column: $table.tempo, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get supersetGroup => $composableBuilder(
    column: $table.supersetGroup,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RoutinesTableAnnotationComposer get routineId {
    final $$RoutinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineId,
      referencedTable: $db.routines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutinesTableAnnotationComposer(
            $db: $db,
            $table: $db.routines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EquipmentTableAnnotationComposer get preferredEquipmentId {
    final $$EquipmentTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.preferredEquipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableAnnotationComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> sessionExercisesRefs<T extends Object>(
    Expression<T> Function($$SessionExercisesTableAnnotationComposer a) f,
  ) {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.routineExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RoutineExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineExercisesTable,
          RoutineExercise,
          $$RoutineExercisesTableFilterComposer,
          $$RoutineExercisesTableOrderingComposer,
          $$RoutineExercisesTableAnnotationComposer,
          $$RoutineExercisesTableCreateCompanionBuilder,
          $$RoutineExercisesTableUpdateCompanionBuilder,
          (RoutineExercise, $$RoutineExercisesTableReferences),
          RoutineExercise,
          PrefetchHooks Function({
            bool routineId,
            bool exerciseId,
            bool preferredEquipmentId,
            bool sessionExercisesRefs,
          })
        > {
  $$RoutineExercisesTableTableManager(
    _$AppDatabase db,
    $RoutineExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> routineId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String?> preferredEquipmentId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> targetSets = const Value.absent(),
                Value<int?> repMin = const Value.absent(),
                Value<int?> repMax = const Value.absent(),
                Value<int?> targetRir = const Value.absent(),
                Value<int?> restSec = const Value.absent(),
                Value<int> warmupSets = const Value.absent(),
                Value<String?> tempo = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> supersetGroup = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineExercisesCompanion(
                id: id,
                routineId: routineId,
                exerciseId: exerciseId,
                preferredEquipmentId: preferredEquipmentId,
                position: position,
                targetSets: targetSets,
                repMin: repMin,
                repMax: repMax,
                targetRir: targetRir,
                restSec: restSec,
                warmupSets: warmupSets,
                tempo: tempo,
                notes: notes,
                supersetGroup: supersetGroup,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String routineId,
                required String exerciseId,
                Value<String?> preferredEquipmentId = const Value.absent(),
                required int position,
                Value<int> targetSets = const Value.absent(),
                Value<int?> repMin = const Value.absent(),
                Value<int?> repMax = const Value.absent(),
                Value<int?> targetRir = const Value.absent(),
                Value<int?> restSec = const Value.absent(),
                Value<int> warmupSets = const Value.absent(),
                Value<String?> tempo = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> supersetGroup = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineExercisesCompanion.insert(
                id: id,
                routineId: routineId,
                exerciseId: exerciseId,
                preferredEquipmentId: preferredEquipmentId,
                position: position,
                targetSets: targetSets,
                repMin: repMin,
                repMax: repMax,
                targetRir: targetRir,
                restSec: restSec,
                warmupSets: warmupSets,
                tempo: tempo,
                notes: notes,
                supersetGroup: supersetGroup,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutineExercisesTable, RoutineExercise>(table),
                  $$RoutineExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                routineId = false,
                exerciseId = false,
                preferredEquipmentId = false,
                sessionExercisesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (sessionExercisesRefs) db.sessionExercises,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (routineId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.routineId,
                            referencedTable: $$RoutineExercisesTableReferences
                                ._routineIdTable(db),
                            referencedColumn: $$RoutineExercisesTableReferences
                                ._routineIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$RoutineExercisesTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn: $$RoutineExercisesTableReferences
                                ._exerciseIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (preferredEquipmentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.preferredEquipmentId,
                            referencedTable: $$RoutineExercisesTableReferences
                                ._preferredEquipmentIdTable(db),
                            referencedColumn: $$RoutineExercisesTableReferences
                                ._preferredEquipmentIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (sessionExercisesRefs)
                        await $_getPrefetchedData<
                          RoutineExercise,
                          $RoutineExercisesTable,
                          SessionExercise
                        >(
                          currentTable: table,
                          referencedTable: $$RoutineExercisesTableReferences
                              ._sessionExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RoutineExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.routineExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RoutineExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineExercisesTable,
      RoutineExercise,
      $$RoutineExercisesTableFilterComposer,
      $$RoutineExercisesTableOrderingComposer,
      $$RoutineExercisesTableAnnotationComposer,
      $$RoutineExercisesTableCreateCompanionBuilder,
      $$RoutineExercisesTableUpdateCompanionBuilder,
      (RoutineExercise, $$RoutineExercisesTableReferences),
      RoutineExercise,
      PrefetchHooks Function({
        bool routineId,
        bool exerciseId,
        bool preferredEquipmentId,
        bool sessionExercisesRefs,
      })
    >;
typedef $$SessionExercisesTableCreateCompanionBuilder =
    SessionExercisesCompanion Function({
      Value<String> id,
      required String sessionId,
      required String stationId,
      required String exerciseId,
      Value<String?> routineExerciseId,
      required int position,
      required LoadUnit loadUnit,
      required LoadBasis loadBasis,
      required int incrementMilli,
      Value<int?> targetSets,
      Value<int?> repMin,
      Value<int?> repMax,
      required int restSec,
      Value<String?> howItWent,
      Value<EffortTag?> effortTag,
      Value<bool> pain,
      Value<int?> supersetGroup,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SessionExercisesTableUpdateCompanionBuilder =
    SessionExercisesCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> stationId,
      Value<String> exerciseId,
      Value<String?> routineExerciseId,
      Value<int> position,
      Value<LoadUnit> loadUnit,
      Value<LoadBasis> loadBasis,
      Value<int> incrementMilli,
      Value<int?> targetSets,
      Value<int?> repMin,
      Value<int?> repMax,
      Value<int> restSec,
      Value<String?> howItWent,
      Value<EffortTag?> effortTag,
      Value<bool> pain,
      Value<int?> supersetGroup,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SessionExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SessionExercisesTable, SessionExercise> {
  $$SessionExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .workoutSessions
      .createAlias('session_exercises__session_id__workout_sessions__id');

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StationsTable _stationIdTable(_$AppDatabase db) =>
      db.stations.createAlias('session_exercises__station_id__stations__id');

  $$StationsTableProcessedTableManager get stationId {
    final $_column = $_itemColumn<String>('station_id')!;

    final manager = $$StationsTableTableManager(
      $_db,
      $_db.stations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias('session_exercises__exercise_id__exercises__id');

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RoutineExercisesTable _routineExerciseIdTable(_$AppDatabase db) =>
      db.routineExercises.createAlias(
        'session_exercises__routine_exercise_id__routine_exercises__id',
      );

  $$RoutineExercisesTableProcessedTableManager? get routineExerciseId {
    final $_column = $_itemColumn<String>('routine_exercise_id');
    if ($_column == null) return null;
    final manager = $$RoutineExercisesTableTableManager(
      $_db,
      $_db.routineExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_routineExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'session_exercises__id__workout_sets__session_exercise_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager($_db, $_db.workoutSets)
        .filter(
          (f) => f.sessionExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LoadUnit, LoadUnit, String> get loadUnit =>
      $composableBuilder(
        column: $table.loadUnit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<LoadBasis, LoadBasis, String> get loadBasis =>
      $composableBuilder(
        column: $table.loadBasis,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get incrementMilli => $composableBuilder(
    column: $table.incrementMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repMin => $composableBuilder(
    column: $table.repMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repMax => $composableBuilder(
    column: $table.repMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSec => $composableBuilder(
    column: $table.restSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get howItWent => $composableBuilder(
    column: $table.howItWent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EffortTag?, EffortTag, String> get effortTag =>
      $composableBuilder(
        column: $table.effortTag,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get pain => $composableBuilder(
    column: $table.pain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get supersetGroup => $composableBuilder(
    column: $table.supersetGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StationsTableFilterComposer get stationId {
    final $$StationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stationId,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableFilterComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RoutineExercisesTableFilterComposer get routineExerciseId {
    final $$RoutineExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineExerciseId,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableFilterComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loadUnit => $composableBuilder(
    column: $table.loadUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loadBasis => $composableBuilder(
    column: $table.loadBasis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incrementMilli => $composableBuilder(
    column: $table.incrementMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repMin => $composableBuilder(
    column: $table.repMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repMax => $composableBuilder(
    column: $table.repMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSec => $composableBuilder(
    column: $table.restSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get howItWent => $composableBuilder(
    column: $table.howItWent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effortTag => $composableBuilder(
    column: $table.effortTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pain => $composableBuilder(
    column: $table.pain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get supersetGroup => $composableBuilder(
    column: $table.supersetGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StationsTableOrderingComposer get stationId {
    final $$StationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stationId,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableOrderingComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RoutineExercisesTableOrderingComposer get routineExerciseId {
    final $$RoutineExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineExerciseId,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionExercisesTable> {
  $$SessionExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LoadUnit, String> get loadUnit =>
      $composableBuilder(column: $table.loadUnit, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LoadBasis, String> get loadBasis =>
      $composableBuilder(column: $table.loadBasis, builder: (column) => column);

  GeneratedColumn<int> get incrementMilli => $composableBuilder(
    column: $table.incrementMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repMin =>
      $composableBuilder(column: $table.repMin, builder: (column) => column);

  GeneratedColumn<int> get repMax =>
      $composableBuilder(column: $table.repMax, builder: (column) => column);

  GeneratedColumn<int> get restSec =>
      $composableBuilder(column: $table.restSec, builder: (column) => column);

  GeneratedColumn<String> get howItWent =>
      $composableBuilder(column: $table.howItWent, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EffortTag?, String> get effortTag =>
      $composableBuilder(column: $table.effortTag, builder: (column) => column);

  GeneratedColumn<bool> get pain =>
      $composableBuilder(column: $table.pain, builder: (column) => column);

  GeneratedColumn<int> get supersetGroup => $composableBuilder(
    column: $table.supersetGroup,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StationsTableAnnotationComposer get stationId {
    final $$StationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stationId,
      referencedTable: $db.stations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StationsTableAnnotationComposer(
            $db: $db,
            $table: $db.stations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RoutineExercisesTableAnnotationComposer get routineExerciseId {
    final $$RoutineExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.routineExerciseId,
      referencedTable: $db.routineExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RoutineExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.routineExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.sessionExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionExercisesTable,
          SessionExercise,
          $$SessionExercisesTableFilterComposer,
          $$SessionExercisesTableOrderingComposer,
          $$SessionExercisesTableAnnotationComposer,
          $$SessionExercisesTableCreateCompanionBuilder,
          $$SessionExercisesTableUpdateCompanionBuilder,
          (SessionExercise, $$SessionExercisesTableReferences),
          SessionExercise,
          PrefetchHooks Function({
            bool sessionId,
            bool stationId,
            bool exerciseId,
            bool routineExerciseId,
            bool workoutSetsRefs,
          })
        > {
  $$SessionExercisesTableTableManager(
    _$AppDatabase db,
    $SessionExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> stationId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<String?> routineExerciseId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<LoadUnit> loadUnit = const Value.absent(),
                Value<LoadBasis> loadBasis = const Value.absent(),
                Value<int> incrementMilli = const Value.absent(),
                Value<int?> targetSets = const Value.absent(),
                Value<int?> repMin = const Value.absent(),
                Value<int?> repMax = const Value.absent(),
                Value<int> restSec = const Value.absent(),
                Value<String?> howItWent = const Value.absent(),
                Value<EffortTag?> effortTag = const Value.absent(),
                Value<bool> pain = const Value.absent(),
                Value<int?> supersetGroup = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionExercisesCompanion(
                id: id,
                sessionId: sessionId,
                stationId: stationId,
                exerciseId: exerciseId,
                routineExerciseId: routineExerciseId,
                position: position,
                loadUnit: loadUnit,
                loadBasis: loadBasis,
                incrementMilli: incrementMilli,
                targetSets: targetSets,
                repMin: repMin,
                repMax: repMax,
                restSec: restSec,
                howItWent: howItWent,
                effortTag: effortTag,
                pain: pain,
                supersetGroup: supersetGroup,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String sessionId,
                required String stationId,
                required String exerciseId,
                Value<String?> routineExerciseId = const Value.absent(),
                required int position,
                required LoadUnit loadUnit,
                required LoadBasis loadBasis,
                required int incrementMilli,
                Value<int?> targetSets = const Value.absent(),
                Value<int?> repMin = const Value.absent(),
                Value<int?> repMax = const Value.absent(),
                required int restSec,
                Value<String?> howItWent = const Value.absent(),
                Value<EffortTag?> effortTag = const Value.absent(),
                Value<bool> pain = const Value.absent(),
                Value<int?> supersetGroup = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionExercisesCompanion.insert(
                id: id,
                sessionId: sessionId,
                stationId: stationId,
                exerciseId: exerciseId,
                routineExerciseId: routineExerciseId,
                position: position,
                loadUnit: loadUnit,
                loadBasis: loadBasis,
                incrementMilli: incrementMilli,
                targetSets: targetSets,
                repMin: repMin,
                repMax: repMax,
                restSec: restSec,
                howItWent: howItWent,
                effortTag: effortTag,
                pain: pain,
                supersetGroup: supersetGroup,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionExercisesTable, SessionExercise>(table),
                  $$SessionExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sessionId = false,
                stationId = false,
                exerciseId = false,
                routineExerciseId = false,
                workoutSetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sessionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable: $$SessionExercisesTableReferences
                                ._sessionIdTable(db),
                            referencedColumn: $$SessionExercisesTableReferences
                                ._sessionIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (stationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.stationId,
                            referencedTable: $$SessionExercisesTableReferences
                                ._stationIdTable(db),
                            referencedColumn: $$SessionExercisesTableReferences
                                ._stationIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (exerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable: $$SessionExercisesTableReferences
                                ._exerciseIdTable(db),
                            referencedColumn: $$SessionExercisesTableReferences
                                ._exerciseIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (routineExerciseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.routineExerciseId,
                            referencedTable: $$SessionExercisesTableReferences
                                ._routineExerciseIdTable(db),
                            referencedColumn: $$SessionExercisesTableReferences
                                ._routineExerciseIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsRefs)
                        await $_getPrefetchedData<
                          SessionExercise,
                          $SessionExercisesTable,
                          WorkoutSet
                        >(
                          currentTable: table,
                          referencedTable: $$SessionExercisesTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionExercisesTable,
      SessionExercise,
      $$SessionExercisesTableFilterComposer,
      $$SessionExercisesTableOrderingComposer,
      $$SessionExercisesTableAnnotationComposer,
      $$SessionExercisesTableCreateCompanionBuilder,
      $$SessionExercisesTableUpdateCompanionBuilder,
      (SessionExercise, $$SessionExercisesTableReferences),
      SessionExercise,
      PrefetchHooks Function({
        bool sessionId,
        bool stationId,
        bool exerciseId,
        bool routineExerciseId,
        bool workoutSetsRefs,
      })
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<String> id,
      required String sessionExerciseId,
      required int position,
      required SetType setType,
      Value<int?> loadMilli,
      Value<int?> reps,
      Value<int?> durationSec,
      Value<int?> distanceM,
      Value<double?> rir,
      Value<DateTime?> completedAt,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<String> id,
      Value<String> sessionExerciseId,
      Value<int> position,
      Value<SetType> setType,
      Value<int?> loadMilli,
      Value<int?> reps,
      Value<int?> durationSec,
      Value<int?> distanceM,
      Value<double?> rir,
      Value<DateTime?> completedAt,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSet> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionExercisesTable _sessionExerciseIdTable(_$AppDatabase db) => db
      .sessionExercises
      .createAlias('workout_sets__session_exercise_id__session_exercises__id');

  $$SessionExercisesTableProcessedTableManager get sessionExerciseId {
    final $_column = $_itemColumn<String>('session_exercise_id')!;

    final manager = $$SessionExercisesTableTableManager(
      $_db,
      $_db.sessionExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SetType, SetType, String> get setType =>
      $composableBuilder(
        column: $table.setType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get loadMilli => $composableBuilder(
    column: $table.loadMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionExercisesTableFilterComposer get sessionExerciseId {
    final $$SessionExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableFilterComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loadMilli => $composableBuilder(
    column: $table.loadMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distanceM => $composableBuilder(
    column: $table.distanceM,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionExercisesTableOrderingComposer get sessionExerciseId {
    final $$SessionExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SetType, String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumn<int> get loadMilli =>
      $composableBuilder(column: $table.loadMilli, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
    column: $table.durationSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumn<double> get rir =>
      $composableBuilder(column: $table.rir, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SessionExercisesTableAnnotationComposer get sessionExerciseId {
    final $$SessionExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionExerciseId,
      referencedTable: $db.sessionExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTable,
          WorkoutSet,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (WorkoutSet, $$WorkoutSetsTableReferences),
          WorkoutSet,
          PrefetchHooks Function({bool sessionExerciseId})
        > {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionExerciseId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<SetType> setType = const Value.absent(),
                Value<int?> loadMilli = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<int?> distanceM = const Value.absent(),
                Value<double?> rir = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                sessionExerciseId: sessionExerciseId,
                position: position,
                setType: setType,
                loadMilli: loadMilli,
                reps: reps,
                durationSec: durationSec,
                distanceM: distanceM,
                rir: rir,
                completedAt: completedAt,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String sessionExerciseId,
                required int position,
                required SetType setType,
                Value<int?> loadMilli = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int?> durationSec = const Value.absent(),
                Value<int?> distanceM = const Value.absent(),
                Value<double?> rir = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                sessionExerciseId: sessionExerciseId,
                position: position,
                setType: setType,
                loadMilli: loadMilli,
                reps: reps,
                durationSec: durationSec,
                distanceM: distanceM,
                rir: rir,
                completedAt: completedAt,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkoutSetsTable, WorkoutSet>(table),
                  $$WorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionExerciseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionExerciseId,
                        referencedTable: $$WorkoutSetsTableReferences
                            ._sessionExerciseIdTable(db),
                        referencedColumn: $$WorkoutSetsTableReferences
                            ._sessionExerciseIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTable,
      WorkoutSet,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (WorkoutSet, $$WorkoutSetsTableReferences),
      WorkoutSet,
      PrefetchHooks Function({bool sessionExerciseId})
    >;
typedef $$BodyCheckinsTableCreateCompanionBuilder =
    BodyCheckinsCompanion Function({
      Value<String> id,
      Value<DateTime> takenAt,
      required String localDate,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$BodyCheckinsTableUpdateCompanionBuilder =
    BodyCheckinsCompanion Function({
      Value<String> id,
      Value<DateTime> takenAt,
      Value<String> localDate,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$BodyCheckinsTableReferences
    extends BaseReferences<_$AppDatabase, $BodyCheckinsTable, BodyCheckin> {
  $$BodyCheckinsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BodyValuesTable, List<BodyValue>>
  _bodyValuesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bodyValues,
    aliasName: 'body_checkins__id__body_values__checkin_id',
  );

  $$BodyValuesTableProcessedTableManager get bodyValuesRefs {
    final manager = $$BodyValuesTableTableManager(
      $_db,
      $_db.bodyValues,
    ).filter((f) => f.checkinId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bodyValuesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BodyPhotosTable, List<BodyPhoto>>
  _bodyPhotosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bodyPhotos,
    aliasName: 'body_checkins__id__body_photos__checkin_id',
  );

  $$BodyPhotosTableProcessedTableManager get bodyPhotosRefs {
    final manager = $$BodyPhotosTableTableManager(
      $_db,
      $_db.bodyPhotos,
    ).filter((f) => f.checkinId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bodyPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BodyCheckinsTableFilterComposer
    extends Composer<_$AppDatabase, $BodyCheckinsTable> {
  $$BodyCheckinsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> bodyValuesRefs(
    Expression<bool> Function($$BodyValuesTableFilterComposer f) f,
  ) {
    final $$BodyValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bodyValues,
      getReferencedColumn: (t) => t.checkinId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BodyValuesTableFilterComposer(
            $db: $db,
            $table: $db.bodyValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bodyPhotosRefs(
    Expression<bool> Function($$BodyPhotosTableFilterComposer f) f,
  ) {
    final $$BodyPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bodyPhotos,
      getReferencedColumn: (t) => t.checkinId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BodyPhotosTableFilterComposer(
            $db: $db,
            $table: $db.bodyPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BodyCheckinsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyCheckinsTable> {
  $$BodyCheckinsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyCheckinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyCheckinsTable> {
  $$BodyCheckinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> bodyValuesRefs<T extends Object>(
    Expression<T> Function($$BodyValuesTableAnnotationComposer a) f,
  ) {
    final $$BodyValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bodyValues,
      getReferencedColumn: (t) => t.checkinId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BodyValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.bodyValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bodyPhotosRefs<T extends Object>(
    Expression<T> Function($$BodyPhotosTableAnnotationComposer a) f,
  ) {
    final $$BodyPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bodyPhotos,
      getReferencedColumn: (t) => t.checkinId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BodyPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.bodyPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BodyCheckinsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyCheckinsTable,
          BodyCheckin,
          $$BodyCheckinsTableFilterComposer,
          $$BodyCheckinsTableOrderingComposer,
          $$BodyCheckinsTableAnnotationComposer,
          $$BodyCheckinsTableCreateCompanionBuilder,
          $$BodyCheckinsTableUpdateCompanionBuilder,
          (BodyCheckin, $$BodyCheckinsTableReferences),
          BodyCheckin,
          PrefetchHooks Function({bool bodyValuesRefs, bool bodyPhotosRefs})
        > {
  $$BodyCheckinsTableTableManager(_$AppDatabase db, $BodyCheckinsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyCheckinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyCheckinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyCheckinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyCheckinsCompanion(
                id: id,
                takenAt: takenAt,
                localDate: localDate,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                required String localDate,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyCheckinsCompanion.insert(
                id: id,
                takenAt: takenAt,
                localDate: localDate,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyCheckinsTable, BodyCheckin>(table),
                  $$BodyCheckinsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({bodyValuesRefs = false, bodyPhotosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bodyValuesRefs) db.bodyValues,
                    if (bodyPhotosRefs) db.bodyPhotos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bodyValuesRefs)
                        await $_getPrefetchedData<
                          BodyCheckin,
                          $BodyCheckinsTable,
                          BodyValue
                        >(
                          currentTable: table,
                          referencedTable: $$BodyCheckinsTableReferences
                              ._bodyValuesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BodyCheckinsTableReferences(
                                db,
                                table,
                                p0,
                              ).bodyValuesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.checkinId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bodyPhotosRefs)
                        await $_getPrefetchedData<
                          BodyCheckin,
                          $BodyCheckinsTable,
                          BodyPhoto
                        >(
                          currentTable: table,
                          referencedTable: $$BodyCheckinsTableReferences
                              ._bodyPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BodyCheckinsTableReferences(
                                db,
                                table,
                                p0,
                              ).bodyPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.checkinId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BodyCheckinsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyCheckinsTable,
      BodyCheckin,
      $$BodyCheckinsTableFilterComposer,
      $$BodyCheckinsTableOrderingComposer,
      $$BodyCheckinsTableAnnotationComposer,
      $$BodyCheckinsTableCreateCompanionBuilder,
      $$BodyCheckinsTableUpdateCompanionBuilder,
      (BodyCheckin, $$BodyCheckinsTableReferences),
      BodyCheckin,
      PrefetchHooks Function({bool bodyValuesRefs, bool bodyPhotosRefs})
    >;
typedef $$BodyValuesTableCreateCompanionBuilder = BodyValuesCompanion Function({
  Value<String> id,
  required String checkinId,
  required BodyMetric metric,
  required int valueMilli,
  Value<BodySource> source,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$BodyValuesTableUpdateCompanionBuilder = BodyValuesCompanion Function({
  Value<String> id,
  Value<String> checkinId,
  Value<BodyMetric> metric,
  Value<int> valueMilli,
  Value<BodySource> source,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$BodyValuesTableReferences
    extends BaseReferences<_$AppDatabase, $BodyValuesTable, BodyValue> {
  $$BodyValuesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BodyCheckinsTable _checkinIdTable(_$AppDatabase db) =>
      db.bodyCheckins.createAlias('body_values__checkin_id__body_checkins__id');

  $$BodyCheckinsTableProcessedTableManager get checkinId {
    final $_column = $_itemColumn<String>('checkin_id')!;

    final manager = $$BodyCheckinsTableTableManager(
      $_db,
      $_db.bodyCheckins,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_checkinIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BodyValuesTableFilterComposer
    extends Composer<_$AppDatabase, $BodyValuesTable> {
  $$BodyValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BodyMetric, BodyMetric, String> get metric =>
      $composableBuilder(
        column: $table.metric,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get valueMilli => $composableBuilder(
    column: $table.valueMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BodySource, BodySource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BodyCheckinsTableFilterComposer get checkinId {
    final $$BodyCheckinsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkinId,
      referencedTable: $db.bodyCheckins,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BodyCheckinsTableFilterComposer(
            $db: $db,
            $table: $db.bodyCheckins,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BodyValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyValuesTable> {
  $$BodyValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valueMilli => $composableBuilder(
    column: $table.valueMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BodyCheckinsTableOrderingComposer get checkinId {
    final $$BodyCheckinsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkinId,
      referencedTable: $db.bodyCheckins,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BodyCheckinsTableOrderingComposer(
            $db: $db,
            $table: $db.bodyCheckins,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BodyValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyValuesTable> {
  $$BodyValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BodyMetric, String> get metric =>
      $composableBuilder(column: $table.metric, builder: (column) => column);

  GeneratedColumn<int> get valueMilli => $composableBuilder(
    column: $table.valueMilli,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<BodySource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BodyCheckinsTableAnnotationComposer get checkinId {
    final $$BodyCheckinsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkinId,
      referencedTable: $db.bodyCheckins,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BodyCheckinsTableAnnotationComposer(
            $db: $db,
            $table: $db.bodyCheckins,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BodyValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyValuesTable,
          BodyValue,
          $$BodyValuesTableFilterComposer,
          $$BodyValuesTableOrderingComposer,
          $$BodyValuesTableAnnotationComposer,
          $$BodyValuesTableCreateCompanionBuilder,
          $$BodyValuesTableUpdateCompanionBuilder,
          (BodyValue, $$BodyValuesTableReferences),
          BodyValue,
          PrefetchHooks Function({bool checkinId})
        > {
  $$BodyValuesTableTableManager(_$AppDatabase db, $BodyValuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> checkinId = const Value.absent(),
                Value<BodyMetric> metric = const Value.absent(),
                Value<int> valueMilli = const Value.absent(),
                Value<BodySource> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyValuesCompanion(
                id: id,
                checkinId: checkinId,
                metric: metric,
                valueMilli: valueMilli,
                source: source,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String checkinId,
                required BodyMetric metric,
                required int valueMilli,
                Value<BodySource> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyValuesCompanion.insert(
                id: id,
                checkinId: checkinId,
                metric: metric,
                valueMilli: valueMilli,
                source: source,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyValuesTable, BodyValue>(table),
                  $$BodyValuesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({checkinId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (checkinId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.checkinId,
                        referencedTable: $$BodyValuesTableReferences
                            ._checkinIdTable(db),
                        referencedColumn: $$BodyValuesTableReferences
                            ._checkinIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BodyValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyValuesTable,
      BodyValue,
      $$BodyValuesTableFilterComposer,
      $$BodyValuesTableOrderingComposer,
      $$BodyValuesTableAnnotationComposer,
      $$BodyValuesTableCreateCompanionBuilder,
      $$BodyValuesTableUpdateCompanionBuilder,
      (BodyValue, $$BodyValuesTableReferences),
      BodyValue,
      PrefetchHooks Function({bool checkinId})
    >;
typedef $$BodyPhotosTableCreateCompanionBuilder = BodyPhotosCompanion Function({
  Value<String> id,
  required String checkinId,
  required PhotoPose pose,
  required String path,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$BodyPhotosTableUpdateCompanionBuilder = BodyPhotosCompanion Function({
  Value<String> id,
  Value<String> checkinId,
  Value<PhotoPose> pose,
  Value<String> path,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$BodyPhotosTableReferences
    extends BaseReferences<_$AppDatabase, $BodyPhotosTable, BodyPhoto> {
  $$BodyPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BodyCheckinsTable _checkinIdTable(_$AppDatabase db) =>
      db.bodyCheckins.createAlias('body_photos__checkin_id__body_checkins__id');

  $$BodyCheckinsTableProcessedTableManager get checkinId {
    final $_column = $_itemColumn<String>('checkin_id')!;

    final manager = $$BodyCheckinsTableTableManager(
      $_db,
      $_db.bodyCheckins,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_checkinIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BodyPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $BodyPhotosTable> {
  $$BodyPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PhotoPose, PhotoPose, String> get pose =>
      $composableBuilder(
        column: $table.pose,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BodyCheckinsTableFilterComposer get checkinId {
    final $$BodyCheckinsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkinId,
      referencedTable: $db.bodyCheckins,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BodyCheckinsTableFilterComposer(
            $db: $db,
            $table: $db.bodyCheckins,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BodyPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyPhotosTable> {
  $$BodyPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pose => $composableBuilder(
    column: $table.pose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BodyCheckinsTableOrderingComposer get checkinId {
    final $$BodyCheckinsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkinId,
      referencedTable: $db.bodyCheckins,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BodyCheckinsTableOrderingComposer(
            $db: $db,
            $table: $db.bodyCheckins,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BodyPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyPhotosTable> {
  $$BodyPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PhotoPose, String> get pose =>
      $composableBuilder(column: $table.pose, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BodyCheckinsTableAnnotationComposer get checkinId {
    final $$BodyCheckinsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checkinId,
      referencedTable: $db.bodyCheckins,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BodyCheckinsTableAnnotationComposer(
            $db: $db,
            $table: $db.bodyCheckins,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BodyPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyPhotosTable,
          BodyPhoto,
          $$BodyPhotosTableFilterComposer,
          $$BodyPhotosTableOrderingComposer,
          $$BodyPhotosTableAnnotationComposer,
          $$BodyPhotosTableCreateCompanionBuilder,
          $$BodyPhotosTableUpdateCompanionBuilder,
          (BodyPhoto, $$BodyPhotosTableReferences),
          BodyPhoto,
          PrefetchHooks Function({bool checkinId})
        > {
  $$BodyPhotosTableTableManager(_$AppDatabase db, $BodyPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> checkinId = const Value.absent(),
                Value<PhotoPose> pose = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyPhotosCompanion(
                id: id,
                checkinId: checkinId,
                pose: pose,
                path: path,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String checkinId,
                required PhotoPose pose,
                required String path,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BodyPhotosCompanion.insert(
                id: id,
                checkinId: checkinId,
                pose: pose,
                path: path,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BodyPhotosTable, BodyPhoto>(table),
                  $$BodyPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({checkinId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (checkinId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.checkinId,
                        referencedTable: $$BodyPhotosTableReferences
                            ._checkinIdTable(db),
                        referencedColumn: $$BodyPhotosTableReferences
                            ._checkinIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BodyPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyPhotosTable,
      BodyPhoto,
      $$BodyPhotosTableFilterComposer,
      $$BodyPhotosTableOrderingComposer,
      $$BodyPhotosTableAnnotationComposer,
      $$BodyPhotosTableCreateCompanionBuilder,
      $$BodyPhotosTableUpdateCompanionBuilder,
      (BodyPhoto, $$BodyPhotosTableReferences),
      BodyPhoto,
      PrefetchHooks Function({bool checkinId})
    >;
typedef $$AppPrefsTableCreateCompanionBuilder = AppPrefsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppPrefsTableUpdateCompanionBuilder = AppPrefsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppPrefsTableFilterComposer
    extends Composer<_$AppDatabase, $AppPrefsTable> {
  $$AppPrefsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppPrefsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppPrefsTable> {
  $$AppPrefsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppPrefsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppPrefsTable> {
  $$AppPrefsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppPrefsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppPrefsTable,
          AppPref,
          $$AppPrefsTableFilterComposer,
          $$AppPrefsTableOrderingComposer,
          $$AppPrefsTableAnnotationComposer,
          $$AppPrefsTableCreateCompanionBuilder,
          $$AppPrefsTableUpdateCompanionBuilder,
          (AppPref, BaseReferences<_$AppDatabase, $AppPrefsTable, AppPref>),
          AppPref,
          PrefetchHooks Function()
        > {
  $$AppPrefsTableTableManager(_$AppDatabase db, $AppPrefsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppPrefsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppPrefsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppPrefsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppPrefsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => AppPrefsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppPrefsTable, AppPref>(table),
                  BaseReferences<_$AppDatabase, $AppPrefsTable, AppPref>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppPrefsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppPrefsTable,
      AppPref,
      $$AppPrefsTableFilterComposer,
      $$AppPrefsTableOrderingComposer,
      $$AppPrefsTableAnnotationComposer,
      $$AppPrefsTableCreateCompanionBuilder,
      $$AppPrefsTableUpdateCompanionBuilder,
      (AppPref, BaseReferences<_$AppDatabase, $AppPrefsTable, AppPref>),
      AppPref,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  required String name,
  required String email,
  required String passwordHash,
  required String passwordSalt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> email,
  Value<String> passwordHash,
  Value<String> passwordSalt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordSalt => $composableBuilder(
    column: $table.passwordSalt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordSalt => $composableBuilder(
    column: $table.passwordSalt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get passwordSalt => $composableBuilder(
    column: $table.passwordSalt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          AppUser,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (AppUser, BaseReferences<_$AppDatabase, $UsersTable, AppUser>),
          AppUser,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> passwordSalt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                email: email,
                passwordHash: passwordHash,
                passwordSalt: passwordSalt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                required String email,
                required String passwordHash,
                required String passwordSalt,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                email: email,
                passwordHash: passwordHash,
                passwordSalt: passwordSalt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsersTable, AppUser>(table),
                  BaseReferences<_$AppDatabase, $UsersTable, AppUser>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      AppUser,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (AppUser, BaseReferences<_$AppDatabase, $UsersTable, AppUser>),
      AppUser,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GymsTableTableManager get gyms => $$GymsTableTableManager(_db, _db.gyms);
  $$EquipmentTableTableManager get equipment =>
      $$EquipmentTableTableManager(_db, _db.equipment);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$StationsTableTableManager get stations =>
      $$StationsTableTableManager(_db, _db.stations);
  $$StationSettingsTableTableManager get stationSettings =>
      $$StationSettingsTableTableManager(_db, _db.stationSettings);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$StationSettingChangesTableTableManager get stationSettingChanges =>
      $$StationSettingChangesTableTableManager(_db, _db.stationSettingChanges);
  $$RoutineExercisesTableTableManager get routineExercises =>
      $$RoutineExercisesTableTableManager(_db, _db.routineExercises);
  $$SessionExercisesTableTableManager get sessionExercises =>
      $$SessionExercisesTableTableManager(_db, _db.sessionExercises);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$BodyCheckinsTableTableManager get bodyCheckins =>
      $$BodyCheckinsTableTableManager(_db, _db.bodyCheckins);
  $$BodyValuesTableTableManager get bodyValues =>
      $$BodyValuesTableTableManager(_db, _db.bodyValues);
  $$BodyPhotosTableTableManager get bodyPhotos =>
      $$BodyPhotosTableTableManager(_db, _db.bodyPhotos);
  $$AppPrefsTableTableManager get appPrefs =>
      $$AppPrefsTableTableManager(_db, _db.appPrefs);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
}
