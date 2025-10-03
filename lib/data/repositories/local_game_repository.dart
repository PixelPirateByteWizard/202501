import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_model.dart';
import '../models/settings_model.dart';
import 'game_repository.dart';
import '../../presentation/utils/constants.dart';

class LocalGameRepository implements GameRepository {
  // Game state operations
  @override
  Future<void> saveGame(GameModel game) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(GameConstants.KEY_GAME_STATE, game.serialize());

    // Update best score if needed
    if (game.score > await loadBestScore()) {
      await saveBestScore(game.score);
    }
  }

  @override
  Future<GameModel?> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final gameJson = prefs.getString(GameConstants.KEY_GAME_STATE);

    if (gameJson == null) {
      return null;
    }

    try {
      final game = GameModel.deserialize(gameJson);

      // Ensure best score is up to date
      final bestScore = await loadBestScore();
      return game.copyWith(bestScore: bestScore);
    } catch (e) {
      // If there's an error parsing the saved game, return null
      return null;
    }
  }

  @override
  Future<void> resetGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(GameConstants.KEY_GAME_STATE);
  }

  // Best score operations
  @override
  Future<void> saveBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(GameConstants.KEY_BEST_SCORE, score);
  }

  @override
  Future<int> loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(GameConstants.KEY_BEST_SCORE) ?? 0;
  }

  @override
  Future<void> resetBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(GameConstants.KEY_BEST_SCORE);
  }

  // Game stats operations
  @override
  Future<void> saveStats(GameStatsModel stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(GameConstants.KEY_STATS, jsonEncode(stats.toJson()));
  }

  @override
  Future<GameStatsModel> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(GameConstants.KEY_STATS);

    if (statsJson == null) {
      return GameStatsModel(
        maxTileValue: 0,
        totalGamesPlayed: 0,
        gamesWon: 0,
        totalPlayTime: const Duration(),
        bestGameTime: const Duration(hours: 99),
        tileMergeCount: {},
        recentScores: [],
      );
    }

    try {
      return GameStatsModel.fromJson(jsonDecode(statsJson));
    } catch (e) {
      // If there's an error parsing the stats, return default stats
      return GameStatsModel(
        maxTileValue: 0,
        totalGamesPlayed: 0,
        gamesWon: 0,
        totalPlayTime: const Duration(),
        bestGameTime: const Duration(hours: 99),
        tileMergeCount: {},
        recentScores: [],
      );
    }
  }

  // Settings operations
  @override
  Future<void> saveSettings(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(GameConstants.KEY_SETTINGS, settings.serialize());
  }

  @override
  Future<SettingsModel> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(GameConstants.KEY_SETTINGS);

    if (settingsJson == null) {
      return SettingsModel.defaultSettings();
    }

    try {
      return SettingsModel.deserialize(settingsJson);
    } catch (e) {
      // If there's an error parsing the settings, return default settings
      return SettingsModel.defaultSettings();
    }
  }
}
