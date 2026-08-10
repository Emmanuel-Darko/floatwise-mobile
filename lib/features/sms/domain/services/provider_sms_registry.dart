import '../../../../shared/enums/mobile_network.dart';

class ProviderSmsRegistry {
  const ProviderSmsRegistry();

  static const Map<MobileNetwork, List<String>> _senderAliases = {
    MobileNetwork.mtn: [
      'mtn momo',
      'mtn mobile money',
      'momo',
      'mtn',
    ],
    MobileNetwork.telecel: [
      'telecel cash',
      'telecel money',
      'telecel',
    ],
    MobileNetwork.airteltigo: [
      'at money',
      'airteltigo',
      'airtel tigo',
      'airteltigo money',
    ],
  };

  bool isSupported(String? sender) {
    if (sender == null || sender.trim().isEmpty) return false;

    final normalized = sender.toLowerCase().trim();

    return _senderAliases.values.any(
      (aliases) => aliases.any(normalized.contains),
    );
  }

  MobileNetwork? networkFor(String? sender) {
    if (sender == null || sender.trim().isEmpty) return null;

    final normalized = sender.toLowerCase().trim();

    for (final entry in _senderAliases.entries) {
      if (entry.value.any(normalized.contains)) {
        return entry.key;
      }
    }

    return null;
  }
}