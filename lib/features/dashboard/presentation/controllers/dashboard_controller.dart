import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../branch/domain/entities/branch_entity.dart';
import '../../../business/domain/entities/business_entity.dart';
import '../../../daily_session/domain/entities/daily_session_entity.dart';
import '../../../settings/presentation/providers/app_config_repository_provider.dart';
import '../../../till/domain/entities/till_entity.dart';
import '../../../branch/presentation/providers/branch_repository_provider.dart';
import '../../../business/presentation/providers/business_repository_provider.dart';
import '../../../daily_session/presentation/providers/daily_session_repository_provider.dart';
import '../../../till/presentation/providers/till_repository_provider.dart';

class DashboardState {
  const DashboardState({
    this.business,
    this.branch,
    this.till,
    this.session,
    this.deposits = 0,
    this.withdrawals = 0,
    this.totalValue = 0,
  });

  final BusinessEntity? business;
  final BranchEntity? branch;
  final TillEntity? till;
  final DailySessionEntity? session;

  final double deposits;
  final double withdrawals;
  final double totalValue;
}

class DashboardController extends AsyncNotifier<DashboardState> {
  @override
  Future<DashboardState> build() async {
    final appConfigRepository =
        await ref.watch(appConfigRepositoryProvider.future);
    final config = await appConfigRepository.getConfig();

    final businessId = config.currentBusinessId;
    final branchId = config.currentBranchId;
    final tillId = config.currentTillId;

    BusinessEntity? business;
    if (businessId != null) {
      business = await ref.watch(businessRepositoryProvider).getById(businessId);
    }

    BranchEntity? branch;
    if (business != null && branchId != null) {
      final branches =
          await ref.watch(branchRepositoryProvider).getBusinessBranches(
                business.id,
              );
      for (final candidate in branches) {
        if (candidate.id == branchId) {
          branch = candidate;
          break;
        }
      }
    }

    TillEntity? till;
    if (tillId != null) {
      till = await ref.watch(tillRepositoryProvider).getById(tillId);
    }

    DailySessionEntity? session;
    if (till != null) {
      session =
          await ref.watch(dailySessionRepositoryProvider).getActiveSession(
                till.id,
              );
    }

    return DashboardState(
      business: business,
      branch: branch,
      till: till,
      session: session,
    );
  }
}