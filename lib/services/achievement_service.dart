import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';

class AchievementService {
  static const String _achievementsKey = 'achievements';
  static const String _unlockedAchievementsKey = 'unlocked_achievements';

  Future<List<Achievement>> getAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = prefs.getString(_achievementsKey);
    final unlockedIds = prefs.getStringList(_unlockedAchievementsKey) ?? [];
    
    if (achievementsJson == null) {
      final defaultAchievements = _getDefaultAchievements();
      await _saveAchievements(defaultAchievements);
      return defaultAchievements.map((achievement) {
        return achievement.copyWith(
          isUnlocked: unlockedIds.contains(achievement.id),
        );
      }).toList();
    }
    
    final achievementsList = jsonDecode(achievementsJson) as List;
    return achievementsList.map((json) {
      final achievement = Achievement.fromJson(json);
      return achievement.copyWith(
        isUnlocked: unlockedIds.contains(achievement.id),
      );
    }).toList();
  }

  Future<void> _saveAchievements(List<Achievement> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = jsonEncode(
      achievements.map((achievement) => achievement.toJson()).toList(),
    );
    await prefs.setString(_achievementsKey, achievementsJson);
  }

  Future<bool> unlockAchievement(String achievementId) async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedIds = prefs.getStringList(_unlockedAchievementsKey) ?? [];
    
    if (unlockedIds.contains(achievementId)) {
      return false; // Already unlocked
    }
    
    unlockedIds.add(achievementId);
    await prefs.setStringList(_unlockedAchievementsKey, unlockedIds);
    return true; // Newly unlocked
  }

  Future<void> checkStoryAchievements({
    required int storiesGenerated,
    required int choicesMade,
    required int locationsVisited,
    required int mapsUnlocked,
  }) async {
    final achievements = await getAchievements();
    
    for (final achievement in achievements) {
      if (achievement.isUnlocked) continue;
      
      bool shouldUnlock = false;
      
      switch (achievement.id) {
        case 'first_story':
          shouldUnlock = storiesGenerated >= 1;
          break;
        case 'story_explorer':
          shouldUnlock = storiesGenerated >= 10;
          break;
        case 'story_master':
          shouldUnlock = storiesGenerated >= 50;
          break;
        case 'decision_maker':
          shouldUnlock = choicesMade >= 25;
          break;
        case 'world_traveler':
          shouldUnlock = locationsVisited >= 5;
          break;
        case 'map_collector':
          shouldUnlock = mapsUnlocked >= 2;
          break;
        case 'adventure_seeker':
          shouldUnlock = locationsVisited >= 10 && choicesMade >= 50;
          break;
      }
      
      if (shouldUnlock) {
        await unlockAchievement(achievement.id);
      }
    }
  }

  List<Achievement> _getDefaultAchievements() {
    return [
      Achievement(
        id: 'first_story',
        name: 'First Adventure',
        description: 'Generate your first AI story',
        icon: 'auto_stories',
        type: AchievementType.story,
        rarity: AchievementRarity.common,
        maxProgress: 1,
        rewards: {'points': 10},
      ),
      Achievement(
        id: 'story_explorer',
        name: 'Story Explorer',
        description: 'Generate 10 AI stories',
        icon: 'explore',
        type: AchievementType.story,
        rarity: AchievementRarity.rare,
        maxProgress: 10,
        rewards: {'points': 25},
      ),
      Achievement(
        id: 'story_master',
        name: 'Story Master',
        description: 'Generate 50 AI stories',
        icon: 'psychology',
        type: AchievementType.story,
        rarity: AchievementRarity.epic,
        maxProgress: 50,
        rewards: {'points': 100},
      ),
      Achievement(
        id: 'decision_maker',
        name: 'Decision Maker',
        description: 'Make 25 choices',
        icon: 'psychology_alt',
        type: AchievementType.exploration,
        rarity: AchievementRarity.rare,
        maxProgress: 25,
        rewards: {'points': 30},
      ),
      Achievement(
        id: 'world_traveler',
        name: 'World Traveler',
        description: 'Visit 5 different locations',
        icon: 'public',
        type: AchievementType.exploration,
        rarity: AchievementRarity.common,
        maxProgress: 5,
        rewards: {'points': 20},
      ),
      Achievement(
        id: 'map_collector',
        name: 'Map Collector',
        description: 'Unlock 2 new maps',
        icon: 'map',
        type: AchievementType.exploration,
        rarity: AchievementRarity.epic,
        maxProgress: 2,
        rewards: {'points': 75},
      ),
      Achievement(
        id: 'adventure_seeker',
        name: 'Adventure Seeker',
        description: 'Visit 10 locations and make 50 choices',
        icon: 'adventure',
        type: AchievementType.exploration,
        rarity: AchievementRarity.legendary,
        maxProgress: 1,
        rewards: {'points': 200},
      ),
    ];
  }
}