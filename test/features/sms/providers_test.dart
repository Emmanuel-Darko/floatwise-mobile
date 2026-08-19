import 'package:flutter_test/flutter_test.dart';
import 'package:floatwise/features/sms/data/providers/airteltigo_provider.dart';
import 'package:floatwise/features/sms/data/providers/mtn_provider.dart';
import 'package:floatwise/features/sms/data/providers/telecel_provider.dart';

void main() {
  group('MtnProvider', () {
    final provider = MtnProvider();

    test('supports a deposit transaction message', () {
      expect(
        provider.isSupportedMessage(
          'Momo: You have received GHS 150.00 from Kwame (0241000000).',
        ),
        isTrue,
      );
    });

    test('excludes a promotional message', () {
      expect(
        provider.isSupportedMessage('MTN: Win with MoMo. Dial *170# to play.'),
        isFalse,
      );
    });

    test('excludes a pure balance notification', () {
      expect(
        provider.isSupportedMessage(
          'MTN Momo: Your MoMo balance is GHS 850.75.',
        ),
        isFalse,
      );
    });

    test('matches known senders', () {
      expect(provider.matchesSender('MTN Momo'), isTrue);
      expect(provider.matchesSender('MobileMoney'), isTrue);
      expect(provider.matchesSender('Mobile Money'), isTrue);
      expect(provider.matchesSender('Ghost Bank'), isFalse);
    });
  });

  group('TelecelProvider', () {
    final provider = TelecelProvider();

    test('supports a transaction message', () {
      expect(
        provider.isSupportedMessage(
          'Telecel Cash: You have received GHS 150.00 from 0241000000.',
        ),
        isTrue,
      );
    });

    test('excludes a pure balance notification', () {
      expect(
        provider.isSupportedMessage(
          'Telecel Cash: Your balance is GHS 220.00.',
        ),
        isFalse,
      );
    });
  });

  group('AirtelTigoProvider', () {
    final provider = AirtelTigoProvider();

    test('supports a transaction message', () {
      expect(
        provider.isSupportedMessage(
          'AirtelTigo Money: Cash Out successful. You have withdrawn GHS 80.00.',
        ),
        isTrue,
      );
    });

    test('excludes a pure balance notification', () {
      expect(
        provider.isSupportedMessage(
          'AirtelTigo: Your account balance is GHS 850.00.',
        ),
        isFalse,
      );
    });
  });
}
