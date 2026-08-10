import 'package:drift/drift.dart';

class RawSmsMessages extends Table {
  TextColumn get id => text()();

  TextColumn get sender => text()();

  TextColumn get address => text()();

  TextColumn get body => text()();

  DateTimeColumn get receivedAt => dateTime()();

  DateTimeColumn get importedAt => dateTime()();

  TextColumn get smsHash => text()();

  BoolColumn get isParsed => boolean().withDefault(const Constant(false))();

  TextColumn get parseError => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [{smsHash}];
}