import 'package:uuid/uuid.dart';

import '../../../../shared/enums/transaction_status.dart';
import '../../../daily_session/domain/entities/daily_session_entity.dart';
import '../../../daily_session/domain/repository/daily_session_repository.dart';
import '../../../ledger/domain/entities/ledger_event_entity.dart';
import '../../../ledger/domain/repository/ledger_event_repository.dart';
import '../../../settings/domain/repository/app_config_repository.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repository/provider_transaction_repository.dart';
import '../../application/transaction_verification_service.dart';

typedef _Effect = ({LedgerEventType type, double cashDelta, double floatDelta});

class TransactionVerificationServiceImpl
    implements TransactionVerificationService {
  TransactionVerificationServiceImpl({
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
  Future<TransactionVerificationResult> verify({
    required TransactionEntity transaction,
    required VerificationEffect effect,
    String? note,
  }) async {
    if (transaction.status != TransactionStatus.needsReview) {
      throw Exception('Only transactions needing review can be verified.');
    }

    final existingEvents = await _ledgerEventRepository.getAll();
    final alreadyPosted = existingEvents.any(
      (event) => event.providerTransactionId == transaction.id,
    );
    if (alreadyPosted) {
      throw Exception(
        'This transaction has already been posted to the ledger.',
      );
    }

    final config = await _appConfigRepository.getConfig();
    final tillId = config.currentTillId;

    DailySessionEntity? activeSession;
    if (tillId != null) {
      activeSession = await _dailySessionRepository.getActiveSession(tillId);
    }

    final ledgerEffect = _effectFor(effect, transaction.amount);

    await _transactionRepository.updateStatus(
      id: transaction.id,
      status: TransactionStatus.verified,
    );

    final session = activeSession;
    var ledgerEventWritten = false;
    if (session != null) {
      const uuid = Uuid();
      await _ledgerEventRepository.save(
        LedgerEventEntity(
          id: uuid.v4(),
          sessionId: session.id,
          tillId: session.tillId,
          type: ledgerEffect.type,
          cashDelta: ledgerEffect.cashDelta,
          floatDelta: ledgerEffect.floatDelta,
          commissionDelta: 0,
          createdAt: transaction.timestamp,
          providerTransactionId: transaction.id,
          note: note ?? _defaultNote(effect),
        ),
      );
      ledgerEventWritten = true;
    }

    return TransactionVerificationResult(
      verified: true,
      ledgerEventWritten: ledgerEventWritten,
    );
  }

  _Effect _effectFor(VerificationEffect effect, double amount) {
    return switch (effect) {
      VerificationEffect.deposit => (
        type: LedgerEventType.deposit,
        cashDelta: amount,
        floatDelta: -amount,
      ),
      VerificationEffect.withdrawal => (
        type: LedgerEventType.withdrawal,
        cashDelta: -amount,
        floatDelta: amount,
      ),
      VerificationEffect.expense => (
        type: LedgerEventType.expense,
        cashDelta: -amount,
        floatDelta: 0,
      ),
      VerificationEffect.adjustment => (
        type: LedgerEventType.adjustment,
        cashDelta: 0,
        floatDelta: 0,
      ),
    };
  }

  String _defaultNote(VerificationEffect effect) {
    return switch (effect) {
      VerificationEffect.deposit => 'Manually verified as deposit',
      VerificationEffect.withdrawal => 'Manually verified as withdrawal',
      VerificationEffect.expense => 'Manually verified as expense',
      VerificationEffect.adjustment => 'Manually verified as adjustment',
    };
  }
}
