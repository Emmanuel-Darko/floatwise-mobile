import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/enums/mobile_network.dart';
import '../../../../shared/enums/transaction_type.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key, this.transactions = const []});

  final List<TransactionEntity> transactions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            if (transactions.isEmpty)
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.history, color: AppColors.textSecondary),
                title: Text(
                  'No recent activity yet',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                subtitle: Text(
                  'Transactions will appear here once you import SMS.',
                ),
              )
            else
              for (final transaction in transactions) ...[
                _ActivityTile(transaction: transaction),
                if (transaction != transactions.last) const Divider(height: 1),
              ],
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (label, icon, color) = switch (transaction.type) {
      TransactionType.cashIn => (
        'Deposit',
        Icons.south_west,
        AppColors.success,
      ),
      TransactionType.cashOut => (
        'Withdrawal',
        Icons.north_east,
        AppColors.error,
      ),
      TransactionType.reversal => ('Reversal', Icons.replay, AppColors.warning),
      _ => ('Needs review', Icons.rule, AppColors.warning),
    };

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            Formatters.currency(transaction.amount),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: transaction.status.name == 'verified'
                  ? color
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
      subtitle: Text(
        '${transaction.network.shortName} · '
        '${Formatters.dateTime(transaction.timestamp)}',
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
