import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/ledger_events.dart';

part 'ledger_event_dao.g.dart';

@DriftAccessor(tables: [LedgerEvents])
class LedgerEventDao extends DatabaseAccessor<AppDatabase>
    with _$LedgerEventDaoMixin {
  LedgerEventDao(super.db);

  Future<void> insertEvent(LedgerEventsCompanion event) {
    return into(ledgerEvents).insert(event);
  }

  Future<List<LedgerEvent>> getBySession(String sessionId) {
    return (select(ledgerEvents)
          ..where((tbl) => tbl.sessionId.equals(sessionId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)]))
        .get();
  }

  Future<List<LedgerEvent>> getAll() {
    return (select(
      ledgerEvents,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)])).get();
  }
}
