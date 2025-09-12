class Achievement {
  final String id;
  final String name;
  final String description;
  final AchievementType type;
  final int targetValue;
  final int currentValue;
  final bool isCompleted;
  final List<AchievementReward> rewards;
  final String iconName;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.targetValue,
    this.currentValue = 0,
    this.isCompleted = false,
    this.rewards = const [],
    this.iconName = 'trophy',
  });

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    AchievementType? type,
    int? targetValue,
    int? currentValue,
    bool? isCompleted,
    List<AchievementReward>? rewards,
    String? iconName,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      isCompleted: isCompleted ?? this.isCompleted,
      rewards: rewards ?? this.rewards,
      iconName: iconName ?? this.iconName,
    );
  }

  double get progress => targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString(),
      'targetValue': targetValue,
      'currentValue': currentValue,
      'isCompleted': isCompleted,
      'rewards': rewards.map((r) => r.toJson()).toList(),
      'iconName': iconName,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: AchievementType.values.firstWhere((e) => e.toString() == json['type']),
      targetValue: json['targetValue'],
      currentValue: json['currentValue'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      rewards: (json['rewards'] as List? ?? [])
          .map((r) => AchievementReward.fromJson(r))
          .toList(),
      iconName: json['iconName'] ?? 'trophy',
    );
  }
}

enum AchievementType {
  battle,      // 战斗相关
  collection,  // 收集相关
  story,       // 剧情相关
  general,     // 武将相关
  equipment,   // 装备相关
  level,       // 等级相关
}

class AchievementReward {
  final AchievementRewardType type;
  final int amount;
  final String? itemId;

  AchievementReward({
    required this.type,
    required this.amount,
    this.itemId,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'amount': amount,
      'itemId': itemId,
    };
  }

  factory AchievementReward.fromJson(Map<String, dynamic> json) {
    return AchievementReward(
      type: AchievementRewardType.values.firstWhere((e) => e.toString() == json['type']),
      amount: json['amount'],
      itemId: json['itemId'],
    );
  }
}

enum AchievementRewardType {
  coins,       // 金币
  experience,  // 经验值
  equipment,   // 装备
  general,     // 武将
}