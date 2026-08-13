import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/ledger_event_entity.dart';
import '../../domain/repository/ledger_event_repository.dart';

class LedgerEventRepositoryImpl implements LedgerEventRepository {
  LedgerEventRepositoryImpl(this.database);

  final AppDatabase database;

  @override
  Future<void> save(LedgerEventEntity event) {
    return database.ledgerEventDao.insertEvent(
      LedgerEventsCompanion.insert(
        id: event.id,
        sessionId: Value(event.sessionId),
        tillId: Value(event.tillId),
        type: event.type.name,
        cashDelta: event.cashDelta,
        floatDelta: event.floatDelta,
        commissionDelta: event.commissionDelta,
        createdAt: event.createdAt,
        providerTransactionId: Value(event.providerTransactionId),
        note: Value(event.note),
      ),
    );
  }

  @override
  Future<List<LedgerEventEntity>> getBySession(String sessionId) async {
    final rows = await database.ledgerEventDao.getBySession(sessionId);

    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<LedgerEventEntity>> getAll() async {
    final rows = await database.ledgerEventDao.getAll();

    return rows.map(_toEntity).toList();
  }

  LedgerEventEntity _toEntity(LedgerEvent row) {
    return LedgerEventEntity(
      id: row.id,
      sessionId: row.sessionId ?? '',
      tillId: row.tillId ?? '',
      type: LedgerEventType.values.byName(row.type),
      cashDelta: row.cashDelta,
      floatDelta: row.floatDelta,
      commissionDelta: row.commissionDelta,
      createdAt: row.createdAt,
      providerTransactionId: row.providerTransactionId,
      note: row.note,
    );
  }
}
