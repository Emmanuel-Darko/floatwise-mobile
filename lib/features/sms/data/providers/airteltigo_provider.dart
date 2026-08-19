import '../../../../shared/enums/mobile_network.dart';
import '../../domain/providers/mobile_money_provider.dart';
import 'provider_message_utils.dart';

class AirtelTigoProvider implements MobileMoneyProviderDefinition {
  @override
  MobileNetwork get provider => MobileNetwork.airteltigo;

  @override
  String get label => 'AirtelTigo';

  @override
  List<String> get knownSenders => const [
    'AirtelTigo',
    'AirtelTigo Money',
    'Airtel Money',
    'Tigo Cash',
    'AT Money',
  ];

  @override
  bool matchesSender(String sender) {
    final normalized = sender.trim().toLowerCase();

    return normalized.contains('airteltigo') ||
        normalized.contains('airtel') ||
        normalized.contains('tigo') ||
        normalized.contains('at money');
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
    return matchesMessage(message) &&
        ProviderMessageUtils.looksLikeTransaction(message);
  }
}
