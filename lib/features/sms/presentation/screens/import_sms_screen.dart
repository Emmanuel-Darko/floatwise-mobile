import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/services/sms_import_service.dart';
import '../providers/sms_import_provider.dart';
import '../providers/sms_permission_provider.dart';

enum SmsImportRange {
  today('From Today', "Recommended for new businesses"),
  monthToDate('From Start of This Month', 'Import all messages this month'),
  custom('Custom Date', 'Choose a starting date'),
  everything('Import Everything', 'May take several minutes');

  const SmsImportRange(this.label, this.description);

  final String label;
  final String description;
}

class ImportSmsScreen extends ConsumerStatefulWidget {
  const ImportSmsScreen({super.key});

  @override
  ConsumerState<ImportSmsScreen> createState() => _ImportSmsScreenState();
}

class _ImportSmsScreenState extends ConsumerState<ImportSmsScreen> {
  bool _permissionGranted = false;
  bool _permissionBusy = false;
  bool _importing = false;
  String? _error;
  ImportResult? _result;
  SmsImportRange _range = SmsImportRange.today;
  DateTime? _customDate;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final granted =
        await ref.read(smsPermissionProvider).hasPermission();
    if (mounted) setState(() => _permissionGranted = granted);
  }

  Future<void> _grantPermission() async {
    setState(() {
      _permissionBusy = true;
      _error = null;
    });

    final granted =
        await ref.read(smsPermissionProvider).requestPermission();

    if (!mounted) return;

    setState(() {
      _permissionGranted = granted;
      _permissionBusy = false;
    });
  }

  DateTime _fromDate() {
    final now = DateTime.now();
    return switch (_range) {
      SmsImportRange.today => DateTime(now.year, now.month, now.day),
      SmsImportRange.monthToDate => DateTime(now.year, now.month),
      SmsImportRange.custom =>
        _customDate ?? DateTime(now.year, now.month, now.day),
      SmsImportRange.everything => DateTime(1970),
    };
  }

  Future<void> _pickCustomDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _customDate = picked);
  }

  Future<void> _startImport() async {
    setState(() {
      _importing = true;
      _error = null;
    });

    try {
      final service = ref.read(smsImportServiceProvider);
      final result = await service.importMessages(from: _fromDate());

      if (!mounted) return;
      setState(() {
        _importing = false;
        _result = result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _importing = false;
        _error = 'Import failed. Please try again.';
      });
    }
  }

  void _done() => context.go('/dashboard');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import SMS')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final result = _result;
    if (result != null) return _summary(context, result);

    if (_importing) {
      return const Column(
        children: [
          SizedBox(height: 48),
          LinearProgressIndicator(),
          SizedBox(height: 16),
          Text('Importing Mobile Money messages…'),
        ],
      );
    }

    if (!_permissionGranted) {
      return _permissionPrompt(context);
    }

    return _rangeSelection(context);
  }

  Widget _permissionPrompt(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        const Icon(
          Icons.sms_outlined,
          size: 64,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome to FloatWise!',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          "Let's import your Mobile Money transactions.",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'FloatWise reads messages in the background of this app only. '
          'Only Mobile Money messages are kept, and they stay on your '
          'device unless you enable sync.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.error),
          ),
        ],
        const SizedBox(height: 32),
        FilledButton(
          onPressed: _permissionBusy ? null : _grantPermission,
          child: _permissionBusy
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Grant SMS Permission'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _permissionBusy ? null : _done,
          child: const Text('Skip for now'),
        ),
      ],
    );
  }

  Widget _rangeSelection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text(
          'Welcome to FloatWise! Let’s import your Mobile Money transactions.',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        Text(
          'Choose import range',
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        RadioGroup<SmsImportRange>(
          groupValue: _range,
          onChanged: (value) {
            if (value == null) return;
            setState(() => _range = value);
            if (value == SmsImportRange.custom) {
              _pickCustomDate();
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final range in SmsImportRange.values)
                RadioListTile<SmsImportRange>(
                  value: range,
                  title: Text(range.label),
                  subtitle: Text(range.description),
                ),
            ],
          ),
        ),
        if (_range == SmsImportRange.custom && _customDate != null)
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 16, bottom: 8),
            child: Text(
              'Starting: ${_customDate.toString().split(' ').first}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.error),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _importing ? null : _startImport,
          child: const Text('Start Import'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _importing ? null : _done,
          child: const Text('Skip for now'),
        ),
      ],
    );
  }

  Widget _summary(BuildContext context, ImportResult result) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        const Icon(
          Icons.check_circle_outline,
          size: 64,
          color: AppColors.success,
        ),
        const SizedBox(height: 16),
        Text(
          'Import Complete',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        _StatRow(label: 'Messages Scanned', value: result.messagesScanned),
        _StatRow(label: 'Relevant Messages', value: result.relevantMessages),
        _StatRow(
          label: 'Imported',
          value: result.imported,
          emphasized: true,
        ),
        _StatRow(
          label: 'Duplicates Skipped',
          value: result.duplicatesSkipped,
        ),
        const SizedBox(height: 24),
        Text(
          'Ready for parsing.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: _done,
          child: const Text('Done'),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final int value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value.toString(),
            style: (emphasized ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium)
                ?.copyWith(
              fontWeight: emphasized ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}