import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 定义成就模型
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  const Achievement(
      {required this.id,
      required this.title,
      required this.description,
      required this.icon});
}

// 定义游戏统计数据模型
class GameStats {
  final int highScore;
  final int totalGamesPlayed;
  final int totalEnemiesDefeated;
  final int longestTimeInSeconds;
  final Set<String> unlockedAchievementIds;

  GameStats({
    this.highScore = 0,
    this.totalGamesPlayed = 0,
    this.totalEnemiesDefeated = 0,
    this.longestTimeInSeconds = 0,
    this.unlockedAchievementIds = const {},
  });
}

class StorageService {
  static const String _highScoreKey = 'highScore';
  static const String _totalGamesPlayedKey = 'totalGamesPlayed';
  static const String _totalEnemiesDefeatedKey = 'totalEnemiesDefeated';
  static const String _longestTimeKey = 'longestTimeInSeconds';
  static const String _unlockedAchievementsKey = 'unlockedAchievements';

  // 预定义所有成就
  static final List<Achievement> _allAchievements = [
    const Achievement(
        id: 'first_game',
        title: '初出茅庐',
        description: '完成你的第一场游戏。',
        icon: Icons.sports_esports),
    const Achievement(
        id: 'survive_1_min',
        title: '幸存者',
        description: '在一局游戏中生存超过1分钟。',
        icon: Icons.timer),
    const Achievement(
        id: 'survive_5_min',
        title: '战场老兵',
        description: '在一局游戏中生存超过5分钟。',
        icon: Icons.shield),
    const Achievement(
        id: 'reach_100_blades',
        title: '刀锋领主',
        description: '刀锋数量达到100。',
        icon: Icons.flash_on),
    const Achievement(
        id: 'defeat_titan',
        title: '泰坦杀手',
        description: '成功击败一个泰坦。',
        icon: Icons.auto_awesome),
  ];

  static List<Achievement> getAllAchievements() => _allAchievements;

  // 获取完整的游戏统计数据
  static Future<GameStats> getGameStats() async {
    final prefs = await SharedPreferences.getInstance();
    return GameStats(
      highScore: prefs.getInt(_highScoreKey) ?? 0,
      totalGamesPlayed: prefs.getInt(_totalGamesPlayedKey) ?? 0,
      totalEnemiesDefeated: prefs.getInt(_totalEnemiesDefeatedKey) ?? 0,
      longestTimeInSeconds: prefs.getInt(_longestTimeKey) ?? 0,
      unlockedAchievementIds:
          (prefs.getStringList(_unlockedAchievementsKey) ?? []).toSet(),
    );
  }

  // 保存完整的游戏统计数据
  static Future<void> saveGameStats(GameStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_highScoreKey, stats.highScore);
    await prefs.setInt(_totalGamesPlayedKey, stats.totalGamesPlayed);
    await prefs.setInt(_totalEnemiesDefeatedKey, stats.totalEnemiesDefeated);
    await prefs.setInt(_longestTimeKey, stats.longestTimeInSeconds);
    await prefs.setStringList(
        _unlockedAchievementsKey, stats.unlockedAchievementIds.toList());
  }
}
