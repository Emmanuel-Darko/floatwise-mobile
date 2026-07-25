import '../../../../shared/enums/mobile_network.dart';
import '../../../../shared/enums/provider_transaction_type.dart';
import '../../../../shared/enums/verification_status.dart';

class ProviderTransactionEntity {
  const ProviderTransactionEntity({
    required this.id,
    required this.tillId,
    required this.providerReference,
    required this.network,
    required this.type,
    required this.amount,
    required this.smsBody,
    required this.receivedAt,
    this.phoneNumber,
    this.customerName,
    this.status = VerificationStatus.pending,
  });

  final String id;

  final String tillId;

  final String providerReference;

  final MobileNetwork network;

  final ProviderTransactionType type;

  final double amount;

  final String smsBody;

  final String? phoneNumber;

  final String? customerName;

  final VerificationStatus status;

  final DateTime receivedAt;

  ProviderTransactionEntity copyWith({
    VerificationStatus? status,
  }) {
    return ProviderTransactionEntity(
      id: id,
      tillId: tillId,
      providerReference: providerReference,
      network: network,
      type: type,
      amount: amount,
      smsBody: smsBody,
      phoneNumber: phoneNumber,
      customerName: customerName,
      status: status ?? this.status,
      receivedAt: receivedAt,
    );
  }
}