import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/daily_sessions.dart';

part 'daily_session_dao.g.dart';

@DriftAccessor(tables: [DailySessions])
class DailySessionDao extends DatabaseAccessor<AppDatabase>
    with _$DailySessionDaoMixin {
  DailySessionDao(super.db);

  Future<void> insertSession(
      DailySessionsCompanion session) {
    return into(dailySessions).insert(session);
  }

  Future<void> updateSession(
      DailySession session) {
    return update(dailySessions).replace(session);
  }

  Future<List<DailySession>> getSessions(
      String tillId) {
    return (select(dailySessions)
          ..where((tbl) => tbl.tillId.equals(tillId))
          ..orderBy([
            (tbl) => OrderingTerm.desc(tbl.openedAt),
          ]))
        .get();
  }

  Future<DailySession?> getActiveSession(
      String tillId) {
    return (select(dailySessions)
          ..where((tbl) =>
              tbl.tillId.equals(tillId) &
              tbl.status.equals('open')))
        .getSingleOrNull();
  }
}