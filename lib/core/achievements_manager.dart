import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'game_engine.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  bool isUnlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  factory Achievement.fromJson(
      Map<String, dynamic> json, Achievement template) {
    return Achievement(
      id: template.id,
      title: template.title,
      description: template.description,
      icon: template.icon,
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
    );
  }
}

class GameRecord {
  final GameDifficulty difficulty;
  final Duration bestTime;
  final int bestMoves;
  final DateTime achievedAt;

  GameRecord({
    required this.difficulty,
    required this.bestTime,
    required this.bestMoves,
    required this.achievedAt,
  });

  Map<String, dynamic> toJson() => {
        'difficulty': difficulty.index,
        'bestTime': bestTime.inSeconds,
        'bestMoves': bestMoves,
        'achievedAt': achievedAt.toIso8601String(),
      };

  factory GameRecord.fromJson(Map<String, dynamic> json) {
    return GameRecord(
      difficulty: GameDifficulty.values[json['difficulty']],
      bestTime: Duration(seconds: json['bestTime']),
      bestMoves: json['bestMoves'],
      achievedAt: DateTime.parse(json['achievedAt']),
    );
  }
}

class AchievementsManager {
  static const String _achievementsKey = 'achievements';
  static const String _recordsKey = 'game_records';

  static final List<Achievement> _achievementTemplates = [
    Achievement(
      id: 'easy_master',
      title: '初级大师',
      description: '在简单难度下完成游戏',
      icon: Icons.star,
    ),
    Achievement(
      id: 'medium_master',
      title: '中级大师',
      description: '在中等难度下完成游戏',
      icon: Icons.workspace_premium,
    ),
    Achievement(
      id: 'hard_master',
      title: '高级大师',
      description: '在困难难度下完成游戏',
      icon: Icons.military_tech,
    ),
    Achievement(
      id: 'speed_master',
      title: '速度之王',
      description: '在60秒内完成任意难度',
      icon: Icons.speed,
    ),
    Achievement(
      id: 'precision_master',
      title: '精确大师',
      description: '用最少步数完成游戏',
      icon: Icons.precision_manufacturing,
    ),
    Achievement(
      id: 'dedication',
      title: '专注力',
      description: '完成10局游戏',
      icon: Icons.psychology,
    ),
  ];

  List<Achievement> _achievements = [];
  Map<GameDifficulty, GameRecord> _records = {};

  // 单例模式
  static final AchievementsManager _instance = AchievementsManager._internal();
  factory AchievementsManager() => _instance;
  AchievementsManager._internal();

  Future<void> initialize() async {
    await _loadAchievements();
    await _loadRecords();
  }

  Future<void> _loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final String? achievementsJson = prefs.getString(_achievementsKey);

    if (achievementsJson != null) {
      final List<dynamic> savedAchievements = jsonDecode(achievementsJson);
      _achievements = _achievementTemplates.map((template) {
        final savedData = savedAchievements.firstWhere(
          (a) => a['id'] == template.id,
          orElse: () => template.toJson(),
        );
        return Achievement.fromJson(savedData, template);
      }).toList();
    } else {
      _achievements = List.from(_achievementTemplates);
    }
  }

  Future<void> _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? recordsJson = prefs.getString(_recordsKey);

    if (recordsJson != null) {
      final Map<String, dynamic> savedRecords = jsonDecode(recordsJson);
      _records = Map.fromEntries(
        savedRecords.entries.map((entry) {
          return MapEntry(
            GameDifficulty.values[int.parse(entry.key)],
            GameRecord.fromJson(entry.value),
          );
        }),
      );
    }
  }

  Future<void> _saveAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = jsonEncode(
      _achievements.map((a) => a.toJson()).toList(),
    );
    await prefs.setString(_achievementsKey, achievementsJson);
  }

  Future<void> _saveRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = jsonEncode(
      Map.fromEntries(
        _records.entries.map((entry) {
          return MapEntry(
            entry.key.index.toString(),
            entry.value.toJson(),
          );
        }),
      ),
    );
    await prefs.setString(_recordsKey, recordsJson);
  }

  List<Achievement> get achievements => List.unmodifiable(_achievements);
  Map<GameDifficulty, GameRecord> get records => Map.unmodifiable(_records);

  Future<void> onGameCompleted(
    GameDifficulty difficulty,
    Duration time,
    int moves,
  ) async {
    // 更新记录
    if (!_records.containsKey(difficulty) ||
        time < _records[difficulty]!.bestTime ||
        moves < _records[difficulty]!.bestMoves) {
      _records[difficulty] = GameRecord(
        difficulty: difficulty,
        bestTime: time,
        bestMoves: moves,
        achievedAt: DateTime.now(),
      );
      await _saveRecords();
    }

    // 检查并解锁成就
    bool achievementsUpdated = false;

    // 难度相关成就
    String difficultyAchievementId;
    switch (difficulty) {
      case GameDifficulty.easy:
        difficultyAchievementId = 'easy_master';
        break;
      case GameDifficulty.medium:
        difficultyAchievementId = 'medium_master';
        break;
      case GameDifficulty.hard:
        difficultyAchievementId = 'hard_master';
        break;
    }

    final difficultyAchievement = _achievements.firstWhere(
      (a) => a.id == difficultyAchievementId,
    );
    if (!difficultyAchievement.isUnlocked) {
      difficultyAchievement.isUnlocked = true;
      achievementsUpdated = true;
    }

    // 速度成就
    if (time.inSeconds <= 60) {
      final speedAchievement = _achievements.firstWhere(
        (a) => a.id == 'speed_master',
      );
      if (!speedAchievement.isUnlocked) {
        speedAchievement.isUnlocked = true;
        achievementsUpdated = true;
      }
    }

    // 精确成就
    int minMoves = (difficulty.gridSize * difficulty.gridSize - 1) * 2;
    if (moves <= minMoves) {
      final precisionAchievement = _achievements.firstWhere(
        (a) => a.id == 'precision_master',
      );
      if (!precisionAchievement.isUnlocked) {
        precisionAchievement.isUnlocked = true;
        achievementsUpdated = true;
      }
    }

    if (achievementsUpdated) {
      await _saveAchievements();
    }
  }

  Future<void> resetProgress() async {
    _achievements = List.from(_achievementTemplates);
    _records.clear();
    await _saveAchievements();
    await _saveRecords();
  }
}
