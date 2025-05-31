import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/player.dart';

class StorageService {
  static const String _gameStateKey = 'xianxiataifang_game_state';
  static const String _highScoreKey = 'xianxiataifang_high_score';
  static const String _maxWaveKey = 'xianxiataifang_max_wave';
  static const String _settingsKey = 'xianxiataifang_settings';

  // Save game state
  static Future<bool> saveGameState(GameState gameState) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameStateJson = json.encode(gameState.toJson());
      return await prefs.setString(_gameStateKey, gameStateJson);
    } catch (e) {
      print('Failed to save game state: $e');
      return false;
    }
  }

  // Load game state
  static Future<GameState?> loadGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameStateJson = prefs.getString(_gameStateKey);

      if (gameStateJson == null) {
        return null;
      }

      final Map<String, dynamic> gameStateMap = json.decode(gameStateJson);
      return GameState.fromJson(gameStateMap);
    } catch (e) {
      print('Failed to load game state: $e');
      return null;
    }
  }

  // Clear saved game state
  static Future<bool> clearGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_gameStateKey);
    } catch (e) {
      print('Failed to clear game state: $e');
      return false;
    }
  }

  // Save high score
  static Future<bool> saveHighScore(int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentHighScore = prefs.getInt(_highScoreKey) ?? 0;

      if (score > currentHighScore) {
        return await prefs.setInt(_highScoreKey, score);
      }

      return true;
    } catch (e) {
      print('Failed to save high score: $e');
      return false;
    }
  }

  // Load high score
  static Future<int> loadHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_highScoreKey) ?? 0;
    } catch (e) {
      print('Failed to load high score: $e');
      return 0;
    }
  }

  // Save max wave
  static Future<bool> saveMaxWave(int wave) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentMaxWave = prefs.getInt(_maxWaveKey) ?? 0;

      if (wave > currentMaxWave) {
        return await prefs.setInt(_maxWaveKey, wave);
      }

      return true;
    } catch (e) {
      print('Failed to save max wave: $e');
      return false;
    }
  }

  // Load max wave
  static Future<int> loadMaxWave() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_maxWaveKey) ?? 0;
    } catch (e) {
      print('Failed to load max wave: $e');
      return 0;
    }
  }

  // Save game settings
  static Future<bool> saveSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(settings);
      return await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      print('Failed to save settings: $e');
      return false;
    }
  }

  // Load game settings
  static Future<Map<String, dynamic>> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson == null) {
        // Return default settings
        return {
          'soundEnabled': true,
          'musicEnabled': true,
          'vibrationEnabled': true,
          'difficulty': 'normal', // easy, normal, hard
        };
      }

      return json.decode(settingsJson);
    } catch (e) {
      print('Failed to load settings: $e');
      return {
        'soundEnabled': true,
        'musicEnabled': true,
        'vibrationEnabled': true,
        'difficulty': 'normal',
      };
    }
  }

  // Save player record (including high score and max wave)
  static Future<bool> savePlayerRecord(Player player) async {
    try {
      await saveHighScore(player.cultivationLevel);
      await saveMaxWave(player.maxWave);
      return true;
    } catch (e) {
      print('Failed to save player record: $e');
      return false;
    }
  }
}
