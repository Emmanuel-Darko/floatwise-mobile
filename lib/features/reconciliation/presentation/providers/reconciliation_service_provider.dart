import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ledger/presentation/providers/ledger_event_repository_provider.dart';
import '../../../transaction/presentation/providers/provider_transaction_repository_provider.dart';
import '../../application/reconciliation_service.dart';
import '../../data/services/reconciliation_service_impl.dart';

final reconciliationServiceProvider = Provider<ReconciliationService>((ref) {
  return ReconciliationServiceImpl(
    ledgerEventRepository: ref.watch(ledgerEventRepositoryProvider),
    transactionRepository: ref.watch(providerTransactionRepositoryProvider),
  );
});
