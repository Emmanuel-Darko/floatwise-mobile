import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_provider.dart';
import '../../data/services/device_sms_reader_impl.dart';
import '../../data/services/sms_import_service_impl.dart';
import '../../domain/services/sms_import_service.dart';
import 'sms_permission_provider.dart';

final smsImportServiceProvider = Provider<SmsImportService>((ref) {
  final database = ref.watch(databaseProvider);

  return SmsImportServiceImpl(
    reader: DeviceSmsReaderImpl(
      permissionService: ref.watch(smsPermissionProvider),
    ),
    rawSmsMessageDao: database.rawSmsMessageDao,
  );
});
