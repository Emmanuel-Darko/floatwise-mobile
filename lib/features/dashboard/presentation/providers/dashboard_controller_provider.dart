import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/dashboard_controller.dart';

final dashboardControllerProvider =
    AsyncNotifierProvider<DashboardController, DashboardState>(
      DashboardController.new,
    );
