import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../branch/domain/entities/branch_entity.dart';
import '../../../branch/presentation/providers/branch_repository_provider.dart';
import '../../../business/domain/entities/business_entity.dart';
import '../../../business/presentation/providers/business_repository_provider.dart';
import '../../../daily_session/domain/entities/daily_session_entity.dart';
import '../../../daily_session/presentation/providers/daily_session_repository_provider.dart';
import '../../../ledger/presentation/providers/ledger_event_repository_provider.dart';
import '../../../settings/presentation/providers/app_config_repository_provider.dart';
import '../../../../shared/enums/transaction_status.dart';
import '../../../../shared/enums/transaction_type.dart';
import '../../../till/domain/entities/till_entity.dart';
import '../../../till/presentation/providers/till_repository_provider.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../../../transaction/presentation/providers/provider_transaction_repository_provider.dart';

class DashboardState {
  const DashboardState({
    this.business,
    this.branch,
    this.till,
    this.session,
    this.cash = 0,
    this.floatBalance = 0,
    this.deposits = 0,
    this.withdrawals = 0,
    this.totalValue = 0,
    this.needsReviewCount = 0,
    this.recentTransactions = const [],
  });

  final BusinessEntity? business;
  final BranchEntity? branch;
  final TillEntity? till;
  final DailySessionEntity? session;

  final double cash;
  final double floatBalance;

  final double deposits;
  final double withdrawals;
  final double totalValue;

  final int needsReviewCount;
  final List<TransactionEntity> recentTransactions;
}

class DashboardController extends AsyncNotifier<DashboardState> {
  @override
  Future<DashboardState> build() async {
    final appConfigRepository = await ref.watch(
      appConfigRepositoryProvider.future,
    );
    final config = await appConfigRepository.getConfig();

    final businessId = config.currentBusinessId;
    final branchId = config.currentBranchId;
    final tillId = config.currentTillId;

    BusinessEntity? business;
    if (businessId != null) {
      business = await ref
          .watch(businessRepositoryProvider)
          .getById(businessId);
    }

    BranchEntity? branch;
    if (business != null && branchId != null) {
      final branches = await ref
          .watch(branchRepositoryProvider)
          .getBusinessBranches(business.id);
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
      session = await ref
          .watch(dailySessionRepositoryProvider)
          .getActiveSession(till.id);
    }

    if (session == null) {
      return DashboardState(
        business: business,
        branch: branch,
        till: till,
        session: null,
      );
    }

    final ledgerEvents = await ref
        .watch(ledgerEventRepositoryProvider)
        .getBySession(session.id);

    var cash = session.openingCash;
    var floatBalance = session.openingFloat;
    for (final event in ledgerEvents) {
      cash += event.cashDelta;
      floatBalance += event.floatDelta;
    }

    final sessionTransactions = await ref
        .watch(providerTransactionRepositoryProvider)
        .getBySession(session.id);

    var deposits = 0.0;
    var withdrawals = 0.0;
    var totalValue = 0.0;
    var needsReviewCount = 0;

    for (final transaction in sessionTransactions) {
      totalValue += transaction.amount;
      switch (transaction.type) {
        case TransactionType.cashIn:
          deposits += transaction.amount;
        case TransactionType.cashOut:
          withdrawals += transaction.amount;
        default:
          break;
      }
      if (transaction.status == TransactionStatus.needsReview) {
        needsReviewCount++;
      }
    }

    final sorted = [...sessionTransactions]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return DashboardState(
      business: business,
      branch: branch,
      till: till,
      session: session,
      cash: cash,
      floatBalance: floatBalance,
      deposits: deposits,
      withdrawals: withdrawals,
      totalValue: totalValue,
      needsReviewCount: needsReviewCount,
      recentTransactions: sorted.take(5).toList(),
    );
  }
}
