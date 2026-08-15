import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floatwise/core/database/app_database.dart';
import 'package:floatwise/features/close_day/data/services/close_day_service_impl.dart';
import 'package:floatwise/features/close_day/domain/models/close_day_result.dart';
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
  late CloseDayServiceImpl closeDayService;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    dailySessionRepository = DailySessionRepositoryImpl(database);
    transactionRepository = ProviderTransactionRepositoryImpl(database);
    ledgerEventRepository = LedgerEventRepositoryImpl(database);
    closeDayService = CloseDayServiceImpl(
      reconciliationService: ReconciliationServiceImpl(
        ledgerEventRepository: ledgerEventRepository,
        transactionRepository: transactionRepository,
      ),
      dailySessionRepository: dailySessionRepository,
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

  test(
    'closes a balanced session immediately and records counted balances',
    () async {
      final session = await openSession(id: 'session-1');
      await addLedgerEvent(
        sessionId: session.id,
        id: 'ev-1',
        type: LedgerEventType.deposit,
        cashDelta: 200,
        floatDelta: -200,
      );

      final result = await closeDayService.closeDay(
        session: session,
        actualCash: 1200,
        actualFloat: 800,
      );

      expect(result.outcome, CloseDayOutcome.closed);
      expect(result.closed, isTrue);
      expect(result.reconciliation.status, ReconciliationStatus.balanced);

      final active = await dailySessionRepository.getActiveSession('till-1');
      expect(active, isNull);

      final sessions = await dailySessionRepository.getSessions('till-1');
      expect(sessions, hasLength(1));
      expect(sessions.first.status, SessionStatus.closed);
      expect(sessions.first.closingCash, 1200);
      expect(sessions.first.closingFloat, 800);
      expect(sessions.first.closedAt, isNotNull);
    },
  );

  test(
    'does not close a short session until the discrepancy is confirmed',
    () async {
      final session = await openSession(id: 'session-2');
      await addLedgerEvent(
        sessionId: session.id,
        id: 'ev-2',
        type: LedgerEventType.deposit,
        cashDelta: 200,
        floatDelta: -200,
      );

      final result = await closeDayService.closeDay(
        session: session,
        actualCash: 1100,
        actualFloat: 800,
      );

      expect(result.outcome, CloseDayOutcome.needsConfirmation);
      expect(result.closed, isFalse);
      expect(result.reconciliation.status, ReconciliationStatus.short);
      expect(result.reconciliation.overallDifference, -100);

      final active = await dailySessionRepository.getActiveSession('till-1');
      expect(active, isNotNull);
    },
  );

  test('closes a short session when the discrepancy is confirmed', () async {
    final session = await openSession(id: 'session-3');
    await addLedgerEvent(
      sessionId: session.id,
      id: 'ev-3',
      type: LedgerEventType.deposit,
      cashDelta: 200,
      floatDelta: -200,
    );

    final result = await closeDayService.closeDay(
      session: session,
      actualCash: 1100,
      actualFloat: 800,
      confirmDiscrepancy: true,
    );

    expect(result.outcome, CloseDayOutcome.closed);
    expect(result.reconciliation.status, ReconciliationStatus.short);

    final active = await dailySessionRepository.getActiveSession('till-1');
    expect(active, isNull);
  });

  test('requires confirmation for an excess position', () async {
    final session = await openSession(id: 'session-4');
    await addLedgerEvent(
      sessionId: session.id,
      id: 'ev-4',
      type: LedgerEventType.deposit,
      cashDelta: 200,
      floatDelta: -200,
    );

    final result = await closeDayService.closeDay(
      session: session,
      actualCash: 1300,
      actualFloat: 800,
    );

    expect(result.outcome, CloseDayOutcome.needsConfirmation);
    expect(result.reconciliation.status, ReconciliationStatus.excess);
    expect(result.reconciliation.overallDifference, 100);

    final active = await dailySessionRepository.getActiveSession('till-1');
    expect(active, isNotNull);
  });

  test('requires confirmation when transactions still need review', () async {
    final session = await openSession(id: 'session-5');
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
      sessionId: session.id,
    );

    final result = await closeDayService.closeDay(
      session: session,
      actualCash: 1000,
      actualFloat: 1000,
    );

    expect(result.outcome, CloseDayOutcome.needsConfirmation);
    expect(result.reconciliation.status, ReconciliationStatus.unresolved);

    final active = await dailySessionRepository.getActiveSession('till-1');
    expect(active, isNotNull);
  });
}
