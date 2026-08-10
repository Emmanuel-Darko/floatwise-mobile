import 'package:drift/drift.dart';

import 'database_connection.dart';

import 'tables/businesses.dart';
import 'tables/branches.dart';
import 'tables/tills.dart';
import 'tables/daily_sessions.dart';
import 'tables/provider_transactions.dart';
import 'tables/ledger_events.dart';
import 'tables/raw_sms_messages.dart';
import 'dao/business_dao.dart';
import 'dao/branch_dao.dart';
import 'dao/till_dao.dart';
import 'dao/daily_session_dao.dart';
import 'dao/raw_sms_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Businesses,
    Branches,
    Tills,
    DailySessions,
    ProviderTransactions,
    LedgerEvents,
    RawSmsMessages,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  late final businessDao = BusinessDao(this);
  late final branchDao = BranchDao(this);
  late final tillDao = TillDao(this);
  late final dailySessionDao = DailySessionDao(this);
  late final rawSmsDao = RawSmsDao(this);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) => migrator.createAll(),
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.createTable(rawSmsMessages);
          }
        },
      );
}