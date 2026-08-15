import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floatwise/core/database/app_database.dart';
import 'package:floatwise/core/database/database_provider.dart';
import 'package:floatwise/features/branch/data/repository/branch_repository_impl.dart';
import 'package:floatwise/features/branch/domain/entities/branch_entity.dart';
import 'package:floatwise/features/business/data/repository/business_repository_impl.dart';
import 'package:floatwise/features/business/domain/entities/business_entity.dart';
import 'package:floatwise/features/daily_session/data/repository/daily_session_repository_impl.dart';
import 'package:floatwise/features/daily_session/domain/entities/daily_session_entity.dart';
import 'package:floatwise/features/dashboard/presentation/providers/dashboard_controller_provider.dart';
import 'package:floatwise/features/ledger/data/repository/ledger_event_repository_impl.dart';
import 'package:floatwise/features/settings/data/repository/app_config_repository_impl.dart';
import 'package:floatwise/features/settings/domain/entities/app_config_entity.dart';
import 'package:floatwise/features/settings/presentation/providers/app_config_repository_provider.dart';
import 'package:floatwise/features/sms/domain/entities/parsed_transaction.dart';
import 'package:floatwise/features/till/domain/entities/till_entity.dart';
import 'package:floatwise/features/till/domain/repository/till_repository_impl.dart';
import 'package:floatwise/features/transaction/data/repository/provider_transaction_repository_impl.dart';
import 'package:floatwise/features/transaction/data/services/transaction_posting_service_impl.dart';
import 'package:floatwise/shared/enums/mobile_network.dart';
import 'package:floatwise/shared/enums/till_status.dart';
import 'package:floatwise/shared/enums/transaction_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;
  late AppConfigRepositoryImpl appConfigRepository;
  late DailySessionRepositoryImpl dailySessionRepository;
  late ProviderTransactionRepositoryImpl transactionRepository;
  late LedgerEventRepositoryImpl ledgerEventRepository;
  late TransactionPostingServiceImpl postingService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    database = AppDatabase(NativeDatabase.memory());
    appConfigRepository = AppConfigRepositoryImpl(prefs);
    dailySessionRepository = DailySessionRepositoryImpl(database);
    transactionRepository = ProviderTransactionRepositoryImpl(database);
    ledgerEventRepository = LedgerEventRepositoryImpl(database);
    postingService = TransactionPostingServiceImpl(
      appConfigRepository: appConfigRepository,
      dailySessionRepository: dailySessionRepository,
      transactionRepository: transactionRepository,
      ledgerEventRepository: ledgerEventRepository,
    );

    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
        appConfigRepositoryProvider.overrideWith((ref) async {
          return appConfigRepository;
        }),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  Future<void> seedSetup() async {
    await appConfigRepository.saveConfig(
      const AppConfigEntity(
        hasCompletedSetup: true,
        currentBusinessId: 'business-1',
        currentBranchId: 'branch-1',
        currentTillId: 'till-1',
      ),
    );

    final businessRepository = BusinessRepositoryImpl(database);
    await businessRepository.create(
      BusinessEntity(
        id: 'business-1',
        name: 'Kode Ventures',
        ownerId: 'owner-1',
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    final branchRepository = BranchRepositoryImpl(database);
    await branchRepository.create(
      BranchEntity(
        id: 'branch-1',
        businessId: 'business-1',
        name: 'Main Branch',
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    final tillRepository = TillRepositoryImpl(database);
    await tillRepository.create(
      TillEntity(
        id: 'till-1',
        branchId: 'branch-1',
        name: 'Till 1',
        phoneNumber: '0241000000',
        network: MobileNetwork.mtn,
        status: TillStatus.active,
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    await dailySessionRepository.openSession(
      DailySessionEntity(
        id: 'session-1',
        tillId: 'till-1',
        openingCash: 500,
        openingFloat: 500,
        status: SessionStatus.open,
        openedAt: DateTime(2026, 8, 13, 8),
      ),
    );
  }

  ParsedTransaction parsed({
    required String id,
    required TransactionType type,
    double amount = 100,
    String? reference,
  }) {
    return ParsedTransaction(
      network: MobileNetwork.mtn,
      type: type,
      amount: amount,
      timestamp: DateTime(2026, 8, 13, 10),
      rawSmsId: id,
      reference: reference,
    );
  }

  test('exposes empty state when no session is active', () async {
    await appConfigRepository.saveConfig(
      const AppConfigEntity(
        hasCompletedSetup: true,
        currentBusinessId: null,
        currentBranchId: null,
        currentTillId: null,
      ),
    );

    final state = await container.read(dashboardControllerProvider.future);

    expect(state.session, isNull);
    expect(state.cash, 0);
    expect(state.floatBalance, 0);
    expect(state.recentTransactions, isEmpty);
  });

  test(
    'computes cash, float, summary, and recent activity from real data',
    () async {
      await seedSetup();

      await postingService.postTransactions([
        parsed(
          id: 'raw-1',
          type: TransactionType.cashIn,
          amount: 150,
          reference: 'REF-1',
        ),
        parsed(
          id: 'raw-2',
          type: TransactionType.cashOut,
          amount: 40,
          reference: 'REF-2',
        ),
        parsed(
          id: 'raw-3',
          type: TransactionType.transfer,
          amount: 20,
          reference: 'REF-3',
        ),
      ]);

      final state = await container.read(dashboardControllerProvider.future);

      expect(state.session?.id, 'session-1');
      expect(state.cash, 610);
      expect(state.floatBalance, 390);
      expect(state.deposits, 150);
      expect(state.withdrawals, 40);
      expect(state.totalValue, 210);
      expect(state.needsReviewCount, 1);
      expect(state.recentTransactions.length, 3);
    },
  );

  test(
    'ledger balances ignore transactions posted without a session',
    () async {
      await appConfigRepository.saveConfig(
        const AppConfigEntity(
          hasCompletedSetup: true,
          currentBusinessId: 'business-1',
          currentBranchId: 'branch-1',
          currentTillId: 'till-1',
        ),
      );

      final businessRepository = BusinessRepositoryImpl(database);
      await businessRepository.create(
        BusinessEntity(
          id: 'business-1',
          name: 'Kode Ventures',
          ownerId: 'owner-1',
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      final tillRepository = TillRepositoryImpl(database);
      await tillRepository.create(
        TillEntity(
          id: 'till-1',
          branchId: 'branch-1',
          name: 'Till 1',
          phoneNumber: '0241000000',
          network: MobileNetwork.mtn,
          status: TillStatus.active,
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      await postingService.postTransactions([
        parsed(
          id: 'raw-4',
          type: TransactionType.cashIn,
          amount: 100,
          reference: 'REF-4',
        ),
      ]);

      final state = await container.read(dashboardControllerProvider.future);

      expect(state.session, isNull);
      expect(state.cash, 0);
      expect(state.floatBalance, 0);
    },
  );
}
