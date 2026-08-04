import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../business/domain/entities/business_entity.dart';
import '../../../branch/domain/entities/branch_entity.dart';
import '../../../till/domain/entities/till_entity.dart';
import '../models/setup_state.dart';

class SetupController extends Notifier<SetupState> {
  @override
  SetupState build() => const SetupState();

  void updateBusiness(BusinessEntity business) {
    state = state.copyWith(business: business);
  }

  void updateBranch(BranchEntity branch) {
    state = state.copyWith(branch: branch);
  }

  void updateTill(TillEntity till) {
    state = state.copyWith(till: till);
  }

  void updateOpeningBalances({
    required double cash,
    required double floatBalance,
  }) {
    state = state.copyWith(
      openingCash: cash,
      openingFloat: floatBalance,
    );
  }
}