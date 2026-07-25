enum LedgerEventType {
  deposit,
  withdrawal,
 floatPurchase,
  floatSale,
 expense,
  adjustment,
  commission,
  reversal,
}

class LedgerEventEntity {
  const LedgerEventEntity({
    required this.id,
    required this.sessionId,
    required this.tillId,
    required this.type,
    required this.cashDelta,
    required this.floatDelta,
    required this.commissionDelta,
    required this.createdAt,
    this.providerTransactionId,
    this.note,
  });

  final String id;

  final String sessionId;

  final String tillId;

  final LedgerEventType type;

  final double cashDelta;

  final double floatDelta;

  final double commissionDelta;

  final String? providerTransactionId;

  final String? note;

  final DateTime createdAt;
}