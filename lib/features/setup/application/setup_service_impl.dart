import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../branch/domain/repository/branch_repository.dart';
import '../../business/domain/repository/business_repository.dart';
import '../../daily_session/domain/entities/daily_session_entity.dart';
import '../../daily_session/domain/repository/daily_session_repository.dart';
import '../../settings/domain/entities/app_config_entity.dart';
import '../../settings/domain/repository/app_config_repository.dart';
import '../../till/domain/repository/till_repository.dart';
import '../presentation/models/setup_state.dart';
import 'setup_service.dart';

class SetupServiceImpl implements SetupService {
  SetupServiceImpl({
    required this.database,
    required this.businessRepository,
    required this.branchRepository,
    required this.tillRepository,
    required this.dailySessionRepository,
    required this.appConfigRepository,
  });

  final AppDatabase database;

  final BusinessRepository businessRepository;
  final BranchRepository branchRepository;
  final TillRepository tillRepository;
  final DailySessionRepository dailySessionRepository;
  final AppConfigRepository appConfigRepository;

  @override
  Future<void> completeSetup({required SetupState state}) async {
    final business = state.business;
    final branch = state.branch;
    final till = state.till;
    final openingCash = state.openingCash;
    final openingFloat = state.openingFloat;

    if (business == null ||
        branch == null ||
        till == null ||
        openingCash == null ||
        openingFloat == null) {
      throw Exception('Setup is incomplete.');
    }

    const uuid = Uuid();

    await database.transaction(() async {
      await businessRepository.create(business);

      await branchRepository.create(branch);

      await tillRepository.create(till);

      final session = DailySessionEntity(
        id: uuid.v4(),
        tillId: till.id,
        openingCash: openingCash,
        openingFloat: openingFloat,
        closingCash: null,
        closingFloat: null,
        status: SessionStatus.open,
        openedAt: DateTime.now(),
        closedAt: null,
      );

      await dailySessionRepository.openSession(session);

      await appConfigRepository.saveConfig(
        AppConfigEntity(
          hasCompletedSetup: true,
          currentBusinessId: business.id,
          currentBranchId: branch.id,
          currentTillId: till.id,
        ),
      );
    });
  }
}
