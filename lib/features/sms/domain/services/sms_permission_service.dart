abstract interface class SmsPermissionService {
  Future<bool> hasPermission();

  Future<bool> requestPermission();
}