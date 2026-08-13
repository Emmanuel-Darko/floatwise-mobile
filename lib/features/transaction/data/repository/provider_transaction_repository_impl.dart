import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../shared/enums/mobile_network.dart';
import '../../../../shared/enums/transaction_source.dart';
import '../../../../shared/enums/transaction_status.dart';
import '../../../../shared/enums/transaction_type.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repository/provider_transaction_repository.dart';

class ProviderTransactionRepositoryImpl
    implements ProviderTransactionRepository {
  ProviderTransactionRepositoryImpl(this.database);

  final AppDatabase database;

  @override
  Future<bool> existsByReference(String reference) async {
    final row = await database.providerTransactionDao.getByReference(reference);

    return row != null;
  }

  @override
  Future<void> save(
    TransactionEntity transaction, {
    String? tillId,
    String? sessionId,
  }) {
    return database.providerTransactionDao.insertTransaction(
      ProviderTransactionsCompanion.insert(
        id: transaction.id,
        tillId: Value(tillId),
        sessionId: Value(sessionId),
        network: transaction.network.name,
        type: transaction.type.name,
        amount: transaction.amount,
        timestamp: transaction.timestamp,
        status: transaction.status.name,
        source: transaction.source.name,
        phoneNumber: Value(transaction.phoneNumber),
        reference: Value(transaction.reference),
        rawSmsId: Value(transaction.rawSmsId),
        balanceAfter: Value(transaction.balanceAfter),
      ),
    );
  }

  @override
  Future<List<TransactionEntity>> getBySession(String sessionId) async {
    final rows = await database.providerTransactionDao.getBySession(sessionId);

    return rows.map(_toEntity).toList();
  }

  @override
  Future<List<TransactionEntity>> getAll() async {
    final rows = await database.providerTransactionDao.getAll();

    return rows.map(_toEntity).toList();
  }

  TransactionEntity _toEntity(ProviderTransaction row) {
    return TransactionEntity(
      id: row.id,
      network: MobileNetwork.values.byName(row.network),
      type: TransactionType.values.byName(row.type),
      amount: row.amount,
      timestamp: row.timestamp,
      status: TransactionStatus.values.byName(row.status),
      source: TransactionSource.values.byName(row.source),
      phoneNumber: row.phoneNumber,
      reference: row.reference,
      rawSmsId: row.rawSmsId,
      balanceAfter: row.balanceAfter,
    );
  }
}
