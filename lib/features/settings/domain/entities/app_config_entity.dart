class AppConfigEntity {
  const AppConfigEntity({
    required this.hasCompletedSetup,
    required this.currentBusinessId,
    required this.currentBranchId,
    required this.currentTillId,
  });

  final bool hasCompletedSetup;

  final String? currentBusinessId;

  final String? currentBranchId;

  final String? currentTillId;
}
