import '../../../../shared/enums/mobile_network.dart';
import '../../../../shared/enums/transaction_type.dart';
import '../../domain/entities/parsed_transaction.dart';
import '../../domain/entities/raw_sms_message_entity.dart';
import '../../domain/services/sms_parser.dart';
import 'sms_parse_utils.dart';

class AirtelTigoSmsParser implements SmsParser {
  @override
  MobileNetwork get network => MobileNetwork.airteltigo;

  @override
  ParsedTransaction? parse(RawSmsMessageEntity message) {
    final body = message.body;

    if (SmsParseUtils.isReversal(body)) {
      return SmsParseUtils.build(network, TransactionType.reversal, message);
    }

    if (SmsParseUtils.isCashIn(body)) {
      return SmsParseUtils.build(network, TransactionType.cashIn, message);
    }

    if (SmsParseUtils.isCashOut(body)) {
      return SmsParseUtils.build(network, TransactionType.cashOut, message);
    }

    if (SmsParseUtils.isTransfer(body)) {
      return SmsParseUtils.build(network, TransactionType.transfer, message);
    }

    return null;
  }
}
