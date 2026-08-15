import '../domain/entities/transaction_entity.dart';

enum VerificationEffect { deposit, withdrawal, expense, adjustment }

class TransactionVerificationResult {
  const TransactionVerificationResult({
    required this.verified,
    required this.ledgerEventWritten,
  });

  final bool verified;

  final bool ledgerEventWritten;
}

abstract interface class TransactionVerificationService {
  Future<TransactionVerificationResult> verify({
    required TransactionEntity transaction,
    required VerificationEffect effect,
    String? note,
  });
}
