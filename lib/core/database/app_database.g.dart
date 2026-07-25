// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BusinessesTable extends Businesses
    with TableInfo<$BusinessesTable, BusinessesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, ownerId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'businesses';
  @override
  VerificationContext validateIntegrity(
    Insertable<BusinessesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessesData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BusinessesTable createAlias(String alias) {
    return $BusinessesTable(attachedDatabase, alias);
  }
}

class BusinessesData extends DataClass implements Insertable<BusinessesData> {
  final String id;
  final String name;
  final String ownerId;
  final DateTime createdAt;
  const BusinessesData({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['owner_id'] = Variable<String>(ownerId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BusinessesCompanion toCompanion(bool nullToAbsent) {
    return BusinessesCompanion(
      id: Value(id),
      name: Value(name),
      ownerId: Value(ownerId),
      createdAt: Value(createdAt),
    );
  }

  factory BusinessesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessesData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'ownerId': serializer.toJson<String>(ownerId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BusinessesData copyWith({
    String? id,
    String? name,
    String? ownerId,
    DateTime? createdAt,
  }) => BusinessesData(
    id: id ?? this.id,
    name: name ?? this.name,
    ownerId: ownerId ?? this.ownerId,
    createdAt: createdAt ?? this.createdAt,
  );
  BusinessesData copyWithCompanion(BusinessesCompanion data) {
    return BusinessesData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessesData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, ownerId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessesData &&
          other.id == this.id &&
          other.name == this.name &&
          other.ownerId == this.ownerId &&
          other.createdAt == this.createdAt);
}

class BusinessesCompanion extends UpdateCompanion<BusinessesData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> ownerId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BusinessesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BusinessesCompanion.insert({
    required String id,
    required String name,
    required String ownerId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       ownerId = Value(ownerId),
       createdAt = Value(createdAt);
  static Insertable<BusinessesData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? ownerId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (ownerId != null) 'owner_id': ownerId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BusinessesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? ownerId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BusinessesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
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
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
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
    return (StringBuffer('BusinessesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('ownerId: $ownerId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BranchesTable extends Branches with TableInfo<$BranchesTable, Branche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BranchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessIdMeta = const VerificationMeta(
    'businessId',
  );
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
    'business_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, businessId, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'branches';
  @override
  VerificationContext validateIntegrity(
    Insertable<Branche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
        _businessIdMeta,
        businessId.isAcceptableOrUnknown(data['business_id']!, _businessIdMeta),
      );
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Branche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Branche(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      businessId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BranchesTable createAlias(String alias) {
    return $BranchesTable(attachedDatabase, alias);
  }
}

class Branche extends DataClass implements Insertable<Branche> {
  final String id;
  final String businessId;
  final String name;
  final DateTime createdAt;
  const Branche({
    required this.id,
    required this.businessId,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BranchesCompanion toCompanion(bool nullToAbsent) {
    return BranchesCompanion(
      id: Value(id),
      businessId: Value(businessId),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Branche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Branche(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Branche copyWith({
    String? id,
    String? businessId,
    String? name,
    DateTime? createdAt,
  }) => Branche(
    id: id ?? this.id,
    businessId: businessId ?? this.businessId,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
  );
  Branche copyWithCompanion(BranchesCompanion data) {
    return Branche(
      id: data.id.present ? data.id.value : this.id,
      businessId: data.businessId.present
          ? data.businessId.value
          : this.businessId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Branche(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, businessId, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Branche &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class BranchesCompanion extends UpdateCompanion<Branche> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BranchesCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BranchesCompanion.insert({
    required String id,
    required String businessId,
    required String name,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       businessId = Value(businessId),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Branche> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BranchesCompanion copyWith({
    Value<String>? id,
    Value<String>? businessId,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BranchesCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
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
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
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
    return (StringBuffer('BranchesCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TillsTable extends Tills with TableInfo<$TillsTable, Till> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TillsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchIdMeta = const VerificationMeta(
    'branchId',
  );
  @override
  late final GeneratedColumn<String> branchId = GeneratedColumn<String>(
    'branch_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _networkMeta = const VerificationMeta(
    'network',
  );
  @override
  late final GeneratedColumn<String> network = GeneratedColumn<String>(
    'network',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    branchId,
    name,
    phoneNumber,
    network,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tills';
  @override
  VerificationContext validateIntegrity(
    Insertable<Till> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(
        _branchIdMeta,
        branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_branchIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('network')) {
      context.handle(
        _networkMeta,
        network.isAcceptableOrUnknown(data['network']!, _networkMeta),
      );
    } else if (isInserting) {
      context.missing(_networkMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Till map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Till(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      branchId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      network: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TillsTable createAlias(String alias) {
    return $TillsTable(attachedDatabase, alias);
  }
}

class Till extends DataClass implements Insertable<Till> {
  final String id;
  final String branchId;
  final String name;
  final String phoneNumber;
  final String network;
  final String status;
  final DateTime createdAt;
  const Till({
    required this.id,
    required this.branchId,
    required this.name,
    required this.phoneNumber,
    required this.network,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['branch_id'] = Variable<String>(branchId);
    map['name'] = Variable<String>(name);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['network'] = Variable<String>(network);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TillsCompanion toCompanion(bool nullToAbsent) {
    return TillsCompanion(
      id: Value(id),
      branchId: Value(branchId),
      name: Value(name),
      phoneNumber: Value(phoneNumber),
      network: Value(network),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory Till.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Till(
      id: serializer.fromJson<String>(json['id']),
      branchId: serializer.fromJson<String>(json['branchId']),
      name: serializer.fromJson<String>(json['name']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      network: serializer.fromJson<String>(json['network']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'branchId': serializer.toJson<String>(branchId),
      'name': serializer.toJson<String>(name),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'network': serializer.toJson<String>(network),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Till copyWith({
    String? id,
    String? branchId,
    String? name,
    String? phoneNumber,
    String? network,
    String? status,
    DateTime? createdAt,
  }) => Till(
    id: id ?? this.id,
    branchId: branchId ?? this.branchId,
    name: name ?? this.name,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    network: network ?? this.network,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  Till copyWithCompanion(TillsCompanion data) {
    return Till(
      id: data.id.present ? data.id.value : this.id,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      name: data.name.present ? data.name.value : this.name,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      network: data.network.present ? data.network.value : this.network,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Till(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('network: $network, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, branchId, name, phoneNumber, network, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Till &&
          other.id == this.id &&
          other.branchId == this.branchId &&
          other.name == this.name &&
          other.phoneNumber == this.phoneNumber &&
          other.network == this.network &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class TillsCompanion extends UpdateCompanion<Till> {
  final Value<String> id;
  final Value<String> branchId;
  final Value<String> name;
  final Value<String> phoneNumber;
  final Value<String> network;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TillsCompanion({
    this.id = const Value.absent(),
    this.branchId = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.network = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TillsCompanion.insert({
    required String id,
    required String branchId,
    required String name,
    required String phoneNumber,
    required String network,
    required String status,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       branchId = Value(branchId),
       name = Value(name),
       phoneNumber = Value(phoneNumber),
       network = Value(network),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<Till> custom({
    Expression<String>? id,
    Expression<String>? branchId,
    Expression<String>? name,
    Expression<String>? phoneNumber,
    Expression<String>? network,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (branchId != null) 'branch_id': branchId,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (network != null) 'network': network,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TillsCompanion copyWith({
    Value<String>? id,
    Value<String>? branchId,
    Value<String>? name,
    Value<String>? phoneNumber,
    Value<String>? network,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TillsCompanion(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      network: network ?? this.network,
      status: status ?? this.status,
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
    if (branchId.present) {
      map['branch_id'] = Variable<String>(branchId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (network.present) {
      map['network'] = Variable<String>(network.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
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
    return (StringBuffer('TillsCompanion(')
          ..write('id: $id, ')
          ..write('branchId: $branchId, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('network: $network, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailySessionsTable extends DailySessions
    with TableInfo<$DailySessionsTable, DailySession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailySessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tillIdMeta = const VerificationMeta('tillId');
  @override
  late final GeneratedColumn<String> tillId = GeneratedColumn<String>(
    'till_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingCashMeta = const VerificationMeta(
    'openingCash',
  );
  @override
  late final GeneratedColumn<double> openingCash = GeneratedColumn<double>(
    'opening_cash',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingFloatMeta = const VerificationMeta(
    'openingFloat',
  );
  @override
  late final GeneratedColumn<double> openingFloat = GeneratedColumn<double>(
    'opening_float',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closingCashMeta = const VerificationMeta(
    'closingCash',
  );
  @override
  late final GeneratedColumn<double> closingCash = GeneratedColumn<double>(
    'closing_cash',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closingFloatMeta = const VerificationMeta(
    'closingFloat',
  );
  @override
  late final GeneratedColumn<double> closingFloat = GeneratedColumn<double>(
    'closing_float',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
    'opened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tillId,
    openingCash,
    openingFloat,
    closingCash,
    closingFloat,
    status,
    openedAt,
    closedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailySession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('till_id')) {
      context.handle(
        _tillIdMeta,
        tillId.isAcceptableOrUnknown(data['till_id']!, _tillIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tillIdMeta);
    }
    if (data.containsKey('opening_cash')) {
      context.handle(
        _openingCashMeta,
        openingCash.isAcceptableOrUnknown(
          data['opening_cash']!,
          _openingCashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingCashMeta);
    }
    if (data.containsKey('opening_float')) {
      context.handle(
        _openingFloatMeta,
        openingFloat.isAcceptableOrUnknown(
          data['opening_float']!,
          _openingFloatMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingFloatMeta);
    }
    if (data.containsKey('closing_cash')) {
      context.handle(
        _closingCashMeta,
        closingCash.isAcceptableOrUnknown(
          data['closing_cash']!,
          _closingCashMeta,
        ),
      );
    }
    if (data.containsKey('closing_float')) {
      context.handle(
        _closingFloatMeta,
        closingFloat.isAcceptableOrUnknown(
          data['closing_float']!,
          _closingFloatMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailySession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailySession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tillId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}till_id'],
      )!,
      openingCash: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}opening_cash'],
      )!,
      openingFloat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}opening_float'],
      )!,
      closingCash: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}closing_cash'],
      ),
      closingFloat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}closing_float'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      openedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}opened_at'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      ),
    );
  }

  @override
  $DailySessionsTable createAlias(String alias) {
    return $DailySessionsTable(attachedDatabase, alias);
  }
}

class DailySession extends DataClass implements Insertable<DailySession> {
  final String id;
  final String tillId;
  final double openingCash;
  final double openingFloat;
  final double? closingCash;
  final double? closingFloat;
  final String status;
  final DateTime openedAt;
  final DateTime? closedAt;
  const DailySession({
    required this.id,
    required this.tillId,
    required this.openingCash,
    required this.openingFloat,
    this.closingCash,
    this.closingFloat,
    required this.status,
    required this.openedAt,
    this.closedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['till_id'] = Variable<String>(tillId);
    map['opening_cash'] = Variable<double>(openingCash);
    map['opening_float'] = Variable<double>(openingFloat);
    if (!nullToAbsent || closingCash != null) {
      map['closing_cash'] = Variable<double>(closingCash);
    }
    if (!nullToAbsent || closingFloat != null) {
      map['closing_float'] = Variable<double>(closingFloat);
    }
    map['status'] = Variable<String>(status);
    map['opened_at'] = Variable<DateTime>(openedAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    return map;
  }

  DailySessionsCompanion toCompanion(bool nullToAbsent) {
    return DailySessionsCompanion(
      id: Value(id),
      tillId: Value(tillId),
      openingCash: Value(openingCash),
      openingFloat: Value(openingFloat),
      closingCash: closingCash == null && nullToAbsent
          ? const Value.absent()
          : Value(closingCash),
      closingFloat: closingFloat == null && nullToAbsent
          ? const Value.absent()
          : Value(closingFloat),
      status: Value(status),
      openedAt: Value(openedAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
    );
  }

  factory DailySession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailySession(
      id: serializer.fromJson<String>(json['id']),
      tillId: serializer.fromJson<String>(json['tillId']),
      openingCash: serializer.fromJson<double>(json['openingCash']),
      openingFloat: serializer.fromJson<double>(json['openingFloat']),
      closingCash: serializer.fromJson<double?>(json['closingCash']),
      closingFloat: serializer.fromJson<double?>(json['closingFloat']),
      status: serializer.fromJson<String>(json['status']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tillId': serializer.toJson<String>(tillId),
      'openingCash': serializer.toJson<double>(openingCash),
      'openingFloat': serializer.toJson<double>(openingFloat),
      'closingCash': serializer.toJson<double?>(closingCash),
      'closingFloat': serializer.toJson<double?>(closingFloat),
      'status': serializer.toJson<String>(status),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
    };
  }

  DailySession copyWith({
    String? id,
    String? tillId,
    double? openingCash,
    double? openingFloat,
    Value<double?> closingCash = const Value.absent(),
    Value<double?> closingFloat = const Value.absent(),
    String? status,
    DateTime? openedAt,
    Value<DateTime?> closedAt = const Value.absent(),
  }) => DailySession(
    id: id ?? this.id,
    tillId: tillId ?? this.tillId,
    openingCash: openingCash ?? this.openingCash,
    openingFloat: openingFloat ?? this.openingFloat,
    closingCash: closingCash.present ? closingCash.value : this.closingCash,
    closingFloat: closingFloat.present ? closingFloat.value : this.closingFloat,
    status: status ?? this.status,
    openedAt: openedAt ?? this.openedAt,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
  );
  DailySession copyWithCompanion(DailySessionsCompanion data) {
    return DailySession(
      id: data.id.present ? data.id.value : this.id,
      tillId: data.tillId.present ? data.tillId.value : this.tillId,
      openingCash: data.openingCash.present
          ? data.openingCash.value
          : this.openingCash,
      openingFloat: data.openingFloat.present
          ? data.openingFloat.value
          : this.openingFloat,
      closingCash: data.closingCash.present
          ? data.closingCash.value
          : this.closingCash,
      closingFloat: data.closingFloat.present
          ? data.closingFloat.value
          : this.closingFloat,
      status: data.status.present ? data.status.value : this.status,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailySession(')
          ..write('id: $id, ')
          ..write('tillId: $tillId, ')
          ..write('openingCash: $openingCash, ')
          ..write('openingFloat: $openingFloat, ')
          ..write('closingCash: $closingCash, ')
          ..write('closingFloat: $closingFloat, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tillId,
    openingCash,
    openingFloat,
    closingCash,
    closingFloat,
    status,
    openedAt,
    closedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailySession &&
          other.id == this.id &&
          other.tillId == this.tillId &&
          other.openingCash == this.openingCash &&
          other.openingFloat == this.openingFloat &&
          other.closingCash == this.closingCash &&
          other.closingFloat == this.closingFloat &&
          other.status == this.status &&
          other.openedAt == this.openedAt &&
          other.closedAt == this.closedAt);
}

class DailySessionsCompanion extends UpdateCompanion<DailySession> {
  final Value<String> id;
  final Value<String> tillId;
  final Value<double> openingCash;
  final Value<double> openingFloat;
  final Value<double?> closingCash;
  final Value<double?> closingFloat;
  final Value<String> status;
  final Value<DateTime> openedAt;
  final Value<DateTime?> closedAt;
  final Value<int> rowid;
  const DailySessionsCompanion({
    this.id = const Value.absent(),
    this.tillId = const Value.absent(),
    this.openingCash = const Value.absent(),
    this.openingFloat = const Value.absent(),
    this.closingCash = const Value.absent(),
    this.closingFloat = const Value.absent(),
    this.status = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailySessionsCompanion.insert({
    required String id,
    required String tillId,
    required double openingCash,
    required double openingFloat,
    this.closingCash = const Value.absent(),
    this.closingFloat = const Value.absent(),
    required String status,
    required DateTime openedAt,
    this.closedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tillId = Value(tillId),
       openingCash = Value(openingCash),
       openingFloat = Value(openingFloat),
       status = Value(status),
       openedAt = Value(openedAt);
  static Insertable<DailySession> custom({
    Expression<String>? id,
    Expression<String>? tillId,
    Expression<double>? openingCash,
    Expression<double>? openingFloat,
    Expression<double>? closingCash,
    Expression<double>? closingFloat,
    Expression<String>? status,
    Expression<DateTime>? openedAt,
    Expression<DateTime>? closedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tillId != null) 'till_id': tillId,
      if (openingCash != null) 'opening_cash': openingCash,
      if (openingFloat != null) 'opening_float': openingFloat,
      if (closingCash != null) 'closing_cash': closingCash,
      if (closingFloat != null) 'closing_float': closingFloat,
      if (status != null) 'status': status,
      if (openedAt != null) 'opened_at': openedAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailySessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? tillId,
    Value<double>? openingCash,
    Value<double>? openingFloat,
    Value<double?>? closingCash,
    Value<double?>? closingFloat,
    Value<String>? status,
    Value<DateTime>? openedAt,
    Value<DateTime?>? closedAt,
    Value<int>? rowid,
  }) {
    return DailySessionsCompanion(
      id: id ?? this.id,
      tillId: tillId ?? this.tillId,
      openingCash: openingCash ?? this.openingCash,
      openingFloat: openingFloat ?? this.openingFloat,
      closingCash: closingCash ?? this.closingCash,
      closingFloat: closingFloat ?? this.closingFloat,
      status: status ?? this.status,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tillId.present) {
      map['till_id'] = Variable<String>(tillId.value);
    }
    if (openingCash.present) {
      map['opening_cash'] = Variable<double>(openingCash.value);
    }
    if (openingFloat.present) {
      map['opening_float'] = Variable<double>(openingFloat.value);
    }
    if (closingCash.present) {
      map['closing_cash'] = Variable<double>(closingCash.value);
    }
    if (closingFloat.present) {
      map['closing_float'] = Variable<double>(closingFloat.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailySessionsCompanion(')
          ..write('id: $id, ')
          ..write('tillId: $tillId, ')
          ..write('openingCash: $openingCash, ')
          ..write('openingFloat: $openingFloat, ')
          ..write('closingCash: $closingCash, ')
          ..write('closingFloat: $closingFloat, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProviderTransactionsTable extends ProviderTransactions
    with TableInfo<$ProviderTransactionsTable, ProviderTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProviderTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tillIdMeta = const VerificationMeta('tillId');
  @override
  late final GeneratedColumn<String> tillId = GeneratedColumn<String>(
    'till_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerReferenceMeta = const VerificationMeta(
    'providerReference',
  );
  @override
  late final GeneratedColumn<String> providerReference =
      GeneratedColumn<String>(
        'provider_reference',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _networkMeta = const VerificationMeta(
    'network',
  );
  @override
  late final GeneratedColumn<String> network = GeneratedColumn<String>(
    'network',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _smsBodyMeta = const VerificationMeta(
    'smsBody',
  );
  @override
  late final GeneratedColumn<String> smsBody = GeneratedColumn<String>(
    'sms_body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedAtMeta = const VerificationMeta(
    'receivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
    'received_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tillId,
    providerReference,
    network,
    type,
    amount,
    smsBody,
    status,
    receivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'provider_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProviderTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('till_id')) {
      context.handle(
        _tillIdMeta,
        tillId.isAcceptableOrUnknown(data['till_id']!, _tillIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tillIdMeta);
    }
    if (data.containsKey('provider_reference')) {
      context.handle(
        _providerReferenceMeta,
        providerReference.isAcceptableOrUnknown(
          data['provider_reference']!,
          _providerReferenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerReferenceMeta);
    }
    if (data.containsKey('network')) {
      context.handle(
        _networkMeta,
        network.isAcceptableOrUnknown(data['network']!, _networkMeta),
      );
    } else if (isInserting) {
      context.missing(_networkMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('sms_body')) {
      context.handle(
        _smsBodyMeta,
        smsBody.isAcceptableOrUnknown(data['sms_body']!, _smsBodyMeta),
      );
    } else if (isInserting) {
      context.missing(_smsBodyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
        _receivedAtMeta,
        receivedAt.isAcceptableOrUnknown(data['received_at']!, _receivedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProviderTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProviderTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tillId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}till_id'],
      )!,
      providerReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_reference'],
      )!,
      network: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}network'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      smsBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sms_body'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      receivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}received_at'],
      )!,
    );
  }

  @override
  $ProviderTransactionsTable createAlias(String alias) {
    return $ProviderTransactionsTable(attachedDatabase, alias);
  }
}

class ProviderTransaction extends DataClass
    implements Insertable<ProviderTransaction> {
  final String id;
  final String tillId;
  final String providerReference;
  final String network;
  final String type;
  final double amount;
  final String smsBody;
  final String status;
  final DateTime receivedAt;
  const ProviderTransaction({
    required this.id,
    required this.tillId,
    required this.providerReference,
    required this.network,
    required this.type,
    required this.amount,
    required this.smsBody,
    required this.status,
    required this.receivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['till_id'] = Variable<String>(tillId);
    map['provider_reference'] = Variable<String>(providerReference);
    map['network'] = Variable<String>(network);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['sms_body'] = Variable<String>(smsBody);
    map['status'] = Variable<String>(status);
    map['received_at'] = Variable<DateTime>(receivedAt);
    return map;
  }

  ProviderTransactionsCompanion toCompanion(bool nullToAbsent) {
    return ProviderTransactionsCompanion(
      id: Value(id),
      tillId: Value(tillId),
      providerReference: Value(providerReference),
      network: Value(network),
      type: Value(type),
      amount: Value(amount),
      smsBody: Value(smsBody),
      status: Value(status),
      receivedAt: Value(receivedAt),
    );
  }

  factory ProviderTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProviderTransaction(
      id: serializer.fromJson<String>(json['id']),
      tillId: serializer.fromJson<String>(json['tillId']),
      providerReference: serializer.fromJson<String>(json['providerReference']),
      network: serializer.fromJson<String>(json['network']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      smsBody: serializer.fromJson<String>(json['smsBody']),
      status: serializer.fromJson<String>(json['status']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tillId': serializer.toJson<String>(tillId),
      'providerReference': serializer.toJson<String>(providerReference),
      'network': serializer.toJson<String>(network),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'smsBody': serializer.toJson<String>(smsBody),
      'status': serializer.toJson<String>(status),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
    };
  }

  ProviderTransaction copyWith({
    String? id,
    String? tillId,
    String? providerReference,
    String? network,
    String? type,
    double? amount,
    String? smsBody,
    String? status,
    DateTime? receivedAt,
  }) => ProviderTransaction(
    id: id ?? this.id,
    tillId: tillId ?? this.tillId,
    providerReference: providerReference ?? this.providerReference,
    network: network ?? this.network,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    smsBody: smsBody ?? this.smsBody,
    status: status ?? this.status,
    receivedAt: receivedAt ?? this.receivedAt,
  );
  ProviderTransaction copyWithCompanion(ProviderTransactionsCompanion data) {
    return ProviderTransaction(
      id: data.id.present ? data.id.value : this.id,
      tillId: data.tillId.present ? data.tillId.value : this.tillId,
      providerReference: data.providerReference.present
          ? data.providerReference.value
          : this.providerReference,
      network: data.network.present ? data.network.value : this.network,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      smsBody: data.smsBody.present ? data.smsBody.value : this.smsBody,
      status: data.status.present ? data.status.value : this.status,
      receivedAt: data.receivedAt.present
          ? data.receivedAt.value
          : this.receivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProviderTransaction(')
          ..write('id: $id, ')
          ..write('tillId: $tillId, ')
          ..write('providerReference: $providerReference, ')
          ..write('network: $network, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('smsBody: $smsBody, ')
          ..write('status: $status, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tillId,
    providerReference,
    network,
    type,
    amount,
    smsBody,
    status,
    receivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProviderTransaction &&
          other.id == this.id &&
          other.tillId == this.tillId &&
          other.providerReference == this.providerReference &&
          other.network == this.network &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.smsBody == this.smsBody &&
          other.status == this.status &&
          other.receivedAt == this.receivedAt);
}

class ProviderTransactionsCompanion
    extends UpdateCompanion<ProviderTransaction> {
  final Value<String> id;
  final Value<String> tillId;
  final Value<String> providerReference;
  final Value<String> network;
  final Value<String> type;
  final Value<double> amount;
  final Value<String> smsBody;
  final Value<String> status;
  final Value<DateTime> receivedAt;
  final Value<int> rowid;
  const ProviderTransactionsCompanion({
    this.id = const Value.absent(),
    this.tillId = const Value.absent(),
    this.providerReference = const Value.absent(),
    this.network = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.smsBody = const Value.absent(),
    this.status = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProviderTransactionsCompanion.insert({
    required String id,
    required String tillId,
    required String providerReference,
    required String network,
    required String type,
    required double amount,
    required String smsBody,
    required String status,
    required DateTime receivedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tillId = Value(tillId),
       providerReference = Value(providerReference),
       network = Value(network),
       type = Value(type),
       amount = Value(amount),
       smsBody = Value(smsBody),
       status = Value(status),
       receivedAt = Value(receivedAt);
  static Insertable<ProviderTransaction> custom({
    Expression<String>? id,
    Expression<String>? tillId,
    Expression<String>? providerReference,
    Expression<String>? network,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<String>? smsBody,
    Expression<String>? status,
    Expression<DateTime>? receivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tillId != null) 'till_id': tillId,
      if (providerReference != null) 'provider_reference': providerReference,
      if (network != null) 'network': network,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (smsBody != null) 'sms_body': smsBody,
      if (status != null) 'status': status,
      if (receivedAt != null) 'received_at': receivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProviderTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? tillId,
    Value<String>? providerReference,
    Value<String>? network,
    Value<String>? type,
    Value<double>? amount,
    Value<String>? smsBody,
    Value<String>? status,
    Value<DateTime>? receivedAt,
    Value<int>? rowid,
  }) {
    return ProviderTransactionsCompanion(
      id: id ?? this.id,
      tillId: tillId ?? this.tillId,
      providerReference: providerReference ?? this.providerReference,
      network: network ?? this.network,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      smsBody: smsBody ?? this.smsBody,
      status: status ?? this.status,
      receivedAt: receivedAt ?? this.receivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tillId.present) {
      map['till_id'] = Variable<String>(tillId.value);
    }
    if (providerReference.present) {
      map['provider_reference'] = Variable<String>(providerReference.value);
    }
    if (network.present) {
      map['network'] = Variable<String>(network.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (smsBody.present) {
      map['sms_body'] = Variable<String>(smsBody.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProviderTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('tillId: $tillId, ')
          ..write('providerReference: $providerReference, ')
          ..write('network: $network, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('smsBody: $smsBody, ')
          ..write('status: $status, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LedgerEventsTable extends LedgerEvents
    with TableInfo<$LedgerEventsTable, LedgerEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  );
  static const VerificationMeta _tillIdMeta = const VerificationMeta('tillId');
  @override
  late final GeneratedColumn<String> tillId = GeneratedColumn<String>(
    'till_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashDeltaMeta = const VerificationMeta(
    'cashDelta',
  );
  @override
  late final GeneratedColumn<double> cashDelta = GeneratedColumn<double>(
    'cash_delta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _floatDeltaMeta = const VerificationMeta(
    'floatDelta',
  );
  @override
  late final GeneratedColumn<double> floatDelta = GeneratedColumn<double>(
    'float_delta',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commissionDeltaMeta = const VerificationMeta(
    'commissionDelta',
  );
  @override
  late final GeneratedColumn<double> commissionDelta = GeneratedColumn<double>(
    'commission_delta',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    tillId,
    type,
    cashDelta,
    floatDelta,
    commissionDelta,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<LedgerEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('till_id')) {
      context.handle(
        _tillIdMeta,
        tillId.isAcceptableOrUnknown(data['till_id']!, _tillIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tillIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('cash_delta')) {
      context.handle(
        _cashDeltaMeta,
        cashDelta.isAcceptableOrUnknown(data['cash_delta']!, _cashDeltaMeta),
      );
    } else if (isInserting) {
      context.missing(_cashDeltaMeta);
    }
    if (data.containsKey('float_delta')) {
      context.handle(
        _floatDeltaMeta,
        floatDelta.isAcceptableOrUnknown(data['float_delta']!, _floatDeltaMeta),
      );
    } else if (isInserting) {
      context.missing(_floatDeltaMeta);
    }
    if (data.containsKey('commission_delta')) {
      context.handle(
        _commissionDeltaMeta,
        commissionDelta.isAcceptableOrUnknown(
          data['commission_delta']!,
          _commissionDeltaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_commissionDeltaMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      tillId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}till_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      cashDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cash_delta'],
      )!,
      floatDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}float_delta'],
      )!,
      commissionDelta: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}commission_delta'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $LedgerEventsTable createAlias(String alias) {
    return $LedgerEventsTable(attachedDatabase, alias);
  }
}

class LedgerEvent extends DataClass implements Insertable<LedgerEvent> {
  final String id;
  final String sessionId;
  final String tillId;
  final String type;
  final double cashDelta;
  final double floatDelta;
  final double commissionDelta;
  final DateTime createdAt;
  const LedgerEvent({
    required this.id,
    required this.sessionId,
    required this.tillId,
    required this.type,
    required this.cashDelta,
    required this.floatDelta,
    required this.commissionDelta,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['till_id'] = Variable<String>(tillId);
    map['type'] = Variable<String>(type);
    map['cash_delta'] = Variable<double>(cashDelta);
    map['float_delta'] = Variable<double>(floatDelta);
    map['commission_delta'] = Variable<double>(commissionDelta);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LedgerEventsCompanion toCompanion(bool nullToAbsent) {
    return LedgerEventsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      tillId: Value(tillId),
      type: Value(type),
      cashDelta: Value(cashDelta),
      floatDelta: Value(floatDelta),
      commissionDelta: Value(commissionDelta),
      createdAt: Value(createdAt),
    );
  }

  factory LedgerEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerEvent(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      tillId: serializer.fromJson<String>(json['tillId']),
      type: serializer.fromJson<String>(json['type']),
      cashDelta: serializer.fromJson<double>(json['cashDelta']),
      floatDelta: serializer.fromJson<double>(json['floatDelta']),
      commissionDelta: serializer.fromJson<double>(json['commissionDelta']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'tillId': serializer.toJson<String>(tillId),
      'type': serializer.toJson<String>(type),
      'cashDelta': serializer.toJson<double>(cashDelta),
      'floatDelta': serializer.toJson<double>(floatDelta),
      'commissionDelta': serializer.toJson<double>(commissionDelta),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LedgerEvent copyWith({
    String? id,
    String? sessionId,
    String? tillId,
    String? type,
    double? cashDelta,
    double? floatDelta,
    double? commissionDelta,
    DateTime? createdAt,
  }) => LedgerEvent(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    tillId: tillId ?? this.tillId,
    type: type ?? this.type,
    cashDelta: cashDelta ?? this.cashDelta,
    floatDelta: floatDelta ?? this.floatDelta,
    commissionDelta: commissionDelta ?? this.commissionDelta,
    createdAt: createdAt ?? this.createdAt,
  );
  LedgerEvent copyWithCompanion(LedgerEventsCompanion data) {
    return LedgerEvent(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      tillId: data.tillId.present ? data.tillId.value : this.tillId,
      type: data.type.present ? data.type.value : this.type,
      cashDelta: data.cashDelta.present ? data.cashDelta.value : this.cashDelta,
      floatDelta: data.floatDelta.present
          ? data.floatDelta.value
          : this.floatDelta,
      commissionDelta: data.commissionDelta.present
          ? data.commissionDelta.value
          : this.commissionDelta,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerEvent(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('tillId: $tillId, ')
          ..write('type: $type, ')
          ..write('cashDelta: $cashDelta, ')
          ..write('floatDelta: $floatDelta, ')
          ..write('commissionDelta: $commissionDelta, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    tillId,
    type,
    cashDelta,
    floatDelta,
    commissionDelta,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerEvent &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.tillId == this.tillId &&
          other.type == this.type &&
          other.cashDelta == this.cashDelta &&
          other.floatDelta == this.floatDelta &&
          other.commissionDelta == this.commissionDelta &&
          other.createdAt == this.createdAt);
}

class LedgerEventsCompanion extends UpdateCompanion<LedgerEvent> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> tillId;
  final Value<String> type;
  final Value<double> cashDelta;
  final Value<double> floatDelta;
  final Value<double> commissionDelta;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const LedgerEventsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.tillId = const Value.absent(),
    this.type = const Value.absent(),
    this.cashDelta = const Value.absent(),
    this.floatDelta = const Value.absent(),
    this.commissionDelta = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LedgerEventsCompanion.insert({
    required String id,
    required String sessionId,
    required String tillId,
    required String type,
    required double cashDelta,
    required double floatDelta,
    required double commissionDelta,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       tillId = Value(tillId),
       type = Value(type),
       cashDelta = Value(cashDelta),
       floatDelta = Value(floatDelta),
       commissionDelta = Value(commissionDelta),
       createdAt = Value(createdAt);
  static Insertable<LedgerEvent> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? tillId,
    Expression<String>? type,
    Expression<double>? cashDelta,
    Expression<double>? floatDelta,
    Expression<double>? commissionDelta,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (tillId != null) 'till_id': tillId,
      if (type != null) 'type': type,
      if (cashDelta != null) 'cash_delta': cashDelta,
      if (floatDelta != null) 'float_delta': floatDelta,
      if (commissionDelta != null) 'commission_delta': commissionDelta,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LedgerEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? tillId,
    Value<String>? type,
    Value<double>? cashDelta,
    Value<double>? floatDelta,
    Value<double>? commissionDelta,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return LedgerEventsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      tillId: tillId ?? this.tillId,
      type: type ?? this.type,
      cashDelta: cashDelta ?? this.cashDelta,
      floatDelta: floatDelta ?? this.floatDelta,
      commissionDelta: commissionDelta ?? this.commissionDelta,
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
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (tillId.present) {
      map['till_id'] = Variable<String>(tillId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (cashDelta.present) {
      map['cash_delta'] = Variable<double>(cashDelta.value);
    }
    if (floatDelta.present) {
      map['float_delta'] = Variable<double>(floatDelta.value);
    }
    if (commissionDelta.present) {
      map['commission_delta'] = Variable<double>(commissionDelta.value);
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
    return (StringBuffer('LedgerEventsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('tillId: $tillId, ')
          ..write('type: $type, ')
          ..write('cashDelta: $cashDelta, ')
          ..write('floatDelta: $floatDelta, ')
          ..write('commissionDelta: $commissionDelta, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BusinessesTable businesses = $BusinessesTable(this);
  late final $BranchesTable branches = $BranchesTable(this);
  late final $TillsTable tills = $TillsTable(this);
  late final $DailySessionsTable dailySessions = $DailySessionsTable(this);
  late final $ProviderTransactionsTable providerTransactions =
      $ProviderTransactionsTable(this);
  late final $LedgerEventsTable ledgerEvents = $LedgerEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    businesses,
    branches,
    tills,
    dailySessions,
    providerTransactions,
    ledgerEvents,
  ];
}

typedef $$BusinessesTableCreateCompanionBuilder =
    BusinessesCompanion Function({
      required String id,
      required String name,
      required String ownerId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BusinessesTableUpdateCompanionBuilder =
    BusinessesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> ownerId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BusinessesTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessesTable> {
  $$BusinessesTableFilterComposer({
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

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BusinessesTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessesTable> {
  $$BusinessesTableOrderingComposer({
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

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BusinessesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessesTable> {
  $$BusinessesTableAnnotationComposer({
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

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BusinessesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BusinessesTable,
          BusinessesData,
          $$BusinessesTableFilterComposer,
          $$BusinessesTableOrderingComposer,
          $$BusinessesTableAnnotationComposer,
          $$BusinessesTableCreateCompanionBuilder,
          $$BusinessesTableUpdateCompanionBuilder,
          (
            BusinessesData,
            BaseReferences<_$AppDatabase, $BusinessesTable, BusinessesData>,
          ),
          BusinessesData,
          PrefetchHooks Function()
        > {
  $$BusinessesTableTableManager(_$AppDatabase db, $BusinessesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BusinessesCompanion(
                id: id,
                name: name,
                ownerId: ownerId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String ownerId,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BusinessesCompanion.insert(
                id: id,
                name: name,
                ownerId: ownerId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BusinessesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BusinessesTable,
      BusinessesData,
      $$BusinessesTableFilterComposer,
      $$BusinessesTableOrderingComposer,
      $$BusinessesTableAnnotationComposer,
      $$BusinessesTableCreateCompanionBuilder,
      $$BusinessesTableUpdateCompanionBuilder,
      (
        BusinessesData,
        BaseReferences<_$AppDatabase, $BusinessesTable, BusinessesData>,
      ),
      BusinessesData,
      PrefetchHooks Function()
    >;
typedef $$BranchesTableCreateCompanionBuilder =
    BranchesCompanion Function({
      required String id,
      required String businessId,
      required String name,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BranchesTableUpdateCompanionBuilder =
    BranchesCompanion Function({
      Value<String> id,
      Value<String> businessId,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BranchesTableFilterComposer
    extends Composer<_$AppDatabase, $BranchesTable> {
  $$BranchesTableFilterComposer({
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

  ColumnFilters<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BranchesTableOrderingComposer
    extends Composer<_$AppDatabase, $BranchesTable> {
  $$BranchesTableOrderingComposer({
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

  ColumnOrderings<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BranchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BranchesTable> {
  $$BranchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
    column: $table.businessId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BranchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BranchesTable,
          Branche,
          $$BranchesTableFilterComposer,
          $$BranchesTableOrderingComposer,
          $$BranchesTableAnnotationComposer,
          $$BranchesTableCreateCompanionBuilder,
          $$BranchesTableUpdateCompanionBuilder,
          (Branche, BaseReferences<_$AppDatabase, $BranchesTable, Branche>),
          Branche,
          PrefetchHooks Function()
        > {
  $$BranchesTableTableManager(_$AppDatabase db, $BranchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BranchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BranchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BranchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> businessId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BranchesCompanion(
                id: id,
                businessId: businessId,
                name: name,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String businessId,
                required String name,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BranchesCompanion.insert(
                id: id,
                businessId: businessId,
                name: name,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BranchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BranchesTable,
      Branche,
      $$BranchesTableFilterComposer,
      $$BranchesTableOrderingComposer,
      $$BranchesTableAnnotationComposer,
      $$BranchesTableCreateCompanionBuilder,
      $$BranchesTableUpdateCompanionBuilder,
      (Branche, BaseReferences<_$AppDatabase, $BranchesTable, Branche>),
      Branche,
      PrefetchHooks Function()
    >;
typedef $$TillsTableCreateCompanionBuilder =
    TillsCompanion Function({
      required String id,
      required String branchId,
      required String name,
      required String phoneNumber,
      required String network,
      required String status,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TillsTableUpdateCompanionBuilder =
    TillsCompanion Function({
      Value<String> id,
      Value<String> branchId,
      Value<String> name,
      Value<String> phoneNumber,
      Value<String> network,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$TillsTableFilterComposer extends Composer<_$AppDatabase, $TillsTable> {
  $$TillsTableFilterComposer({
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

  ColumnFilters<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TillsTableOrderingComposer
    extends Composer<_$AppDatabase, $TillsTable> {
  $$TillsTableOrderingComposer({
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

  ColumnOrderings<String> get branchId => $composableBuilder(
    column: $table.branchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TillsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TillsTable> {
  $$TillsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get network =>
      $composableBuilder(column: $table.network, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TillsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TillsTable,
          Till,
          $$TillsTableFilterComposer,
          $$TillsTableOrderingComposer,
          $$TillsTableAnnotationComposer,
          $$TillsTableCreateCompanionBuilder,
          $$TillsTableUpdateCompanionBuilder,
          (Till, BaseReferences<_$AppDatabase, $TillsTable, Till>),
          Till,
          PrefetchHooks Function()
        > {
  $$TillsTableTableManager(_$AppDatabase db, $TillsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TillsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TillsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TillsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> branchId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> network = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TillsCompanion(
                id: id,
                branchId: branchId,
                name: name,
                phoneNumber: phoneNumber,
                network: network,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String branchId,
                required String name,
                required String phoneNumber,
                required String network,
                required String status,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TillsCompanion.insert(
                id: id,
                branchId: branchId,
                name: name,
                phoneNumber: phoneNumber,
                network: network,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TillsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TillsTable,
      Till,
      $$TillsTableFilterComposer,
      $$TillsTableOrderingComposer,
      $$TillsTableAnnotationComposer,
      $$TillsTableCreateCompanionBuilder,
      $$TillsTableUpdateCompanionBuilder,
      (Till, BaseReferences<_$AppDatabase, $TillsTable, Till>),
      Till,
      PrefetchHooks Function()
    >;
typedef $$DailySessionsTableCreateCompanionBuilder =
    DailySessionsCompanion Function({
      required String id,
      required String tillId,
      required double openingCash,
      required double openingFloat,
      Value<double?> closingCash,
      Value<double?> closingFloat,
      required String status,
      required DateTime openedAt,
      Value<DateTime?> closedAt,
      Value<int> rowid,
    });
typedef $$DailySessionsTableUpdateCompanionBuilder =
    DailySessionsCompanion Function({
      Value<String> id,
      Value<String> tillId,
      Value<double> openingCash,
      Value<double> openingFloat,
      Value<double?> closingCash,
      Value<double?> closingFloat,
      Value<String> status,
      Value<DateTime> openedAt,
      Value<DateTime?> closedAt,
      Value<int> rowid,
    });

class $$DailySessionsTableFilterComposer
    extends Composer<_$AppDatabase, $DailySessionsTable> {
  $$DailySessionsTableFilterComposer({
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

  ColumnFilters<String> get tillId => $composableBuilder(
    column: $table.tillId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get openingCash => $composableBuilder(
    column: $table.openingCash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get openingFloat => $composableBuilder(
    column: $table.openingFloat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get closingCash => $composableBuilder(
    column: $table.closingCash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get closingFloat => $composableBuilder(
    column: $table.closingFloat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailySessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailySessionsTable> {
  $$DailySessionsTableOrderingComposer({
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

  ColumnOrderings<String> get tillId => $composableBuilder(
    column: $table.tillId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get openingCash => $composableBuilder(
    column: $table.openingCash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get openingFloat => $composableBuilder(
    column: $table.openingFloat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get closingCash => $composableBuilder(
    column: $table.closingCash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get closingFloat => $composableBuilder(
    column: $table.closingFloat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailySessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailySessionsTable> {
  $$DailySessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tillId =>
      $composableBuilder(column: $table.tillId, builder: (column) => column);

  GeneratedColumn<double> get openingCash => $composableBuilder(
    column: $table.openingCash,
    builder: (column) => column,
  );

  GeneratedColumn<double> get openingFloat => $composableBuilder(
    column: $table.openingFloat,
    builder: (column) => column,
  );

  GeneratedColumn<double> get closingCash => $composableBuilder(
    column: $table.closingCash,
    builder: (column) => column,
  );

  GeneratedColumn<double> get closingFloat => $composableBuilder(
    column: $table.closingFloat,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);
}

class $$DailySessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailySessionsTable,
          DailySession,
          $$DailySessionsTableFilterComposer,
          $$DailySessionsTableOrderingComposer,
          $$DailySessionsTableAnnotationComposer,
          $$DailySessionsTableCreateCompanionBuilder,
          $$DailySessionsTableUpdateCompanionBuilder,
          (
            DailySession,
            BaseReferences<_$AppDatabase, $DailySessionsTable, DailySession>,
          ),
          DailySession,
          PrefetchHooks Function()
        > {
  $$DailySessionsTableTableManager(_$AppDatabase db, $DailySessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailySessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailySessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailySessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tillId = const Value.absent(),
                Value<double> openingCash = const Value.absent(),
                Value<double> openingFloat = const Value.absent(),
                Value<double?> closingCash = const Value.absent(),
                Value<double?> closingFloat = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> openedAt = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailySessionsCompanion(
                id: id,
                tillId: tillId,
                openingCash: openingCash,
                openingFloat: openingFloat,
                closingCash: closingCash,
                closingFloat: closingFloat,
                status: status,
                openedAt: openedAt,
                closedAt: closedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tillId,
                required double openingCash,
                required double openingFloat,
                Value<double?> closingCash = const Value.absent(),
                Value<double?> closingFloat = const Value.absent(),
                required String status,
                required DateTime openedAt,
                Value<DateTime?> closedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailySessionsCompanion.insert(
                id: id,
                tillId: tillId,
                openingCash: openingCash,
                openingFloat: openingFloat,
                closingCash: closingCash,
                closingFloat: closingFloat,
                status: status,
                openedAt: openedAt,
                closedAt: closedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailySessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailySessionsTable,
      DailySession,
      $$DailySessionsTableFilterComposer,
      $$DailySessionsTableOrderingComposer,
      $$DailySessionsTableAnnotationComposer,
      $$DailySessionsTableCreateCompanionBuilder,
      $$DailySessionsTableUpdateCompanionBuilder,
      (
        DailySession,
        BaseReferences<_$AppDatabase, $DailySessionsTable, DailySession>,
      ),
      DailySession,
      PrefetchHooks Function()
    >;
typedef $$ProviderTransactionsTableCreateCompanionBuilder =
    ProviderTransactionsCompanion Function({
      required String id,
      required String tillId,
      required String providerReference,
      required String network,
      required String type,
      required double amount,
      required String smsBody,
      required String status,
      required DateTime receivedAt,
      Value<int> rowid,
    });
typedef $$ProviderTransactionsTableUpdateCompanionBuilder =
    ProviderTransactionsCompanion Function({
      Value<String> id,
      Value<String> tillId,
      Value<String> providerReference,
      Value<String> network,
      Value<String> type,
      Value<double> amount,
      Value<String> smsBody,
      Value<String> status,
      Value<DateTime> receivedAt,
      Value<int> rowid,
    });

class $$ProviderTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $ProviderTransactionsTable> {
  $$ProviderTransactionsTableFilterComposer({
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

  ColumnFilters<String> get tillId => $composableBuilder(
    column: $table.tillId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerReference => $composableBuilder(
    column: $table.providerReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smsBody => $composableBuilder(
    column: $table.smsBody,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProviderTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProviderTransactionsTable> {
  $$ProviderTransactionsTableOrderingComposer({
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

  ColumnOrderings<String> get tillId => $composableBuilder(
    column: $table.tillId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerReference => $composableBuilder(
    column: $table.providerReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get network => $composableBuilder(
    column: $table.network,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smsBody => $composableBuilder(
    column: $table.smsBody,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProviderTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProviderTransactionsTable> {
  $$ProviderTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tillId =>
      $composableBuilder(column: $table.tillId, builder: (column) => column);

  GeneratedColumn<String> get providerReference => $composableBuilder(
    column: $table.providerReference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get network =>
      $composableBuilder(column: $table.network, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get smsBody =>
      $composableBuilder(column: $table.smsBody, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
    column: $table.receivedAt,
    builder: (column) => column,
  );
}

class $$ProviderTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProviderTransactionsTable,
          ProviderTransaction,
          $$ProviderTransactionsTableFilterComposer,
          $$ProviderTransactionsTableOrderingComposer,
          $$ProviderTransactionsTableAnnotationComposer,
          $$ProviderTransactionsTableCreateCompanionBuilder,
          $$ProviderTransactionsTableUpdateCompanionBuilder,
          (
            ProviderTransaction,
            BaseReferences<
              _$AppDatabase,
              $ProviderTransactionsTable,
              ProviderTransaction
            >,
          ),
          ProviderTransaction,
          PrefetchHooks Function()
        > {
  $$ProviderTransactionsTableTableManager(
    _$AppDatabase db,
    $ProviderTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProviderTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProviderTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProviderTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tillId = const Value.absent(),
                Value<String> providerReference = const Value.absent(),
                Value<String> network = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> smsBody = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> receivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProviderTransactionsCompanion(
                id: id,
                tillId: tillId,
                providerReference: providerReference,
                network: network,
                type: type,
                amount: amount,
                smsBody: smsBody,
                status: status,
                receivedAt: receivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tillId,
                required String providerReference,
                required String network,
                required String type,
                required double amount,
                required String smsBody,
                required String status,
                required DateTime receivedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProviderTransactionsCompanion.insert(
                id: id,
                tillId: tillId,
                providerReference: providerReference,
                network: network,
                type: type,
                amount: amount,
                smsBody: smsBody,
                status: status,
                receivedAt: receivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProviderTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProviderTransactionsTable,
      ProviderTransaction,
      $$ProviderTransactionsTableFilterComposer,
      $$ProviderTransactionsTableOrderingComposer,
      $$ProviderTransactionsTableAnnotationComposer,
      $$ProviderTransactionsTableCreateCompanionBuilder,
      $$ProviderTransactionsTableUpdateCompanionBuilder,
      (
        ProviderTransaction,
        BaseReferences<
          _$AppDatabase,
          $ProviderTransactionsTable,
          ProviderTransaction
        >,
      ),
      ProviderTransaction,
      PrefetchHooks Function()
    >;
typedef $$LedgerEventsTableCreateCompanionBuilder =
    LedgerEventsCompanion Function({
      required String id,
      required String sessionId,
      required String tillId,
      required String type,
      required double cashDelta,
      required double floatDelta,
      required double commissionDelta,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$LedgerEventsTableUpdateCompanionBuilder =
    LedgerEventsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> tillId,
      Value<String> type,
      Value<double> cashDelta,
      Value<double> floatDelta,
      Value<double> commissionDelta,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$LedgerEventsTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerEventsTable> {
  $$LedgerEventsTableFilterComposer({
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

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tillId => $composableBuilder(
    column: $table.tillId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cashDelta => $composableBuilder(
    column: $table.cashDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get floatDelta => $composableBuilder(
    column: $table.floatDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get commissionDelta => $composableBuilder(
    column: $table.commissionDelta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LedgerEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerEventsTable> {
  $$LedgerEventsTableOrderingComposer({
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

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tillId => $composableBuilder(
    column: $table.tillId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cashDelta => $composableBuilder(
    column: $table.cashDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get floatDelta => $composableBuilder(
    column: $table.floatDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get commissionDelta => $composableBuilder(
    column: $table.commissionDelta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LedgerEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerEventsTable> {
  $$LedgerEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get tillId =>
      $composableBuilder(column: $table.tillId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get cashDelta =>
      $composableBuilder(column: $table.cashDelta, builder: (column) => column);

  GeneratedColumn<double> get floatDelta => $composableBuilder(
    column: $table.floatDelta,
    builder: (column) => column,
  );

  GeneratedColumn<double> get commissionDelta => $composableBuilder(
    column: $table.commissionDelta,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LedgerEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LedgerEventsTable,
          LedgerEvent,
          $$LedgerEventsTableFilterComposer,
          $$LedgerEventsTableOrderingComposer,
          $$LedgerEventsTableAnnotationComposer,
          $$LedgerEventsTableCreateCompanionBuilder,
          $$LedgerEventsTableUpdateCompanionBuilder,
          (
            LedgerEvent,
            BaseReferences<_$AppDatabase, $LedgerEventsTable, LedgerEvent>,
          ),
          LedgerEvent,
          PrefetchHooks Function()
        > {
  $$LedgerEventsTableTableManager(_$AppDatabase db, $LedgerEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> tillId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> cashDelta = const Value.absent(),
                Value<double> floatDelta = const Value.absent(),
                Value<double> commissionDelta = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LedgerEventsCompanion(
                id: id,
                sessionId: sessionId,
                tillId: tillId,
                type: type,
                cashDelta: cashDelta,
                floatDelta: floatDelta,
                commissionDelta: commissionDelta,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String tillId,
                required String type,
                required double cashDelta,
                required double floatDelta,
                required double commissionDelta,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => LedgerEventsCompanion.insert(
                id: id,
                sessionId: sessionId,
                tillId: tillId,
                type: type,
                cashDelta: cashDelta,
                floatDelta: floatDelta,
                commissionDelta: commissionDelta,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LedgerEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LedgerEventsTable,
      LedgerEvent,
      $$LedgerEventsTableFilterComposer,
      $$LedgerEventsTableOrderingComposer,
      $$LedgerEventsTableAnnotationComposer,
      $$LedgerEventsTableCreateCompanionBuilder,
      $$LedgerEventsTableUpdateCompanionBuilder,
      (
        LedgerEvent,
        BaseReferences<_$AppDatabase, $LedgerEventsTable, LedgerEvent>,
      ),
      LedgerEvent,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BusinessesTableTableManager get businesses =>
      $$BusinessesTableTableManager(_db, _db.businesses);
  $$BranchesTableTableManager get branches =>
      $$BranchesTableTableManager(_db, _db.branches);
  $$TillsTableTableManager get tills =>
      $$TillsTableTableManager(_db, _db.tills);
  $$DailySessionsTableTableManager get dailySessions =>
      $$DailySessionsTableTableManager(_db, _db.dailySessions);
  $$ProviderTransactionsTableTableManager get providerTransactions =>
      $$ProviderTransactionsTableTableManager(_db, _db.providerTransactions);
  $$LedgerEventsTableTableManager get ledgerEvents =>
      $$LedgerEventsTableTableManager(_db, _db.ledgerEvents);
}
