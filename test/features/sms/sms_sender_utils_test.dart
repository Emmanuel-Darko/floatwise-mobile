import 'package:flutter_test/flutter_test.dart';
import 'package:floatwise/features/sms/data/providers/sms_sender_utils.dart';

void main() {
  group('SmsSenderUtils.isNamedSender', () {
    test('accepts named senders', () {
      expect(SmsSenderUtils.isNamedSender('MTN Momo'), isTrue);
      expect(SmsSenderUtils.isNamedSender('MobileMoney'), isTrue);
      expect(SmsSenderUtils.isNamedSender('Telecel Cash'), isTrue);
      expect(SmsSenderUtils.isNamedSender('AirtelTigo Money'), isTrue);
      expect(SmsSenderUtils.isNamedSender('Ghost Bank'), isTrue);
    });

    test('rejects numeric, phone, and shortcode senders', () {
      expect(SmsSenderUtils.isNamedSender('0241000000'), isFalse);
      expect(SmsSenderUtils.isNamedSender('+233241000000'), isFalse);
      expect(SmsSenderUtils.isNamedSender('*170#'), isFalse);
      expect(SmsSenderUtils.isNamedSender('1234'), isFalse);
      expect(SmsSenderUtils.isNamedSender(''), isFalse);
      expect(SmsSenderUtils.isNamedSender('   '), isFalse);
    });
  });
}
