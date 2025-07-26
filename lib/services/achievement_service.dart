import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';
import '../models/game_state.dart';

class AchievementService {
  static const String _achievementPrefix = 'achievement_';
  static const String _achievementTimePrefix = 'achievement_time_';

  static Future<List<Achievement>> getUnlockedAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Achievement> unlockedAchievements = [];

    for (final achievement in Achievement.allAchievements) {
      final isUnlocked = prefs.getBool('$_achievementPrefix${achievement.id}') ?? false;
      if (isUnlocked) {
        final unlockedTime = prefs.getInt('$_achievementTimePrefix${achievement.id}');
        final unlockedAt = unlockedTime != null 
            ? DateTime.fromMillisecondsSinceEpoch(unlockedTime)
            : null;
        
        unlockedAchievements.add(achievement.copyWith(
          isUnlocked: true,
          unlockedAt: unlockedAt,
        ));
      }
    }

    return unlockedAchievements;
  }

  static Future<bool> isAchievementUnlocked(String achievementId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_achievementPrefix$achievementId') ?? false;
  }

  static Future<Achievement?> unlockAchievement(String achievementId) async {
    final isAlreadyUnlocked = await isAchievementUnlocked(achievementId);
    if (isAlreadyUnlocked) return null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_achievementPrefix$achievementId', true);
    await prefs.setInt('$_achievementTimePrefix$achievementId', 
        DateTime.now().millisecondsSinceEpoch);

    final achievement = Achievement.allAchievements
        .firstWhere((a) => a.id == achievementId);
    
    return achievement.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );
  }

  static Future<List<Achievement>> checkAchievements(
    GameState gameState, 
    int levelTime, 
    bool usedUndo,
  ) async {
    final List<Achievement> newlyUnlocked = [];

    // Check level completion achievements
    if (gameState.isWon) {
      final levelAchievements = [
        ('first_level', 1),
        ('level_5', 5),
        ('level_10', 10),
      ];

      for (final (achievementId, targetLevel) in levelAchievements) {
        if (gameState.currentLevel >= targetLevel) {
          final achievement = await unlockAchievement(achievementId);
          if (achievement != null) {
            newlyUnlocked.add(achievement);
          }
        }
      }

      // Check perfect score achievement
      // This would need to be passed in or calculated differently
      
      // Check speed run achievement
      if (levelTime <= 30) {
        final achievement = await unlockAchievement('speed_demon');
        if (achievement != null) {
          newlyUnlocked.add(achievement);
        }
      }

      // Check no undo achievement
      if (!usedUndo) {
        final achievement = await unlockAchievement('no_undo_master');
        if (achievement != null) {
          newlyUnlocked.add(achievement);
        }
      }

      // Check bottle collector achievement
      if (gameState.bottles.length >= 10) {
        final achievement = await unlockAchievement('bottle_collector');
        if (achievement != null) {
          newlyUnlocked.add(achievement);
        }
      }
    }

    return newlyUnlocked;
  }

  static Future<int> getTotalUnlockedCount() async {
    final unlockedAchievements = await getUnlockedAchievements();
    return unlockedAchievements.length;
  }

  static Future<double> getCompletionPercentage() async {
    final unlockedCount = await getTotalUnlockedCount();
    return unlockedCount / Achievement.allAchievements.length;
  }
}