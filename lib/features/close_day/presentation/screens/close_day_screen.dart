import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../../dashboard/presentation/providers/dashboard_controller_provider.dart';
import '../../../reconciliation/domain/models/reconciliation_result.dart';
import '../../domain/models/close_day_result.dart';
import '../providers/close_day_service_provider.dart';

class CloseDayScreen extends ConsumerStatefulWidget {
  const CloseDayScreen({super.key});

  @override
  ConsumerState<CloseDayScreen> createState() => _CloseDayScreenState();
}

class _CloseDayScreenState extends ConsumerState<CloseDayScreen> {
  final _cashController = TextEditingController();
  final _floatController = TextEditingController();

  bool _busy = false;
  bool _confirmed = false;
  String? _error;
  CloseDayResult? _result;

  @override
  void dispose() {
    _cashController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  double? _parseAmount(String value) {
    final parsed = double.tryParse(value.trim());
    if (parsed == null || parsed < 0) return null;
    return parsed;
  }

  Future<void> _submit({required bool confirmDiscrepancy}) async {
    final cash = _parseAmount(_cashController.text);
    final float = _parseAmount(_floatController.text);

    if (cash == null || float == null) {
      setState(() => _error = 'Enter valid amounts for cash and float.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final dashboard = ref.read(dashboardControllerProvider).valueOrNull;
      final session = dashboard?.session;
      if (session == null) {
        setState(() {
          _busy = false;
          _error = 'No active session found.';
        });
        return;
      }

      final service = ref.read(closeDayServiceProvider);
      final result = await service.closeDay(
        session: session,
        actualCash: cash,
        actualFloat: float,
        confirmDiscrepancy: confirmDiscrepancy,
      );

      if (!mounted) return;

      if (result.closed) {
        ref.invalidate(dashboardControllerProvider);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Day closed successfully.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        context.go('/dashboard');
        return;
      }

      setState(() {
        _busy = false;
        _result = result;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = 'Failed to close the day. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Close Day')),
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const Center(child: Text('Failed to load session.')),
          data: (state) {
            final session = state.session;
            if (session == null) {
              return const Center(child: Text('No active session found.'));
            }
            return _content(state);
          },
        ),
      ),
    );
  }

  Widget _content(DashboardState state) {
    final theme = Theme.of(context);
    final session = state.session!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.till?.name ?? 'Till',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Opened ${Formatters.dateTime(session.openedAt)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Expected Balances', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _ExpectedItem(
                      label: 'Cash',
                      amount: state.cash,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ExpectedItem(
                      label: 'Float',
                      amount: state.floatBalance,
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Counted Balances', style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Actual cash counted',
            controller: _cashController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: const Icon(Icons.payments_outlined),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Actual float counted',
            controller: _floatController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.error),
            ),
          ],
          if (_result != null) ...[
            const SizedBox(height: 24),
            _ReconciliationPanel(result: _result!),
          ],
          const SizedBox(height: 32),
          if (_result != null && !_result!.closed) ...[
            CheckboxListTile(
              value: _confirmed,
              onChanged: (value) {
                setState(() => _confirmed = value ?? false);
              },
              title: Text(
                'I confirm the discrepancy and want to close the day anyway',
                style: theme.textTheme.bodyMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),
          ],
          FilledButton(
            onPressed:
                _busy || (_result != null && !_result!.closed && !_confirmed)
                ? null
                : () => _submit(
                    confirmDiscrepancy: _result?.closed == false && _confirmed,
                  ),
            child: _busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Close Day'),
          ),
          if (_result != null && !_result!.closed) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _busy
                  ? null
                  : () {
                      setState(() {
                        _result = null;
                        _confirmed = false;
                      });
                    },
              child: const Text('Edit amounts'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExpectedItem extends StatelessWidget {
  const _ExpectedItem({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          Formatters.currency(amount),
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ReconciliationPanel extends StatelessWidget {
  const _ReconciliationPanel({required this.result});

  final CloseDayResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reconciliation = result.reconciliation;
    final (label, color, icon) = _statusVisuals(reconciliation.status, theme);

    return Card(
      color: color.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _DifferenceRow(
              label: 'Cash',
              expected: reconciliation.expectedCash,
              actual: reconciliation.actualCash,
            ),
            const SizedBox(height: 8),
            _DifferenceRow(
              label: 'Float',
              expected: reconciliation.expectedFloat,
              actual: reconciliation.actualFloat,
            ),
            const Divider(height: 24),
            Text(
              'Overall ${reconciliation.overallDifference < 0 ? 'shortage' : 'excess'}: '
              '${Formatters.currency(reconciliation.overallDifference.abs())}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  (String, Color, IconData) _statusVisuals(
    ReconciliationStatus status,
    ThemeData theme,
  ) {
    switch (status) {
      case ReconciliationStatus.balanced:
        return ('Balanced', AppColors.success, Icons.check_circle_outline);
      case ReconciliationStatus.short:
        return ('Short', AppColors.error, Icons.error_outline);
      case ReconciliationStatus.excess:
        return ('Excess', AppColors.warning, Icons.warning_amber_outlined);
      case ReconciliationStatus.unresolved:
        return ('Unresolved', AppColors.warning, Icons.rule_outlined);
    }
  }
}

class _DifferenceRow extends StatelessWidget {
  const _DifferenceRow({
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
