import '../entities/branch_entity.dart';

abstract interface class BranchRepository {
  Future<void> create(BranchEntity branch);

  Future<void> update(BranchEntity branch);

  Future<void> delete(String id);

  Future<List<BranchEntity>> getBusinessBranches(
      String businessId);
}