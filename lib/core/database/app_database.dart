import 'package:drift/drift.dart';

import 'database_connection.dart';

import 'tables/businesses.dart';
import 'tables/branches.dart';
import 'tables/tills.dart';
import 'tables/daily_sessions.dart';
import 'tables/provider_transactions.dart';
import 'tables/ledger_events.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Businesses,
    Branches,
    Tills,
    DailySessions,
    ProviderTransactions,
    LedgerEvents,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}