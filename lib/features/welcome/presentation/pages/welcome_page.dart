import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../branch/domain/entities/branch_entity.dart';
import '../../../branch/presentation/providers/branch_repository_provider.dart';
import '../../../business/data/repository/business_repository_impl.dart';
import '../../../business/domain/entities/business_entity.dart';
import '../../../daily_session/domain/entities/daily_session_entity.dart';
import '../../../daily_session/presentation/providers/daily_session_repository_provider.dart';
import '../../../../shared/enums/mobile_network.dart';
import '../../../../shared/enums/till_status.dart';
import '../../../till/domain/entities/till_entity.dart';
import '../../../till/presentation/providers/till_repository_provider.dart';

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

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    final businessRepo = ref.read(businessRepositoryProvider);
                    final branchRepo = ref.read(branchRepositoryProvider);
                    final tillRepo = ref.read(tillRepositoryProvider);
                    final sessionRepo = ref.read(dailySessionRepositoryProvider);

                    final suffix = DateTime.now().millisecondsSinceEpoch;
                    final businessId = 'biz-$suffix';
                    final branchId = 'branch-$suffix';
                    final tillId = 'till-$suffix';
                    final now = DateTime.now();

                    await businessRepo.create(
                      BusinessEntity(
                        id: businessId,
                        name: 'Test Business',
                        ownerId: 'owner-1',
                        createdAt: now,
                      ),
                    );
                    debugPrint('>>> Step 1: Business created');

                    await branchRepo.create(
                      BranchEntity(
                        id: branchId,
                        businessId: businessId,
                        name: 'Main Branch',
                        createdAt: now,
                      ),
                    );
                    debugPrint('>>> Step 2: Branch created');

                    await tillRepo.create(
                      TillEntity(
                        id: tillId,
                        branchId: branchId,
                        name: 'Till 1',
                        phoneNumber: '0240000000',
                        network: MobileNetwork.mtn,
                        status: TillStatus.active,
                        createdAt: now,
                      ),
                    );
                    debugPrint('>>> Step 3: Till created');

                    await sessionRepo.openSession(
                      DailySessionEntity(
                        id: 'sess-$suffix-1',
                        tillId: tillId,
                        openingCash: 1000,
                        openingFloat: 500,
                        status: SessionStatus.open,
                        openedAt: now,
                      ),
                    );
                    debugPrint('>>> Step 4: Session opened');

                    var duplicateRejected = false;
                    try {
                      await sessionRepo.openSession(
                        DailySessionEntity(
                          id: 'sess-$suffix-2',
                          tillId: tillId,
                          openingCash: 1000,
                          openingFloat: 500,
                          status: SessionStatus.open,
                          openedAt: now,
                        ),
                      );
                    } catch (e) {
                      if (e.toString().contains(
                            'An active session already exists',
                          )) {
                        duplicateRejected = true;
                      }
                    }
                    debugPrint(
                      '>>> Step 5: Duplicate open rejected: $duplicateRejected',
                    );

                    await sessionRepo.closeSession(
                      DailySessionEntity(
                        id: 'sess-$suffix-1',
                        tillId: tillId,
                        openingCash: 1000,
                        openingFloat: 500,
                        closingCash: 1200,
                        closingFloat: 700,
                        status: SessionStatus.closed,
                        openedAt: now,
                        closedAt: now,
                      ),
                    );
                    debugPrint('>>> Step 6: Session closed');

                    var reopened = true;
                    try {
                      await sessionRepo.openSession(
                        DailySessionEntity(
                          id: 'sess-$suffix-3',
                          tillId: tillId,
                          openingCash: 1000,
                          openingFloat: 500,
                          status: SessionStatus.open,
                          openedAt: now,
                        ),
                      );
                    } catch (e) {
                      reopened = false;
                      debugPrint('>>> Reopen failed: $e');
                    }
                    debugPrint(
                      '>>> Step 7: Reopen succeeded: $reopened',
                    );
                    debugPrint(
                      '>>> Session rule test complete: '
                      'duplicateRejected=$duplicateRejected, '
                      'reopened=$reopened',
                    );
                  },
                  child: const Text('🧪 Test Session Rule'),
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