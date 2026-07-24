import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// Transactions table for the local ledger
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'deposit', 'withdrawal', 'transfer'
  RealColumn get amount => real()();
  TextColumn get description => text().nullable()();
  TextColumn get reference => text().nullable()();
  TextColumn get customerName => text().nullable()();
  TextColumn get customerPhone => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

/// SMS logs table
class SmsLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sender => text()();
  TextColumn get body => text()();
  RealColumn get amount => real().nullable()();
  TextColumn get parsedType => text().nullable()();
  DateTimeColumn get receivedAt => dateTime()();
  BoolColumn get processed => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Transactions, SmsLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'floatwise.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
