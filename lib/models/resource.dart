class Resource {
  final String id;
  final String name;
  final String icon;
  final int amount;
  final int maxAmount;

  const Resource({
    required this.id,
    required this.name,
    required this.icon,
    required this.amount,
    this.maxAmount = 9999,
  });

  Resource copyWith({
    String? id,
    String? name,
    String? icon,
    int? amount,
    int? maxAmount,
  }) {
    return Resource(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      amount: amount ?? this.amount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'amount': amount,
      'maxAmount': maxAmount,
    };
  }

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      amount: json['amount'],
      maxAmount: json['maxAmount'] ?? 9999,
    );
  }
}
