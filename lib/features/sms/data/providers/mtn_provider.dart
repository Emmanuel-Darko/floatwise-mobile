import '../../../../shared/enums/mobile_network.dart';
import '../../domain/providers/mobile_money_provider.dart';
import 'provider_message_utils.dart';

class MtnProvider implements MobileMoneyProviderDefinition {
  @override
  MobileNetwork get provider => MobileNetwork.mtn;

  @override
  String get label => 'MTN';

  @override
  List<String> get knownSenders => const ['MTN MoMo', 'MTN Momo', 'MoMo'];

  @override
  bool matchesSender(String sender) {
    final normalized = sender.trim().toLowerCase();

    return normalized.contains('mtn') || normalized.contains('momo');
  }

  @override
  bool matchesMessage(String message) {
    final normalized = message.toLowerCase();

    return normalized.contains('momo') || normalized.contains('mobile money');
  }

  @override
  bool isSupportedMessage(String message) {
    return matchesMessage(message) &&
        ProviderMessageUtils.looksLikeTransaction(message);
  }
}
