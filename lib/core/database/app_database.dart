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
import 'dao/raw_sms_message_dao.dart';
import 'dao/provider_transaction_dao.dart';
import 'dao/ledger_event_dao.dart';

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
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  late final businessDao = BusinessDao(this);
  late final branchDao = BranchDao(this);
  late final tillDao = TillDao(this);
  late final dailySessionDao = DailySessionDao(this);
  late final rawSmsMessageDao = RawSmsMessageDao(this);
  late final providerTransactionDao = ProviderTransactionDao(this);
  late final ledgerEventDao = LedgerEventDao(this);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(rawSmsMessages);
      }
      if (from < 3) {
        await migrator.deleteTable('provider_transactions');
        await migrator.createTable(providerTransactions);
        await migrator.deleteTable('ledger_events');
        await migrator.createTable(ledgerEvents);
      }
    },
  );
}
