class BusinessEntity {
  const BusinessEntity({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String ownerId;
  final DateTime createdAt;

  BusinessEntity copyWith({
    String? id,
    String? name,
    String? ownerId,
    DateTime? createdAt,
  }) {
    return BusinessEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory BusinessEntity.fromJson(Map<String, dynamic> json) {
    return BusinessEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ownerId': ownerId,
    'createdAt': createdAt.toIso8601String(),
  };
}
