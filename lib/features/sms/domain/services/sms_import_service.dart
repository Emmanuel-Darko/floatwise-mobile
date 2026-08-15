import '../models/sms_discovery_result.dart';
import '../models/sms_import_result.dart';

abstract interface class SmsImportService {
  Future<SmsDiscoveryResult> discoverSenders();

  Future<SmsImportResult> importMessages({
    required DateTime from,
    required Iterable<String> senderAddresses,
  });
}
