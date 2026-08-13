import '../entities/till_entity.dart';

abstract interface class TillRepository {
  Future<void> create(TillEntity till);

  Future<void> update(TillEntity till);

  Future<void> delete(String id);

  Future<TillEntity?> getById(String id);

  Future<List<TillEntity>> getBranchTills(String branchId);
}
