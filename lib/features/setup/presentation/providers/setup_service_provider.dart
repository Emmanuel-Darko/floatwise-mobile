import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../../branch/presentation/providers/branch_repository_provider.dart';
import '../../../business/presentation/providers/business_repository_provider.dart';
import '../../../daily_session/presentation/providers/daily_session_repository_provider.dart';
import '../../../settings/presentation/providers/app_config_repository_provider.dart';
import '../../../till/presentation/providers/till_repository_provider.dart';
import '../../application/setup_service.dart';
import '../../application/setup_service_impl.dart';

final setupServiceProvider = FutureProvider<SetupService>((ref) async {
  final database = ref.watch(databaseProvider);

  final appConfigRepository =
      await ref.watch(appConfigRepositoryProvider.future);

  return SetupServiceImpl(
    database: database,
    businessRepository: ref.watch(businessRepositoryProvider),
    branchRepository: ref.watch(branchRepositoryProvider),
    tillRepository: ref.watch(tillRepositoryProvider),
    dailySessionRepository: ref.watch(dailySessionRepositoryProvider),
    appConfigRepository: appConfigRepository,
  );
});