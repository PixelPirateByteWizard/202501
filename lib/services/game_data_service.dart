import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/general.dart';
import '../models/stage.dart';
import '../models/item.dart';
import '../models/game_progress.dart';
import '../models/formation.dart';
import '../models/shop_item.dart';
import 'achievement_service.dart';

class GameDataService {
  static const String _progressKey = 'game_progress';
  static const String _generalsKey = 'generals';
  static const String _inventoryKey = 'inventory';
  static const String _formationKey = 'formation';
  static const String _shopStockKey = 'shop_stock';
  static const String _purchaseHistoryKey = 'purchase_history';

  // 获取游戏进度
  static Future<GameProgress> getGameProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progressJson = prefs.getString(_progressKey);
    
    if (progressJson != null) {
      return GameProgress.fromJson(jsonDecode(progressJson));
    }
    
    return GameProgress.defaultProgress;
  }

  // 保存游戏进度
  static Future<void> saveGameProgress(GameProgress progress) async {
    await saveGameProgressWithoutAchievementCheck(progress);
    
    // 触发成就检查
    await AchievementService.checkAndUpdateAchievements();
  }

  // 内部保存方法，不触发成就检查（避免无限循环）
  static Future<void> saveGameProgressWithoutAchievementCheck(GameProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, jsonEncode(progress.toJson()));
  }

  // 获取武将列表
  static Future<List<General>> getGenerals() async {
    final prefs = await SharedPreferences.getInstance();
    final generalsJson = prefs.getString(_generalsKey);
    
    if (generalsJson != null) {
      final List<dynamic> generalsList = jsonDecode(generalsJson);
      return generalsList.map((json) => General.fromJson(json)).toList();
    }
    
    return _getDefaultGenerals();
  }

  // 保存武将列表
  static Future<void> saveGenerals(List<General> generals) async {
    final prefs = await SharedPreferences.getInstance();
    final generalsJson = generals.map((g) => g.toJson()).toList();
    await prefs.setString(_generalsKey, jsonEncode(generalsJson));
  }

  // 获取背包物品
  static Future<List<Item>> getInventory() async {
    final prefs = await SharedPreferences.getInstance();
    final inventoryJson = prefs.getString(_inventoryKey);
    
    if (inventoryJson != null) {
      final List<dynamic> itemsList = jsonDecode(inventoryJson);
      return itemsList.map((json) => Item.fromJson(json)).toList();
    }
    
    return _getDefaultItems();
  }

  // 保存背包物品
  static Future<void> saveInventory(List<Item> items) async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = items.map((i) => i.toJson()).toList();
    await prefs.setString(_inventoryKey, jsonEncode(itemsJson));
  }

  // 获取关卡列表
  static Future<List<Stage>> getStages() async {
    final progress = await getGameProgress();
    final defaultStages = _getDefaultStages();
    
    // 根据游戏进度更新关卡状态
    return defaultStages.map((stage) {
      if (progress.completedStages.contains(stage.id)) {
        return stage.copyWith(status: StageStatus.completed);
      } else if (_isStageUnlocked(stage, progress.completedStages)) {
        return stage.copyWith(status: StageStatus.unlocked);
      } else {
        return stage.copyWith(status: StageStatus.locked);
      }
    }).toList();
  }

  // 检查关卡是否应该解锁
  static bool _isStageUnlocked(Stage stage, List<String> completedStages) {
    // 第一个关卡默认解锁
    if (stage.id == 'stage_1_1') return true;
    
    // 获取前一个关卡ID
    final previousStageId = _getPreviousStageId(stage.id);
    if (previousStageId == null) return false;
    
    // 检查前一个关卡是否已完成
    return completedStages.contains(previousStageId);
  }

  // 获取前一个关卡ID
  static String? _getPreviousStageId(String stageId) {
    final parts = stageId.split('_');
    if (parts.length != 3) return null;
    
    final chapter = int.parse(parts[1]);
    final stage = int.parse(parts[2]);
    
    if (stage > 1) {
      // 同章节的前一个关卡
      return 'stage_${chapter}_${stage - 1}';
    } else if (chapter > 1) {
      // 前一章节的最后一个关卡
      final previousChapterStages = _getStagesInChapter(chapter - 1);
      if (previousChapterStages.isNotEmpty) {
        return previousChapterStages.last.id;
      }
    }
    
    return null;
  }

  // 获取指定章节的所有关卡
  static List<Stage> _getStagesInChapter(int chapter) {
    return _getDefaultStages().where((stage) => stage.chapter == chapter).toList();
  }

  // 完成关卡并解锁下一关
  static Future<void> completeStage(String stageId) async {
    final progress = await getGameProgress();
    
    if (!progress.completedStages.contains(stageId)) {
      final updatedProgress = progress.copyWith(
        completedStages: [...progress.completedStages, stageId],
      );
      await saveGameProgress(updatedProgress);
    }
  }

  // 获取当前阵型
  static Future<Formation> getCurrentFormation() async {
    final prefs = await SharedPreferences.getInstance();
    final formationJson = prefs.getString(_formationKey);
    
    if (formationJson != null) {
      return Formation.fromJson(jsonDecode(formationJson));
    }
    
    return _getDefaultFormation();
  }

  // 保存当前阵型
  static Future<void> saveCurrentFormation(Formation formation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_formationKey, jsonEncode(formation.toJson()));
  }

  // 获取阵型类型列表
  static List<FormationType> getFormationTypes() {
    return FormationType.defaultTypes;
  }

  // 装备物品给武将
  static Future<bool> equipItemToGeneral(String generalId, String itemId, String slot) async {
    final generals = await getGenerals();
    final items = await getInventory();
    
    final generalIndex = generals.indexWhere((g) => g.id == generalId);
    final item = items.firstWhere((i) => i.id == itemId, orElse: () => items.first);
    
    if (generalIndex == -1) return false;
    
    // 检查物品类型是否匹配装备槽
    if (!_isItemTypeMatchSlot(item.type, slot)) return false;
    
    final general = generals[generalIndex];
    
    // 如果该槽位已有装备，先卸下
    final currentEquipment = general.equipment[slot];
    if (currentEquipment != null) {
      await _unequipItem(currentEquipment);
    }
    
    // 装备新物品
    final updatedEquipment = Map<String, String?>.from(general.equipment);
    updatedEquipment[slot] = itemId;
    
    generals[generalIndex] = general.copyWith(equipment: updatedEquipment);
    
    // 从背包中移除物品（如果不是消耗品）
    if (item.type != ItemType.consumable) {
      final itemIndex = items.indexWhere((i) => i.id == itemId);
      if (itemIndex != -1) {
        if (items[itemIndex].quantity > 1) {
          items[itemIndex] = items[itemIndex].copyWith(quantity: items[itemIndex].quantity - 1);
        } else {
          items.removeAt(itemIndex);
        }
      }
    }
    
    await saveGenerals(generals);
    await saveInventory(items);
    
    return true;
  }

  // 卸下武将装备
  static Future<bool> unequipItemFromGeneral(String generalId, String slot) async {
    final generals = await getGenerals();
    final items = await getInventory();
    
    final generalIndex = generals.indexWhere((g) => g.id == generalId);
    if (generalIndex == -1) return false;
    
    final general = generals[generalIndex];
    final itemId = general.equipment[slot];
    if (itemId == null) return false;
    
    // 将装备放回背包
    final item = _getItemById(itemId);
    if (item != null) {
      final existingItemIndex = items.indexWhere((i) => i.id == itemId);
      if (existingItemIndex != -1) {
        items[existingItemIndex] = items[existingItemIndex].copyWith(
          quantity: items[existingItemIndex].quantity + 1
        );
      } else {
        items.add(item.copyWith(quantity: 1));
      }
    }
    
    // 从武将身上移除装备
    final updatedEquipment = Map<String, String?>.from(general.equipment);
    updatedEquipment[slot] = null;
    
    generals[generalIndex] = general.copyWith(equipment: updatedEquipment);
    
    await saveGenerals(generals);
    await saveInventory(items);
    
    return true;
  }

  // 检查物品类型是否匹配装备槽
  static bool _isItemTypeMatchSlot(ItemType itemType, String slot) {
    switch (slot) {
      case 'weapon':
        return itemType == ItemType.weapon;
      case 'armor':
        return itemType == ItemType.armor;
      case 'accessory':
        return itemType == ItemType.accessory;
      default:
        return false;
    }
  }

  // 卸下装备的辅助方法
  static Future<void> _unequipItem(String itemId) async {
    final items = await getInventory();
    final item = _getItemById(itemId);
    if (item != null) {
      final existingItemIndex = items.indexWhere((i) => i.id == itemId);
      if (existingItemIndex != -1) {
        items[existingItemIndex] = items[existingItemIndex].copyWith(
          quantity: items[existingItemIndex].quantity + 1
        );
      } else {
        items.add(item.copyWith(quantity: 1));
      }
      await saveInventory(items);
    }
  }

  // 根据ID获取物品模板
  static Item? _getItemById(String itemId) {
    final defaultItems = _getDefaultItems();
    try {
      return defaultItems.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  // 获取商店商品列表
  static List<ShopItem> getShopItems() {
    return _getDefaultShopItems();
  }

  // 获取商店库存
  static Future<Map<String, int>> getShopStock() async {
    final prefs = await SharedPreferences.getInstance();
    final stockJson = prefs.getString(_shopStockKey);
    
    if (stockJson != null) {
      return Map<String, int>.from(jsonDecode(stockJson));
    }
    
    return _getDefaultShopStock();
  }

  // 保存商店库存
  static Future<void> saveShopStock(Map<String, int> stock) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shopStockKey, jsonEncode(stock));
  }

  // 购买商品
  static Future<bool> purchaseItem(String itemId, int quantity) async {
    final progress = await getGameProgress();
    final shopItems = getShopItems();
    final stock = await getShopStock();
    final inventory = await getInventory();
    
    final shopItem = shopItems.firstWhere(
      (item) => item.id == itemId,
      orElse: () => shopItems.first,
    );
    
    final totalPrice = shopItem.price * quantity;
    final currentStock = stock[itemId] ?? shopItem.stock;
    
    // 检查金币是否足够
    if (progress.gold < totalPrice) {
      return false;
    }
    
    // 检查库存是否足够
    if (currentStock != -1 && currentStock < quantity) {
      return false;
    }
    
    // 扣除金币
    final updatedProgress = progress.copyWith(gold: progress.gold - totalPrice);
    await saveGameProgress(updatedProgress);
    
    // 更新库存
    if (currentStock != -1) {
      stock[itemId] = currentStock - quantity;
      await saveShopStock(stock);
    }
    
    // 添加到背包
    final inventoryItem = shopItem.toInventoryItem(quantity: quantity);
    final existingItemIndex = inventory.indexWhere((item) => item.id == itemId);
    
    if (existingItemIndex != -1) {
      inventory[existingItemIndex] = inventory[existingItemIndex].copyWith(
        quantity: inventory[existingItemIndex].quantity + quantity,
      );
    } else {
      inventory.add(inventoryItem);
    }
    
    await saveInventory(inventory);
    
    // 记录购买历史
    await _addPurchaseRecord(PurchaseRecord(
      itemId: itemId,
      quantity: quantity,
      totalPrice: totalPrice,
      purchaseTime: DateTime.now(),
    ));
    
    // 触发成就检查
    await AchievementService.checkAndUpdateAchievements();
    
    return true;
  }

  // 获取购买历史
  static Future<List<PurchaseRecord>> getPurchaseHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_purchaseHistoryKey);
    
    if (historyJson != null) {
      final List<dynamic> historyList = jsonDecode(historyJson);
      return historyList.map((json) => PurchaseRecord.fromJson(json)).toList();
    }
    
    return [];
  }

  // 添加购买记录
  static Future<void> _addPurchaseRecord(PurchaseRecord record) async {
    final history = await getPurchaseHistory();
    history.add(record);
    
    // 只保留最近100条记录
    if (history.length > 100) {
      history.removeRange(0, history.length - 100);
    }
    
    final prefs = await SharedPreferences.getInstance();
    final historyJson = history.map((r) => r.toJson()).toList();
    await prefs.setString(_purchaseHistoryKey, jsonEncode(historyJson));
  }

  // 刷新商店（重置限时商品等）
  static Future<void> refreshShop() async {
    final stock = _getDefaultShopStock();
    await saveShopStock(stock);
  }

  // 默认武将数据
  static List<General> _getDefaultGenerals() {
    return [
      General(
        id: 'liu_bei',
        name: '刘备',
        position: '蜀汉皇帝',
        attack: 75,
        defense: 80,
        intelligence: 85,
        speed: 70,
        level: 1,
        experience: 0,
        skills: ['仁德', '激将'],
        avatar: '刘',
      ),
      General(
        id: 'guan_yu',
        name: '关羽',
        position: '武圣',
        attack: 95,
        defense: 85,
        intelligence: 75,
        speed: 80,
        level: 1,
        experience: 0,
        skills: ['武圣', '义绝'],
        avatar: '关',
      ),
      General(
        id: 'zhang_fei',
        name: '张飞',
        position: '猛将',
        attack: 90,
        defense: 80,
        intelligence: 60,
        speed: 75,
        level: 1,
        experience: 0,
        skills: ['咆哮', '嗜酒'],
        avatar: '张',
      ),
      General(
        id: 'zhao_yun',
        name: '赵云',
        position: '常胜将军',
        attack: 85,
        defense: 90,
        intelligence: 80,
        speed: 95,
        level: 1,
        experience: 0,
        skills: ['龙胆', '冲阵'],
        avatar: '赵',
      ),
      General(
        id: 'zhuge_liang',
        name: '诸葛亮',
        position: '卧龙',
        attack: 60,
        defense: 70,
        intelligence: 100,
        speed: 75,
        level: 1,
        experience: 0,
        skills: ['观星', '空城', '八阵'],
        avatar: '诸',
      ),
      General(
        id: 'cao_cao',
        name: '曹操',
        position: '魏武帝',
        attack: 80,
        defense: 85,
        intelligence: 95,
        speed: 85,
        level: 1,
        experience: 0,
        skills: ['奸雄', '护驾'],
        avatar: '曹',
      ),
    ];
  }

  // 默认关卡数据
  static List<Stage> _getDefaultStages() {
    return [
      // 第一章：群雄并起
      Stage(
        id: 'stage_1_1',
        name: '桃园结义',
        description: '刘备、关羽、张飞三人结为兄弟，共同对抗黄巾军',
        difficulty: 1,
        enemies: ['黄巾军'],
        status: StageStatus.unlocked,
        chapter: 1,
        rewards: {'experience': 100, 'gold': 50},
      ),
      Stage(
        id: 'stage_1_2',
        name: '讨伐董卓',
        description: '十八路诸侯联合讨伐董卓',
        difficulty: 2,
        enemies: ['董卓军', '吕布'],
        status: StageStatus.locked,
        chapter: 1,
        rewards: {'experience': 150, 'gold': 75},
      ),
      Stage(
        id: 'stage_1_3',
        name: '三英战吕布',
        description: '刘关张三兄弟联手对战吕布',
        difficulty: 3,
        enemies: ['吕布'],
        status: StageStatus.locked,
        chapter: 1,
        rewards: {'experience': 200, 'gold': 100},
      ),
      Stage(
        id: 'stage_1_4',
        name: '徐州争夺',
        description: '刘备与吕布争夺徐州控制权',
        difficulty: 3,
        enemies: ['吕布军', '高顺'],
        status: StageStatus.locked,
        chapter: 1,
        rewards: {'experience': 220, 'gold': 110},
      ),
      Stage(
        id: 'stage_1_5',
        name: '白门楼',
        description: '曹操围困下邳，吕布败亡',
        difficulty: 4,
        enemies: ['吕布', '陈宫', '张辽'],
        status: StageStatus.locked,
        chapter: 1,
        rewards: {'experience': 250, 'gold': 125},
      ),

      // 第二章：三足鼎立
      Stage(
        id: 'stage_2_1',
        name: '官渡之战',
        description: '曹操与袁绍的决定性战役',
        difficulty: 5,
        enemies: ['袁绍军', '颜良', '文丑'],
        status: StageStatus.locked,
        chapter: 2,
        rewards: {'experience': 300, 'gold': 150},
      ),
      Stage(
        id: 'stage_2_2',
        name: '赤壁之战',
        description: '孙刘联军火烧赤壁，大败曹军',
        difficulty: 6,
        enemies: ['曹操军', '蔡瑁', '张允'],
        status: StageStatus.locked,
        chapter: 2,
        rewards: {'experience': 350, 'gold': 175},
      ),
      Stage(
        id: 'stage_2_3',
        name: '华容道',
        description: '关羽华容道义释曹操',
        difficulty: 5,
        enemies: ['曹操', '张辽', '徐晃'],
        status: StageStatus.locked,
        chapter: 2,
        rewards: {'experience': 320, 'gold': 160},
      ),
      Stage(
        id: 'stage_2_4',
        name: '取西川',
        description: '刘备夺取益州，建立蜀汉基业',
        difficulty: 6,
        enemies: ['刘璋军', '张任', '严颜'],
        status: StageStatus.locked,
        chapter: 2,
        rewards: {'experience': 380, 'gold': 190},
      ),
      Stage(
        id: 'stage_2_5',
        name: '汉中争夺',
        description: '刘备与曹操争夺汉中',
        difficulty: 7,
        enemies: ['夏侯渊', '张郃', '徐晃'],
        status: StageStatus.locked,
        chapter: 2,
        rewards: {'experience': 400, 'gold': 200},
      ),

      // 第三章：鼎足之势
      Stage(
        id: 'stage_3_1',
        name: '襄樊之战',
        description: '关羽水淹七军，威震华夏',
        difficulty: 7,
        enemies: ['于禁', '庞德', '曹仁'],
        status: StageStatus.locked,
        chapter: 3,
        rewards: {'experience': 450, 'gold': 225},
      ),
      Stage(
        id: 'stage_3_2',
        name: '麦城之围',
        description: '关羽败走麦城，英雄末路',
        difficulty: 8,
        enemies: ['吕蒙', '陆逊', '朱然'],
        status: StageStatus.locked,
        chapter: 3,
        rewards: {'experience': 480, 'gold': 240},
      ),
      Stage(
        id: 'stage_3_3',
        name: '夷陵之战',
        description: '刘备伐吴，陆逊火烧连营',
        difficulty: 8,
        enemies: ['陆逊', '朱然', '韩当'],
        status: StageStatus.locked,
        chapter: 3,
        rewards: {'experience': 500, 'gold': 250},
      ),
      Stage(
        id: 'stage_3_4',
        name: '白帝托孤',
        description: '刘备病逝白帝城，托孤诸葛亮',
        difficulty: 7,
        enemies: ['孙权军', '周泰', '甘宁'],
        status: StageStatus.locked,
        chapter: 3,
        rewards: {'experience': 520, 'gold': 260},
      ),
      Stage(
        id: 'stage_3_5',
        name: '南征孟获',
        description: '诸葛亮七擒七纵孟获',
        difficulty: 8,
        enemies: ['孟获', '祝融', '兀突骨'],
        status: StageStatus.locked,
        chapter: 3,
        rewards: {'experience': 550, 'gold': 275},
      ),

      // 第四章：北伐中原
      Stage(
        id: 'stage_4_1',
        name: '第一次北伐',
        description: '诸葛亮首次北伐，失街亭',
        difficulty: 9,
        enemies: ['张郃', '司马懿', '郭淮'],
        status: StageStatus.locked,
        chapter: 4,
        rewards: {'experience': 600, 'gold': 300},
      ),
      Stage(
        id: 'stage_4_2',
        name: '空城计',
        description: '诸葛亮空城计退司马懿',
        difficulty: 8,
        enemies: ['司马懿', '司马昭', '邓艾'],
        status: StageStatus.locked,
        chapter: 4,
        rewards: {'experience': 580, 'gold': 290},
      ),
      Stage(
        id: 'stage_4_3',
        name: '祁山会战',
        description: '蜀魏祁山大战',
        difficulty: 9,
        enemies: ['曹真', '张郃', '费曜'],
        status: StageStatus.locked,
        chapter: 4,
        rewards: {'experience': 620, 'gold': 310},
      ),
      Stage(
        id: 'stage_4_4',
        name: '木牛流马',
        description: '诸葛亮发明木牛流马运粮',
        difficulty: 8,
        enemies: ['司马懿', '张虎', '乐綝'],
        status: StageStatus.locked,
        chapter: 4,
        rewards: {'experience': 640, 'gold': 320},
      ),
      Stage(
        id: 'stage_4_5',
        name: '五丈原',
        description: '诸葛亮病逝五丈原，蜀汉衰落',
        difficulty: 10,
        enemies: ['司马懿', '司马师', '钟会'],
        status: StageStatus.locked,
        chapter: 4,
        rewards: {'experience': 700, 'gold': 350},
      ),

      // 第五章：三国归晋
      Stage(
        id: 'stage_5_1',
        name: '高平陵之变',
        description: '司马懿政变，夺取曹魏大权',
        difficulty: 9,
        enemies: ['曹爽', '何晏', '丁谧'],
        status: StageStatus.locked,
        chapter: 5,
        rewards: {'experience': 650, 'gold': 325},
      ),
      Stage(
        id: 'stage_5_2',
        name: '淮南三叛',
        description: '王凌、毌丘俭、诸葛诞先后叛乱',
        difficulty: 10,
        enemies: ['诸葛诞', '文钦', '唐咨'],
        status: StageStatus.locked,
        chapter: 5,
        rewards: {'experience': 720, 'gold': 360},
      ),
      Stage(
        id: 'stage_5_3',
        name: '蜀汉灭亡',
        description: '邓艾偷渡阴平，蜀汉灭亡',
        difficulty: 11,
        enemies: ['姜维', '廖化', '张翼'],
        status: StageStatus.locked,
        chapter: 5,
        rewards: {'experience': 750, 'gold': 375},
      ),
      Stage(
        id: 'stage_5_4',
        name: '东吴末路',
        description: '孙皓暴政，东吴衰落',
        difficulty: 10,
        enemies: ['孙皓', '张悌', '沈莹'],
        status: StageStatus.locked,
        chapter: 5,
        rewards: {'experience': 780, 'gold': 390},
      ),
      Stage(
        id: 'stage_5_5',
        name: '三国归晋',
        description: '司马炎建立西晋，统一天下',
        difficulty: 12,
        enemies: ['司马炎', '羊祜', '杜预'],
        status: StageStatus.locked,
        chapter: 5,
        rewards: {'experience': 1000, 'gold': 500},
      ),
    ];
  }

  // 默认物品数据
  static List<Item> _getDefaultItems() {
    return [
      Item(
        id: 'sword_1',
        name: '青龙偃月刀',
        description: '关羽的专属武器，攻击力+20',
        type: ItemType.weapon,
        quantity: 1,
        stats: {'attack': 20},
        icon: '⚔️',
      ),
      Item(
        id: 'armor_1',
        name: '龙鳞甲',
        description: '传说中的护甲，防御力+15',
        type: ItemType.armor,
        quantity: 1,
        stats: {'defense': 15},
        icon: '🛡️',
      ),
      Item(
        id: 'potion_1',
        name: '生命药水',
        description: '恢复生命值的药水',
        type: ItemType.consumable,
        quantity: 5,
        stats: {'health': 50},
        icon: '🧪',
      ),
    ];
  }

  // 默认阵型
  static Formation _getDefaultFormation() {
    return Formation(
      id: 'feng_shi',
      name: '锋矢阵',
      description: '攻击型阵型，前锋伤害+15%，中军伤害+10%，但承伤增加20%',
      bonuses: {'attack': 15, 'damage_taken': 20},
      positions: [
        'guan_yu', // 前排左
        'liu_bei', // 前排中
        'zhang_fei', // 前排右
        null, // 中排左
        null, // 中排中
        null, // 中排右
        null, // 后排左
        null, // 后排中
        null, // 后排右
      ],
    );
  }

  // 默认商店商品
  static List<ShopItem> _getDefaultShopItems() {
    return [
      // 武器类
      ShopItem(
        id: 'iron_sword',
        name: '铁剑',
        description: '普通的铁制长剑，攻击力+10',
        type: ItemType.weapon,
        price: 100,
        stats: {'attack': 10},
        icon: '⚔️',
        stock: -1,
        rarity: 'common',
      ),
      ShopItem(
        id: 'steel_sword',
        name: '钢剑',
        description: '精钢打造的长剑，攻击力+18',
        type: ItemType.weapon,
        price: 300,
        stats: {'attack': 18},
        icon: '🗡️',
        stock: 10,
        rarity: 'rare',
      ),
      ShopItem(
        id: 'dragon_blade',
        name: '龙纹刀',
        description: '传说中的神兵，攻击力+35，速度+10',
        type: ItemType.weapon,
        price: 1000,
        stats: {'attack': 35, 'speed': 10},
        icon: '🔪',
        stock: 3,
        rarity: 'legendary',
      ),
      
      // 防具类
      ShopItem(
        id: 'leather_armor',
        name: '皮甲',
        description: '轻便的皮制护甲，防御力+8',
        type: ItemType.armor,
        price: 80,
        stats: {'defense': 8},
        icon: '🦺',
        stock: -1,
        rarity: 'common',
      ),
      ShopItem(
        id: 'chain_mail',
        name: '锁子甲',
        description: '坚固的锁链护甲，防御力+15',
        type: ItemType.armor,
        price: 250,
        stats: {'defense': 15},
        icon: '🛡️',
        stock: 8,
        rarity: 'rare',
      ),
      ShopItem(
        id: 'plate_armor',
        name: '板甲',
        description: '重型板甲，防御力+25，但速度-5',
        type: ItemType.armor,
        price: 600,
        stats: {'defense': 25, 'speed': -5},
        icon: '🛡️',
        stock: 5,
        rarity: 'epic',
      ),
      
      // 饰品类
      ShopItem(
        id: 'power_ring',
        name: '力量戒指',
        description: '增强力量的魔法戒指，攻击力+12',
        type: ItemType.accessory,
        price: 200,
        stats: {'attack': 12},
        icon: '💍',
        stock: 6,
        rarity: 'rare',
      ),
      ShopItem(
        id: 'wisdom_amulet',
        name: '智慧护符',
        description: '提升智慧的神秘护符，智力+20',
        type: ItemType.accessory,
        price: 350,
        stats: {'intelligence': 20},
        icon: '🔮',
        stock: 4,
        rarity: 'epic',
      ),
      ShopItem(
        id: 'speed_boots',
        name: '疾风靴',
        description: '如风般的靴子，速度+15',
        type: ItemType.accessory,
        price: 180,
        stats: {'speed': 15},
        icon: '👢',
        stock: 7,
        rarity: 'rare',
      ),
      
      // 消耗品类
      ShopItem(
        id: 'health_potion_small',
        name: '小型生命药水',
        description: '恢复少量生命值',
        type: ItemType.consumable,
        price: 20,
        stats: {'health': 30},
        icon: '🧪',
        stock: -1,
        rarity: 'common',
      ),
      ShopItem(
        id: 'health_potion_large',
        name: '大型生命药水',
        description: '恢复大量生命值',
        type: ItemType.consumable,
        price: 50,
        stats: {'health': 80},
        icon: '🍶',
        stock: -1,
        rarity: 'rare',
      ),
      ShopItem(
        id: 'exp_scroll',
        name: '经验卷轴',
        description: '使用后获得经验值',
        type: ItemType.consumable,
        price: 100,
        stats: {'experience': 200},
        icon: '📜',
        stock: 20,
        rarity: 'rare',
      ),
    ];
  }

  // 默认商店库存
  static Map<String, int> _getDefaultShopStock() {
    final shopItems = _getDefaultShopItems();
    final stock = <String, int>{};
    
    for (final item in shopItems) {
      if (item.stock != -1) {
        stock[item.id] = item.stock;
      }
    }
    
    return stock;
  }
}