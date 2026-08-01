import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';

import '../../data/repository/daily_session_repository_impl.dart';
import '../../domain/repository/daily_session_repository.dart';

final dailySessionRepositoryProvider =
    Provider<DailySessionRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return DailySessionRepositoryImpl(database);
});
