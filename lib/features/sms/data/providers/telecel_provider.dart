import '../../../../shared/enums/mobile_network.dart';
import '../../domain/providers/mobile_money_provider.dart';
import 'provider_message_utils.dart';

class TelecelProvider implements MobileMoneyProviderDefinition {
  @override
  MobileNetwork get provider => MobileNetwork.telecel;

  @override
  String get label => 'Telecel';

  @override
  List<String> get knownSenders => const [
    'Telecel',
    'Telecel Cash',
    'Telecel Money',
    'Vodafone',
    'Vodafone Cash',
  ];

  @override
  bool matchesSender(String sender) {
    final normalized = sender.trim().toLowerCase();

    return normalized.contains('telecel') ||
        normalized.contains('telecelcash') ||
        normalized.contains('vodafone');
  }

  @override
  bool matchesMessage(String message) {
    final normalized = message.toLowerCase();

    return normalized.contains('telecel cash') ||
        normalized.contains('vodafone cash');
  }

  @override
  bool isSupportedMessage(String message) {
    return matchesMessage(message) &&
        ProviderMessageUtils.looksLikeTransaction(message);
  }
}
