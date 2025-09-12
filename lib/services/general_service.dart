import '../models/general.dart';
import '../models/material.dart' as material;
import '../models/game_state.dart';
import 'material_service.dart';

class GeneralService {
  // 武将升级（带材料检查）
  static material.UpgradeResult upgradeGeneral(General general, GameState gameState) {
    // 检查经验是否足够
    if (general.experience < general.maxExperience) {
      return material.UpgradeResult(
        success: false,
        message: '经验不足，无法升级！\n当前经验：${general.experience}/${general.maxExperience}',
      );
    }

    // 获取升级所需材料
    final requirements = MaterialService.getUpgradeRequirements(
      general.level,
      general.rarity,
    );

    // 检查银币是否足够
    final coinRequirement = requirements.firstWhere(
      (req) => req.materialId == 'coins',
      orElse: () => material.UpgradeRequirement(materialId: 'coins', quantity: 0),
    );
    
    if (gameState.coins < coinRequirement.quantity) {
      return material.UpgradeResult(
        success: false,
        message: '银币不足，无法升级！\n需要：${coinRequirement.quantity} 银币\n当前：${gameState.coins} 银币',
      );
    }

    // 检查其他材料是否足够（排除银币）
    final materialRequirements = requirements.where((req) => req.materialId != 'coins').toList();
    if (!MaterialService.hasEnoughMaterials(gameState.materials, materialRequirements)) {
      final missingInfo = MaterialService.getCompleteMissingMaterialsInfo(
        gameState.materials,
        gameState.coins,
        requirements,
      );
      return material.UpgradeResult(
        success: false,
        message: '材料不足，无法升级！\n\n缺少材料：\n${missingInfo.join('\n')}',
      );
    }

    // 执行升级
    final upgradedGeneral = _performLevelUp(general);
    final consumedMaterials = requirements.map((req) {
      final mat = MaterialService.getMaterial(req.materialId)!;
      return material.MaterialStack(material: mat, quantity: req.quantity);
    }).toList();

    return material.UpgradeResult(
      success: true,
      message: '${general.name} 升级成功！\n等级：${general.level} → ${upgradedGeneral.level}',
      upgradedGeneral: upgradedGeneral,
      consumedMaterials: consumedMaterials,
    );
  }

  // 武将升级（简单版本，不检查材料）
  static General levelUpGeneral(General general) {
    if (general.experience < general.maxExperience) {
      return general; // 经验不足，无法升级
    }
    
    return _performLevelUp(general);
  }

  // 执行升级逻辑
  static General _performLevelUp(General general) {
    final newLevel = general.level + 1;
    final remainingExp = general.experience - general.maxExperience;
    final newMaxExp = _calculateMaxExperience(newLevel);
    
    // 计算属性提升
    final newStats = GeneralStats(
      force: general.stats.force + _getStatGrowth('force', general.position),
      intelligence: general.stats.intelligence + _getStatGrowth('intelligence', general.position),
      leadership: general.stats.leadership + _getStatGrowth('leadership', general.position),
      speed: general.stats.speed + _getStatGrowth('speed', general.position),
      troops: general.stats.troops + _getStatGrowth('troops', general.position),
    );
    
    return general.copyWith(
      level: newLevel,
      experience: remainingExp,
      maxExperience: newMaxExp,
      stats: newStats,
    );
  }
  
  // 获得经验值
  static General gainExperience(General general, int expGain) {
    var updatedGeneral = general.copyWith(
      experience: general.experience + expGain,
    );
    
    // 检查是否可以升级
    while (updatedGeneral.experience >= updatedGeneral.maxExperience) {
      updatedGeneral = levelUpGeneral(updatedGeneral);
    }
    
    return updatedGeneral;
  }
  
  // 计算升级所需经验
  static int _calculateMaxExperience(int level) {
    return 100 + (level - 1) * 50; // 基础100，每级增加50
  }
  
