import '../models/sms_import_result.dart';

abstract interface class SmsImportService {
  Future<SmsImportResult> importMessages({
    required DateTime from,
    Set<String>? senderAddresses,
  });
}
