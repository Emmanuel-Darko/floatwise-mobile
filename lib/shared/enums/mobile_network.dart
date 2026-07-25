enum MobileNetwork {
  mtn,
  telecel,
  airteltigo,
}

extension MobileNetworkExtension on MobileNetwork {
  String get displayName {
    switch (this) {
      case MobileNetwork.mtn:
        return 'MTN Mobile Money';
      case MobileNetwork.telecel:
        return 'Telecel Cash';
      case MobileNetwork.airteltigo:
        return 'AT Money';
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
    }
  }
}