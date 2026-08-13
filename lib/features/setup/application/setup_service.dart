import '../presentation/models/setup_state.dart';

abstract interface class SetupService {
  Future<void> completeSetup({required SetupState state});
}
