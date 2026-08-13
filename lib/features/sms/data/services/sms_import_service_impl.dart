import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/dao/raw_sms_message_dao.dart';
import '../../domain/models/sms_import_result.dart';
import '../../domain/providers/mobile_money_provider_registry.dart';
import '../../domain/services/device_sms_reader.dart';
import '../../domain/services/sms_import_service.dart';

class SmsImportServiceImpl implements SmsImportService {
  SmsImportServiceImpl({
    required this._reader,
    required this._registry,
    required this._rawSmsMessageDao,
  });

  final DeviceSmsReader _reader;
  final MobileMoneyProviderRegistry _registry;
  final RawSmsMessageDao _rawSmsMessageDao;

  @override
  Future<SmsImportResult> importMessages({required DateTime from}) async {
    final messages = await _reader.readMessages(from: from);

    const uuid = Uuid();
    final now = DateTime.now();

    var relevant = 0;
    var imported = 0;
    var duplicates = 0;

    for (final message in messages) {
      final provider = _registry.identify(
        sender: message.sender,
        message: message.body,
      );

      if (provider == null) continue;

      relevant++;

      final hash = _computeHash(
        sender: message.sender,
        body: message.body,
        receivedAt: message.receivedAt,
      );

      if (await _rawSmsMessageDao.existsByHash(hash)) {
        duplicates++;
        continue;
      }

      await _rawSmsMessageDao.insertMessage(
        RawSmsMessagesCompanion.insert(
          id: uuid.v4(),
          sender: message.sender,
          address: message.sender,
          body: message.body,
          receivedAt: message.receivedAt,
          importedAt: now,
          smsHash: hash,
        ),
      );

      imported++;
    }

    return SmsImportResult(
      scanned: messages.length,
      relevant: relevant,
      imported: imported,
      duplicates: duplicates,
    );
  }

  String _computeHash({
    required String sender,
    required String body,
    required DateTime receivedAt,
  }) {
    final input = '$sender|$body|${receivedAt.millisecondsSinceEpoch}';
    return sha256.convert(utf8.encode(input)).toString();
  }
}
