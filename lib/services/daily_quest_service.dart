import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/daily_quest.dart';

class DailyQuestService {
  static const String _questsKey = 'daily_quests';
  static const String _lastGeneratedKey = 'last_quest_generated';
  
  final Uuid _uuid = const Uuid();
  final Random _random = Random();

  Future<List<DailyQuest>> getDailyQuests() async {
    await _generateQuestsIfNeeded();
    
    final prefs = await SharedPreferences.getInstance();
    final questsJson = prefs.getString(_questsKey) ?? '[]';
    final questsList = jsonDecode(questsJson) as List;
    
    return questsList.map((json) => DailyQuest.fromJson(json)).toList();
  }

  Future<void> _generateQuestsIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastGenerated = prefs.getString(_lastGeneratedKey);
    final today = DateTime.now();
    
    if (lastGenerated == null || 
        !_isSameDay(DateTime.parse(lastGenerated), today)) {
      await _generateDailyQuests();
      await prefs.setString(_lastGeneratedKey, today.toIso8601String());
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  Future<void> _generateDailyQuests() async {
    final quests = <DailyQuest>[];
    final today = DateTime.now();

    // 生成3个每日任务
    final questTemplates = [
      {
        'title': 'Story Creator',
        'description': 'Generate {target} AI stories',
        'type': QuestType.generateStories,
        'target': 3 + _random.nextInt(3), // 3-5
        'rewards': {'Experience': 50, 'Gears': 10},
      },
      {
        'title': 'Decision Expert',
        'description': 'Make {target} choices',
        'type': QuestType.makeChoices,
        'target': 5 + _random.nextInt(5), // 5-9
        'rewards': {'Experience': 30, 'Energy': 20},
      },
      {
        'title': 'Explorer',
        'description': 'Visit {target} different locations',
        'type': QuestType.visitLocations,
        'target': 2 + _random.nextInt(2), // 2-3
        'rewards': {'Experience': 75, 'Ancient Key': 1},
      },
      {
        'title': 'Gaming Expert',
        'description': 'Play for {target} minutes',
        'type': QuestType.playTime,
        'target': 15 + _random.nextInt(15), // 15-29
        'rewards': {'Experience': 40, 'Steam': 15},
      },
    ];

    // 随机选择3个任务
    questTemplates.shuffle(_random);
    for (int i = 0; i < 3; i++) {
      final template = questTemplates[i];
      final target = template['target'] as int;
      
      quests.add(DailyQuest(
        id: _uuid.v4(),
        title: template['title'] as String,
        description: (template['description'] as String).replaceAll('{target}', target.toString()),
        type: template['type'] as QuestType,
        targetValue: target,
        rewards: template['rewards'] as Map<String, dynamic>,
        createdAt: today,
      ));
    }

    await _saveQuests(quests);
  }

  Future<void> _saveQuests(List<DailyQuest> quests) async {
    final prefs = await SharedPreferences.getInstance();
    final questsJson = jsonEncode(quests.map((q) => q.toJson()).toList());
    await prefs.setString(_questsKey, questsJson);
  }

  Future<void> updateQuestProgress({
    required int storiesGenerated,
    required int choicesMade,
    required int locationsVisited,
    required int playTimeMinutes,
  }) async {
    final quests = await getDailyQuests();
    bool hasUpdates = false;

    for (int i = 0; i < quests.length; i++) {
      final quest = quests[i];
      if (quest.status != QuestStatus.active) continue;

      int newProgress = quest.currentProgress;
      
      switch (quest.type) {
        case QuestType.generateStories:
          newProgress = storiesGenerated;
          break;
        case QuestType.makeChoices:
          newProgress = choicesMade;
          break;
        case QuestType.visitLocations:
          newProgress = locationsVisited;
          break;
        case QuestType.playTime:
          newProgress = playTimeMinutes;
          break;
        case QuestType.unlockAchievements:
          // 这个需要从成就服务获取数据
          break;
      }

      if (newProgress != quest.currentProgress) {
        final updatedQuest = quest.copyWith(
          currentProgress: newProgress,
          status: newProgress >= quest.targetValue 
              ? QuestStatus.completed 
              : QuestStatus.active,
          completedAt: newProgress >= quest.targetValue 
              ? DateTime.now() 
              : null,
        );
        
        quests[i] = updatedQuest;
        hasUpdates = true;
      }
    }

    if (hasUpdates) {
      await _saveQuests(quests);
    }
  }

  Future<bool> claimQuestReward(String questId) async {
    final quests = await getDailyQuests();
    final questIndex = quests.indexWhere((q) => q.id == questId);
    
    if (questIndex == -1) return false;
    
    final quest = quests[questIndex];
    if (quest.status != QuestStatus.completed) return false;
    
    final updatedQuest = quest.copyWith(status: QuestStatus.claimed);
    quests[questIndex] = updatedQuest;
    
    await _saveQuests(quests);
    return true;
  }

  Future<List<DailyQuest>> getCompletedQuests() async {
    final quests = await getDailyQuests();
    return quests.where((q) => q.status == QuestStatus.completed).toList();
  }
}