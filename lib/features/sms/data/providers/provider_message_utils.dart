class ProviderMessageUtils {
  ProviderMessageUtils._();

  static final _amountAndKeyword = RegExp(
    r'ghs\s*[\d,]+(?:\.\d{1,2})?',
    caseSensitive: false,
  );

  static const _activityKeywords = [
    'received',
    'sent',
    'payment',
    'transfer',
    'cash out',
    'cashout',
    'withdrawn',
    'reversal',
    'fee',
    'commission',
  ];

  static bool looksLikeTransaction(String message) {
    final normalized = message.toLowerCase();

    if (!_amountAndKeyword.hasMatch(normalized)) return false;

    return _activityKeywords.any(normalized.contains);
  }
}
