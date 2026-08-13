import 'dart:io';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';

import '../../domain/services/device_sms_reader.dart';
import '../../domain/services/sms_permission_service.dart';

class DeviceSmsReaderImpl implements DeviceSmsReader {
  DeviceSmsReaderImpl({required this._permissionService, SmsQuery? smsQuery})
    : _smsQuery = smsQuery ?? SmsQuery();

  final SmsPermissionService _permissionService;
  final SmsQuery _smsQuery;

  static const int _pageSize = 1000;

  @override
  Future<List<DeviceSmsMessage>> readMessages({required DateTime from}) async {
    if (!Platform.isAndroid) {
      throw Exception('SMS reading is only available on Android.');
    }

    if (!await _permissionService.hasPermission()) {
      throw Exception('SMS permission has not been granted.');
    }

    final messages = <DeviceSmsMessage>[];

    var start = 0;
    while (true) {
      final page = await _smsQuery.querySms(
        kinds: [SmsQueryKind.inbox],
        start: start,
        count: _pageSize,
      );

      for (final message in page) {
        final receivedAt = message.date;
        if (receivedAt == null) continue;
        if (receivedAt.isBefore(from)) continue;

        messages.add(
          DeviceSmsMessage(
            sender: message.address ?? '',
            body: message.body ?? '',
            receivedAt: receivedAt,
          ),
        );
      }

      if (page.length < _pageSize) break;

      start += _pageSize;
    }

    return messages;
  }
}
