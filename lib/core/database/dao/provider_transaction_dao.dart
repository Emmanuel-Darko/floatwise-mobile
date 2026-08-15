import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/provider_transactions.dart';

part 'provider_transaction_dao.g.dart';

@DriftAccessor(tables: [ProviderTransactions])
class ProviderTransactionDao extends DatabaseAccessor<AppDatabase>
    with _$ProviderTransactionDaoMixin {
  ProviderTransactionDao(super.db);

  Future<void> insertTransaction(ProviderTransactionsCompanion transaction) {
    return into(
      providerTransactions,
    ).insert(transaction, mode: InsertMode.insert);
  }

  Future<ProviderTransaction?> getById(String id) {
    return (select(providerTransactions)
          ..where((tbl) => tbl.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> updateStatus({required String id, required String status}) {
    return (update(providerTransactions)..where((tbl) => tbl.id.equals(id)))
        .write(ProviderTransactionsCompanion(status: Value(status)));
  }

  Future<ProviderTransaction?> getByReference(String reference) {
    return (select(providerTransactions)
          ..where((tbl) => tbl.reference.equals(reference))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<ProviderTransaction>> getBySession(String sessionId) {
    return (select(providerTransactions)
          ..where((tbl) => tbl.sessionId.equals(sessionId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.timestamp)]))
        .get();
  }

  Future<List<ProviderTransaction>> getAll() {
    return (select(
      providerTransactions,
    )..orderBy([(tbl) => OrderingTerm.desc(tbl.timestamp)])).get();
  }
}
