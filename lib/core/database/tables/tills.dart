import 'package:drift/drift.dart';

class Tills extends Table {
  TextColumn get id => text()();

  TextColumn get branchId => text()();

  TextColumn get name => text()();

  TextColumn get phoneNumber => text()();

  TextColumn get network => text()();

  TextColumn get status => text()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}