import '../../../features/sms/domain/entities/parsed_transaction.dart';
import '../domain/models/transaction_posting_result.dart';

abstract interface class TransactionPostingService {
  Future<TransactionPostingResult> postTransactions(
    List<ParsedTransaction> transactions,
  );
}
