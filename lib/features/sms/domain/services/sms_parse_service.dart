import '../models/sms_parse_result.dart';

abstract interface class SmsParseService {
  Future<SmsParseResult> parsePendingMessages();
}
