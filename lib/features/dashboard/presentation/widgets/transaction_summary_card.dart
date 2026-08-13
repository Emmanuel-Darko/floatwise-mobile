import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';

class TransactionSummaryCard extends StatelessWidget {
  const TransactionSummaryCard({
    super.key,
    required this.deposits,
    required this.withdrawals,
    required this.totalValue,
    this.needsReviewCount = 0,
  });

  final double deposits;
  final double withdrawals;
  final double totalValue;
  final int needsReviewCount;

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
              "Today's Summary",
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              label: 'Deposits',
              amount: deposits,
              color: AppColors.success,
            ),
            _SummaryRow(
              label: 'Withdrawals',
              amount: withdrawals,
              color: AppColors.error,
            ),
            const Divider(height: 24),
            _SummaryRow(
              label: 'Total Value',
              amount: totalValue,
              color: AppColors.textPrimary,
              emphasized: true,
            ),
            if (needsReviewCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(Icons.rule, size: 16, color: AppColors.warning),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '$needsReviewCount transaction(s) awaiting review',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    required this.color,
    this.emphasized = false,
  });

  final String label;
  final double amount;
  final Color color;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: emphasized
                ? theme.textTheme.titleSmall
                : theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
          ),
          Text(
            Formatters.currency(amount),
            style:
                (emphasized
                        ? theme.textTheme.titleSmall
                        : theme.textTheme.bodyMedium)
                    ?.copyWith(
                      color: color,
                      fontWeight: emphasized
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
          ),
        ],
      ),
    );
  }
}
