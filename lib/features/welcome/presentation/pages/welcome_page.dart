import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_balance_wallet_rounded,
                size: 90,
                color: AppColors.primary,
              ),

              const SizedBox(height: AppSpacing.xl),

              Text(
                'FloatWise',
                style: theme.textTheme.headlineMedium,
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Know your cash.\nTrust your float.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    // Next story: Setup Wizard
                  },
                  child: const Text('Get Started'),
                ),
              ),

              const Spacer(),

              Text(
                'Version 1.0.0',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}