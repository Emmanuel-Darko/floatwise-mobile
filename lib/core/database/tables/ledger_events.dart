import 'package:drift/drift.dart';

class LedgerEvents extends Table {
  TextColumn get id => text()();

  TextColumn get sessionId => text().nullable()();

  TextColumn get tillId => text().nullable()();

  TextColumn get type => text()();

  RealColumn get cashDelta => real()();

  RealColumn get floatDelta => real()();

  RealColumn get commissionDelta => real()();

  DateTimeColumn get createdAt => dateTime()();

  TextColumn get providerTransactionId => text().nullable()();

  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
