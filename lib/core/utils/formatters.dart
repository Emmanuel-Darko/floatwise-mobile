import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  /// Format currency (GHS — Ghanaian Cedi)
  static String currency(double amount) {
    final formatter = NumberFormat.currency(symbol: 'GHS ', decimalDigits: 2);
    return formatter.format(amount);
  }

  /// Format date as "Jul 24, 2026"
  static String date(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime);
  }

  /// Format date and time as "Jul 24, 2026 1:37 AM"
  static String dateTime(DateTime dateTime) {
    return DateFormat.yMMMd().add_jm().format(dateTime);
  }

  /// Format time as "1:37 AM"
  static String time(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  /// Format phone number for display
  static String phone(String phone) {
    if (phone.length == 10) {
      return '${phone.substring(0, 3)} ${phone.substring(3, 6)} ${phone.substring(6)}';
    }
    return phone;
  }
}
