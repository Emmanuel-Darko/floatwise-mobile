class TransactionPostingResult {
  const TransactionPostingResult({
    required this.processed,
    required this.posted,
    required this.needsReview,
    required this.duplicates,
    required this.hasActiveSession,
  });

  final int processed;

  final int posted;

  final int needsReview;

  final int duplicates;

  final bool hasActiveSession;
}
