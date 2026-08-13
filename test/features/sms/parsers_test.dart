import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:floatwise/features/sms/data/parsers/airteltigo_sms_parser.dart';
import 'package:floatwise/features/sms/data/parsers/mtn_sms_parser.dart';
import 'package:floatwise/features/sms/data/parsers/telecel_sms_parser.dart';
import 'package:floatwise/features/sms/domain/entities/raw_sms_message_entity.dart';
import 'package:floatwise/features/sms/domain/providers/sms_parser_registry.dart';
import 'package:floatwise/features/sms/domain/services/sms_parser.dart';
import 'package:floatwise/shared/enums/mobile_network.dart';
import 'package:floatwise/shared/enums/transaction_type.dart';

RawSmsMessageEntity rawMessage({required String sender, required String body}) {
  return RawSmsMessageEntity(
    id: 'raw-${body.hashCode}',
    sender: sender,
    body: body,
    receivedAt: DateTime(2026, 8, 12, 9, 30),
    importedAt: DateTime(2026, 8, 12, 9, 35),
    smsHash: body,
    isParsed: false,
  );
}

String fixture(String relativePath) {
  return File('test/fixtures/sms/$relativePath').readAsStringSync().trim();
}

void expectParsed({
  required SmsParser parser,
  required RawSmsMessageEntity message,
  required TransactionType type,
  required double amount,
  String? reference,
  String? phoneNumber,
  double? balanceAfter,
}) {
  final result = parser.parse(message);
  expect(result, isNotNull, reason: 'Expected a parsed transaction');
  expect(result!.network, parser.network);
  expect(result.type, type);
  expect(result.amount, amount);
  expect(result.rawSmsId, message.id);
  expect(result.reference, reference);
  expect(result.phoneNumber, phoneNumber);
  expect(result.balanceAfter, balanceAfter);
}

void expectUnparsed({
  required SmsParser parser,
  required RawSmsMessageEntity message,
}) {
  expect(parser.parse(message), isNull, reason: 'Expected no transaction');
}

