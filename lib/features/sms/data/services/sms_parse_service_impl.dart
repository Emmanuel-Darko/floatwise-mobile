import '../../../../core/database/dao/raw_sms_message_dao.dart';
import '../../domain/entities/parsed_transaction.dart';
import '../../domain/entities/raw_sms_message_entity.dart';
import '../../domain/models/sms_parse_result.dart';
import '../../domain/providers/mobile_money_provider_registry.dart';
import '../../domain/providers/sms_parser_registry.dart';
import '../../domain/services/sms_parse_service.dart';

class SmsParseServiceImpl implements SmsParseService {
  SmsParseServiceImpl({
    required this._rawSmsMessageDao,
    required this._providerRegistry,
    required this._parserRegistry,
  });

  final RawSmsMessageDao _rawSmsMessageDao;
  final MobileMoneyProviderRegistry _providerRegistry;
  final SmsParserRegistry _parserRegistry;

  @override
  Future<SmsParseResult> parsePendingMessages() async {
    final messages = await _rawSmsMessageDao.getUnparsedMessages();

    var parsed = 0;
    var failed = 0;
    final transactions = <ParsedTransaction>[];

    for (final message in messages) {
      final entity = RawSmsMessageEntity(
        id: message.id,
        sender: message.sender,
        body: message.body,
        receivedAt: message.receivedAt,
        importedAt: message.importedAt,
        smsHash: message.smsHash,
        isParsed: message.isParsed,
        parseError: message.parseError,
      );

      final provider = _providerRegistry.identify(
        sender: entity.sender,
        message: entity.body,
      );
      final parser = provider == null
          ? null
          : _parserRegistry.parserFor(provider.provider);

      if (parser == null) {
        await _rawSmsMessageDao.markParseError(
          id: entity.id,
          error: 'No parser available for message sender.',
        );
        failed++;
        continue;
      }

      try {
        final result = parser.parse(entity);

        if (result == null) {
          await _rawSmsMessageDao.markParseError(
            id: entity.id,
            error: 'Message is not a recognized transaction.',
          );
          failed++;
          continue;
        }

        await _rawSmsMessageDao.markParsed(id: entity.id);
        parsed++;
        transactions.add(result);
      } catch (error) {
        await _rawSmsMessageDao.markParseError(
          id: entity.id,
          error: error.toString(),
        );
        failed++;
      }
    }

    return SmsParseResult(
      processed: messages.length,
      parsed: parsed,
      failed: failed,
      transactions: transactions,
    );
  }
}
