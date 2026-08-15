import '../../../../shared/enums/mobile_network.dart';

abstract interface class MobileMoneyProviderDefinition {
  MobileNetwork get provider;

  String get label;

  List<String> get knownSenders;

  bool matchesSender(String sender);

  bool matchesMessage(String message);

  bool isSupportedMessage(String message);
}
