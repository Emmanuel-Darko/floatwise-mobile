import '../../../daily_session/domain/entities/daily_session_entity.dart';
import '../../../daily_session/domain/repository/daily_session_repository.dart';
import '../../../reconciliation/application/reconciliation_service.dart';
import '../../../reconciliation/domain/models/reconciliation_result.dart';
import '../../application/close_day_service.dart';
import '../../domain/models/close_day_result.dart';

class CloseDayServiceImpl implements CloseDayService {
  CloseDayServiceImpl({
    required this._reconciliationService,
    required this._dailySessionRepository,
  });

  final ReconciliationService _reconciliationService;
  final DailySessionRepository _dailySessionRepository;

  @override
  Future<CloseDayResult> closeDay({
    required DailySessionEntity session,
    required double actualCash,
    required double actualFloat,
    bool confirmDiscrepancy = false,
  }) async {
    final reconciliation = await _reconciliationService.reconcile(
      session: session,
      actualCash: actualCash,
      actualFloat: actualFloat,
    );

    final isBalanced = reconciliation.status == ReconciliationStatus.balanced;

    if (!isBalanced && !confirmDiscrepancy) {
      return CloseDayResult(
        outcome: CloseDayOutcome.needsConfirmation,
        reconciliation: reconciliation,
      );
    }

    final closedSession = DailySessionEntity(
      id: session.id,
      tillId: session.tillId,
      openingCash: session.openingCash,
      openingFloat: session.openingFloat,
      closingCash: actualCash,
      closingFloat: actualFloat,
      status: SessionStatus.closed,
      openedAt: session.openedAt,
      closedAt: DateTime.now(),
    );

    await _dailySessionRepository.closeSession(closedSession);

    return CloseDayResult(
      outcome: CloseDayOutcome.closed,
      reconciliation: reconciliation,
      closedSession: closedSession,
    );
  }
}
