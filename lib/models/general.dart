import 'item.dart';

class General {
  final String id;
  final String name;
  final String position;
  final int attack;
  final int defense;
  final int intelligence;
  final int speed;
  final int level;
  final int experience;
  final List<String> skills;
  final String avatar;
  final String imagePath; // 角色图片路径
  final String description; // 角色描述
  final String? specialty; // 特色技能
  final int rarity; // 稀有度 (1-5星)
  final Map<String, String?> equipment; // 装备槽位：weapon, armor, accessory

  General({
    required this.id,
    required this.name,
    required this.position,
    required this.attack,
    required this.defense,
    required this.intelligence,
    required this.speed,
    required this.level,
    required this.experience,
    required this.skills,
    required this.avatar,
    required this.imagePath,
    required this.description,
    this.specialty,
    this.rarity = 3,
    Map<String, String?>? equipment,
  }) : equipment =
           equipment ?? {'weapon': null, 'armor': null, 'accessory': null};

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'attack': attack,
      'defense': defense,
      'intelligence': intelligence,
      'speed': speed,
      'level': level,
      'experience': experience,
      'skills': skills,
      'avatar': avatar,
      'imagePath': imagePath,
      'description': description,
      'specialty': specialty,
      'rarity': rarity,
      'equipment': equipment,
    };
  }

  factory General.fromJson(Map<String, dynamic> json) {
    return General(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      attack: json['attack'],
      defense: json['defense'],
      intelligence: json['intelligence'],
      speed: json['speed'],
      level: json['level'],
      experience: json['experience'],
      skills: List<String>.from(json['skills']),
      avatar: json['avatar'],
      imagePath: json['imagePath'] ?? 'assets/role/小兵.png',
      description: json['description'] ?? '',
      specialty: json['specialty'],
      rarity: json['rarity'] ?? 3,
      equipment: json['equipment'] != null
          ? Map<String, String?>.from(json['equipment'])
          : {'weapon': null, 'armor': null, 'accessory': null},
    );
  }

  General copyWith({
    String? id,
    String? name,
    String? position,
    int? attack,
    int? defense,
    int? intelligence,
    int? speed,
    int? level,
    int? experience,
    List<String>? skills,
    String? avatar,
    String? imagePath,
    String? description,
    String? specialty,
    int? rarity,
    Map<String, String?>? equipment,
  }) {
    return General(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      intelligence: intelligence ?? this.intelligence,
      speed: speed ?? this.speed,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      avatar: avatar ?? this.avatar,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      specialty: specialty ?? this.specialty,
      rarity: rarity ?? this.rarity,
      equipment: equipment ?? this.equipment,
    );
  }

  // 计算总属性（基础属性 + 装备加成）
  int getTotalAttack(List<Item> allItems) {
    int total = attack;
    for (String slot in equipment.keys) {
      final itemId = equipment[slot];
      if (itemId != null) {
        final item = allItems.firstWhere(
          (i) => i.id == itemId,
          orElse: () => allItems.first,
        );
        total += item.stats['attack'] ?? 0;
      }
    }
    return total;
  }

  int getTotalDefense(List<Item> allItems) {
    int total = defense;
    for (String slot in equipment.keys) {
      final itemId = equipment[slot];
      if (itemId != null) {
        final item = allItems.firstWhere(
          (i) => i.id == itemId,
          orElse: () => allItems.first,
        );
        total += item.stats['defense'] ?? 0;
      }
    }
    return total;
  }

  int getTotalIntelligence(List<Item> allItems) {
    int total = intelligence;
    for (String slot in equipment.keys) {
      final itemId = equipment[slot];
      if (itemId != null) {
        final item = allItems.firstWhere(
          (i) => i.id == itemId,
          orElse: () => allItems.first,
        );
        total += item.stats['intelligence'] ?? 0;
      }
    }
    return total;
  }

  int getTotalSpeed(List<Item> allItems) {
    int total = speed;
    for (String slot in equipment.keys) {
      final itemId = equipment[slot];
      if (itemId != null) {
        final item = allItems.firstWhere(
          (i) => i.id == itemId,
          orElse: () => allItems.first,
        );
        total += item.stats['speed'] ?? 0;
      }
    }
    return total;
  }
}
