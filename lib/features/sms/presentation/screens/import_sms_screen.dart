import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/models/sms_import_result.dart';
import '../../domain/models/sms_parse_result.dart';
import '../providers/sms_import_provider.dart';
import '../providers/sms_parse_service_provider.dart';
import '../providers/sms_permission_provider.dart';

enum SmsImportRange {
  today('Today'),
  monthToDate('Start of this month'),
  custom('Custom date'),
  everything('Everything available');

  const SmsImportRange(this.label);

  final String label;
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
  SmsImportResult? _result;
  SmsParseResult? _parseResult;
  SmsImportRange _range = SmsImportRange.today;
  DateTime? _customDate;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final granted = await ref.read(smsPermissionProvider).hasPermission();
    if (mounted) setState(() => _permissionGranted = granted);
  }

  Future<void> _grantPermission() async {
    setState(() {
      _permissionBusy = true;
      _error = null;
    });

    final granted = await ref.read(smsPermissionProvider).requestPermission();

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

      SmsParseResult? parseResult;
      try {
        parseResult = await ref
            .read(smsParseServiceProvider)
            .parsePendingMessages();
      } catch (parseError) {
        parseResult = null;
      }

      if (!mounted) return;
      setState(() {
        _importing = false;
        _result = result;
        _parseResult = parseResult;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _importing = false;
        _error = 'Import failed. Please try again.';
      });
    }
  }

  void _continue() => context.go('/dashboard');

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
    if (result != null) {
      return _summary(context, result, _parseResult);
    }

    if (_importing) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 48),
          LinearProgressIndicator(),
          SizedBox(height: 24),
          Text('Importing messages…'),
          SizedBox(height: 4),
          Text('Scanning SMS…'),
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
        const Icon(Icons.sms_outlined, size: 64, color: AppColors.primary),
        const SizedBox(height: 16),
        Text(
          'Import Mobile Money SMS',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'FloatWise needs access to your messages to import your '
          'Mobile Money transactions. Messages stay on your device unless '
          'you enable sync.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
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
          onPressed: _permissionBusy ? null : _continue,
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
        Text('Import Mobile Money SMS', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          'Choose when to start tracking',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
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
          child: const Text('Import SMS'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _importing ? null : _continue,
          child: const Text('Skip for now'),
        ),
      ],
    );
  }

  Widget _summary(
    BuildContext context,
    SmsImportResult result,
    SmsParseResult? parseResult,
  ) {
    final theme = Theme.of(context);
    final number = NumberFormat.decimalPattern();

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
        _StatRow(label: 'scanned', value: number.format(result.scanned)),
        _StatRow(label: 'relevant', value: number.format(result.relevant)),
        _StatRow(
          label: 'imported',
          value: number.format(result.imported),
          emphasized: true,
        ),
        _StatRow(
          label: 'duplicates skipped',
          value: number.format(result.duplicates),
        ),
        if (parseResult != null) ...[
          const Divider(height: 32),
          _StatRow(
            label: 'parsed',
            value: number.format(parseResult.parsed),
            emphasized: true,
          ),
          _StatRow(
            label: 'need attention',
            value: number.format(parseResult.failed),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          parseResult == null
              ? 'Ready for parsing.'
              : 'Transactions are ready for verification.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        FilledButton(onPressed: _continue, child: const Text('Continue')),
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
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            value,
            style:
                (emphasized
                        ? theme.textTheme.titleMedium
                        : theme.textTheme.bodyLarge)
                    ?.copyWith(
                      fontWeight: emphasized
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