void main() {
  group('MtnSmsParser', () {
    final parser = MtnSmsParser();

    test('parses a cash deposit', () {
      expectParsed(
        parser: parser,
        message: rawMessage(
          sender: 'MTN Momo',
          body: fixture('mtn/mtn_deposit.txt'),
        ),
        type: TransactionType.cashIn,
        amount: 150.00,
        reference: 'XKW7QPLR2M',
        phoneNumber: '0241000000',
        balanceAfter: 850.75,
      );
    });

    test('parses a cash withdrawal', () {
      expectParsed(
        parser: parser,
        message: rawMessage(
          sender: 'MTN Momo',
          body: fixture('mtn/mtn_withdrawal.txt'),
        ),
        type: TransactionType.cashOut,
        amount: 40.00,
        reference: 'XKW7QPLR3N',
        phoneNumber: '0552000000',
        balanceAfter: 810.75,
      );
    });

    test('parses a reversal', () {
      expectParsed(
        parser: parser,
        message: rawMessage(
          sender: 'MTN Momo',
          body: fixture('mtn/mtn_reversal.txt'),
        ),
        type: TransactionType.reversal,
        amount: 40.00,
        reference: 'XKW7QPLR4P',
        phoneNumber: '0552000000',
        balanceAfter: 850.75,
      );
    });

    test('returns null for a balance notification', () {
      expectUnparsed(
        parser: parser,
        message: rawMessage(
          sender: 'MTN Momo',
          body: fixture('mtn/mtn_balance.txt'),
        ),
      );
    });

    test('returns null for a promotional message', () {
      expectUnparsed(
        parser: parser,
        message: rawMessage(sender: 'MTN', body: fixture('mtn/mtn_promo.txt')),
      );
    });

    test('returns null when the amount is missing', () {
      expectUnparsed(
        parser: parser,
        message: rawMessage(
          sender: 'MTN Momo',
          body:
              'Momo: You have received funds from Kwame Boateng. '
              'Transaction ID: XKW7QPLR5Q',
        ),
      );
    });
  });

  group('TelecelSmsParser', () {
    final parser = TelecelSmsParser();

    test('parses a cash deposit', () {
      expectParsed(
        parser: parser,
        message: rawMessage(
          sender: 'Telecel',
          body: fixture('telecel/telecel_deposit.txt'),
        ),
        type: TransactionType.cashIn,
        amount: 20.00,
        phoneNumber: '0243000000',
        balanceAfter: 240.00,
      );
    });

    test('parses a cash withdrawal', () {
      expectParsed(
        parser: parser,
        message: rawMessage(
          sender: 'Telecel',
          body: fixture('telecel/telecel_withdrawal.txt'),
        ),
        type: TransactionType.cashOut,
        amount: 20.00,
        phoneNumber: '0204000000',
        balanceAfter: 220.00,
      );
    });

    test('parses a reversal', () {
      expectParsed(
        parser: parser,
        message: rawMessage(
          sender: 'Telecel',
          body: fixture('telecel/telecel_reversal.txt'),
        ),
        type: TransactionType.reversal,
        amount: 10.00,
        phoneNumber: '0204000000',
        balanceAfter: 230.00,
      );
    });

    test('returns null for a balance notification', () {
      expectUnparsed(
        parser: parser,
        message: rawMessage(
          sender: 'Telecel',
          body: fixture('telecel/telecel_balance.txt'),
        ),
      );
    });

    test('returns null for a failed transaction', () {
      expectUnparsed(
        parser: parser,
        message: rawMessage(
          sender: 'Telecel',
          body: fixture('telecel/telecel_failed.txt'),
        ),
      );
    });
  });

  group('AirtelTigoSmsParser', () {
    final parser = AirtelTigoSmsParser();

    test('parses a cash deposit', () {
      expectParsed(
        parser: parser,
        message: rawMessage(
          sender: 'AirtelTigo',
          body: fixture('airteltigo/at_deposit.txt'),
        ),
        type: TransactionType.cashIn,
        amount: 100.00,
        reference: 'AT0012345678',
        phoneNumber: '0265000000',
        balanceAfter: 900.00,
      );
    });

    test('parses a cash withdrawal', () {
      expectParsed(
        parser: parser,
        message: rawMessage(
          sender: 'AirtelTigo',
          body: fixture('airteltigo/at_withdrawal.txt'),
        ),
        type: TransactionType.cashOut,
        amount: 50.00,
        phoneNumber: '0276000000',
        balanceAfter: 850.00,
      );
    });

    test('parses a cash out at an agent', () {
      expectParsed(
        parser: parser,
        message: rawMessage(
          sender: 'AirtelTigo',
          body: fixture('airteltigo/at_cashout.txt'),
        ),
        type: TransactionType.cashOut,
        amount: 80.00,
        balanceAfter: 770.00,
      );
    });

    test('returns null for a balance notification', () {
      expectUnparsed(
        parser: parser,
        message: rawMessage(
          sender: 'AirtelTigo',
          body: fixture('airteltigo/at_balance.txt'),
        ),
      );
    });
  });

  group('SmsParserRegistry', () {
    test('resolves a parser by network', () {
      final registry = SmsParserRegistry([
        MtnSmsParser(),
        TelecelSmsParser(),
        AirtelTigoSmsParser(),
      ]);

      expect(registry.parserFor(MobileNetwork.mtn), isA<MtnSmsParser>());
      expect(
        registry.parserFor(MobileNetwork.telecel),
        isA<TelecelSmsParser>(),
      );
      expect(
        registry.parserFor(MobileNetwork.airteltigo),
        isA<AirtelTigoSmsParser>(),
      );
      expect(registry.parserFor(MobileNetwork.unknown), isNull);
    });
  });
}
