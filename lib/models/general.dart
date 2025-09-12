class General {
  final String id;
  final String name;
  final String avatar;
  final int rarity; // 1-5星
  final int level;
  final int experience;
  final int maxExperience;
  final GeneralStats stats;
  final List<Skill> skills;
  final Equipment? weapon;
  final Equipment? armor;
  final Equipment? accessory;
  final String biography;
  final String position; // 前锋、谋士、辅助等

  General({
    required this.id,
    required this.name,
    required this.avatar,
    required this.rarity,
    required this.level,
    required this.experience,
    required this.maxExperience,
    required this.stats,
    required this.skills,
    this.weapon,
    this.armor,
    this.accessory,
    required this.biography,
    required this.position,
  });

  General copyWith({
    String? id,
    String? name,
    String? avatar,
    int? rarity,
    int? level,
    int? experience,
    int? maxExperience,
    GeneralStats? stats,
    List<Skill>? skills,
    Equipment? weapon,
    Equipment? armor,
    Equipment? accessory,
    String? biography,
    String? position,
  }) {
    return General(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      rarity: rarity ?? this.rarity,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      maxExperience: maxExperience ?? this.maxExperience,
      stats: stats ?? this.stats,
      skills: skills ?? this.skills,
      weapon: weapon ?? this.weapon,
      armor: armor ?? this.armor,
      accessory: accessory ?? this.accessory,
      biography: biography ?? this.biography,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'rarity': rarity,
      'level': level,
      'experience': experience,
      'maxExperience': maxExperience,
      'stats': stats.toJson(),
      'skills': skills.map((s) => s.toJson()).toList(),
      'weapon': weapon?.toJson(),
      'armor': armor?.toJson(),
      'accessory': accessory?.toJson(),
      'biography': biography,
      'position': position,
    };
  }

  factory General.fromJson(Map<String, dynamic> json) {
    return General(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      rarity: json['rarity'],
      level: json['level'],
      experience: json['experience'],
      maxExperience: json['maxExperience'],
      stats: GeneralStats.fromJson(json['stats']),
      skills: (json['skills'] as List).map((s) => Skill.fromJson(s)).toList(),
      weapon: json['weapon'] != null ? Equipment.fromJson(json['weapon']) : null,
      armor: json['armor'] != null ? Equipment.fromJson(json['armor']) : null,
      accessory: json['accessory'] != null ? Equipment.fromJson(json['accessory']) : null,
      biography: json['biography'],
      position: json['position'],
    );
  }
}

class GeneralStats {
  final int force; // 武力
  final int intelligence; // 智力
  final int leadership; // 统率
  final int speed; // 速度
  final int troops; // 兵力

  GeneralStats({
    required this.force,
    required this.intelligence,
    required this.leadership,
    required this.speed,
    required this.troops,
  });

  GeneralStats copyWith({
    int? force,
    int? intelligence,
    int? leadership,
    int? speed,
    int? troops,
  }) {
    return GeneralStats(
      force: force ?? this.force,
      intelligence: intelligence ?? this.intelligence,
      leadership: leadership ?? this.leadership,
      speed: speed ?? this.speed,
      troops: troops ?? this.troops,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'force': force,
      'intelligence': intelligence,
      'leadership': leadership,
      'speed': speed,
      'troops': troops,
    };
  }

  factory GeneralStats.fromJson(Map<String, dynamic> json) {
    return GeneralStats(
      force: json['force'],
      intelligence: json['intelligence'],
      leadership: json['leadership'],
      speed: json['speed'],
      troops: json['troops'],
    );
  }
}

class Skill {
  final String id;
  final String name;
  final String description;
  final SkillType type;
  final int cooldown;
  final int currentCooldown;

  Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.cooldown,
    this.currentCooldown = 0,
  });

  Skill copyWith({
    String? id,
    String? name,
    String? description,
    SkillType? type,
    int? cooldown,
    int? currentCooldown,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      cooldown: cooldown ?? this.cooldown,
      currentCooldown: currentCooldown ?? this.currentCooldown,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString(),
      'cooldown': cooldown,
      'currentCooldown': currentCooldown,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: SkillType.values.firstWhere((e) => e.toString() == json['type']),
      cooldown: json['cooldown'],
      currentCooldown: json['currentCooldown'] ?? 0,
    );
  }
}

enum SkillType {
  active,
  passive,
}

class Equipment {
  final String id;
  final String name;
  final String description;
  final EquipmentType type;
  final int rarity;
  final Map<String, int> stats;
  final String? specialEffect;

  Equipment({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rarity,
    required this.stats,
    this.specialEffect,
  });

  Equipment copyWith({
    String? id,
    String? name,
    String? description,
    EquipmentType? type,
    int? rarity,
    Map<String, int>? stats,
    String? specialEffect,
  }) {
    return Equipment(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      stats: stats ?? this.stats,
      specialEffect: specialEffect ?? this.specialEffect,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString(),
      'rarity': rarity,
      'stats': stats,
      'specialEffect': specialEffect,
    };
  }

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: EquipmentType.values.firstWhere((e) => e.toString() == json['type']),
      rarity: json['rarity'],
      stats: Map<String, int>.from(json['stats']),
      specialEffect: json['specialEffect'],
    );
  }
}

enum EquipmentType {
  weapon,
  armor,
  accessory,
}