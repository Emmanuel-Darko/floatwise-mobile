import '../../../../shared/enums/transaction_status.dart';
import '../entities/transaction_entity.dart';

abstract interface class ProviderTransactionRepository {
  Future<bool> existsByReference(String reference);

  Future<TransactionEntity?> getById(String id);

  Future<void> save(
    TransactionEntity transaction, {
    String? tillId,
    String? sessionId,
  });

  Future<void> updateStatus({
    required String id,
    required TransactionStatus status,
  });

  Future<List<TransactionEntity>> getBySession(String sessionId);

  Future<List<TransactionEntity>> getAll();
}
