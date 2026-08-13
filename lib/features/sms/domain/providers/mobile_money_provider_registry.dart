import 'mobile_money_provider.dart';

class MobileMoneyProviderRegistry {
  MobileMoneyProviderRegistry(Iterable<MobileMoneyProviderDefinition> providers)
    : _providers = List<MobileMoneyProviderDefinition>.unmodifiable(providers);

  final List<MobileMoneyProviderDefinition> _providers;

  MobileMoneyProviderDefinition? identify({
    required String sender,
    required String message,
  }) {
    for (final provider in _providers) {
      if (provider.matchesSender(sender) &&
          provider.isSupportedMessage(message)) {
        return provider;
      }
    }

    return null;
  }

  List<MobileMoneyProviderDefinition> get providers =>
      List.unmodifiable(_providers);
}
