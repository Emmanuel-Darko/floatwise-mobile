import '../../../../core/database/app_database.dart';

import '../../domain/entities/branch_entity.dart';
import '../../domain/repository/branch_repository.dart';

class BranchRepositoryImpl
    implements BranchRepository {
  BranchRepositoryImpl(this.database);

  final AppDatabase database;

  @override
  Future<void> create(BranchEntity branch) async {
    await database.branchDao.insertBranch(
      BranchesCompanion.insert(
        id: branch.id,
        businessId: branch.businessId,
        name: branch.name,
        createdAt: branch.createdAt,
      ),
    );
  }

  @override
  Future<void> delete(String id) {
    return database.branchDao.deleteBranch(id);
  }

  @override
  Future<List<BranchEntity>> getBusinessBranches(
      String businessId) async {
    final rows = await database.branchDao
        .getBusinessBranches(businessId);

    return rows
        .map(
          (row) => BranchEntity(
            id: row.id,
            businessId: row.businessId,
            name: row.name,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<void> update(BranchEntity branch) {
    return database.branchDao.updateBranch(
      Branch(
        id: branch.id,
        businessId: branch.businessId,
        name: branch.name,
        createdAt: branch.createdAt,
      ),
    );
  }
}