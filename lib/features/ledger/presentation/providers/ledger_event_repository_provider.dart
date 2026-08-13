import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/repository/ledger_event_repository_impl.dart';
import '../../domain/repository/ledger_event_repository.dart';

final ledgerEventRepositoryProvider = Provider<LedgerEventRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return LedgerEventRepositoryImpl(database);
});
