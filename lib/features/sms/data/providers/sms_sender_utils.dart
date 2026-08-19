class SmsSenderUtils {
  SmsSenderUtils._();

  static final _nonNamePattern = RegExp(r'^[0-9\s()+\-#*./]+$');

  static bool isNamedSender(String sender) {
    final trimmed = sender.trim();
    if (trimmed.isEmpty) return false;

    return !_nonNamePattern.hasMatch(trimmed);
  }
}
