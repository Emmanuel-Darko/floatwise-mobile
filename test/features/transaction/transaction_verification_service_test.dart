import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floatwise/core/database/app_database.dart';
import 'package:floatwise/features/daily_session/data/repository/daily_session_repository_impl.dart';
import 'package:floatwise/features/daily_session/domain/entities/daily_session_entity.dart';
import 'package:floatwise/features/ledger/data/repository/ledger_event_repository_impl.dart';
import 'package:floatwise/features/settings/data/repository/app_config_repository_impl.dart';
import 'package:floatwise/features/settings/domain/entities/app_config_entity.dart';
import 'package:floatwise/features/transaction/application/transaction_verification_service.dart';
import 'package:floatwise/features/transaction/data/repository/provider_transaction_repository_impl.dart';
import 'package:floatwise/features/transaction/data/services/transaction_verification_service_impl.dart';
import 'package:floatwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:floatwise/shared/enums/mobile_network.dart';
import 'package:floatwise/shared/enums/transaction_source.dart';
import 'package:floatwise/shared/enums/transaction_status.dart';
import 'package:floatwise/shared/enums/transaction_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase database;
  late AppConfigRepositoryImpl appConfigRepository;
  late DailySessionRepositoryImpl dailySessionRepository;
  late ProviderTransactionRepositoryImpl transactionRepository;
  late LedgerEventRepositoryImpl ledgerEventRepository;
  late TransactionVerificationServiceImpl verificationService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    database = AppDatabase(NativeDatabase.memory());
    appConfigRepository = AppConfigRepositoryImpl(prefs);
    dailySessionRepository = DailySessionRepositoryImpl(database);
    transactionRepository = ProviderTransactionRepositoryImpl(database);
    ledgerEventRepository = LedgerEventRepositoryImpl(database);
    verificationService = TransactionVerificationServiceImpl(
      appConfigRepository: appConfigRepository,
      dailySessionRepository: dailySessionRepository,
      transactionRepository: transactionRepository,
      ledgerEventRepository: ledgerEventRepository,
    );
  });

  tearDown(() async {
    await database.close();
  });

  Future<void> activeSetup(String sessionId, String tillId) async {
    await appConfigRepository.saveConfig(
      AppConfigEntity(
        hasCompletedSetup: true,
        currentBusinessId: 'b1',
        currentBranchId: 'br1',
        currentTillId: tillId,
      ),
    );
    await dailySessionRepository.openSession(
      DailySessionEntity(
        id: sessionId,
        tillId: tillId,
        openingCash: 500,
        openingFloat: 500,
        status: SessionStatus.open,
        openedAt: DateTime(2026, 8, 13, 8),
      ),
    );
  }

  TransactionEntity pendingTransaction(String id) {
    return TransactionEntity(
      id: id,
      network: MobileNetwork.mtn,
      type: TransactionType.transfer,
      amount: 100,
      timestamp: DateTime(2026, 8, 13, 10),
      status: TransactionStatus.needsReview,
      source: TransactionSource.sms,
      reference: 'REF-$id',
      rawSmsId: 'raw-$id',
    );
  }

  test('verifies as a deposit and writes a cash-in ledger event', () async {
    await activeSetup('session-1', 'till-1');
    await transactionRepository.save(pendingTransaction('tx-1'));

    final result = await verificationService.verify(
      transaction: pendingTransaction('tx-1'),
      effect: VerificationEffect.deposit,
    );

    expect(result.verified, isTrue);
    expect(result.ledgerEventWritten, isTrue);

    final stored = await transactionRepository.getById('tx-1');
    expect(stored!.status, TransactionStatus.verified);

    final events = await ledgerEventRepository.getAll();
    expect(events.length, 1);
    expect(events.first.cashDelta, 100);
    expect(events.first.floatDelta, -100);
    expect(events.first.providerTransactionId, 'tx-1');
    expect(events.first.sessionId, 'session-1');
  });

  test('verifies as a withdrawal and writes a cash-out ledger event', () async {
    await activeSetup('session-2', 'till-1');
    await transactionRepository.save(pendingTransaction('tx-2'));

    await verificationService.verify(
      transaction: pendingTransaction('tx-2'),
      effect: VerificationEffect.withdrawal,
    );

    final events = await ledgerEventRepository.getAll();
    expect(events.length, 1);
    expect(events.first.cashDelta, -100);
    expect(events.first.floatDelta, 100);
  });

  test('verifies as an expense with cash-only movement', () async {
    await activeSetup('session-3', 'till-1');
    await transactionRepository.save(pendingTransaction('tx-3'));

    await verificationService.verify(
      transaction: pendingTransaction('tx-3'),
      effect: VerificationEffect.expense,
    );

    final events = await ledgerEventRepository.getAll();
    expect(events.length, 1);
    expect(events.first.cashDelta, -100);
    expect(events.first.floatDelta, 0);
  });

  test('verifies as an adjustment with no cash or float movement', () async {
    await activeSetup('session-4', 'till-1');
    await transactionRepository.save(pendingTransaction('tx-4'));

    await verificationService.verify(
      transaction: pendingTransaction('tx-4'),
      effect: VerificationEffect.adjustment,
    );

    final events = await ledgerEventRepository.getAll();
    expect(events.length, 1);
    expect(events.first.cashDelta, 0);
    expect(events.first.floatDelta, 0);
  });

  test('rejects verification of an already-verified transaction', () async {
    await activeSetup('session-5', 'till-1');
    final transaction = pendingTransaction('tx-5');
    await transactionRepository.save(transaction);

    await expectLater(
      () => verificationService.verify(
        transaction: transaction.copyWith(status: TransactionStatus.verified),
        effect: VerificationEffect.deposit,
      ),
      throwsException,
    );

    final events = await ledgerEventRepository.getAll();
    expect(events, isEmpty);
  });

  test(
    'does not write a second ledger event on duplicate verification',
    () async {
      await activeSetup('session-6', 'till-1');
      await transactionRepository.save(pendingTransaction('tx-6'));

      final first = await verificationService.verify(
        transaction: pendingTransaction('tx-6'),
        effect: VerificationEffect.deposit,
      );
      expect(first.ledgerEventWritten, isTrue);

      await expectLater(
        () => verificationService.verify(
          transaction: pendingTransaction(
            'tx-6',
          ).copyWith(status: TransactionStatus.verified),
          effect: VerificationEffect.withdrawal,
        ),
        throwsException,
      );

      final events = await ledgerEventRepository.getAll();
      expect(events.length, 1);
    },
  );

  test(
    'marks verified without a ledger event when no session is active',
    () async {
      await appConfigRepository.saveConfig(
        const AppConfigEntity(
          hasCompletedSetup: true,
          currentBusinessId: 'b1',
          currentBranchId: 'br1',
          currentTillId: 'till-1',
        ),
      );
      await transactionRepository.save(pendingTransaction('tx-7'));

      final result = await verificationService.verify(
        transaction: pendingTransaction('tx-7'),
        effect: VerificationEffect.deposit,
      );

      expect(result.verified, isTrue);
      expect(result.ledgerEventWritten, isFalse);

      final stored = await transactionRepository.getById('tx-7');
      expect(stored!.status, TransactionStatus.verified);

      final events = await ledgerEventRepository.getAll();
      expect(events, isEmpty);
    },
  );
}