  // 根据职业获取属性成长
  static int _getStatGrowth(String statType, String position) {
    switch (position) {
      case '前锋':
        switch (statType) {
          case 'force': return 3;
          case 'intelligence': return 1;
          case 'leadership': return 2;
          case 'speed': return 1;
          case 'troops': return 150;
          default: return 0;
        }
      case '谋士':
        switch (statType) {
          case 'force': return 1;
          case 'intelligence': return 3;
          case 'leadership': return 2;
          case 'speed': return 1;
          case 'troops': return 100;
          default: return 0;
        }
      case '辅助':
        switch (statType) {
          case 'force': return 2;
          case 'intelligence': return 2;
          case 'leadership': return 3;
          case 'speed': return 1;
          case 'troops': return 120;
          default: return 0;
        }
      default:
        switch (statType) {
          case 'force': return 2;
          case 'intelligence': return 2;
          case 'leadership': return 2;
          case 'speed': return 1;
          case 'troops': return 120;
          default: return 0;
        }
    }
  }
  
  // 装备武器
  static General equipWeapon(General general, Equipment weapon) {
    if (weapon.type != EquipmentType.weapon) {
      return general;
    }
    
    return general.copyWith(weapon: weapon);
  }
  
  // 装备防具
  static General equipArmor(General general, Equipment armor) {
    if (armor.type != EquipmentType.armor) {
      return general;
    }
    
    return general.copyWith(armor: armor);
  }
  
  // 装备饰品
  static General equipAccessory(General general, Equipment accessory) {
    if (accessory.type != EquipmentType.accessory) {
      return general;
    }
    
    return general.copyWith(accessory: accessory);
  }
  
  // 计算武将总战力
  static int calculatePower(General general) {
    int basePower = general.stats.force + 
                   general.stats.intelligence + 
                   general.stats.leadership + 
                   general.stats.speed * 2 + 
                   general.stats.troops ~/ 10;
    
    // 装备加成
    int equipmentBonus = 0;
    if (general.weapon != null) {
      equipmentBonus += general.weapon!.stats.values.fold(0, (sum, value) => sum + value);
    }
    if (general.armor != null) {
      equipmentBonus += general.armor!.stats.values.fold(0, (sum, value) => sum + value);
    }
    if (general.accessory != null) {
      equipmentBonus += general.accessory!.stats.values.fold(0, (sum, value) => sum + value);
    }
    
    // 等级加成
    int levelBonus = general.level * 10;
    
    return basePower + equipmentBonus + levelBonus;
  }
  
  // 获取武将稀有度颜色
  static String getRarityName(int rarity) {
    switch (rarity) {
      case 1: return '普通';
      case 2: return '精良';
      case 3: return '稀有';
      case 4: return '史诗';
      case 5: return '传说';
      default: return '未知';
    }
  }

  // 检查武将是否可以升级
  static bool canUpgrade(General general, GameState gameState) {
    if (general.experience < general.maxExperience) {
      return false;
    }

    final requirements = MaterialService.getUpgradeRequirements(
      general.level,
      general.rarity,
    );

    // 检查银币是否足够
    final coinRequirement = requirements.firstWhere(
      (req) => req.materialId == 'coins',
      orElse: () => material.UpgradeRequirement(materialId: 'coins', quantity: 0),
    );
    
    if (gameState.coins < coinRequirement.quantity) {
      return false;
    }

    // 检查其他材料是否足够（排除银币）
    final materialRequirements = requirements.where((req) => req.materialId != 'coins').toList();
    return MaterialService.hasEnoughMaterials(gameState.materials, materialRequirements);
  }

  // 获取升级预览信息
  static Map<String, dynamic> getUpgradePreview(General general) {
    if (general.experience < general.maxExperience) {
      return {
        'canUpgrade': false,
        'reason': '经验不足',
        'currentExp': general.experience,
        'maxExp': general.maxExperience,
      };
    }

    final previewGeneral = _performLevelUp(general);
    final requirements = MaterialService.getUpgradeRequirements(
      general.level,
      general.rarity,
    );

    return {
      'canUpgrade': true,
      'currentLevel': general.level,
      'newLevel': previewGeneral.level,
      'statChanges': {
        'force': previewGeneral.stats.force - general.stats.force,
        'intelligence': previewGeneral.stats.intelligence - general.stats.intelligence,
        'leadership': previewGeneral.stats.leadership - general.stats.leadership,
        'speed': previewGeneral.stats.speed - general.stats.speed,
        'troops': previewGeneral.stats.troops - general.stats.troops,
      },
      'requirements': requirements,
    };
  }
}