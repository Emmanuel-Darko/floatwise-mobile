import '../../daily_session/domain/entities/daily_session_entity.dart';
import '../domain/models/reconciliation_result.dart';

abstract interface class ReconciliationService {
  Future<ReconciliationResult> reconcile({
    required DailySessionEntity session,
    required double actualCash,
    required double actualFloat,
  });
}
