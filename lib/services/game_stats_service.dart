import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GameStatsService {
  static const String _statsKey = 'game_stats';

  Future<GameStats> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_statsKey);
    
    if (statsJson == null) {
      final defaultStats = GameStats();
      await _saveStats(defaultStats);
      return defaultStats;
    }
    
    final statsMap = jsonDecode(statsJson) as Map<String, dynamic>;
    return GameStats.fromJson(statsMap);
  }

  Future<void> _saveStats(GameStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = jsonEncode(stats.toJson());
    await prefs.setString(_statsKey, statsJson);
  }

  Future<void> incrementStoriesGenerated() async {
    final stats = await getStats();
    final updatedStats = stats.copyWith(
      storiesGenerated: stats.storiesGenerated + 1,
      totalPlayTime: stats.totalPlayTime + const Duration(minutes: 2),
    );
    await _saveStats(updatedStats);
  }

  Future<void> incrementChoicesMade() async {
    final stats = await getStats();
    final updatedStats = stats.copyWith(
      choicesMade: stats.choicesMade + 1,
    );
    await _saveStats(updatedStats);
  }

  Future<void> addLocationVisited(String locationId) async {
    final stats = await getStats();
    final visitedLocations = Set<String>.from(stats.locationsVisited);
    visitedLocations.add(locationId);
    
    final updatedStats = stats.copyWith(
      locationsVisited: visitedLocations.toList(),
    );
    await _saveStats(updatedStats);
  }

  Future<void> addPlayTime(Duration duration) async {
    final stats = await getStats();
    final updatedStats = stats.copyWith(
      totalPlayTime: stats.totalPlayTime + duration,
    );
    await _saveStats(updatedStats);
  }

  Future<void> updateLastPlayed() async {
    final stats = await getStats();
    final updatedStats = stats.copyWith(
      lastPlayed: DateTime.now(),
    );
    await _saveStats(updatedStats);
  }
}

class GameStats {
  final int storiesGenerated;
  final int choicesMade;
  final List<String> locationsVisited;
  final Duration totalPlayTime;
  final DateTime lastPlayed;
  final DateTime firstPlayed;
  final int sessionsPlayed;

  GameStats({
    this.storiesGenerated = 0,
    this.choicesMade = 0,
    this.locationsVisited = const [],
    this.totalPlayTime = Duration.zero,
    DateTime? lastPlayed,
    DateTime? firstPlayed,
    this.sessionsPlayed = 0,
  }) : lastPlayed = lastPlayed ?? DateTime.now(),
       firstPlayed = firstPlayed ?? DateTime.now();

  GameStats copyWith({
    int? storiesGenerated,
    int? choicesMade,
    List<String>? locationsVisited,
    Duration? totalPlayTime,
    DateTime? lastPlayed,
    DateTime? firstPlayed,
    int? sessionsPlayed,
  }) {
    return GameStats(
      storiesGenerated: storiesGenerated ?? this.storiesGenerated,
      choicesMade: choicesMade ?? this.choicesMade,
      locationsVisited: locationsVisited ?? this.locationsVisited,
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      firstPlayed: firstPlayed ?? this.firstPlayed,
      sessionsPlayed: sessionsPlayed ?? this.sessionsPlayed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storiesGenerated': storiesGenerated,
      'choicesMade': choicesMade,
      'locationsVisited': locationsVisited,
      'totalPlayTime': totalPlayTime.inMilliseconds,
      'lastPlayed': lastPlayed.toIso8601String(),
      'firstPlayed': firstPlayed.toIso8601String(),
      'sessionsPlayed': sessionsPlayed,
    };
  }

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      storiesGenerated: json['storiesGenerated'] ?? 0,
      choicesMade: json['choicesMade'] ?? 0,
      locationsVisited: List<String>.from(json['locationsVisited'] ?? []),
      totalPlayTime: Duration(milliseconds: json['totalPlayTime'] ?? 0),
      lastPlayed: DateTime.parse(json['lastPlayed'] ?? DateTime.now().toIso8601String()),
      firstPlayed: DateTime.parse(json['firstPlayed'] ?? DateTime.now().toIso8601String()),
      sessionsPlayed: json['sessionsPlayed'] ?? 0,
    );
  }

  String get formattedPlayTime {
    final hours = totalPlayTime.inHours;
    final minutes = totalPlayTime.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  double get averageSessionTime {
    if (sessionsPlayed == 0) return 0.0;
    return totalPlayTime.inMinutes / sessionsPlayed;
  }
}