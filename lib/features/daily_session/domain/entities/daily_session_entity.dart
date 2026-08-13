enum SessionStatus { open, closed }

class DailySessionEntity {
  const DailySessionEntity({
    required this.id,
    required this.tillId,
    required this.openingCash,
    required this.openingFloat,
    required this.status,
    required this.openedAt,
    this.closedAt,
    this.closingCash,
    this.closingFloat,
  });

  final String id;
  final String tillId;

  final double openingCash;
  final double openingFloat;

  final double? closingCash;
  final double? closingFloat;

  final SessionStatus status;

  final DateTime openedAt;
  final DateTime? closedAt;
}
