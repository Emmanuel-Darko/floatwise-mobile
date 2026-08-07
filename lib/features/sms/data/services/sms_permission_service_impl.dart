import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../../domain/services/sms_permission_service.dart';

class SmsPermissionServiceImpl implements SmsPermissionService {
  @override
  Future<bool> hasPermission() async {
    if (!Platform.isAndroid) return false;

    final status = await Permission.sms.status;

    return status.isGranted;
  }

  @override
  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return false;

    final status = await Permission.sms.request();

    return status.isGranted;
  }
}