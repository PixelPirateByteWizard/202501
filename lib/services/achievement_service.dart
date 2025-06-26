import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement_model.dart';
import '../models/game_stats_model.dart';

/// Service for managing achievements and progress tracking
/// 管理成就和进度追踪的服务
class AchievementService {
  static final AchievementService _instance = AchievementService._internal();
  factory AchievementService() => _instance;
  AchievementService._internal();

  List<Achievement> _achievements = [];
  GameStats _gameStats = GameStats();

  List<Achievement> get achievements => _achievements;
  GameStats get gameStats => _gameStats;

  /// Initialize the service and load data
  /// 初始化服务并加载数据
  Future<void> initialize() async {
    await _loadAchievements();
    await _loadGameStats();
  }

  /// Load achievements from storage
  /// 从存储加载成就
  Future<void> _loadAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final achievementsJson = prefs.getString('achievements');

      // Initialize with default achievements
      _achievements = List.from(Achievement.allAchievements);

      if (achievementsJson != null) {
        final Map<String, dynamic> savedData = json.decode(achievementsJson);

        // Update achievements with saved progress
        for (int i = 0; i < _achievements.length; i++) {
          final achievementData = savedData[_achievements[i].id];
          if (achievementData != null) {
            _achievements[i] =
                Achievement.fromJson(achievementData, _achievements[i]);
          }
        }
      }
    } catch (e) {
      print('Error loading achievements: $e');
      _achievements = List.from(Achievement.allAchievements);
    }
  }

  /// Save achievements to storage
  /// 保存成就到存储
  Future<void> _saveAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> achievementsData = {};

      for (final achievement in _achievements) {
        achievementsData[achievement.id] = achievement.toJson();
      }

      await prefs.setString('achievements', json.encode(achievementsData));
    } catch (e) {
      print('Error saving achievements: $e');
    }
  }

  /// Load game statistics from storage
  /// 从存储加载游戏统计
  Future<void> _loadGameStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsJson = prefs.getString('gameStats');

      if (statsJson != null) {
        final Map<String, dynamic> statsData = json.decode(statsJson);
        _gameStats = GameStats.fromJson(statsData);
      }
    } catch (e) {
      print('Error loading game stats: $e');
      _gameStats = GameStats();
    }
  }

  /// Save game statistics to storage
  /// 保存游戏统计到存储
  Future<void> _saveGameStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gameStats', json.encode(_gameStats.toJson()));
    } catch (e) {
      print('Error saving game stats: $e');
    }
  }

  /// Record a synthesis action
  /// 记录合成操作
  Future<List<Achievement>> recordSynthesis() async {
    _gameStats.addSynthesis();

    final unlockedAchievements = <Achievement>[];

    // Update synthesis-related achievements
    for (int i = 0; i < _achievements.length; i++) {
      if (_achievements[i].type == AchievementType.synthesis) {
        _achievements[i] = _achievements[i].copyWith(
          currentProgress: _gameStats.totalSyntheses,
        );

        if (_achievements[i].shouldUnlock()) {
          _achievements[i] = _achievements[i].copyWith(isUnlocked: true);
          unlockedAchievements.add(_achievements[i]);
        }
      }
    }

    await _saveAchievements();
    await _saveGameStats();

    return unlockedAchievements;
  }

  /// Record a match action
  /// 记录匹配操作
  Future<List<Achievement>> recordMatch() async {
    _gameStats.addMatch();

    final unlockedAchievements = <Achievement>[];

    // Update matching-related achievements
    for (int i = 0; i < _achievements.length; i++) {
      if (_achievements[i].type == AchievementType.matching) {
        _achievements[i] = _achievements[i].copyWith(
          currentProgress: _gameStats.totalMatches,
        );

        if (_achievements[i].shouldUnlock()) {
          _achievements[i] = _achievements[i].copyWith(isUnlocked: true);
          unlockedAchievements.add(_achievements[i]);
        }
      }
    }

    await _saveAchievements();
    await _saveGameStats();

    return unlockedAchievements;
  }

  /// Record level completion
  /// 记录关卡完成
  Future<List<Achievement>> recordLevelCompletion(
      int level, int score, int movesUsed, int movesLeft) async {
    _gameStats.addLevelCompletion(level, score, movesUsed, movesLeft);

    final unlockedAchievements = <Achievement>[];

    // Update level-related achievements
    for (int i = 0; i < _achievements.length; i++) {
      final achievement = _achievements[i];

      switch (achievement.type) {
        case AchievementType.level:
          _achievements[i] = achievement.copyWith(
            currentProgress: _gameStats.totalLevelsCompleted,
          );
          break;

        case AchievementType.score:
          if (score >= achievement.targetValue) {
            _achievements[i] = achievement.copyWith(
              currentProgress: achievement.targetValue,
            );
          }
          break;

        case AchievementType.efficiency:
          if (movesLeft >= achievement.targetValue) {
            _achievements[i] = achievement.copyWith(
              currentProgress: achievement.targetValue,
            );
          }
          break;

        default:
          break;
      }

      if (_achievements[i].shouldUnlock()) {
        _achievements[i] = _achievements[i].copyWith(isUnlocked: true);
        unlockedAchievements.add(_achievements[i]);
      }
    }

    await _saveAchievements();
    await _saveGameStats();

    return unlockedAchievements;
  }

  /// Get total achievement points earned
  /// 获取获得的总成就点数
  int getTotalPoints() {
    return _achievements
        .where((a) => a.isUnlocked)
        .fold(0, (sum, a) => sum + a.points);
  }

  /// Get completion percentage
  /// 获取完成百分比
  double getCompletionPercentage() {
    final unlockedCount = _achievements.where((a) => a.isUnlocked).length;
    return unlockedCount / _achievements.length;
  }

  /// Get achievements by category
  /// 按类别获取成就
  List<Achievement> getAchievementsByType(AchievementType type) {
    return _achievements.where((a) => a.type == type).toList();
  }

  /// Reset all progress (for development/testing)
  /// 重置所有进度（用于开发/测试）
  Future<void> resetAllProgress() async {
    _achievements = List.from(Achievement.allAchievements);
    _gameStats = GameStats();

    await _saveAchievements();
    await _saveGameStats();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('highestLevel');
  }
}
