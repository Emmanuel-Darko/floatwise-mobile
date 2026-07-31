import '../../domain/entities/till_entity.dart';
import '../../domain/repositories/till_repository.dart';

import '../../../../core/database/app_database.dart';
import '../../../../shared/enums/mobile_network.dart';
import '../../../../shared/enums/till_status.dart';

class TillRepositoryImpl implements TillRepository {
  TillRepositoryImpl(this.database);

  final AppDatabase database;

  @override
  Future<List<TillEntity>> getBranchTills(String branchId) async {
    final rows = await database.tillDao.getBranchTills(branchId);

    return rows
        .map(
          (row) => TillEntity(
            id: row.id,
            branchId: row.branchId,
            name: row.name,
            phoneNumber: row.phoneNumber,
            network: MobileNetwork.values.byName(row.network),
            status: TillStatus.values.byName(row.status),
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<TillEntity?> getById(String id) async {
    final row = await database.tillDao.getTill(id);

    if (row == null) return null;

    return TillEntity(
      id: row.id,
      branchId: row.branchId,
      name: row.name,
      phoneNumber: row.phoneNumber,
      network: MobileNetwork.values.byName(row.network),
      status: TillStatus.values.byName(row.status),
      createdAt: row.createdAt,
    );
  }

  @override
  Future<void> create(TillEntity till) async {
    await database.tillDao.insertTill(
      TillsCompanion.insert(
        id: till.id,
        branchId: till.branchId,
        name: till.name,
        phoneNumber: till.phoneNumber,
        network: till.network.name,
        status: till.status.name,
        createdAt: till.createdAt,
      ),
    );
  }

  @override
  Future<void> update(TillEntity till) async {
    await database.tillDao.updateTill(
      Till(
        id: till.id,
        branchId: till.branchId,
        name: till.name,
        phoneNumber: till.phoneNumber,
        network: till.network.name,
        status: till.status.name,
        createdAt: till.createdAt,
      ),
    );
  }

  @override
  Future<void> delete(String id) {
    return database.tillDao.deleteTill(id);
  }
}
