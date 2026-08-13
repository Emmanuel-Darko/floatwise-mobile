import '../../../../shared/enums/mobile_network.dart';
import '../entities/parsed_transaction.dart';
import '../entities/raw_sms_message_entity.dart';

abstract interface class SmsParser {
  MobileNetwork get network;

  ParsedTransaction? parse(RawSmsMessageEntity message);
}
