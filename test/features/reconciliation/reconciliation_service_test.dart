import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floatwise/core/database/app_database.dart';
import 'package:floatwise/features/daily_session/data/repository/daily_session_repository_impl.dart';
import 'package:floatwise/features/daily_session/domain/entities/daily_session_entity.dart';
import 'package:floatwise/features/ledger/data/repository/ledger_event_repository_impl.dart';
import 'package:floatwise/features/ledger/domain/entities/ledger_event_entity.dart';
import 'package:floatwise/features/reconciliation/data/services/reconciliation_service_impl.dart';
import 'package:floatwise/features/reconciliation/domain/models/reconciliation_result.dart';
import 'package:floatwise/features/transaction/data/repository/provider_transaction_repository_impl.dart';
import 'package:floatwise/features/transaction/domain/entities/transaction_entity.dart';
import 'package:floatwise/shared/enums/mobile_network.dart';
import 'package:floatwise/shared/enums/transaction_source.dart';
import 'package:floatwise/shared/enums/transaction_status.dart';
import 'package:floatwise/shared/enums/transaction_type.dart';

void main() {
  late AppDatabase database;
  late DailySessionRepositoryImpl dailySessionRepository;
  late ProviderTransactionRepositoryImpl transactionRepository;
  late LedgerEventRepositoryImpl ledgerEventRepository;
  late ReconciliationServiceImpl reconcileService;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    dailySessionRepository = DailySessionRepositoryImpl(database);
    transactionRepository = ProviderTransactionRepositoryImpl(database);
    ledgerEventRepository = LedgerEventRepositoryImpl(database);
    reconcileService = ReconciliationServiceImpl(
      ledgerEventRepository: ledgerEventRepository,
      transactionRepository: transactionRepository,
    );
  });

  tearDown(() async {
    await database.close();
  });

  Future<DailySessionEntity> openSession({
    required String id,
    double openingCash = 1000,
    double openingFloat = 1000,
  }) async {
    final session = DailySessionEntity(
      id: id,
      tillId: 'till-1',
      openingCash: openingCash,
      openingFloat: openingFloat,
      status: SessionStatus.open,
      openedAt: DateTime(2026, 8, 13, 8),
    );
    await dailySessionRepository.openSession(session);
    return session;
  }

  Future<void> addLedgerEvent({
    required String sessionId,
    required String id,
    required LedgerEventType type,
    required double cashDelta,
    required double floatDelta,
  }) async {
    await ledgerEventRepository.save(
      LedgerEventEntity(
        id: id,
        sessionId: sessionId,
        tillId: 'till-1',
        type: type,
        cashDelta: cashDelta,
        floatDelta: floatDelta,
        commissionDelta: 0,
        createdAt: DateTime(2026, 8, 13, 9),
      ),
    );
  }

  Future<void> addNeedsReviewTransaction(String sessionId) async {
    await transactionRepository.save(
      TransactionEntity(
        id: 'txn-needs-review',
        network: MobileNetwork.mtn,
        type: TransactionType.transfer,
        amount: 100,
        timestamp: DateTime(2026, 8, 13, 9, 30),
        status: TransactionStatus.needsReview,
        source: TransactionSource.sms,
      ),
      tillId: 'till-1',
      sessionId: sessionId,
    );
  }

  test('reconciles a balanced session with deposits and withdrawals', () async {
    final session = await openSession(id: 'session-1');
    await addLedgerEvent(
      sessionId: session.id,
      id: 'ev-1',
      type: LedgerEventType.deposit,
      cashDelta: 200,
      floatDelta: -200,
    );
    await addLedgerEvent(
      sessionId: session.id,
      id: 'ev-2',
      type: LedgerEventType.withdrawal,
      cashDelta: -50,
      floatDelta: 50,
    );

    final result = await reconcileService.reconcile(
      session: session,
      actualCash: 1150,
      actualFloat: 850,
    );

    expect(result.expectedCash, 1150);
    expect(result.expectedFloat, 850);
    expect(result.cashDifference, 0);
    expect(result.floatDifference, 0);
    expect(result.overallDifference, 0);
    expect(result.status, ReconciliationStatus.balanced);
  });

  test('flags a short position when actual cash is below expected', () async {
    final session = await openSession(id: 'session-2');
    await addLedgerEvent(
      sessionId: session.id,
      id: 'ev-3',
      type: LedgerEventType.deposit,
      cashDelta: 200,
      floatDelta: -200,
    );

    final result = await reconcileService.reconcile(
      session: session,
      actualCash: 1100,
      actualFloat: 800,
    );

    expect(result.cashDifference, -100);
    expect(result.floatDifference, 0);
    expect(result.overallDifference, -100);
    expect(result.status, ReconciliationStatus.short);
  });

  test('flags an excess position when actual cash is above expected', () async {
    final session = await openSession(id: 'session-3');
    await addLedgerEvent(
      sessionId: session.id,
      id: 'ev-4',
      type: LedgerEventType.deposit,
      cashDelta: 200,
      floatDelta: -200,
    );

    final result = await reconcileService.reconcile(
      session: session,
      actualCash: 1300,
      actualFloat: 800,
    );

    expect(result.cashDifference, 100);
    expect(result.overallDifference, 100);
    expect(result.status, ReconciliationStatus.excess);
  });

  test(
    'marks a session as unresolved while transactions need review',
    () async {
      final session = await openSession(id: 'session-4');
      await addLedgerEvent(
        sessionId: session.id,
        id: 'ev-5',
        type: LedgerEventType.deposit,
        cashDelta: 200,
        floatDelta: -200,
      );
      await addNeedsReviewTransaction(session.id);

      final result = await reconcileService.reconcile(
        session: session,
        actualCash: 1200,
        actualFloat: 800,
      );

      expect(result.status, ReconciliationStatus.unresolved);
    },
  );

  test(
    'uses opening balances as expected values when no events exist',
    () async {
      final session = await openSession(id: 'session-5');

      final result = await reconcileService.reconcile(
        session: session,
        actualCash: 1000,
        actualFloat: 1000,
      );

      expect(result.expectedCash, 1000);
      expect(result.expectedFloat, 1000);
      expect(result.status, ReconciliationStatus.balanced);
    },
  );
}
