import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';
import '../models/game_progress.dart';
import '../models/general.dart';
import '../models/shop_item.dart';
import 'game_data_service.dart';

class AchievementService {
  static const String _achievementsKey = 'achievements';

  // 获取所有成就
  static Future<List<Achievement>> getAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = prefs.getString(_achievementsKey);

    if (achievementsJson != null) {
      final List<dynamic> achievementsList = jsonDecode(achievementsJson);
      return achievementsList
          .map((json) => Achievement.fromJson(json))
          .toList();
    }

    return _getDefaultAchievements();
  }

  // 保存成就
  static Future<void> saveAchievements(List<Achievement> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = achievements.map((a) => a.toJson()).toList();
    await prefs.setString(_achievementsKey, jsonEncode(achievementsJson));
  }

  // 更新成就进度
  static Future<List<Achievement>> updateAchievementProgress(
    String achievementId,
    int increment,
  ) async {
    final achievements = await getAchievements();
    final index = achievements.indexWhere((a) => a.id == achievementId);

    if (index != -1) {
      final achievement = achievements[index];
      final newValue = (achievement.currentValue + increment).clamp(
        0,
        achievement.targetValue,
      );

      achievements[index] = achievement.copyWith(currentValue: newValue);

      // 检查是否可以解锁
      if (achievements[index].canUnlock(achievements) &&
          !achievements[index].isUnlocked) {
        achievements[index] = achievements[index].copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );

        // 发放奖励
        await _grantRewards(achievements[index]);
      }

      await saveAchievements(achievements);
    }

    return achievements;
  }

  // 检查并更新所有相关成就
  static Future<List<Achievement>> checkAndUpdateAchievements() async {
    final achievements = await getAchievements();
    final progress = await GameDataService.getGameProgress();
    final generals = await GameDataService.getGenerals();
    final inventory = await GameDataService.getInventory();
    final purchaseHistory = await GameDataService.getPurchaseHistory();

    bool hasUpdates = false;

    for (int i = 0; i < achievements.length; i++) {
      final achievement = achievements[i];
      if (achievement.isUnlocked) continue;

      int newValue = _calculateAchievementProgress(
        achievement,
        progress,
        generals,
        inventory,
        purchaseHistory,
      );

      if (newValue != achievement.currentValue) {
        achievements[i] = achievement.copyWith(currentValue: newValue);
        hasUpdates = true;

        // 检查是否可以解锁
        if (achievements[i].canUnlock(achievements)) {
          achievements[i] = achievements[i].copyWith(
            isUnlocked: true,
            unlockedAt: DateTime.now(),
          );
          await _grantRewards(achievements[i]);
        }
      }
    }

    if (hasUpdates) {
      await saveAchievements(achievements);
    }

    return achievements;
  }

  // 计算成就进度
  static int _calculateAchievementProgress(
    Achievement achievement,
    GameProgress progress,
    List<General> generals,
    List<dynamic> inventory,
    List<PurchaseRecord> purchaseHistory,
  ) {
    switch (achievement.id) {
      // 进度相关成就
      case 'reach_level_5':
        return progress.playerLevel;
      case 'reach_level_10':
        return progress.playerLevel;
      case 'reach_level_20':
        return progress.playerLevel;
      case 'complete_chapter_1':
        return progress.currentChapter > 1 ? 1 : 0;
      case 'complete_chapter_3':
        return progress.currentChapter > 3 ? 1 : 0;
      case 'complete_10_stages':
        return progress.completedStages.length;
      case 'complete_50_stages':
        return progress.completedStages.length;

      // 收集相关成就
      case 'collect_5_generals':
        return progress.unlockedGenerals.length;
      case 'collect_10_generals':
        return progress.unlockedGenerals.length;
      case 'collect_all_shu_generals':
        final shuGenerals = [
          'liu_bei',
          'guan_yu',
          'zhang_fei',
          'zhao_yun',
          'zhuge_liang',
        ];
        return shuGenerals
            .where((id) => progress.unlockedGenerals.contains(id))
            .length;
      case 'collect_100_items':
        int total = 0;
        for (final item in inventory) {
          final quantity = item.quantity;
          if (quantity is int) {
            total += quantity;
          } else if (quantity is double) {
            total += quantity.round();
          } else if (quantity != null) {
            total += (quantity as num).round();
          } else {
            total += 1;
          }
        }
        return total;
      case 'collect_legendary_weapon':
        return inventory.any(
              (item) => item.type?.index == 0 && item.name.contains('龙'),
            )
            ? 1
            : 0;

      // 战斗相关成就
      case 'win_first_battle':
        return progress.completedStages.isNotEmpty ? 1 : 0;
      case 'win_10_battles':
        return progress.completedStages.length;
      case 'win_100_battles':
        return progress.completedStages.length;

      // 财富相关成就
      case 'earn_1000_gold':
        return progress.gold >= 1000 ? 1 : 0;
      case 'earn_10000_gold':
        return progress.gold >= 10000 ? 1 : 0;
      case 'spend_5000_gold':
        return purchaseHistory.fold<int>(
          0,
          (sum, record) => sum + record.totalPrice,
        );

      // 特殊成就
      case 'first_purchase':
        return purchaseHistory.isNotEmpty ? 1 : 0;
      case 'shopaholic':
        return purchaseHistory.length;
      case 'max_level_general':
        return generals.any((g) => g.level >= 50) ? 1 : 0;

      default:
        return achievement.currentValue;
    }
  }

  // 发放奖励
  static Future<void> _grantRewards(Achievement achievement) async {
    final progress = await GameDataService.getGameProgress();

    int goldReward = achievement.rewards['gold'] ?? 0;
    int expReward = achievement.rewards['experience'] ?? 0;
    List<String> itemRewards = List<String>.from(
      achievement.rewards['items'] ?? [],
    );

    // 发放金币和经验（合并更新避免多次保存）
    if (goldReward > 0 || expReward > 0) {
      final updatedProgress = progress.copyWith(
        gold: progress.gold + goldReward,
        experience: progress.experience + expReward,
      );
      await GameDataService.saveGameProgressWithoutAchievementCheck(updatedProgress);
    }

    // 发放物品
    for (String _ in itemRewards) {
      // 这里需要根据实际的物品系统来实现
      // 暂时跳过物品奖励的实现
    }
  }

  // 获取成就统计
  static Future<AchievementStatistics> getAchievementStatistics() async {
    final achievements = await getAchievements();

    final totalAchievements = achievements.length;
    final unlockedAchievements = achievements.where((a) => a.isUnlocked).length;

    // 计算总积分（根据稀有度）
    int totalPoints = 0;
    for (final achievement in achievements.where((a) => a.isUnlocked)) {
      switch (achievement.rarity) {
        case AchievementRarity.common:
          totalPoints += 10;
          break;
        case AchievementRarity.rare:
          totalPoints += 25;
          break;
        case AchievementRarity.epic:
          totalPoints += 50;
          break;
        case AchievementRarity.legendary:
          totalPoints += 100;
          break;
      }
    }

    // 类型统计
    final typeBreakdown = <AchievementType, int>{};
    for (final type in AchievementType.values) {
      typeBreakdown[type] = achievements
          .where((a) => a.type == type && a.isUnlocked)
          .length;
    }

    // 稀有度统计
    final rarityBreakdown = <AchievementRarity, int>{};
    for (final rarity in AchievementRarity.values) {
      rarityBreakdown[rarity] = achievements
          .where((a) => a.rarity == rarity && a.isUnlocked)
          .length;
    }

    // 最近解锁的成就
    final recentUnlocked =
        achievements.where((a) => a.isUnlocked && a.unlockedAt != null).toList()
          ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!));

    return AchievementStatistics(
      totalAchievements: totalAchievements,
      unlockedAchievements: unlockedAchievements,
      totalPoints: totalPoints,
      typeBreakdown: typeBreakdown,
      rarityBreakdown: rarityBreakdown,
      recentUnlocked: recentUnlocked.take(5).toList(),
    );
  }

  // 默认成就列表
  static List<Achievement> _getDefaultAchievements() {
    return [
      // 进度成就
      Achievement(
        id: 'reach_level_5',
        name: '初出茅庐',
        description: '达到5级',
        icon: '🌱',
        type: AchievementType.progress,
        rarity: AchievementRarity.common,
        targetValue: 5,
        rewards: {'gold': 100, 'experience': 50},
      ),
      Achievement(
        id: 'reach_level_10',
        name: '小有名气',
        description: '达到10级',
        icon: '⭐',
        type: AchievementType.progress,
        rarity: AchievementRarity.rare,
        targetValue: 10,
        rewards: {'gold': 300, 'experience': 150},
        prerequisites: ['reach_level_5'],
      ),
      Achievement(
        id: 'reach_level_20',
        name: '声名远扬',
        description: '达到20级',
        icon: '🌟',
        type: AchievementType.progress,
        rarity: AchievementRarity.epic,
        targetValue: 20,
        rewards: {'gold': 1000, 'experience': 500},
        prerequisites: ['reach_level_10'],
      ),

      // 章节成就
      Achievement(
        id: 'complete_chapter_1',
        name: '桃园三结义',
        description: '完成第一章',
        icon: '🍑',
        type: AchievementType.progress,
        rarity: AchievementRarity.common,
        targetValue: 1,
        rewards: {'gold': 200, 'experience': 100},
      ),
      Achievement(
        id: 'complete_chapter_3',
        name: '三分天下',
        description: '完成第三章',
        icon: '⚔️',
        type: AchievementType.progress,
        rarity: AchievementRarity.epic,
        targetValue: 1,
        rewards: {'gold': 1500, 'experience': 800},
      ),

      // 关卡成就
      Achievement(
        id: 'complete_10_stages',
        name: '征战四方',
        description: '完成10个关卡',
        icon: '🏰',
        type: AchievementType.progress,
        rarity: AchievementRarity.common,
        targetValue: 10,
        rewards: {'gold': 500, 'experience': 200},
      ),
      Achievement(
        id: 'complete_50_stages',
        name: '百战不殆',
        description: '完成50个关卡',
        icon: '🏆',
        type: AchievementType.progress,
        rarity: AchievementRarity.epic,
        targetValue: 50,
        rewards: {'gold': 2000, 'experience': 1000},
      ),

      // 收集成就
      Achievement(
        id: 'collect_5_generals',
        name: '招贤纳士',
        description: '收集5名武将',
        icon: '👥',
        type: AchievementType.collection,
        rarity: AchievementRarity.common,
        targetValue: 5,
        rewards: {'gold': 300, 'experience': 100},
      ),
      Achievement(
        id: 'collect_10_generals',
        name: '人才济济',
        description: '收集10名武将',
        icon: '👑',
        type: AchievementType.collection,
        rarity: AchievementRarity.rare,
        targetValue: 10,
        rewards: {'gold': 800, 'experience': 300},
      ),
      Achievement(
        id: 'collect_all_shu_generals',
        name: '蜀汉五虎',
        description: '收集所有蜀国武将',
        icon: '🐅',
        type: AchievementType.collection,
        rarity: AchievementRarity.legendary,
        targetValue: 5,
        rewards: {'gold': 3000, 'experience': 1500},
      ),

      // 物品收集
      Achievement(
        id: 'collect_100_items',
        name: '收藏家',
        description: '收集100件物品',
        icon: '📦',
        type: AchievementType.collection,
        rarity: AchievementRarity.rare,
        targetValue: 100,
        rewards: {'gold': 1000, 'experience': 400},
      ),
      Achievement(
        id: 'collect_legendary_weapon',
        name: '神兵利器',
        description: '获得传说级武器',
        icon: '⚡',
        type: AchievementType.collection,
        rarity: AchievementRarity.legendary,
        targetValue: 1,
        rewards: {'gold': 2000, 'experience': 800},
      ),

      // 战斗成就
      Achievement(
        id: 'win_first_battle',
        name: '初战告捷',
        description: '赢得第一场战斗',
        icon: '🎯',
        type: AchievementType.battle,
        rarity: AchievementRarity.common,
        targetValue: 1,
        rewards: {'gold': 50, 'experience': 25},
      ),
      Achievement(
        id: 'win_10_battles',
        name: '连战连胜',
        description: '赢得10场战斗',
        icon: '🔥',
        type: AchievementType.battle,
        rarity: AchievementRarity.common,
        targetValue: 10,
        rewards: {'gold': 400, 'experience': 150},
      ),
      Achievement(
        id: 'win_100_battles',
        name: '百战百胜',
        description: '赢得100场战斗',
        icon: '💎',
        type: AchievementType.battle,
        rarity: AchievementRarity.epic,
        targetValue: 100,
        rewards: {'gold': 2500, 'experience': 1200},
      ),

      // 财富成就
      Achievement(
        id: 'earn_1000_gold',
        name: '小富即安',
        description: '拥有1000金币',
        icon: '💰',
        type: AchievementType.progress,
        rarity: AchievementRarity.common,
        targetValue: 1,
        rewards: {'experience': 100},
      ),
      Achievement(
        id: 'earn_10000_gold',
        name: '富甲一方',
        description: '拥有10000金币',
        icon: '💎',
        type: AchievementType.progress,
        rarity: AchievementRarity.rare,
        targetValue: 1,
        rewards: {'experience': 500},
      ),
      Achievement(
        id: 'spend_5000_gold',
        name: '挥金如土',
        description: '累计消费5000金币',
        icon: '💸',
        type: AchievementType.special,
        rarity: AchievementRarity.rare,
        targetValue: 5000,
        rewards: {'gold': 1000, 'experience': 300},
      ),

      // 商店成就
      Achievement(
        id: 'first_purchase',
        name: '初次购物',
        description: '在商店购买第一件物品',
        icon: '🛒',
        type: AchievementType.special,
        rarity: AchievementRarity.common,
        targetValue: 1,
        rewards: {'gold': 100, 'experience': 50},
      ),
      Achievement(
        id: 'shopaholic',
        name: '购物狂',
        description: '在商店购买50次',
        icon: '🛍️',
        type: AchievementType.special,
        rarity: AchievementRarity.epic,
        targetValue: 50,
        rewards: {'gold': 1500, 'experience': 600},
      ),

      // 武将成就
      Achievement(
        id: 'max_level_general',
        name: '武将大师',
        description: '将一名武将升到满级',
        icon: '🎖️',
        type: AchievementType.special,
        rarity: AchievementRarity.legendary,
        targetValue: 1,
        rewards: {'gold': 5000, 'experience': 2000},
      ),
    ];
  }
}
