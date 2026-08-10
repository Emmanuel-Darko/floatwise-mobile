class ImportResult {
  const ImportResult({
    required this.messagesScanned,
    required this.relevantMessages,
    required this.imported,
    required this.duplicatesSkipped,
  });

  final int messagesScanned;
  final int relevantMessages;
  final int imported;
  final int duplicatesSkipped;
}

abstract interface class SmsImportService {
  Future<ImportResult> importMessages({
    required DateTime from,
  });
}