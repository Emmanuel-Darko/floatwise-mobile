import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/services/provider_sms_registry.dart';
import '../../domain/services/sms_import_service.dart';
import '../../domain/services/sms_permission_service.dart';

class SmsImportServiceImpl implements SmsImportService {
  SmsImportServiceImpl(
    this._database,
    this._permissionService, [
    this._registry = const ProviderSmsRegistry(),
    SmsQuery? smsQuery,
  ]) : _smsQuery = smsQuery ?? SmsQuery();

  final AppDatabase _database;
  final SmsPermissionService _permissionService;
  final ProviderSmsRegistry _registry;
  final SmsQuery _smsQuery;

  static const int _pageSize = 1000;

  @override
  Future<ImportResult> importMessages({
    required DateTime from,
  }) async {
    if (!Platform.isAndroid) {
      throw Exception('SMS import is only available on Android.');
    }

    if (!await _permissionService.hasPermission()) {
      throw Exception('SMS permission has not been granted.');
    }

    final messages = await _readInbox();

    final filtered = messages.where((message) {
      final receivedAt = message.date;
      if (receivedAt == null) return false;
      if (receivedAt.isBefore(from)) return false;
      return _registry.isSupported(message.address);
    }).toList();

    final existingHashes = await _database.rawSmsDao.getAllHashes();
    const uuid = Uuid();
    final now = DateTime.now();

    final rows = <RawSmsMessagesCompanion>[];
    var duplicatesSkipped = 0;

    for (final message in filtered) {
      final receivedAt = message.date!;
      final hash = _computeHash(
        address: message.address,
        body: message.body,
        receivedAt: receivedAt,
      );

      if (existingHashes.contains(hash)) {
        duplicatesSkipped++;
        continue;
      }

      rows.add(
        RawSmsMessagesCompanion.insert(
          id: uuid.v4(),
          sender: message.address ?? '',
          address: message.address ?? '',
          body: message.body ?? '',
          receivedAt: receivedAt,
          importedAt: now,
          smsHash: hash,
        ),
      );
    }

    await _database.rawSmsDao.insertMessages(rows);

    return ImportResult(
      messagesScanned: messages.length,
      relevantMessages: filtered.length,
      imported: rows.length,
      duplicatesSkipped: duplicatesSkipped,
    );
  }

  Future<List<SmsMessage>> _readInbox() async {
    final incoming = <SmsMessage>[];

    var start = 0;
    while (true) {
      final page = await _smsQuery.querySms(
        kinds: [SmsQueryKind.inbox],
        start: start,
        count: _pageSize,
      );

      incoming.addAll(page);

      if (page.length < _pageSize) break;

      start += _pageSize;
    }

    return incoming;
  }

  String _computeHash({
    required String? address,
    required String? body,
    required DateTime receivedAt,
  }) {
    final input = '${address ?? ''}|${body ?? ''}|'
        '${receivedAt.millisecondsSinceEpoch}';
    return sha256.convert(utf8.encode(input)).toString();
  }
}