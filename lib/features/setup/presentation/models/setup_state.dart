import '../../../business/domain/entities/business_entity.dart';
import '../../../branch/domain/entities/branch_entity.dart';
import '../../../till/domain/entities/till_entity.dart';

class SetupState {
  const SetupState({
    this.business,
    this.branch,
    this.till,
    this.openingCash,
    this.openingFloat,
  });

  final BusinessEntity? business;
  final BranchEntity? branch;
  final TillEntity? till;

  final double? openingCash;
  final double? openingFloat;

  SetupState copyWith({
    BusinessEntity? business,
    BranchEntity? branch,
    TillEntity? till,
    double? openingCash,
    double? openingFloat,
  }) {
    return SetupState(
      business: business ?? this.business,
      branch: branch ?? this.branch,
      till: till ?? this.till,
      openingCash: openingCash ?? this.openingCash,
      openingFloat: openingFloat ?? this.openingFloat,
    );
  }
}