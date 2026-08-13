import '../entities/parsed_transaction.dart';

class SmsParseResult {
  const SmsParseResult({
    required this.processed,
    required this.parsed,
    required this.failed,
    this.transactions = const [],
  });

  final int processed;

  final int parsed;

  final int failed;

  final List<ParsedTransaction> transactions;
}
