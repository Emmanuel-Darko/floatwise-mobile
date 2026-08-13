import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../providers/dashboard_controller_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/session_card.dart';
import '../widgets/transaction_summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: const DashboardAppBar(),
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const Center(child: Text('Failed to load dashboard.')),
          data: (state) => SingleChildScrollView(
            child: Column(
              children: [
                SessionCard(session: state.session, tillName: state.till?.name),
                BalanceCard(
                  cash: state.session?.openingCash ?? 0,
                  floatBalance: state.session?.openingFloat ?? 0,
                ),
                TransactionSummaryCard(
                  deposits: state.deposits,
                  withdrawals: state.withdrawals,
                  totalValue: state.totalValue,
                ),
                const QuickActionsCard(),
                const RecentActivityCard(),
                const SizedBox(height: 24),
                Text(
                  'FloatWise',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
