import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/dao/raw_sms_message_dao.dart';
import '../../domain/models/discovered_sender.dart';
import '../../domain/models/sms_discovery_result.dart';
import '../../domain/models/sms_import_result.dart';
import '../../domain/providers/mobile_money_provider_registry.dart';
import '../../domain/services/device_sms_reader.dart';
import '../../domain/services/sms_import_service.dart';
import '../../../../shared/enums/mobile_network.dart';

class SmsImportServiceImpl implements SmsImportService {
  SmsImportServiceImpl({
    required this.reader,
    required this.registry,
    required this.rawSmsMessageDao,
  });

  final DeviceSmsReader reader;
  final MobileMoneyProviderRegistry registry;
  final RawSmsMessageDao rawSmsMessageDao;

  @override
  Future<SmsDiscoveryResult> discoverSenders({required DateTime from}) async {
    final messages = await reader.readMessages(from: from);

    final sendersByAddress = <String, MobileNetwork>{};
    for (final message in messages) {
      final provider = registry.identify(
        sender: message.sender,
        message: message.body,
      );
      if (provider == null) continue;

      sendersByAddress.putIfAbsent(
        message.sender.trim(),
        () => provider.provider,
      );
    }

    final senders = sendersByAddress.entries
        .map(
          (entry) => DiscoveredSender(sender: entry.key, provider: entry.value),
        )
        .toList();

    return SmsDiscoveryResult(messages: messages, senders: senders);
  }

  @override
  Future<SmsImportResult> importMessages({
    required DateTime from,
    required Iterable<String> senderAddresses,
  }) async {
    final selected = senderAddresses.toSet();
    final messages = await reader.readMessages(from: from);

    const uuid = Uuid();
    final now = DateTime.now();

    var relevant = 0;
    var imported = 0;
    var duplicates = 0;

    for (final message in messages) {
      if (!selected.contains(message.sender.trim())) continue;

      final provider = registry.identify(
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

      if (await rawSmsMessageDao.existsByHash(hash)) {
        duplicates++;
        continue;
      }

      await rawSmsMessageDao.insertMessage(
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
