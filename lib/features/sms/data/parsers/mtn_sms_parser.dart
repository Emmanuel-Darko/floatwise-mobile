import '../../../../shared/enums/mobile_network.dart';
import '../../../../shared/enums/transaction_type.dart';
import '../../domain/entities/parsed_transaction.dart';
import '../../domain/entities/raw_sms_message_entity.dart';
import '../../domain/services/sms_parser.dart';
import 'sms_parse_utils.dart';

class MtnSmsParser implements SmsParser {
  @override
  MobileNetwork get network => MobileNetwork.mtn;

  @override
  ParsedTransaction? parse(RawSmsMessageEntity message) {
    final normalized = message.body.toLowerCase();

    if (normalized.contains('revers')) {
      return SmsParseUtils.build(network, TransactionType.reversal, message);
    }

    if (normalized.contains('received')) {
      return SmsParseUtils.build(network, TransactionType.cashIn, message);
    }

    if (normalized.contains('sent')) {
      return SmsParseUtils.build(network, TransactionType.cashOut, message);
    }

    if (normalized.contains('transfer')) {
      return SmsParseUtils.build(network, TransactionType.transfer, message);
    }

    return null;
  }
}
