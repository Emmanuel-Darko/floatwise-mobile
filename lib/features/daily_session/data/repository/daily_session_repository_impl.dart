import 'package:drift/drift.dart';

import '../../domain/entities/daily_session_entity.dart';
import '../../domain/repository/daily_session_repository.dart';

import '../../../../core/database/app_database.dart';

class DailySessionRepositoryImpl implements DailySessionRepository {
  DailySessionRepositoryImpl(this.database);

  final AppDatabase database;

  @override
  Future<void> openSession(DailySessionEntity session) async {
    final active = await database.dailySessionDao.getActiveSession(
      session.tillId,
    );

    if (active != null) {
      throw Exception('An active session already exists for this till.');
    }

    await database.dailySessionDao.insertSession(
      DailySessionsCompanion.insert(
        id: session.id,
        tillId: session.tillId,
        openingCash: session.openingCash,
        openingFloat: session.openingFloat,
        status: session.status.name,
        openedAt: session.openedAt,
      ),
    );
  }

  @override
  Future<void> closeSession(DailySessionEntity session) async {
    final active = await database.dailySessionDao.getActiveSession(
      session.tillId,
    );

    if (active == null) {
      throw Exception('No active session found for this till.');
    }

    await database.dailySessionDao.updateSession(
      active.copyWith(
        closingCash: Value(session.closingCash),
        closingFloat: Value(session.closingFloat),
        status: SessionStatus.closed.name,
        closedAt: Value(session.closedAt ?? DateTime.now()),
      ),
    );
  }

  @override
  Future<DailySessionEntity?> getActiveSession(String tillId) async {
    final row = await database.dailySessionDao.getActiveSession(tillId);

    if (row == null) return null;

    return DailySessionEntity(
      id: row.id,
      tillId: row.tillId,
      openingCash: row.openingCash,
      openingFloat: row.openingFloat,
      closingCash: row.closingCash,
      closingFloat: row.closingFloat,
      status: SessionStatus.values.byName(row.status),
      openedAt: row.openedAt,
      closedAt: row.closedAt,
    );
  }

  @override
  Future<List<DailySessionEntity>> getSessions(String tillId) async {
    final rows = await database.dailySessionDao.getSessions(tillId);

    return rows
        .map(
          (row) => DailySessionEntity(
            id: row.id,
            tillId: row.tillId,
            openingCash: row.openingCash,
            openingFloat: row.openingFloat,
            closingCash: row.closingCash,
            closingFloat: row.closingFloat,
            status: SessionStatus.values.byName(row.status),
            openedAt: row.openedAt,
            closedAt: row.closedAt,
          ),
        )
        .toList();
  }
}
