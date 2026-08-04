import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/enums/mobile_network.dart';
import '../providers/setup_controller_provider.dart';

class ReviewStepScreen extends ConsumerWidget {
  const ReviewStepScreen({super.key, required this.onFinish});

  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(setupControllerProvider);
    final theme = Theme.of(context);
    final business = state.business;
    final branch = state.branch;
    final till = state.till;
    final cash = state.openingCash;
    final float = state.openingFloat;

    final ready = business != null &&
        branch != null &&
        till != null &&
        cash != null &&
        float != null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _Section(
                  title: 'Business',
                  value: business?.name ?? '—',
                ),
                _Section(
                  title: 'Branch',
                  value: branch?.name ?? '—',
                ),
                _Section(
                  title: 'Till',
                  value: till != null
                      ? '${till.network.shortName} ${Formatters.phone(till.phoneNumber)}'
                      : '—',
                ),
                _Section(
                  title: 'Opening Cash',
                  value: cash != null ? Formatters.currency(cash) : '—',
                ),
                _Section(
                  title: 'Opening Float',
                  value: float != null ? Formatters.currency(float) : '—',
                ),
                const SizedBox(height: 16),
                Text(
                  'Review the details before you finish.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: ready ? onFinish : null,
            child: const Text('Finish Setup'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}