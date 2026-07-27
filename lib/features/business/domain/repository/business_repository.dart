import '../entities/business_entity.dart';

abstract interface class BusinessRepository {
  Future<void> create(BusinessEntity business);

  Future<void> update(BusinessEntity business);

  Future<void> delete(String id);

  Future<BusinessEntity?> getById(String id);

  Future<List<BusinessEntity>> getAll();
}