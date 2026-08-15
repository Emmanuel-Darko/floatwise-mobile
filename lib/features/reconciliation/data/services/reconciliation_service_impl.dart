import '../../../../shared/enums/transaction_status.dart';
import '../../../daily_session/domain/entities/daily_session_entity.dart';
import '../../../ledger/domain/repository/ledger_event_repository.dart';
import '../../../transaction/domain/repository/provider_transaction_repository.dart';
import '../../application/reconciliation_service.dart';
import '../../domain/models/reconciliation_result.dart';

class ReconciliationServiceImpl implements ReconciliationService {
  ReconciliationServiceImpl({
    required this._ledgerEventRepository,
    required this._transactionRepository,
  });

  static const double _tolerance = 0.005;

  final LedgerEventRepository _ledgerEventRepository;
  final ProviderTransactionRepository _transactionRepository;

  @override
  Future<ReconciliationResult> reconcile({
    required DailySessionEntity session,
    required double actualCash,
    required double actualFloat,
  }) async {
    final events = await _ledgerEventRepository.getBySession(session.id);

    var cashDelta = 0.0;
    var floatDelta = 0.0;
    for (final event in events) {
      cashDelta += event.cashDelta;
      floatDelta += event.floatDelta;
    }

    final expectedCash = session.openingCash + cashDelta;
    final expectedFloat = session.openingFloat + floatDelta;

    final cashDifference = actualCash - expectedCash;
    final floatDifference = actualFloat - expectedFloat;
    final overallDifference = cashDifference + floatDifference;

    final unresolved = await _hasUnresolvedTransactions(session.id);

    final status = unresolved
        ? ReconciliationStatus.unresolved
        : _statusFor(
            cashDifference: cashDifference,
            floatDifference: floatDifference,
            overallDifference: overallDifference,
          );

    return ReconciliationResult(
      expectedCash: expectedCash,
      expectedFloat: expectedFloat,
      actualCash: actualCash,
      actualFloat: actualFloat,
      cashDifference: cashDifference,
      floatDifference: floatDifference,
      overallDifference: overallDifference,
      status: status,
    );
  }

  Future<bool> _hasUnresolvedTransactions(String sessionId) async {
    final transactions = await _transactionRepository.getBySession(sessionId);
    return transactions.any(
      (transaction) => transaction.status == TransactionStatus.needsReview,
    );
  }

  ReconciliationStatus _statusFor({
    required double cashDifference,
    required double floatDifference,
    required double overallDifference,
  }) {
    final cashMatches = cashDifference.abs() <= _tolerance;
    final floatMatches = floatDifference.abs() <= _tolerance;

    if (cashMatches && floatMatches) {
      return ReconciliationStatus.balanced;
    }

    if (overallDifference < 0) {
      return ReconciliationStatus.short;
    }

    return ReconciliationStatus.excess;
  }
}
