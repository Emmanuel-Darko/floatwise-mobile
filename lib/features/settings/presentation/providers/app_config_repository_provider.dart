import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repository/app_config_repository_impl.dart';
import '../../domain/repository/app_config_repository.dart';

final appConfigRepositoryProvider = FutureProvider<AppConfigRepository>((
  ref,
) async {
  final prefs = await SharedPreferences.getInstance();

  return AppConfigRepositoryImpl(prefs);
});
