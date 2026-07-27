import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/tills.dart';

part 'till_dao.g.dart';

@DriftAccessor(tables: [Tills])
class TillDao extends DatabaseAccessor<AppDatabase>
    with _$TillDaoMixin {
  TillDao(super.db);

  Future<List<Till>> getAllTills() {
    return select(tills).get();
  }

  Future<List<Till>> getBranchTills(String branchId) {
    return (select(tills)
          ..where((tbl) => tbl.branchId.equals(branchId)))
        .get();
  }

  Future<Till?> getTill(String id) {
    return (select(tills)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> insertTill(TillsCompanion companion) async {
    await into(tills).insert(companion);
  }

  Future<void> updateTill(Till till) async {
    await update(tills).replace(till);
  }

  Future<void> deleteTill(String id) async {
    await (delete(tills)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
