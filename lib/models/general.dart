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
