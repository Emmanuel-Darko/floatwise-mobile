import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/theme/app_colors.dart';
import '../providers/sms_permission_provider.dart';

class SmsPermissionScreen extends ConsumerStatefulWidget {
  const SmsPermissionScreen({super.key});

  @override
  ConsumerState<SmsPermissionScreen> createState() =>
      _SmsPermissionScreenState();
}

class _SmsPermissionScreenState extends ConsumerState<SmsPermissionScreen> {
  bool _busy = false;
  bool _denied = false;

  Future<void> _grantPermission() async {
    setState(() {
      _busy = true;
      _denied = false;
    });

    final service = ref.read(smsPermissionProvider);
    final granted = await service.requestPermission();

    if (!mounted) return;

    if (granted) {
      context.go('/sms/import');
      return;
    }

    final status = await Permission.sms.status;

    if (!mounted) return;

    if (status.isPermanentlyDenied) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Permission Blocked'),
          content: const Text(
            'SMS access was blocked. Please enable it in your app settings to import messages.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Not Now'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    } else {
      setState(() => _denied = true);
    }

    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('SMS Access')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(
                Icons.sms_outlined,
                size: 72,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Let FloatWise read your messages',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'FloatWise needs access to your messages so it can automatically record your Mobile Money transactions.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              const _TrustPoint(
                icon: Icons.verified_user_outlined,
                title: 'Mobile Money only',
                subtitle:
                    'Only Mobile Money messages are processed. Everything else is ignored.',
              ),
              const SizedBox(height: 16),
              const _TrustPoint(
                icon: Icons.shield_outlined,
                title: 'Stays on your device',
                subtitle:
                    'Messages are stored locally unless you choose to enable sync.',
              ),
              const SizedBox(height: 16),
              const _TrustPoint(
                icon: Icons.settings_accessibility_outlined,
                title: 'You stay in control',
                subtitle:
                    'You can revoke access at any time from your device settings.',
              ),
              if (_denied) ...[
                const SizedBox(height: 16),
                Text(
                  'Permission was not granted. Try again or open settings to enable access.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
              const Spacer(),
              FilledButton(
                onPressed: _busy ? null : _grantPermission,
                child: _busy
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Grant Access'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _busy ? null : () => context.go('/dashboard'),
                child: const Text('Not Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustPoint extends StatelessWidget {
  const _TrustPoint({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}