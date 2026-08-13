import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/enums/mobile_network.dart';
import '../providers/setup_controller_provider.dart';
import '../providers/setup_service_provider.dart';

class ReviewStepScreen extends ConsumerStatefulWidget {
  const ReviewStepScreen({super.key});

  @override
  ConsumerState<ReviewStepScreen> createState() => _ReviewStepScreenState();
}

class _ReviewStepScreenState extends ConsumerState<ReviewStepScreen> {
  bool _busy = false;

  Future<void> _finish() async {
    setState(() => _busy = true);

    try {
      final setupService = await ref.read(setupServiceProvider.future);
      final state = ref.read(setupControllerProvider);

      await setupService.completeSetup(state: state);

      if (mounted) {
        context.go('/sms/import');
      }
    } catch (_) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Setup Failed'),
          content: const Text('Could not save your setup. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(setupControllerProvider);
    final theme = Theme.of(context);
    final business = state.business;
    final branch = state.branch;
    final till = state.till;
    final cash = state.openingCash;
    final float = state.openingFloat;

    final ready =
        business != null &&
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
                _Section(title: 'Business', value: business?.name ?? '—'),
                _Section(title: 'Branch', value: branch?.name ?? '—'),
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
            onPressed: ready && !_busy ? _finish : null,
            child: _busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Finish Setup'),
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
