import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../business/data/repository/business_repository_impl.dart';
import '../../../business/domain/entities/business_entity.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    final repository = ref.read(businessRepositoryProvider);

                    await repository.create(
                      BusinessEntity(
                        id: 'test-${DateTime.now().millisecondsSinceEpoch}',
                        name: 'Test Business',
                        ownerId: 'owner-1',
                        createdAt: DateTime.now(),
                      ),
                    );

                    final businesses = await repository.getAll();
                    debugPrint('>>> Persistence test: ${businesses.first.name}');
                  },
                  child: const Text('🧪 Test Persistence'),
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