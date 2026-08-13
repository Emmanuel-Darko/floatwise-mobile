import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../daily_session/presentation/providers/daily_session_repository_provider.dart';
import '../../../ledger/presentation/providers/ledger_event_repository_provider.dart';
import '../../../settings/presentation/providers/app_config_repository_provider.dart';
import '../../application/transaction_posting_service.dart';
import '../../data/services/transaction_posting_service_impl.dart';
import '../providers/provider_transaction_repository_provider.dart';

final transactionPostingServiceProvider =
    FutureProvider<TransactionPostingService>((ref) async {
      final appConfigRepository = await ref.watch(
        appConfigRepositoryProvider.future,
      );

      return TransactionPostingServiceImpl(
        appConfigRepository: appConfigRepository,
        dailySessionRepository: ref.watch(dailySessionRepositoryProvider),
        transactionRepository: ref.watch(providerTransactionRepositoryProvider),
        ledgerEventRepository: ref.watch(ledgerEventRepositoryProvider),
      );
    });
