import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/businesses.dart';

part 'business_dao.g.dart';

@DriftAccessor(tables: [Businesses])
class BusinessDao extends DatabaseAccessor<AppDatabase>
    with _$BusinessDaoMixin {
  BusinessDao(super.db);

  Future<List<BusinessesData>> getAllBusinesses() {
    return select(businesses).get();
  }

  Future<BusinessesData?> getBusiness(String id) {
    return (select(
      businesses,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertBusiness(BusinessesCompanion business) async {
    await into(businesses).insert(business);
  }

  Future<void> updateBusiness(BusinessesData business) async {
    await update(businesses).replace(business);
  }

  Future<void> deleteBusiness(String id) async {
    await (delete(businesses)..where((tbl) => tbl.id.equals(id))).go();
  }
}
