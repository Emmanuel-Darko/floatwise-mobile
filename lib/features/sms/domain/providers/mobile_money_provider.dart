import '../../../../shared/enums/mobile_network.dart';

abstract interface class MobileMoneyProviderDefinition {
  MobileNetwork get provider;

  bool matchesSender(String sender);

  bool matchesMessage(String message);

  bool isSupportedMessage(String message);
}
