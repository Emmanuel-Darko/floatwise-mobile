import 'package:drift/drift.dart';

import 'database_connection.dart';

import 'tables/businesses.dart';
import 'tables/branches.dart';
import 'tables/tills.dart';
import 'tables/daily_sessions.dart';
import 'tables/provider_transactions.dart';
import 'tables/ledger_events.dart';
import 'dao/business_dao.dart';
import 'dao/branch_dao.dart';
import 'dao/till_dao.dart';
import 'dao/daily_session_dao.dart';

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

  late final businessDao = BusinessDao(this);
  late final branchDao = BranchDao(this);
  late final tillDao = TillDao(this);
  late final dailySessionDao = DailySessionDao(this);

  @override
  int get schemaVersion => 1;
}