class SmsParseResult {
  const SmsParseResult({
    required this.processed,
    required this.parsed,
    required this.failed,
  });

  final int processed;

  final int parsed;

  final int failed;
}
