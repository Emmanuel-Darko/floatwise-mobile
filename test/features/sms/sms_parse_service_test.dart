import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floatwise/core/database/app_database.dart';
import 'package:floatwise/features/sms/data/parsers/airteltigo_sms_parser.dart';
import 'package:floatwise/features/sms/data/parsers/mtn_sms_parser.dart';
import 'package:floatwise/features/sms/data/parsers/telecel_sms_parser.dart';
import 'package:floatwise/features/sms/data/providers/airteltigo_provider.dart';
import 'package:floatwise/features/sms/data/providers/mtn_provider.dart';
import 'package:floatwise/features/sms/data/providers/telecel_provider.dart';
import 'package:floatwise/features/sms/data/services/sms_parse_service_impl.dart';
import 'package:floatwise/features/sms/domain/providers/mobile_money_provider_registry.dart';
import 'package:floatwise/features/sms/domain/providers/sms_parser_registry.dart';

Future<void> insertRawSms({
  required AppDatabase database,
  required String id,
  required String sender,
  required String body,
  required String smsHash,
}) {
  return database.rawSmsMessageDao.insertMessage(
    RawSmsMessagesCompanion.insert(
      id: id,
      sender: sender,
      address: sender,
      body: body,
      receivedAt: DateTime(2026, 8, 12, 9, 30),
      importedAt: DateTime(2026, 8, 12, 9, 35),
      smsHash: smsHash,
    ),
  );
}

void main() {
  late AppDatabase database;

  SmsParseServiceImpl buildService() => SmsParseServiceImpl(
    rawSmsMessageDao: database.rawSmsMessageDao,
    providerRegistry: MobileMoneyProviderRegistry([
      MtnProvider(),
      TelecelProvider(),
      AirtelTigoProvider(),
    ]),
    parserRegistry: SmsParserRegistry([
      MtnSmsParser(),
      TelecelSmsParser(),
      AirtelTigoSmsParser(),
    ]),
  );

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('marks parsed messages and flags the rest', () async {
    await insertRawSms(
      database: database,
      id: 'mtn-1',
      sender: 'MTN Momo',
      body:
          'Momo: You have received GHS 150.00 from Kwame Boateng '
          '(0241000000). New Balance is GHS 850.75. '
          'Transaction ID: XKW7QPLR2M',
      smsHash: 'mtn-hash-1',
    );
    await insertRawSms(
      database: database,
      id: 'telecel-1',
      sender: 'Telecel',
      body:
          'Telecel Cash: You have sent GHS 20.00 to Efua Mensah '
          '(0204000000). Your Telecel Cash balance is GHS 220.00.',
      smsHash: 'telecel-hash-1',
    );
    await insertRawSms(
      database: database,
      id: 'at-1',
      sender: 'AirtelTigo',
      body:
          'AirtelTigo Money: Cash Out successful. You have withdrawn '
          'GHS 80.00 from your account. Available Balance GHS 770.00.',
      smsHash: 'at-hash-1',
    );
    await insertRawSms(
      database: database,
      id: 'telecel-balance',
      sender: 'Telecel',
      body: 'Telecel Cash: Your balance is GHS 220.00.',
      smsHash: 'telecel-hash-2',
    );
    await insertRawSms(
      database: database,
      id: 'telecel-failed',
      sender: 'Telecel',
      body:
          'Telecel Cash: Transaction Failed. You do not have sufficient '
          'balance for this transaction.',
      smsHash: 'telecel-hash-3',
    );

    final result = await buildService().parsePendingMessages();

    expect(result.processed, 5);
    expect(result.parsed, 3);
    expect(result.failed, 2);
    expect(result.transactions.length, 3);

    final remaining = await database.rawSmsMessageDao.getUnparsedMessages();

    expect(remaining.length, 2);
    for (final message in remaining) {
      expect(message.isParsed, isFalse);
      expect(message.parseError, isNotNull);
    }
  });

  test('is idempotent across runs', () async {
    await insertRawSms(
      database: database,
      id: 'mtn-2',
      sender: 'MTN Momo',
      body: 'Momo: You have received GHS 150.00 from Kwame Boateng.',
      smsHash: 'mtn-hash-2',
    );

    final first = await buildService().parsePendingMessages();
    final second = await buildService().parsePendingMessages();

    expect(first.processed, 1);
    expect(first.parsed, 1);
    expect(first.failed, 0);
    expect(second.processed, 0);
    expect(second.parsed, 0);
    expect(second.failed, 0);
    expect(second.transactions, isEmpty);
  });
}
