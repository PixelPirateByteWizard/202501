import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _currentLevelKey = 'current_level';
  static const String _levelStarsKey = 'level_stars_';
  static const String _bestMovesKey = 'best_moves_';

  static Future<int> getCurrentLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentLevelKey) ?? 1;
  }

  static Future<void> setCurrentLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentLevelKey, level);
  }

  static Future<int> getLevelStars(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_levelStarsKey$level') ?? 0;
  }

  static Future<void> setLevelStars(int level, int stars) async {
    final prefs = await SharedPreferences.getInstance();
    final currentStars = await getLevelStars(level);
    if (stars > currentStars) {
      await prefs.setInt('$_levelStarsKey$level', stars);
    }
  }

  static Future<int> getBestMoves(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_bestMovesKey$level') ?? 999;
  }

  static Future<void> setBestMoves(int level, int moves) async {
    final prefs = await SharedPreferences.getInstance();
    final currentBest = await getBestMoves(level);
    if (moves < currentBest) {
      await prefs.setInt('$_bestMovesKey$level', moves);
    }
  }

  static Future<void> unlockNextLevel(int currentLevel) async {
    final maxUnlockedLevel = await getCurrentLevel();
    if (currentLevel >= maxUnlockedLevel) {
      await setCurrentLevel(currentLevel + 1);
    }
  }
}