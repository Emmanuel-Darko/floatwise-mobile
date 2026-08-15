class SmsImportResult {
  const SmsImportResult({
    required this.scanned,
    required this.imported,
    required this.duplicates,
  });

  final int scanned;
  final int imported;
  final int duplicates;
}
