import 'package:flutter/material.dart';

enum AchievementType {
  levelComplete,
  perfectScore,
  speedRun,
  noUndo,
  bottleMaster,
  colorExpert,
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final AchievementType type;
  final int targetValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.type,
    required this.targetValue,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      color: color,
      type: type,
      targetValue: targetValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  static const List<Achievement> allAchievements = [
    Achievement(
      id: 'first_level',
      title: '初學者',
      description: '完成第一關',
      icon: Icons.star,
      color: Colors.amber,
      type: AchievementType.levelComplete,
      targetValue: 1,
    ),
    Achievement(
      id: 'level_5',
      title: '進步中',
      description: '完成第5關',
      icon: Icons.trending_up,
      color: Colors.blue,
      type: AchievementType.levelComplete,
      targetValue: 5,
    ),
    Achievement(
      id: 'level_10',
      title: '專家',
      description: '完成第10關',
      icon: Icons.emoji_events,
      color: Colors.purple,
      type: AchievementType.levelComplete,
      targetValue: 10,
    ),
    Achievement(
      id: 'perfect_score',
      title: '完美主義者',
      description: '獲得3星評價',
      icon: Icons.star_rate,
      color: Colors.amber,
      type: AchievementType.perfectScore,
      targetValue: 1,
    ),
    Achievement(
      id: 'speed_demon',
      title: '速度惡魔',
      description: '在30秒內完成一關',
      icon: Icons.flash_on,
      color: Colors.orange,
      type: AchievementType.speedRun,
      targetValue: 30,
    ),
    Achievement(
      id: 'no_undo_master',
      title: '一次成功',
      description: '不使用撤銷完成一關',
      icon: Icons.check_circle,
      color: Colors.green,
      type: AchievementType.noUndo,
      targetValue: 1,
    ),
    Achievement(
      id: 'bottle_collector',
      title: '瓶子收集家',
      description: '使用10個瓶子完成一關',
      icon: Icons.collections,
      color: Colors.teal,
      type: AchievementType.bottleMaster,
      targetValue: 10,
    ),
  ];
}