import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/general.dart';
import '../models/battle.dart';
import 'material_service.dart';

class GameDataService {
  static const String _gameStateKey = 'game_state';
  static const String _settingsKey = 'game_settings';

  // 获取游戏状态
  static Future<GameState?> loadGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameStateJson = prefs.getString(_gameStateKey);
      
      if (gameStateJson != null) {
        final Map<String, dynamic> data = jsonDecode(gameStateJson);
        return GameState.fromJson(data);
      }
      
      return null;
    } catch (e) {
      print('Error loading game state: $e');
      return null;
    }
  }

  // 保存游戏状态
  static Future<bool> saveGameState(GameState gameState) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameStateJson = jsonEncode(gameState.toJson());
      return await prefs.setString(_gameStateKey, gameStateJson);
    } catch (e) {
      print('Error saving game state: $e');
      return false;
    }
  }

  // 创建新游戏
  static Future<GameState> createNewGame() async {
    final defaultFormation = _getDefaultFormation();
    final startingGenerals = _getStartingGenerals();
    final startingEquipment = _getStartingEquipment();
    
    final gameState = GameState(
      playerId: DateTime.now().millisecondsSinceEpoch.toString(),
      currentChapter: 1,
      currentSection: 1,
      generals: startingGenerals,
      inventory: startingEquipment,
      materials: MaterialService.getInitialMaterials(),
      coins: 1000,
      currentFormation: defaultFormation,
      unlockedChapters: ['1'],
      gameProgress: {},
      playerStats: PlayerStats(
        generalsRecruited: startingGenerals.length,
        equipmentCollected: startingEquipment.length,
      ),
    );

    await saveGameState(gameState);
    return gameState;
  }

  // 获取默认阵型
  static Formation _getDefaultFormation() {
    return Formation(
      id: 'fengshi',
      name: '锋矢阵',
      description: '攻击型阵型，前锋伤害+15%，中军伤害+10%，但承伤增加20%',
      positions: [
        FormationPosition(index: 0, name: '左翼', bonuses: {'damage': 0.05}),
        FormationPosition(index: 1, name: '前锋', bonuses: {'damage': 0.15, 'takeDamage': 0.20}),
        FormationPosition(index: 2, name: '右翼', bonuses: {'damage': 0.05}),
        FormationPosition(index: 3, name: '左军', bonuses: {}),
        FormationPosition(index: 4, name: '中军', bonuses: {'damage': 0.10}),
        FormationPosition(index: 5, name: '右军', bonuses: {}),
        FormationPosition(index: 6, name: '左营', bonuses: {'defense': 0.10}),
        FormationPosition(index: 7, name: '大营', bonuses: {'defense': 0.15}),
        FormationPosition(index: 8, name: '右营', bonuses: {'defense': 0.10}),
      ],
      bonuses: {'morale': 0.10},
    );
  }

  // 获取初始武将
  static List<General> _getStartingGenerals() {
    return [
      General(
        id: 'guanyu',
        name: '关羽',
        avatar: '关',
        rarity: 5,
        level: 1,
        experience: 100,
        maxExperience: 100,
        stats: GeneralStats(
          force: 98,
          intelligence: 75,
          leadership: 92,
          speed: 8,
          troops: 2500,
        ),
        skills: [
          Skill(
            id: 'longdan',
            name: '龙胆',
            description: '常山赵子龙怀护主之心，冲入敌阵，对直线敌人造成穿刺伤害，并提升自身闪避',
            type: SkillType.active,
            cooldown: 3,
          ),
        ],
        weapon: Equipment(
          id: 'qinglong_dao',
          name: '青龙偃月刀',
          description: '关羽的专属武器，重达八十二斤，削铁如泥',
          type: EquipmentType.weapon,
          rarity: 5,
          stats: {'force': 25, 'critRate': 15},
          specialEffect: '攻击时有几率触发"龙吟"，对目标造成额外伤害',
        ),
        biography: '字云长，河东解良人。身长九尺，髯长二尺，面如重枣，唇若涂脂，丹凤眼，卧蚕眉，相貌堂堂，威风凛凛。',
        position: '前锋',
      ),
      General(
        id: 'zhangliao',
        name: '张辽',
        avatar: '张',
        rarity: 4,
        level: 1,
        experience: 50,
        maxExperience: 100,
        stats: GeneralStats(
          force: 90,
          intelligence: 70,
          leadership: 88,
          speed: 12,
          troops: 2000,
        ),
        skills: [
          Skill(
            id: 'tuxi',
            name: '突袭',
            description: '发动突然袭击，对敌方造成大量伤害并降低其士气',
            type: SkillType.active,
            cooldown: 2,
          ),
        ],
        biography: '字文远，雁门马邑人。三国时期曹魏著名将领，五子良将之首。',
        position: '前锋',
      ),
      General(
        id: 'guojia',
        name: '郭嘉',
        avatar: '郭',
        rarity: 5,
        level: 1,
        experience: 100,
        maxExperience: 100,
        stats: GeneralStats(
          force: 30,
          intelligence: 98,
          leadership: 65,
          speed: 6,
          troops: 1500,
        ),
        skills: [
          Skill(
            id: 'qice',
            name: '奇策',
            description: '运用奇谋，为我军提供战术指导，提升全军攻击力',
            type: SkillType.active,
            cooldown: 4,
          ),
        ],
        accessory: Equipment(
          id: 'zhuge_jin',
          name: '诸葛巾',
          description: '智者的象征，能够提升思维敏捷度',
          type: EquipmentType.accessory,
          rarity: 4,
          stats: {'intelligence': 18, 'critRate': 12},
          specialEffect: '每回合有几率恢复己方兵力最少的单位10%兵力',
        ),
        biography: '字奉孝，颍川阳翟人。东汉末年曹操帐下著名谋士。',
        position: '谋士',
      ),
    ];
  }

  // 获取初始装备
  static List<Equipment> _getStartingEquipment() {
    return [
      Equipment(
        id: 'dilu',
        name: '的卢',
        description: '刘备的坐骑，能够日行千里，危急时刻能够救主脱险',
        type: EquipmentType.accessory,
        rarity: 5,
        stats: {'speed': 15, 'defense': 10},
        specialEffect: '首次受到致命伤害时，必定闪避并回复20%兵力',
      ),
      Equipment(
        id: 'zhuque_shan',
        name: '朱雀羽扇',
        description: '传说中的神器，能够操控火焰的力量',
        type: EquipmentType.weapon,
        rarity: 4,
        stats: {'intelligence': 20, 'force': 5},
        specialEffect: '使用火计时有几率使目标陷入"灼烧"状态',
      ),
      Equipment(
        id: 'iron_armor',
        name: '精铁战甲',
        description: '用上等精铁打造的战甲，防护力极强',
        type: EquipmentType.armor,
        rarity: 3,
        stats: {'defense': 15, 'troops': 200},
        specialEffect: '受到攻击时有几率减少10%伤害',
      ),
    ];
  }

  // 获取游戏设置
  static Future<Map<String, dynamic>> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      
      if (settingsJson != null) {
        return jsonDecode(settingsJson);
      }
      
      return _getDefaultSettings();
    } catch (e) {
      print('Error loading settings: $e');
      return _getDefaultSettings();
    }
  }

  // 保存游戏设置
  static Future<bool> saveSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(settings);
      return await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      print('Error saving settings: $e');
      return false;
    }
  }

  // 默认设置
  static Map<String, dynamic> _getDefaultSettings() {
    return {
      'backgroundMusic': 0.7,
      'soundEffects': 0.85,
      'textSpeed': 0.6,
      'narrativeStyle': '演义风格',
      'generationSpeed': '适中',
      'pushNotifications': true,
      'battleAnimations': true,
    };
  }

  // 获取所有可用阵型
  static List<Formation> getAllFormations() {
    return [
      _getDefaultFormation(),
      Formation(
        id: 'yanxing',
        name: '雁行阵',
        description: '平衡型阵型，全军攻防均衡，适合持久战',
        positions: [
          FormationPosition(index: 0, name: '左翼', bonuses: {'defense': 0.05}),
          FormationPosition(index: 1, name: '前军', bonuses: {'damage': 0.05}),
          FormationPosition(index: 2, name: '右翼', bonuses: {'defense': 0.05}),
          FormationPosition(index: 3, name: '左军', bonuses: {'damage': 0.05}),
          FormationPosition(index: 4, name: '中军', bonuses: {'damage': 0.10, 'defense': 0.10}),
          FormationPosition(index: 5, name: '右军', bonuses: {'damage': 0.05}),
          FormationPosition(index: 6, name: '左营', bonuses: {'defense': 0.05}),
          FormationPosition(index: 7, name: '后军', bonuses: {'defense': 0.10}),
          FormationPosition(index: 8, name: '右营', bonuses: {'defense': 0.05}),
        ],
        bonuses: {'stability': 0.15},
      ),
      Formation(
        id: 'yulin',
        name: '鱼鳞阵',
        description: '防御型阵型，大幅提升防御力，但攻击力略有下降',
        positions: [
          FormationPosition(index: 0, name: '左哨', bonuses: {'defense': 0.10}),
          FormationPosition(index: 1, name: '前哨', bonuses: {'defense': 0.15}),
          FormationPosition(index: 2, name: '右哨', bonuses: {'defense': 0.10}),
          FormationPosition(index: 3, name: '左卫', bonuses: {'defense': 0.15}),
          FormationPosition(index: 4, name: '中坚', bonuses: {'defense': 0.25}),
          FormationPosition(index: 5, name: '右卫', bonuses: {'defense': 0.15}),
          FormationPosition(index: 6, name: '左营', bonuses: {'defense': 0.20}),
          FormationPosition(index: 7, name: '大营', bonuses: {'defense': 0.30}),
          FormationPosition(index: 8, name: '右营', bonuses: {'defense': 0.20}),
        ],
        bonuses: {'defense': 0.20, 'damage': -0.10},
      ),
    ];
  }
}