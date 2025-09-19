enum ItemType { weapon, armor, accessory, consumable }

class Item {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final int quantity;
  final Map<String, int> stats;
  final String icon;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.quantity,
    required this.stats,
    required this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.index,
      'quantity': quantity,
      'stats': stats,
      'icon': icon,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: ItemType.values[json['type']],
      quantity: json['quantity'],
      stats: Map<String, int>.from(json['stats']),
      icon: json['icon'],
    );
  }

  Item copyWith({
    String? id,
    String? name,
    String? description,
    ItemType? type,
    int? quantity,
    Map<String, int>? stats,
    String? icon,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      stats: stats ?? this.stats,
      icon: icon ?? this.icon,
    );
  }
}