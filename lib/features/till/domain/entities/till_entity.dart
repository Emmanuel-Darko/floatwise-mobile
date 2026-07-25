import '../../../../shared/enums/mobile_network.dart';
import '../../../../shared/enums/till_status.dart';

class TillEntity {
  const TillEntity({
    required this.id,
    required this.branchId,
    required this.name,
    required this.phoneNumber,
    required this.network,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String branchId;
  final String name;
  final String phoneNumber;
  final MobileNetwork network;
  final TillStatus status;
  final DateTime createdAt;

  TillEntity copyWith({
    String? id,
    String? branchId,
    String? name,
    String? phoneNumber,
    MobileNetwork? network,
    TillStatus? status,
    DateTime? createdAt,
  }) {
    return TillEntity(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      network: network ?? this.network,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TillEntity.fromJson(Map<String, dynamic> json) {
    return TillEntity(
      id: json['id'] as String,
      branchId: json['branchId'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      network: MobileNetwork.values.byName(json['network'] as String),
      status: TillStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'branchId': branchId,
        'name': name,
        'phoneNumber': phoneNumber,
        'network': network.name,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };
}