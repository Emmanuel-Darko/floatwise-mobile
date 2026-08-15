import '../services/device_sms_reader.dart';
import 'discovered_sender.dart';

class SmsDiscoveryResult {
  const SmsDiscoveryResult({required this.messages, required this.senders});

  final List<DeviceSmsMessage> messages;

  final List<DiscoveredSender> senders;
}
