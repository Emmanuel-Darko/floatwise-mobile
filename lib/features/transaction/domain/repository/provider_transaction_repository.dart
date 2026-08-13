import '../entities/transaction_entity.dart';

abstract interface class ProviderTransactionRepository {
  Future<bool> existsByReference(String reference);

  Future<void> save(
    TransactionEntity transaction, {
    String? tillId,
    String? sessionId,
  });

  Future<List<TransactionEntity>> getBySession(String sessionId);

  Future<List<TransactionEntity>> getAll();
}
