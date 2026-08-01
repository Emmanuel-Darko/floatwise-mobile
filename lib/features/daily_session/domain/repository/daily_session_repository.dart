import '../entities/daily_session_entity.dart';

abstract interface class DailySessionRepository {
  Future<void> openSession(DailySessionEntity session);

  Future<void> closeSession(DailySessionEntity session);

  Future<DailySessionEntity?> getActiveSession(String tillId);

  Future<List<DailySessionEntity>> getSessions(String tillId);
}
