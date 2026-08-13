enum MobileNetwork { mtn, telecel, airteltigo, unknown }

extension MobileNetworkExtension on MobileNetwork {
  String get displayName {
    switch (this) {
      case MobileNetwork.mtn:
        return 'MTN Mobile Money';
      case MobileNetwork.telecel:
        return 'Telecel Cash';
      case MobileNetwork.airteltigo:
        return 'AT Money';
      case MobileNetwork.unknown:
        return 'Unknown';
    }
  }

  String get shortName {
    switch (this) {
      case MobileNetwork.mtn:
        return 'MTN';
      case MobileNetwork.telecel:
        return 'Telecel';
      case MobileNetwork.airteltigo:
        return 'AT';
      case MobileNetwork.unknown:
        return '—';
    }
  }
}
