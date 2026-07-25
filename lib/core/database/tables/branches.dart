import 'package:drift/drift.dart';

class Branches extends Table {
  TextColumn get id => text()();

  TextColumn get businessId => text()();

  TextColumn get name => text()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}