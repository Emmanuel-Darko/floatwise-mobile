import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/repository/business_repository_impl.dart';
import '../../domain/repository/business_repository.dart';

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return BusinessRepositoryImpl(database);
});