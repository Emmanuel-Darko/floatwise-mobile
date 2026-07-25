import 'package:drift/drift.dart';

class ProviderTransactions extends Table {
  TextColumn get id => text()();

  TextColumn get tillId => text()();

  TextColumn get providerReference => text()();

  TextColumn get network => text()();

  TextColumn get type => text()();

  RealColumn get amount => real()();

  TextColumn get smsBody => text()();

  TextColumn get status => text()();

  DateTimeColumn get receivedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}