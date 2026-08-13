import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../daily_session/domain/entities/daily_session_entity.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({super.key, required this.session, required this.tillName});

  final DailySessionEntity? session;
  final String? tillName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = session != null && session!.status == SessionStatus.open;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Session',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                _StatusChip(label: active ? 'Open' : 'Closed', active: active),
              ],
            ),
            const SizedBox(height: 12),
            Text(tillName ?? '—', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              session != null
                  ? 'Opened ${Formatters.time(session!.openedAt)}'
                  : 'No active session',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.success : AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
