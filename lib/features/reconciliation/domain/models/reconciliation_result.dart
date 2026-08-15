enum ReconciliationStatus { balanced, short, excess, unresolved }

class ReconciliationResult {
  const ReconciliationResult({
    required this.expectedCash,
    required this.expectedFloat,
    required this.actualCash,
    required this.actualFloat,
    required this.cashDifference,
    required this.floatDifference,
    required this.overallDifference,
    required this.status,
  });

  final double expectedCash;

  final double expectedFloat;

  final double actualCash;

  final double actualFloat;

  final double cashDifference;

  final double floatDifference;

  final double overallDifference;

  final ReconciliationStatus status;
}
