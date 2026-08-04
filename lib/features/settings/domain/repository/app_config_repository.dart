import '../entities/app_config_entity.dart';

abstract interface class AppConfigRepository {
  Future<AppConfigEntity> getConfig();

  Future<void> saveConfig(AppConfigEntity config);

  Future<bool> hasCompletedSetup();
}
