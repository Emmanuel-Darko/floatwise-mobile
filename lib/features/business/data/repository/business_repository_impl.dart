import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/business_entity.dart';
import '../../domain/repository/business_repository.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BusinessRepositoryImpl(db);
});

class BusinessRepositoryImpl implements BusinessRepository {
  BusinessRepositoryImpl(this.database);

  final AppDatabase database;

  @override
  Future<List<BusinessEntity>> getAll() async {
    final rows = await database.businessDao.getAllBusinesses();

    return rows
        .map(
          (row) => BusinessEntity(
            id: row.id,
            name: row.name,
            ownerId: row.ownerId,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<BusinessEntity?> getById(String id) async {
    final row = await database.businessDao.getBusiness(id);

    if (row == null) return null;

    return BusinessEntity(
      id: row.id,
      name: row.name,
      ownerId: row.ownerId,
      createdAt: row.createdAt,
    );
  }

  @override
  Future<void> create(BusinessEntity business) async {
    await database.businessDao.insertBusiness(
      BusinessesCompanion.insert(
        id: business.id,
        name: business.name,
        ownerId: business.ownerId,
        createdAt: business.createdAt,
      ),
    );
  }

  @override
  Future<void> update(BusinessEntity business) async {
    await database.businessDao.updateBusiness(
      BusinessesData(
        id: business.id,
        name: business.name,
        ownerId: business.ownerId,
        createdAt: business.createdAt,
      ),
    );
  }

  @override
  Future<void> delete(String id) {
    return database.businessDao.deleteBusiness(id);
  }
}