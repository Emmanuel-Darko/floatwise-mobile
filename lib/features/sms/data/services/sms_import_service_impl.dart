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
import '../providers/sms_sender_utils.dart';

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
  Future<SmsDiscoveryResult> discoverSenders() async {
    final messages = await reader.readMessages(from: _farPast);

    final senders = <String>{};
    for (final message in messages) {
      final sender = message.sender.trim();
      if (sender.isEmpty) continue;
      if (!SmsSenderUtils.isNamedSender(sender)) continue;
      if (registry.resolveBySender(sender) == null) continue;

      senders.add(sender);
    }

    final sorted = senders.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return SmsDiscoveryResult(
      messages: messages,
      senders: sorted.map((s) => DiscoveredSender(sender: s)).toList(),
    );
  }

  @override
  Future<SmsImportResult> importMessages({
    required DateTime from,
    required Iterable<String> senderAddresses,
  }) async {
    final selected = senderAddresses
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toSet();
    final messages = await reader.readMessages(from: from);

    const uuid = Uuid();
    final now = DateTime.now();

    var scanned = 0;
    var imported = 0;
    var duplicates = 0;

    for (final message in messages) {
      if (!selected.contains(message.sender.trim())) continue;

      scanned++;

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
      scanned: scanned,
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

  static final DateTime _farPast = DateTime(1970);
}
