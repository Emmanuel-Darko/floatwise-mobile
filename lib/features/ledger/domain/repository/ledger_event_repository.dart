import '../entities/ledger_event_entity.dart';

abstract interface class LedgerEventRepository {
  Future<void> save(LedgerEventEntity event);

  Future<List<LedgerEventEntity>> getBySession(String sessionId);

  Future<List<LedgerEventEntity>> getAll();
}
