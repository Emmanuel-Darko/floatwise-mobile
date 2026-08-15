import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../../dashboard/presentation/providers/dashboard_controller_provider.dart';
import '../../domain/models/reconciliation_result.dart';
import '../providers/reconciliation_service_provider.dart';
import '../widgets/reconciliation_result_panel.dart';

class ReconcileScreen extends ConsumerStatefulWidget {
  const ReconcileScreen({super.key});

  @override
  ConsumerState<ReconcileScreen> createState() => _ReconcileScreenState();
}

class _ReconcileScreenState extends ConsumerState<ReconcileScreen> {
  final _cashController = TextEditingController();
  final _floatController = TextEditingController();

  bool _busy = false;
  String? _error;
  ReconciliationResult? _result;

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

  Future<void> _runReconciliation() async {
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

      final service = ref.read(reconciliationServiceProvider);
      final result = await service.reconcile(
        session: session,
        actualCash: cash,
        actualFloat: float,
      );

      if (!mounted) return;

      setState(() {
        _busy = false;
        _result = result;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = 'Reconciliation failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reconcile')),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(state.till?.name ?? 'Till', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Session opened. Expected balances below.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
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
            ReconciliationResultPanel(result: _result!),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.go('/close-day'),
              icon: const Icon(Icons.login),
              label: const Text('Proceed to Close Day'),
            ),
          ],
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _busy ? null : _runReconciliation,
            child: _busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Run Reconciliation'),
          ),
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
