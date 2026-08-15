import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../dashboard/presentation/providers/dashboard_controller_provider.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../../../transaction/presentation/providers/provider_transaction_repository_provider.dart';
import '../../../transaction/application/transaction_verification_service.dart';
import '../../../transaction/presentation/providers/transaction_verification_service_provider.dart';
import '../../../../shared/enums/transaction_status.dart';

class TransactionReviewScreen extends ConsumerStatefulWidget {
  const TransactionReviewScreen({super.key});

  @override
  ConsumerState<TransactionReviewScreen> createState() =>
      _TransactionReviewScreenState();
}

class _TransactionReviewScreenState
    extends ConsumerState<TransactionReviewScreen> {
  VerificationEffect? _selectedEffect;
  String? _activeTransactionId;
  bool _busy = false;
  String? _error;

  Future<void> _verify(TransactionEntity transaction) async {
    final effect = _selectedEffect;
    if (effect == null) {
      setState(
        () => _error = 'Choose how this transaction affects your books.',
      );
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
      _activeTransactionId = transaction.id;
    });

    try {
      final service = await ref.read(
        transactionVerificationServiceProvider.future,
      );
      await service.verify(transaction: transaction, effect: effect);

      if (!mounted) return;

      setState(() {
        _busy = false;
        _activeTransactionId = null;
        _selectedEffect = null;
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Transaction verified.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      ref.invalidate(dashboardControllerProvider);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _activeTransactionId = null;
        _error = 'Verification failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Transactions')),
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    final dashboard = ref.watch(dashboardControllerProvider).valueOrNull;
    final session = dashboard?.session;

    if (session == null) {
      return const Center(child: Text('No active session found.'));
    }

    final repository = ref.watch(providerTransactionRepositoryProvider);

    return FutureBuilder<List<TransactionEntity>>(
      future: repository.getBySession(session.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          );
        }

        final pending = snapshot.data!
            .where((t) => t.status == TransactionStatus.needsReview)
            .toList();

        if (pending.isEmpty) {
          return const Center(
            child: Text('All transactions have been reviewed.'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: pending.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final transaction = pending[index];
            return _TransactionReviewCard(
              transaction: transaction,
              selectedEffect: _selectedEffect,
              busy: _busy && _activeTransactionId == transaction.id,
              onEffectChanged: (effect) =>
                  setState(() => _selectedEffect = effect),
              onVerify: () => _verify(transaction),
            );
          },
        );
      },
    );
  }
}

class _TransactionReviewCard extends StatelessWidget {
  const _TransactionReviewCard({
    required this.transaction,
    required this.selectedEffect,
    required this.busy,
    required this.onEffectChanged,
    required this.onVerify,
  });

  final TransactionEntity transaction;
  final VerificationEffect? selectedEffect;
  final bool busy;
  final ValueChanged<VerificationEffect> onEffectChanged;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    transaction.type.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  Formatters.currency(transaction.amount),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _Detail(label: 'Network', value: transaction.network.name),
            if (transaction.phoneNumber != null)
              _Detail(
                label: 'Phone',
                value: Formatters.phone(transaction.phoneNumber!),
              ),
            if (transaction.reference != null)
              _Detail(label: 'Reference', value: transaction.reference!),
            _Detail(
              label: 'Time',
              value: Formatters.dateTime(transaction.timestamp),
            ),
            const Divider(height: 24),
            Text(
              'Effect on your books',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            _EffectSelector(value: selectedEffect, onChanged: onEffectChanged),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: busy ? null : onVerify,
              icon: busy
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check, size: 18),
              label: const Text('Verify & Post'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _EffectSelector extends StatelessWidget {
  const _EffectSelector({required this.value, required this.onChanged});

  final VerificationEffect? value;
  final ValueChanged<VerificationEffect> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<VerificationEffect>(
      groupValue: value,
      onChanged: (selected) {
        if (selected != null) onChanged(selected);
      },
      child: Column(
        children: [
          for (final effect in VerificationEffect.values)
            RadioListTile<VerificationEffect>(
              dense: true,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              value: effect,
              title: Text(_effectLabel(effect)),
            ),
        ],
      ),
    );
  }

  String _effectLabel(VerificationEffect effect) {
    return switch (effect) {
      VerificationEffect.deposit => 'Deposit — cash increases, float decreases',
      VerificationEffect.withdrawal =>
        'Withdrawal — cash decreases, float increases',
      VerificationEffect.expense => 'Expense — cash decreases',
      VerificationEffect.adjustment => 'Adjustment — no cash/float movement',
    };
  }
}
