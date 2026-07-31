import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';

import '../../../business/data/repository/branch_repository_impl.dart';
import '../../../business/domain/repository/branch_repository.dart';

final branchRepositoryProvider =
    Provider<BranchRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return BranchRepositoryImpl(database);
});