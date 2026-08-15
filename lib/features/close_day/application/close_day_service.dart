import '../../daily_session/domain/entities/daily_session_entity.dart';
import '../domain/models/close_day_result.dart';

abstract interface class CloseDayService {
  Future<CloseDayResult> closeDay({
    required DailySessionEntity session,
    required double actualCash,
    required double actualFloat,
    bool confirmDiscrepancy = false,
  });
}
