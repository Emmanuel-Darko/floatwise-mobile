import 'package:drift/drift.dart';

class ProviderTransactions extends Table {
  TextColumn get id => text()();

  TextColumn get tillId => text().nullable()();

  TextColumn get sessionId => text().nullable()();

  TextColumn get network => text()();

  TextColumn get type => text()();

  RealColumn get amount => real()();

  DateTimeColumn get timestamp => dateTime()();

  TextColumn get status => text()();

  TextColumn get source => text()();

  TextColumn get phoneNumber => text().nullable()();

  TextColumn get reference => text().nullable()();

  TextColumn get rawSmsId => text().nullable()();

  RealColumn get balanceAfter => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
