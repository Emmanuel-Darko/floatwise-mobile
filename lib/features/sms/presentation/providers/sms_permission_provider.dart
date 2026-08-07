import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/sms_permission_service_impl.dart';
import '../../domain/services/sms_permission_service.dart';

final smsPermissionProvider = Provider<SmsPermissionService>((ref) {
  return SmsPermissionServiceImpl();
});