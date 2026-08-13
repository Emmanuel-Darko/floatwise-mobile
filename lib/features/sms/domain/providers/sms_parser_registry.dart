import '../../../../shared/enums/mobile_network.dart';
import '../services/sms_parser.dart';

class SmsParserRegistry {
  SmsParserRegistry(Iterable<SmsParser> parsers)
    : _parsers = List<SmsParser>.unmodifiable(parsers);

  final List<SmsParser> _parsers;

  SmsParser? parserFor(MobileNetwork network) {
    for (final parser in _parsers) {
      if (parser.network == network) return parser;
    }

    return null;
  }

  List<SmsParser> get parsers => List.unmodifiable(_parsers);
}
