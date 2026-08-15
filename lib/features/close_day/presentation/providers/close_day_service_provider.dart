import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../daily_session/presentation/providers/daily_session_repository_provider.dart';
import '../../../reconciliation/presentation/providers/reconciliation_service_provider.dart';
import '../../application/close_day_service.dart';
import '../../data/services/close_day_service_impl.dart';

final closeDayServiceProvider = Provider<CloseDayService>((ref) {
  return CloseDayServiceImpl(
    reconciliationService: ref.watch(reconciliationServiceProvider),
    dailySessionRepository: ref.watch(dailySessionRepositoryProvider),
  );
});
