import 'package:drift/drift.dart';

class DailySessions extends Table {
  TextColumn get id => text()();

  TextColumn get tillId => text()();

  RealColumn get openingCash => real()();

  RealColumn get openingFloat => real()();

  RealColumn get closingCash => real().nullable()();

  RealColumn get closingFloat => real().nullable()();

  TextColumn get status => text()();

  DateTimeColumn get openedAt => dateTime()();

  DateTimeColumn get closedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}