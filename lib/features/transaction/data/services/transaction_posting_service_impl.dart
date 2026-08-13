import 'package:uuid/uuid.dart';

import '../../../../shared/enums/transaction_source.dart';
import '../../../../shared/enums/transaction_status.dart';
import '../../../../shared/enums/transaction_type.dart';
import '../../../daily_session/domain/entities/daily_session_entity.dart';
import '../../../daily_session/domain/repository/daily_session_repository.dart';
import '../../../ledger/domain/entities/ledger_event_entity.dart';
import '../../../ledger/domain/repository/ledger_event_repository.dart';
import '../../../settings/domain/repository/app_config_repository.dart';
import '../../../sms/domain/entities/parsed_transaction.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/models/transaction_posting_result.dart';
import '../../domain/repository/provider_transaction_repository.dart';
import '../../application/transaction_posting_service.dart';

typedef _Outcome = ({
  TransactionStatus status,
  LedgerEventType? eventType,
  double cashDelta,
  double floatDelta,
});

class TransactionPostingServiceImpl implements TransactionPostingService {
  TransactionPostingServiceImpl({
    required this._appConfigRepository,
    required this._dailySessionRepository,
    required this._transactionRepository,
    required this._ledgerEventRepository,
  });

  final AppConfigRepository _appConfigRepository;
  final DailySessionRepository _dailySessionRepository;
  final ProviderTransactionRepository _transactionRepository;
  final LedgerEventRepository _ledgerEventRepository;

  @override
  Future<TransactionPostingResult> postTransactions(
    List<ParsedTransaction> transactions,
  ) async {
    final config = await _appConfigRepository.getConfig();
    final tillId = config.currentTillId;

    DailySessionEntity? session;
    if (tillId != null) {
      session = await _dailySessionRepository.getActiveSession(tillId);
    }

    const uuid = Uuid();

    var posted = 0;
    var needsReview = 0;
    var duplicates = 0;

    for (final parsed in transactions) {
      final reference = parsed.reference;
      if (reference != null &&
          await _transactionRepository.existsByReference(reference)) {
        duplicates++;
        continue;
      }

      final outcome = _classify(parsed);

      final transaction = TransactionEntity(
        id: uuid.v4(),
        network: parsed.network,
        type: parsed.type,
        amount: parsed.amount,
        timestamp: parsed.timestamp,
        status: outcome.status,
        source: TransactionSource.sms,
        phoneNumber: parsed.phoneNumber,
        reference: parsed.reference,
        rawSmsId: parsed.rawSmsId,
        balanceAfter: parsed.balanceAfter,
      );

      await _transactionRepository.save(
        transaction,
        tillId: session?.tillId,
        sessionId: session?.id,
      );

      if (outcome.status == TransactionStatus.verified && session != null) {
        await _ledgerEventRepository.save(
          LedgerEventEntity(
            id: uuid.v4(),
            sessionId: session.id,
            tillId: session.tillId,
            type: outcome.eventType!,
            cashDelta: outcome.cashDelta,
            floatDelta: outcome.floatDelta,
            commissionDelta: 0,
            createdAt: parsed.timestamp,
            providerTransactionId: transaction.id,
          ),
        );
        posted++;
      } else {
        needsReview++;
      }
    }

    return TransactionPostingResult(
      processed: transactions.length,
      posted: posted,
      needsReview: needsReview,
      duplicates: duplicates,
      hasActiveSession: session != null,
    );
  }

  _Outcome _classify(ParsedTransaction parsed) {
    switch (parsed.type) {
      case TransactionType.cashIn:
        return (
          status: TransactionStatus.verified,
          eventType: LedgerEventType.deposit,
          cashDelta: parsed.amount,
          floatDelta: -parsed.amount,
        );
      case TransactionType.cashOut:
        return (
          status: TransactionStatus.verified,
          eventType: LedgerEventType.withdrawal,
          cashDelta: -parsed.amount,
          floatDelta: parsed.amount,
        );
      case TransactionType.transfer:
      case TransactionType.airtime:
      case TransactionType.data:
      case TransactionType.billPayment:
      case TransactionType.fee:
      case TransactionType.reversal:
      case TransactionType.unknown:
        return (
          status: TransactionStatus.needsReview,
          eventType: null,
          cashDelta: 0,
          floatDelta: 0,
        );
    }
  }
}
