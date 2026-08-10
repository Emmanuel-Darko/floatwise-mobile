import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/raw_sms_messages.dart';

part 'raw_sms_dao.g.dart';

@DriftAccessor(tables: [RawSmsMessages])
class RawSmsDao extends DatabaseAccessor<AppDatabase>
    with _$RawSmsDaoMixin {
  RawSmsDao(super.db);

  Future<Set<String>> getAllHashes() async {
    final query = selectOnly(rawSmsMessages);
    query.addColumns([rawSmsMessages.smsHash]);
    final rows = await query.get();

    return rows
        .map((row) => row.read(rawSmsMessages.smsHash)!)
        .toSet();
  }

  Future<void> insertMessages(
    List<RawSmsMessagesCompanion> messages,
  ) async {
    await transaction(() async {
      await batch((batch) {
        batch.insertAll(rawSmsMessages, messages);
      });
    });
  }

  Future<List<RawSmsMessage>> getUnparsed() {
    return (select(rawSmsMessages)
          ..where((tbl) => tbl.isParsed.equals(false))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.receivedAt)]))
        .get();
  }
}