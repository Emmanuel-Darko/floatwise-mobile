import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_config_entity.dart';
import '../../domain/repository/app_config_repository.dart';

import '../../../../core/constants/storage_keys.dart';

class AppConfigRepositoryImpl implements AppConfigRepository {
  AppConfigRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<AppConfigEntity> getConfig() async {
    return AppConfigEntity(
      hasCompletedSetup:
          _prefs.getBool(StorageKeys.hasCompletedSetup) ?? false,
      currentBusinessId: _prefs.getString(StorageKeys.currentBusinessId),
      currentBranchId: _prefs.getString(StorageKeys.currentBranchId),
      currentTillId: _prefs.getString(StorageKeys.currentTillId),
    );
  }

  @override
  Future<void> saveConfig(AppConfigEntity config) async {
    await _prefs.setBool(
      StorageKeys.hasCompletedSetup,
      config.hasCompletedSetup,
    );

    final currentBusinessId = config.currentBusinessId;
    final currentBranchId = config.currentBranchId;
    final currentTillId = config.currentTillId;

    if (currentBusinessId != null) {
      await _prefs.setString(
        StorageKeys.currentBusinessId,
        currentBusinessId,
      );
    } else {
      await _prefs.remove(StorageKeys.currentBusinessId);
    }

    if (currentBranchId != null) {
      await _prefs.setString(
        StorageKeys.currentBranchId,
        currentBranchId,
      );
    } else {
      await _prefs.remove(StorageKeys.currentBranchId);
    }

    if (currentTillId != null) {
      await _prefs.setString(
        StorageKeys.currentTillId,
        currentTillId,
      );
    } else {
      await _prefs.remove(StorageKeys.currentTillId);
    }
  }

  @override
  Future<bool> hasCompletedSetup() async {
    return _prefs.getBool(StorageKeys.hasCompletedSetup) ?? false;
  }
}