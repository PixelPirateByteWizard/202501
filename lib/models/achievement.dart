import 'package:flutter/material.dart';

enum AchievementType {
  battle,      // 战斗相关
  collection,  // 收集相关
  progress,    // 进度相关
  social,      // 社交相关
  special,     // 特殊成就
}

enum AchievementRarity {
  common,      // 普通
  rare,        // 稀有
  epic,        // 史诗
  legendary,   // 传说
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementType type;
  final AchievementRarity rarity;
  final int targetValue;
  final int currentValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final Map<String, dynamic> rewards; // 奖励：gold, experience, items等
  final List<String> prerequisites; // 前置成就

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.rarity,
    required this.targetValue,
    this.currentValue = 0,
    this.isUnlocked = false,
    this.unlockedAt,
    this.rewards = const {},
    this.prerequisites = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'type': type.index,
      'rarity': rarity.index,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.millisecondsSinceEpoch,
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
      targetValue: json['targetValue'],
      currentValue: json['currentValue'] ?? 0,
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(json['unlockedAt'])
        : null,
      rewards: Map<String, dynamic>.from(json['rewards'] ?? {}),
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
    );
  }

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    AchievementType? type,
    AchievementRarity? rarity,
    int? targetValue,
    int? currentValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
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
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rewards: rewards ?? this.rewards,
      prerequisites: prerequisites ?? this.prerequisites,
    );
  }

  // 获取进度百分比
  double get progressPercentage {
    if (targetValue == 0) return 0.0;
    return (currentValue / targetValue).clamp(0.0, 1.0);
  }

  // 是否可以解锁
  bool canUnlock(List<Achievement> allAchievements) {
    if (isUnlocked) return false;
    if (currentValue < targetValue) return false;
    
    // 检查前置成就
    for (String prerequisiteId in prerequisites) {
      final prerequisite = allAchievements.firstWhere(
        (a) => a.id == prerequisiteId,
        orElse: () => allAchievements.first,
      );
      if (!prerequisite.isUnlocked) return false;
    }
    
    return true;
  }

  // 获取稀有度颜色
  Color getRarityColor() {
    switch (rarity) {
      case AchievementRarity.common:
        return const Color(0xFF9E9E9E); // 灰色
      case AchievementRarity.rare:
        return const Color(0xFF2196F3); // 蓝色
      case AchievementRarity.epic:
        return const Color(0xFF9C27B0); // 紫色
      case AchievementRarity.legendary:
        return const Color(0xFFFF9800); // 橙色
    }
  }

  // 获取稀有度名称
  String getRarityName() {
    switch (rarity) {
      case AchievementRarity.common:
        return '普通';
      case AchievementRarity.rare:
        return '稀有';
      case AchievementRarity.epic:
        return '史诗';
      case AchievementRarity.legendary:
        return '传说';
    }
  }

  // 获取类型名称
  String getTypeName() {
    switch (type) {
      case AchievementType.battle:
        return '战斗';
      case AchievementType.collection:
        return '收集';
      case AchievementType.progress:
        return '进度';
      case AchievementType.social:
        return '社交';
      case AchievementType.special:
        return '特殊';
    }
  }

  // 获取类型图标
  IconData getTypeIcon() {
    switch (type) {
      case AchievementType.battle:
        return Icons.sports_martial_arts;
      case AchievementType.collection:
        return Icons.collections;
      case AchievementType.progress:
        return Icons.trending_up;
      case AchievementType.social:
        return Icons.people;
      case AchievementType.special:
        return Icons.star;
    }
  }
}

// 成就统计
class AchievementStatistics {
  final int totalAchievements;
  final int unlockedAchievements;
  final int totalPoints;
  final Map<AchievementType, int> typeBreakdown;
  final Map<AchievementRarity, int> rarityBreakdown;
  final List<Achievement> recentUnlocked;

  AchievementStatistics({
    required this.totalAchievements,
    required this.unlockedAchievements,
    required this.totalPoints,
    required this.typeBreakdown,
    required this.rarityBreakdown,
    required this.recentUnlocked,
  });

  double get completionPercentage {
    if (totalAchievements == 0) return 0.0;
    return (unlockedAchievements / totalAchievements * 100);
  }
}