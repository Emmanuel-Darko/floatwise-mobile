import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floatwise/core/database/app_database.dart';
import 'package:floatwise/features/daily_session/data/repository/daily_session_repository_impl.dart';
import 'package:floatwise/features/daily_session/domain/entities/daily_session_entity.dart';
import 'package:floatwise/features/ledger/data/repository/ledger_event_repository_impl.dart';
import 'package:floatwise/features/settings/data/repository/app_config_repository_impl.dart';
import 'package:floatwise/features/settings/domain/entities/app_config_entity.dart';
import 'package:floatwise/features/sms/domain/entities/parsed_transaction.dart';
import 'package:floatwise/features/transaction/data/repository/provider_transaction_repository_impl.dart';
import 'package:floatwise/features/transaction/data/services/transaction_posting_service_impl.dart';
import 'package:floatwise/shared/enums/mobile_network.dart';
import 'package:floatwise/shared/enums/transaction_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase database;
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
  });

  tearDown(() async {
    await database.close();
  });

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

  test('posts verified cash-in and cash-out to the ledger', () async {
    await appConfigRepository.saveConfig(
      const AppConfigEntity(
        hasCompletedSetup: true,
        currentBusinessId: 'b1',
        currentBranchId: 'br1',
        currentTillId: 'till-1',
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

    final result = await postingService.postTransactions([
      parsed(
        id: 'raw-1',
        type: TransactionType.cashIn,
        amount: 150,
        reference: 'REF-IN-1',
      ),
      parsed(
        id: 'raw-2',
        type: TransactionType.cashOut,
        amount: 80,
        reference: 'REF-OUT-1',
      ),
    ]);

    expect(result.processed, 2);
    expect(result.posted, 2);
    expect(result.needsReview, 0);
    expect(result.duplicates, 0);
    expect(result.hasActiveSession, isTrue);

    final transactions = await transactionRepository.getAll();
    expect(transactions.length, 2);
    expect(transactions.every((t) => t.status.name == 'verified'), isTrue);

    final events = await ledgerEventRepository.getAll();
    expect(events.length, 2);
    expect(events.first.cashDelta, 150);
    expect(events.first.floatDelta, -150);
    expect(events.last.cashDelta, -80);
    expect(events.last.floatDelta, 80);
  });

  test('flags non-cash types as needsReview without ledger events', () async {
    await appConfigRepository.saveConfig(
      const AppConfigEntity(
        hasCompletedSetup: true,
        currentBusinessId: 'b1',
        currentBranchId: 'br1',
        currentTillId: 'till-1',
      ),
    );
    await dailySessionRepository.openSession(
      DailySessionEntity(
        id: 'session-2',
        tillId: 'till-1',
        openingCash: 500,
        openingFloat: 500,
        status: SessionStatus.open,
        openedAt: DateTime(2026, 8, 13, 8),
      ),
    );

    final result = await postingService.postTransactions([
      parsed(id: 'raw-3', type: TransactionType.transfer, reference: 'REF-T-1'),
      parsed(id: 'raw-4', type: TransactionType.airtime, reference: 'REF-A-1'),
    ]);

    expect(result.posted, 0);
    expect(result.needsReview, 2);
    expect(result.hasActiveSession, isTrue);

    final transactions = await transactionRepository.getAll();
    expect(transactions.length, 2);
    expect(transactions.every((t) => t.status.name == 'needsReview'), isTrue);

    final events = await ledgerEventRepository.getAll();
    expect(events, isEmpty);
  });

  test('skips duplicate references', () async {
    await appConfigRepository.saveConfig(
      const AppConfigEntity(
        hasCompletedSetup: true,
        currentBusinessId: 'b1',
        currentBranchId: 'br1',
        currentTillId: 'till-1',
      ),
    );
    await dailySessionRepository.openSession(
      DailySessionEntity(
        id: 'session-3',
        tillId: 'till-1',
        openingCash: 500,
        openingFloat: 500,
        status: SessionStatus.open,
        openedAt: DateTime(2026, 8, 13, 8),
      ),
    );

    final first = await postingService.postTransactions([
      parsed(id: 'raw-5', type: TransactionType.cashIn, reference: 'REF-DUP'),
    ]);
    final second = await postingService.postTransactions([
      parsed(id: 'raw-6', type: TransactionType.cashIn, reference: 'REF-DUP'),
    ]);

    expect(first.posted, 1);
    expect(first.duplicates, 0);
    expect(second.posted, 0);
    expect(second.duplicates, 1);

    final transactions = await transactionRepository.getAll();
    expect(transactions.length, 1);
    final events = await ledgerEventRepository.getAll();
    expect(events.length, 1);
  });

  test(
    'saves verified transactions without a ledger event when no session is active',
    () async {
      await appConfigRepository.saveConfig(
        const AppConfigEntity(
          hasCompletedSetup: true,
          currentBusinessId: 'b1',
          currentBranchId: 'br1',
          currentTillId: 'till-1',
        ),
      );

      final result = await postingService.postTransactions([
        parsed(
          id: 'raw-7',
          type: TransactionType.cashIn,
          reference: 'REF-NO-SESSION',
        ),
      ]);

      expect(result.posted, 0);
      expect(result.needsReview, 1);
      expect(result.hasActiveSession, isFalse);

      final transactions = await transactionRepository.getAll();
      expect(transactions.length, 1);
      expect(transactions.first.status.name, 'verified');

      final events = await ledgerEventRepository.getAll();
      expect(events, isEmpty);
    },
  );
}
