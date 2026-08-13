import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/raw_sms_messages.dart';

part 'raw_sms_message_dao.g.dart';

@DriftAccessor(tables: [RawSmsMessages])
class RawSmsMessageDao extends DatabaseAccessor<AppDatabase>
    with _$RawSmsMessageDaoMixin {
  RawSmsMessageDao(super.db);

  Future<bool> existsByHash(String hash) async {
    final query = select(rawSmsMessages)
      ..where((table) => table.smsHash.equals(hash))
      ..limit(1);

    return (await query.getSingleOrNull()) != null;
  }

  Future<void> insertMessage(RawSmsMessagesCompanion message) {
    return into(
      rawSmsMessages,
    ).insert(message, mode: InsertMode.insertOrIgnore);
  }

  Future<List<RawSmsMessage>> getUnparsedMessages() {
    return (select(rawSmsMessages)
          ..where((table) => table.isParsed.equals(false))
          ..orderBy([(table) => OrderingTerm.asc(table.receivedAt)]))
        .get();
  }

  Future<void> markParsed({required String id}) {
    return (update(
      rawSmsMessages,
    )..where((table) => table.id.equals(id))).write(
      const RawSmsMessagesCompanion(
        isParsed: Value(true),
        parseError: Value(null),
      ),
    );
  }

  Future<void> markParseError({required String id, required String error}) {
    return (update(rawSmsMessages)..where((table) => table.id.equals(id)))
        .write(RawSmsMessagesCompanion(parseError: Value(error)));
  }
}
