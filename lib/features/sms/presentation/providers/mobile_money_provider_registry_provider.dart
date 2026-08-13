import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/airteltigo_provider.dart';
import '../../data/providers/mtn_provider.dart';
import '../../data/providers/telecel_provider.dart';
import '../../domain/providers/mobile_money_provider_registry.dart';

final mobileMoneyProviderRegistryProvider =
    Provider<MobileMoneyProviderRegistry>((ref) {
      return MobileMoneyProviderRegistry([
        MtnProvider(),
        TelecelProvider(),
        AirtelTigoProvider(),
      ]);
    });
