import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';

import '../../domain/repositories/till_repository.dart';
import '../../domain/repositories/till_repository_impl.dart';

final tillRepositoryProvider =
    Provider<TillRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return TillRepositoryImpl(database);
});
