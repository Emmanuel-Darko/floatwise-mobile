/// Shared helpers for the setup wizard steps.
class SetupUtils {
  const SetupUtils._();

  /// Generates a temporary local identifier until real ids are persisted.
  static String generateLocalId() {
    return 'local-${DateTime.now().microsecondsSinceEpoch.toRadixString(16)}';
  }
}