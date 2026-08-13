import '../../../../shared/enums/mobile_network.dart';
import '../../domain/providers/mobile_money_provider.dart';

class TelecelProvider implements MobileMoneyProviderDefinition {
  @override
  MobileNetwork get provider => MobileNetwork.telecel;

  @override
  bool matchesSender(String sender) {
    final normalized = sender.trim().toLowerCase();

    return normalized.contains('telecel') || normalized.contains('vodafone');
  }

  @override
  bool matchesMessage(String message) {
    final normalized = message.toLowerCase();

    return normalized.contains('telecel cash') ||
        normalized.contains('vodafone cash');
  }

  @override
  bool isSupportedMessage(String message) {
    return matchesMessage(message);
  }
}
