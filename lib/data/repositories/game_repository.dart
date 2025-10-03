import '../models/game_model.dart';
import '../models/settings_model.dart';

abstract class GameRepository {
  // Game state operations
  Future<void> saveGame(GameModel game);
  Future<GameModel?> loadGame();
  Future<void> resetGame();

  // Best score operations
  Future<void> saveBestScore(int score);
  Future<int> loadBestScore();
  Future<void> resetBestScore();

  // Game stats operations
  Future<void> saveStats(GameStatsModel stats);
  Future<GameStatsModel> loadStats();

  // Settings operations
  Future<void> saveSettings(SettingsModel settings);
  Future<SettingsModel> loadSettings();
}
