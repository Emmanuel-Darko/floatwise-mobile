import '../../../../shared/enums/mobile_network.dart';
import '../../domain/providers/mobile_money_provider.dart';

class AirtelTigoProvider implements MobileMoneyProviderDefinition {
  @override
  MobileNetwork get provider => MobileNetwork.airteltigo;

  @override
  bool matchesSender(String sender) {
    final normalized = sender.trim().toLowerCase();

    return normalized.contains('airteltigo') ||
        normalized.contains('airtel') ||
        normalized.contains('tigo');
  }

  @override
  bool matchesMessage(String message) {
    final normalized = message.toLowerCase();

    return normalized.contains('airteltigo') ||
        normalized.contains('airtel money') ||
        normalized.contains('tigo cash');
  }

  @override
  bool isSupportedMessage(String message) {
    return matchesMessage(message);
  }
}
