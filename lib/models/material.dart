class Material {
  final String id;
  final String name;
  final String description;
  final MaterialType type;
  final int rarity;
  final String icon;

  Material({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    required this.icon,
  });

  Material copyWith({
    String? id,
    String? name,
    String? description,
    MaterialType? type,
    int? rarity,
    String? icon,
  }) {
    return Material(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString(),
      'rarity': rarity,
      'icon': icon,
    };
  }

  factory Material.fromJson(Map<String, dynamic> json) {
    return Material(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: MaterialType.values.firstWhere((e) => e.toString() == json['type']),
      rarity: json['rarity'],
      icon: json['icon'],
    );
  }
}

enum MaterialType {
  upgrade,    // 升级材料
  currency,   // 货币
  special,    // 特殊材料
}

class MaterialStack {
  final Material material;
  final int quantity;

  MaterialStack({
    required this.material,
    required this.quantity,
  });

  MaterialStack copyWith({
    Material? material,
    int? quantity,
  }) {
    return MaterialStack(
      material: material ?? this.material,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'material': material.toJson(),
      'quantity': quantity,
    };
  }

  factory MaterialStack.fromJson(Map<String, dynamic> json) {
    return MaterialStack(
      material: Material.fromJson(json['material']),
      quantity: json['quantity'],
    );
  }
}

class UpgradeRequirement {
  final String materialId;
  final int quantity;

  UpgradeRequirement({
    required this.materialId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'materialId': materialId,
      'quantity': quantity,
    };
  }

  factory UpgradeRequirement.fromJson(Map<String, dynamic> json) {
    return UpgradeRequirement(
      materialId: json['materialId'],
      quantity: json['quantity'],
    );
  }
}

class UpgradeResult {
  final bool success;
  final String message;
  final dynamic upgradedGeneral; // 使用dynamic避免循环依赖
  final List<MaterialStack>? consumedMaterials;

  UpgradeResult({
    required this.success,
    required this.message,
    this.upgradedGeneral,
    this.consumedMaterials,
  });
}