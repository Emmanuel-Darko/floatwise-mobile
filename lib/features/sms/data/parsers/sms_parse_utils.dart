import '../../../../shared/enums/mobile_network.dart';
import '../../../../shared/enums/transaction_type.dart';
import '../../domain/entities/parsed_transaction.dart';
import '../../domain/entities/raw_sms_message_entity.dart';

class SmsParseUtils {
  SmsParseUtils._();

  static final _amountRegex = RegExp(
    r'ghs\s*([\d,]+(?:\.\d{1,2})?)',
    caseSensitive: false,
  );

  static final _balanceAfterRegex = RegExp(
    r'(?:new\s+)?balance\s*(?:is|:)?\s*ghs\s*([\d,]+(?:\.\d{1,2})?)',
    caseSensitive: false,
  );

  static final _referenceRegex = RegExp(
    r'(?:transaction\s*(?:id|no|number|ref|reference)|ref(?:erence)?|reference\s*id|txn)\s*:?\s*([a-z0-9]{6,})',
    caseSensitive: false,
  );

  static final _phoneRegex = RegExp(r'\b0[2-9]\d{8}\b');

  static bool isReversal(String text) {
    final normalized = text.toLowerCase();
    return normalized.contains('revers');
  }

  static bool isCashIn(String text) {
    final normalized = text.toLowerCase();
    if (normalized.contains('received') ||
        normalized.contains('payment received for') ||
        normalized.contains('received payment for')) {
      return true;
    }
    return false;
  }

  static bool isCashOut(String text) {
    final normalized = text.toLowerCase();
    if (normalized.contains('sent') ||
        normalized.contains('payment made for') ||
        normalized.contains('made payment for') ||
        normalized.contains('cash out') ||
        normalized.contains('cashout') ||
        normalized.contains('withdrawn')) {
      return true;
    }
    return false;
  }

  static bool isTransfer(String text) {
    return text.toLowerCase().contains('transfer');
  }

  static ParsedTransaction? build(
    MobileNetwork network,
    TransactionType type,
    RawSmsMessageEntity message,
  ) {
    final amount = amountOf(message.body);
    if (amount == null) return null;

    return ParsedTransaction(
      network: network,
      type: type,
      amount: amount,
      timestamp: message.receivedAt,
      rawSmsId: message.id,
      phoneNumber: phoneNumber(message.body),
      reference: reference(message.body),
      balanceAfter: balanceAfter(message.body),
    );
  }

  static double? amountOf(String text) {
    final match = _amountRegex.firstMatch(text);
    if (match == null) return null;

    return double.tryParse(match.group(1)!.replaceAll(',', ''));
  }

  static double? balanceAfter(String text) {
    final match = _balanceAfterRegex.firstMatch(text);
    if (match == null) return null;

    return double.tryParse(match.group(1)!.replaceAll(',', ''));
  }

  static String? reference(String text) {
    final match = _referenceRegex.firstMatch(text);
    return match?.group(1);
  }

  static String? phoneNumber(String text) {
    final match = _phoneRegex.firstMatch(text);
    return match?.group(0);
  }
}
