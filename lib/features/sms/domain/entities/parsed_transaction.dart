import '../../../../shared/enums/mobile_network.dart';
import '../../../../shared/enums/transaction_type.dart';

class ParsedTransaction {
  const ParsedTransaction({
    required this.network,
    required this.type,
    required this.amount,
    required this.timestamp,
    required this.rawSmsId,
    this.phoneNumber,
    this.reference,
    this.balanceAfter,
  });

  final MobileNetwork network;

  final TransactionType type;

  final double amount;

  final DateTime timestamp;

  final String rawSmsId;

  final String? phoneNumber;

  final String? reference;

  final double? balanceAfter;
}
