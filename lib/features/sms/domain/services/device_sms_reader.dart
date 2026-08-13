class DeviceSmsMessage {
  const DeviceSmsMessage({
    required this.sender,
    required this.body,
    required this.receivedAt,
  });

  final String sender;
  final String body;
  final DateTime receivedAt;
}

abstract interface class DeviceSmsReader {
  Future<List<DeviceSmsMessage>> readMessages({required DateTime from});
}
