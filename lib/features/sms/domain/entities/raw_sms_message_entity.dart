class RawSmsMessageEntity {
  const RawSmsMessageEntity({
    required this.id,
    required this.sender,
    required this.body,
    required this.receivedAt,
    required this.importedAt,
    required this.smsHash,
    required this.isParsed,
    this.parseError,
  });

  final String id;
  final String sender;
  final String body;
  final DateTime receivedAt;
  final DateTime importedAt;
  final String smsHash;
  final bool isParsed;
  final String? parseError;
}
