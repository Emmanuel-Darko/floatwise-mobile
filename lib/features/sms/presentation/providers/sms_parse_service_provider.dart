import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/parsers/airteltigo_sms_parser.dart';
import '../../data/parsers/mtn_sms_parser.dart';
import '../../data/parsers/telecel_sms_parser.dart';
import '../../data/services/sms_parse_service_impl.dart';
import '../../domain/providers/sms_parser_registry.dart';
import '../../domain/services/sms_parse_service.dart';
import 'mobile_money_provider_registry_provider.dart';

final smsParseServiceProvider = Provider<SmsParseService>((ref) {
  final database = ref.watch(databaseProvider);

  return SmsParseServiceImpl(
    rawSmsMessageDao: database.rawSmsMessageDao,
    providerRegistry: ref.watch(mobileMoneyProviderRegistryProvider),
    parserRegistry: SmsParserRegistry([
      MtnSmsParser(),
      TelecelSmsParser(),
      AirtelTigoSmsParser(),
    ]),
  );
});
