class SmsImportResult {
  const SmsImportResult({
    required this.scanned,
    required this.relevant,
    required this.imported,
    required this.duplicates,
  });

  final int scanned;
  final int relevant;
  final int imported;
  final int duplicates;
}
