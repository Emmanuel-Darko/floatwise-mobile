import '../../../daily_session/domain/entities/daily_session_entity.dart';
import '../../../reconciliation/domain/models/reconciliation_result.dart';

enum CloseDayOutcome { closed, needsConfirmation }

class CloseDayResult {
  const CloseDayResult({
    required this.outcome,
    required this.reconciliation,
    this.closedSession,
  });

  final CloseDayOutcome outcome;
  final ReconciliationResult reconciliation;
  final DailySessionEntity? closedSession;

  bool get closed => outcome == CloseDayOutcome.closed;
}
