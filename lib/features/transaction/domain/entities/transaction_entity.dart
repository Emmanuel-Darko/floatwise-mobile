import '../../../../shared/enums/mobile_network.dart';
import '../../../../shared/enums/transaction_source.dart';
import '../../../../shared/enums/transaction_status.dart';
import '../../../../shared/enums/transaction_type.dart';

class TransactionEntity {
  const TransactionEntity({
    required this.id,
    required this.network,
    required this.type,
    required this.amount,
    required this.timestamp,
    required this.status,
    required this.source,
    this.phoneNumber,
    this.reference,
    this.rawSmsId,
    this.balanceAfter,
  });

  final String id;

  final MobileNetwork network;

  final TransactionType type;

  final double amount;

  final DateTime timestamp;

  final TransactionStatus status;

  final TransactionSource source;

  final String? phoneNumber;

  final String? reference;

  final String? rawSmsId;

  final double? balanceAfter;

  TransactionEntity copyWith({
    String? id,
    MobileNetwork? network,
    TransactionType? type,
    double? amount,
    DateTime? timestamp,
    TransactionStatus? status,
    TransactionSource? source,
    String? phoneNumber,
    String? reference,
    String? rawSmsId,
    double? balanceAfter,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      network: network ?? this.network,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      source: source ?? this.source,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      reference: reference ?? this.reference,
      rawSmsId: rawSmsId ?? this.rawSmsId,
      balanceAfter: balanceAfter ?? this.balanceAfter,
    );
  }
}
