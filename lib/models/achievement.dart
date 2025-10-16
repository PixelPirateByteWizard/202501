enum AchievementType { exploration, crafting, story, collection, efficiency }

enum AchievementRarity { common, rare, epic, legendary }

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementType type;
  final AchievementRarity rarity;
  final int maxProgress;
  final int currentProgress;
  final bool isUnlocked;
  final DateTime? unlockedDate;
  final Map<String, dynamic> rewards;
  final List<String> prerequisites;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.rarity,
    required this.maxProgress,
    this.currentProgress = 0,
    this.isUnlocked = false,
    this.unlockedDate,
    this.rewards = const {},
    this.prerequisites = const [],
  });

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    AchievementType? type,
    AchievementRarity? rarity,
    int? maxProgress,
    int? currentProgress,
    bool? isUnlocked,
    DateTime? unlockedDate,
    Map<String, dynamic>? rewards,
    List<String>? prerequisites,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      maxProgress: maxProgress ?? this.maxProgress,
      currentProgress: currentProgress ?? this.currentProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
      rewards: rewards ?? this.rewards,
      prerequisites: prerequisites ?? this.prerequisites,
    );
  }

  double get progressPercentage => currentProgress / maxProgress;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'type': type.index,
      'rarity': rarity.index,
      'maxProgress': maxProgress,
      'currentProgress': currentProgress,
      'isUnlocked': isUnlocked,
      'unlockedDate': unlockedDate?.toIso8601String(),
      'rewards': rewards,
      'prerequisites': prerequisites,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      type: AchievementType.values[json['type']],
      rarity: AchievementRarity.values[json['rarity']],
      maxProgress: json['maxProgress'],
      currentProgress: json['currentProgress'] ?? 0,
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedDate: json['unlockedDate'] != null
          ? DateTime.parse(json['unlockedDate'])
          : null,
      rewards: Map<String, dynamic>.from(json['rewards'] ?? {}),
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
    );
  }
}