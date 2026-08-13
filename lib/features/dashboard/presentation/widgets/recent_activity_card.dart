import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

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
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.history,
                color: AppColors.textSecondary,
              ),
              title: Text(
                'No recent activity yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              subtitle: const Text(
                'Transactions will appear here once you import SMS.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
