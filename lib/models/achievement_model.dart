/// Enum for different types of achievements
/// 不同类型成就的枚举
enum AchievementType {
  synthesis,
  matching,
  level,
  score,
  streak,
  efficiency,
}

/// Represents a single achievement in the game
/// 代表游戏中的单个成就
class Achievement {
  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final int targetValue;
  final String iconName;
  final int points;
  bool isUnlocked;
  int currentProgress;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    required this.iconName,
    required this.points,
    this.isUnlocked = false,
    this.currentProgress = 0,
  });

  /// Calculate progress percentage
  /// 计算进度百分比
  double get progressPercentage =>
      (currentProgress / targetValue).clamp(0.0, 1.0);

  /// Check if achievement should be unlocked
  /// 检查成就是否应该解锁
  bool shouldUnlock() => currentProgress >= targetValue && !isUnlocked;

  /// Copy with method for updates
  /// 用于更新的复制方法
  Achievement copyWith({
    bool? isUnlocked,
    int? currentProgress,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      type: type,
      targetValue: targetValue,
      iconName: iconName,
      points: points,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }

  /// Convert to Map for storage
  /// 转换为Map用于存储
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isUnlocked': isUnlocked,
      'currentProgress': currentProgress,
    };
  }

  /// Create from Map for loading
  /// 从Map创建用于加载
  static Achievement fromJson(Map<String, dynamic> json, Achievement template) {
    return template.copyWith(
      isUnlocked: json['isUnlocked'] ?? false,
      currentProgress: json['currentProgress'] ?? 0,
    );
  }

  /// Static list of all achievements
  /// 所有成就的静态列表
  static final List<Achievement> allAchievements = [
    // Synthesis achievements
    Achievement(
      id: 'first_synthesis',
      title: 'First Synthesis',
      description: 'Perform your first color synthesis',
      type: AchievementType.synthesis,
      targetValue: 1,
      iconName: 'science',
      points: 10,
    ),
    Achievement(
      id: 'synthesis_master',
      title: 'Synthesis Master',
      description: 'Perform 100 color syntheses',
      type: AchievementType.synthesis,
      targetValue: 100,
      iconName: 'auto_awesome',
      points: 50,
    ),
    Achievement(
      id: 'synthesis_expert',
      title: 'Synthesis Expert',
      description: 'Perform 500 color syntheses',
      type: AchievementType.synthesis,
      targetValue: 500,
      iconName: 'stars',
      points: 100,
    ),

    // Matching achievements
    Achievement(
      id: 'first_match',
      title: 'First Match',
      description: 'Clear your first color match',
      type: AchievementType.matching,
      targetValue: 1,
      iconName: 'celebration',
      points: 10,
    ),
    Achievement(
      id: 'match_master',
      title: 'Match Master',
      description: 'Clear 200 color matches',
      type: AchievementType.matching,
      targetValue: 200,
      iconName: 'emoji_events',
      points: 50,
    ),

    // Level achievements
    Achievement(
      id: 'level_5',
      title: 'Getting Started',
      description: 'Complete Level 5',
      type: AchievementType.level,
      targetValue: 5,
      iconName: 'flag',
      points: 25,
    ),
    Achievement(
      id: 'level_10',
      title: 'Dedicated Player',
      description: 'Complete Level 10',
      type: AchievementType.level,
      targetValue: 10,
      iconName: 'military_tech',
      points: 50,
    ),
    Achievement(
      id: 'level_20',
      title: 'Alchemist Veteran',
      description: 'Complete Level 20',
      type: AchievementType.level,
      targetValue: 20,
      iconName: 'workspace_premium',
      points: 100,
    ),

    // Score achievements
    Achievement(
      id: 'score_1000',
      title: 'Score Hunter',
      description: 'Reach 1000 points in a single level',
      type: AchievementType.score,
      targetValue: 1000,
      iconName: 'trending_up',
      points: 30,
    ),
    Achievement(
      id: 'score_5000',
      title: 'Score Master',
      description: 'Reach 5000 points in a single level',
      type: AchievementType.score,
      targetValue: 5000,
      iconName: 'show_chart',
      points: 75,
    ),

    // Efficiency achievements
    Achievement(
      id: 'efficient_win',
      title: 'Efficient Alchemist',
      description: 'Win a level with 10+ moves remaining',
      type: AchievementType.efficiency,
      targetValue: 10,
      iconName: 'speed',
      points: 40,
    ),
    Achievement(
      id: 'perfect_level',
      title: 'Perfect Execution',
      description: 'Win a level with 15+ moves remaining',
      type: AchievementType.efficiency,
      targetValue: 15,
      iconName: 'diamond',
      points: 75,
    ),
  ];
}
