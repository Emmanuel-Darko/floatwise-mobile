import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/models/reconciliation_result.dart';

class ReconciliationResultPanel extends StatelessWidget {
  const ReconciliationResultPanel({super.key, required this.result});

  final ReconciliationResult result;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StatusHeroCard(result: result),
        const SizedBox(height: 12),
        ReconciliationDetailsCard(result: result),
      ],
    );
  }
}

class _StatusHeroCard extends StatelessWidget {
  const _StatusHeroCard({required this.result});

  final ReconciliationResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, color, icon) = _statusVisuals(result.status);

    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 24, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _differenceText(result),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _supportingText(result),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  (String, Color, IconData) _statusVisuals(ReconciliationStatus status) {
    switch (status) {
      case ReconciliationStatus.balanced:
        return (
          'You are balanced',
          AppColors.success,
          Icons.check_circle_outline,
        );
      case ReconciliationStatus.short:
        return ('You are short', AppColors.error, Icons.error_outline);
      case ReconciliationStatus.excess:
        return ('You have extra', AppColors.warning, Icons.trending_up);
      case ReconciliationStatus.unresolved:
        return ('Check unclear items', AppColors.warning, Icons.rule_outlined);
    }
  }

  String _differenceText(ReconciliationResult reconciliation) {
    switch (reconciliation.status) {
      case ReconciliationStatus.balanced:
        return Formatters.currency(0);
      case ReconciliationStatus.short:
      case ReconciliationStatus.excess:
        final sign = reconciliation.overallDifference < 0 ? '-' : '+';
        return '$sign${Formatters.currency(reconciliation.overallDifference.abs())}';
      case ReconciliationStatus.unresolved:
        return 'Unresolved';
    }
  }

  String _supportingText(ReconciliationResult reconciliation) {
    switch (reconciliation.status) {
      case ReconciliationStatus.balanced:
        return 'Your counted money matches what FloatWise expected.';
      case ReconciliationStatus.short:
        final short = Formatters.currency(
          reconciliation.overallDifference.abs(),
        );
        return 'You are short by $short. Count your cash again and confirm.';
      case ReconciliationStatus.excess:
        final extra = Formatters.currency(
          reconciliation.overallDifference.abs(),
        );
        return 'You have $extra more than expected. Verify before closing.';
      case ReconciliationStatus.unresolved:
        return 'Resolve transactions that still need review before closing.';
    }
  }
}

class ReconciliationDetailsCard extends StatelessWidget {
  const ReconciliationDetailsCard({super.key, required this.result});

  final ReconciliationResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Breakdown',
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            ReconciliationDifferenceRow(
              label: 'Cash',
              expected: result.expectedCash,
              actual: result.actualCash,
            ),
            const SizedBox(height: 8),
            ReconciliationDifferenceRow(
              label: 'Float',
              expected: result.expectedFloat,
              actual: result.actualFloat,
            ),
          ],
        ),
      ),
    );
  }
}

class ReconciliationDifferenceRow extends StatelessWidget {
  const ReconciliationDifferenceRow({
    super.key,
    required this.label,
    required this.expected,
    required this.actual,
  });

  final String label;
  final double expected;
  final double actual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final difference = actual - expected;
    final matches = difference.abs() <= 0.005;
    final color = matches ? AppColors.success : AppColors.error;

    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Expected ${Formatters.currency(expected)}',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Text(
          matches
              ? 'Matches'
              : '${difference < 0 ? '-' : '+'}${Formatters.currency(difference.abs())}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
