import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/branches.dart';

part 'branch_dao.g.dart';

@DriftAccessor(tables: [Branches])
class BranchDao extends DatabaseAccessor<AppDatabase>
    with _$BranchDaoMixin {
  BranchDao(super.db);

  Future<List<Branch>> getAllBranches() {
    return select(branches).get();
  }

  Future<List<Branch>> getBusinessBranches(String businessId) {
    return (select(branches)
          ..where((tbl) => tbl.businessId.equals(businessId)))
        .get();
  }

  Future<void> insertBranch(
      BranchesCompanion companion) async {
    await into(branches).insert(companion);
  }

  Future<void> updateBranch(
      Branch branch) async {
    await update(branches).replace(branch);
  }

  Future<void> deleteBranch(String id) async {
    await (delete(branches)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}