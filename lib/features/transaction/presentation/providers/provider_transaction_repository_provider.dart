import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/repository/provider_transaction_repository_impl.dart';
import '../../domain/repository/provider_transaction_repository.dart';

final providerTransactionRepositoryProvider =
    Provider<ProviderTransactionRepository>((ref) {
      final database = ref.watch(databaseProvider);

      return ProviderTransactionRepositoryImpl(database);
    });
