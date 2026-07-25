import 'package:drift/drift.dart';

class LedgerEvents extends Table {
  TextColumn get id => text()();

  TextColumn get sessionId => text()();

  TextColumn get tillId => text()();

  TextColumn get type => text()();

  RealColumn get cashDelta => real()();

  RealColumn get floatDelta => real()();

  RealColumn get commissionDelta => real()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}