import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/setup_controller.dart';
import '../models/setup_state.dart';

final setupControllerProvider =
    NotifierProvider<SetupController, SetupState>(
  SetupController.new,
);