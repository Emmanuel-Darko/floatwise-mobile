import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:floatwise/core/database/app_database.dart';
import 'package:floatwise/features/sms/data/providers/airteltigo_provider.dart';
import 'package:floatwise/features/sms/data/providers/mtn_provider.dart';
import 'package:floatwise/features/sms/data/providers/telecel_provider.dart';
import 'package:floatwise/features/sms/data/services/sms_import_service_impl.dart';
import 'package:floatwise/features/sms/domain/providers/mobile_money_provider_registry.dart';
import 'package:floatwise/features/sms/domain/services/device_sms_reader.dart';
import 'package:floatwise/features/sms/domain/services/sms_import_service.dart';
import 'package:floatwise/shared/enums/mobile_network.dart';

class FakeReader implements DeviceSmsReader {
  FakeReader(this.messages);

  final List<DeviceSmsMessage> messages;

  Set<String>? lastUsedAddresses;

  @override
  Future<List<DeviceSmsMessage>> readMessages({
    required DateTime from,
    Set<String>? senderAddresses,
  }) async {
    lastUsedAddresses = senderAddresses;
    return messages;
  }
}

void main() {
  late AppDatabase database;
  late FakeReader reader;
  late SmsImportService service;
  late MobileMoneyProviderRegistry registry;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    registry = MobileMoneyProviderRegistry([
      MtnProvider(),
      TelecelProvider(),
      AirtelTigoProvider(),
    ]);
  });

  tearDown(() async {
    await database.close();
  });

  test('discovers distinct relevant senders from the inbox', () async {
    reader = FakeReader([
      DeviceSmsMessage(
        sender: 'MTN Momo',
        body:
            'Momo: You have received GHS 150.00 from Kwame Boateng '
            '(0241000000). Transaction ID: XKW7QPLR2M',
        receivedAt: DateTime(2026, 8, 15, 10),
      ),
      DeviceSmsMessage(
        sender: 'MTN Momo',
        body:
            'Momo: You have sent GHS 40.00 to Ama Serwaa (0552000000). '
            'Transaction ID: XKW7QPLR2N',
        receivedAt: DateTime(2026, 8, 15, 11),
      ),
      DeviceSmsMessage(
        sender: 'Telecel Cash',
        body:
            'Telecel Cash: Cash withdrawn. GHS 100.00. New balance GHS 120.00.',
        receivedAt: DateTime(2026, 8, 15, 12),
      ),
      DeviceSmsMessage(
        sender: 'Ghost Bank',
        body: 'Your OTP for login is 123456.',
        receivedAt: DateTime(2026, 8, 15, 10),
      ),
    ]);
    service = SmsImportServiceImpl(
      reader: reader,
      registry: registry,
      rawSmsMessageDao: database.rawSmsMessageDao,
    );

    final result = await service.discoverSenders(from: DateTime(2026, 1, 1));

    expect(result.messages.length, 4);
    expect(
      result.senders.map((s) => s.sender),
      containsAll(<String>['MTN Momo', 'Telecel Cash']),
    );
    expect(result.senders, isNot(contains('Ghost Bank')));
    expect(
      result.senders.firstWhere((s) => s.sender == 'MTN Momo').provider,
      MobileNetwork.mtn,
    );
  });

  test('imports only messages from selected senders', () async {
    reader = FakeReader([
      DeviceSmsMessage(
        sender: 'MTN Momo',
        body:
            'Momo: You have received GHS 150.00 from Kwame Boateng '
            '(0241000000). Transaction ID: XKW7QPLR2M',
        receivedAt: DateTime(2026, 8, 15, 10),
      ),
      DeviceSmsMessage(
        sender: 'Telecel Cash',
        body:
            'Telecel Cash: Cash withdrawn. GHS 100.00. New balance GHS 120.00.',
        receivedAt: DateTime(2026, 8, 15, 12),
      ),
      DeviceSmsMessage(
        sender: 'MTN Momo',
        body: 'MTN: Win with MoMo. Dial *170# to play. T&Cs apply.',
        receivedAt: DateTime(2026, 8, 15, 10),
      ),
    ]);
    service = SmsImportServiceImpl(
      reader: reader,
      registry: registry,
      rawSmsMessageDao: database.rawSmsMessageDao,
    );

    final result = await service.importMessages(
      from: DateTime(2026, 1, 1),
      senderAddresses: const {'MTN Momo'},
    );

    expect(result.scanned, 3);
    expect(result.relevant, 1);
    expect(result.imported, 1);
    expect(result.duplicates, 0);
  });

  test('skips duplicate messages by hash', () async {
    reader = FakeReader([
      DeviceSmsMessage(
        sender: 'MTN Momo',
        body:
            'Momo: You have sent GHS 40.00 to Ama Serwaa (0552000000). '
            'Transaction ID: XKW7QPLR2M',
        receivedAt: DateTime(2026, 8, 15, 10),
      ),
    ]);
    service = SmsImportServiceImpl(
      reader: reader,
      registry: registry,
      rawSmsMessageDao: database.rawSmsMessageDao,
    );

    final first = await service.importMessages(
      from: DateTime(2026, 1, 1),
      senderAddresses: const {'MTN Momo'},
    );
    final second = await service.importMessages(
      from: DateTime(2026, 1, 1),
      senderAddresses: const {'MTN Momo'},
    );

    expect(first.imported, 1);
    expect(second.imported, 0);
    expect(second.duplicates, 1);
  });
}
