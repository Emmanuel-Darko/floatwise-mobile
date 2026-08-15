import '../../../../shared/enums/mobile_network.dart';

class DiscoveredSender {
  const DiscoveredSender({required this.sender, required this.provider});

  final String sender;

  final MobileNetwork provider;
}
