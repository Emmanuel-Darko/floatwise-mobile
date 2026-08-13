import 'package:drift/drift.dart';

class Businesses extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get ownerId => text()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
