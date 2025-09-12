import '../models/material.dart';

class MaterialService {
  // 预定义的材料
  static final Map<String, Material> _materials = {
    'exp_scroll_small': Material(
      id: 'exp_scroll_small',
      name: '经验卷轴（小）',
      description: '提供少量经验值的卷轴',
      type: MaterialType.upgrade,
      rarity: 1,
      icon: '📜',
    ),
    'exp_scroll_medium': Material(
      id: 'exp_scroll_medium',
      name: '经验卷轴（中）',
      description: '提供中等经验值的卷轴',
      type: MaterialType.upgrade,
      rarity: 2,
      icon: '📋',
    ),
    'exp_scroll_large': Material(
      id: 'exp_scroll_large',
      name: '经验卷轴（大）',
      description: '提供大量经验值的卷轴',
      type: MaterialType.upgrade,
      rarity: 3,
      icon: '📃',
    ),
    'upgrade_stone_common': Material(
      id: 'upgrade_stone_common',
      name: '普通升级石',
      description: '用于武将升级的普通石头',
      type: MaterialType.upgrade,
      rarity: 1,
      icon: '🪨',
    ),
    'upgrade_stone_rare': Material(
      id: 'upgrade_stone_rare',
      name: '稀有升级石',
      description: '用于武将升级的稀有石头',
      type: MaterialType.upgrade,
      rarity: 2,
      icon: '💎',
    ),
    'upgrade_stone_epic': Material(
      id: 'upgrade_stone_epic',
      name: '史诗升级石',
      description: '用于武将升级的史诗石头',
      type: MaterialType.upgrade,
      rarity: 3,
      icon: '💠',
    ),
    'coins': Material(
      id: 'coins',
      name: '银币',
      description: '游戏中的通用货币',
      type: MaterialType.currency,
      rarity: 1,
      icon: '🪙',
    ),
  };

  // 获取材料信息
  static Material? getMaterial(String materialId) {
    return _materials[materialId];
  }

  // 获取所有材料
  static List<Material> getAllMaterials() {
    return _materials.values.toList();
  }

  // 检查玩家是否拥有足够的材料（不包括银币检查）
  static bool hasEnoughMaterials(
    List<MaterialStack> playerMaterials,
    List<UpgradeRequirement> requirements,
  ) {
    for (final requirement in requirements) {
      // 跳过银币检查，银币应该在调用方单独检查
      if (requirement.materialId == 'coins') {
        continue;
      }
      
      final playerStack = playerMaterials.firstWhere(
        (stack) => stack.material.id == requirement.materialId,
        orElse: () => MaterialStack(
          material: _materials[requirement.materialId]!,
          quantity: 0,
        ),
      );
      
      if (playerStack.quantity < requirement.quantity) {
        return false;
      }
    }
    return true;
  }

  // 消耗材料
  static List<MaterialStack> consumeMaterials(
    List<MaterialStack> playerMaterials,
    List<UpgradeRequirement> requirements,
  ) {
    final updatedMaterials = List<MaterialStack>.from(playerMaterials);
    
    for (final requirement in requirements) {
      final index = updatedMaterials.indexWhere(
        (stack) => stack.material.id == requirement.materialId,
      );
      
      if (index != -1) {
        final currentStack = updatedMaterials[index];
        final newQuantity = currentStack.quantity - requirement.quantity;
        
        if (newQuantity <= 0) {
          updatedMaterials.removeAt(index);
        } else {
          updatedMaterials[index] = currentStack.copyWith(quantity: newQuantity);
        }
      }
    }
    
    return updatedMaterials;
  }

  // 添加材料
  static List<MaterialStack> addMaterials(
    List<MaterialStack> playerMaterials,
    String materialId,
    int quantity,
  ) {
    final material = _materials[materialId];
    if (material == null) return playerMaterials;

    final updatedMaterials = List<MaterialStack>.from(playerMaterials);
    final existingIndex = updatedMaterials.indexWhere(
      (stack) => stack.material.id == materialId,
    );

    if (existingIndex != -1) {
      final existingStack = updatedMaterials[existingIndex];
      updatedMaterials[existingIndex] = existingStack.copyWith(
        quantity: existingStack.quantity + quantity,
      );
    } else {
      updatedMaterials.add(MaterialStack(
        material: material,
        quantity: quantity,
      ));
    }

    return updatedMaterials;
  }

  // 获取武将升级所需材料
  static List<UpgradeRequirement> getUpgradeRequirements(
    int currentLevel,
    int rarity,
  ) {
    final requirements = <UpgradeRequirement>[];
    
    // 基础银币需求
    final coinCost = 100 + (currentLevel * 50) + (rarity * 100);
    requirements.add(UpgradeRequirement(
      materialId: 'coins',
      quantity: coinCost,
    ));

    // 根据等级和稀有度确定升级石需求
    if (currentLevel < 10) {
      requirements.add(UpgradeRequirement(
        materialId: 'upgrade_stone_common',
        quantity: 1 + (currentLevel ~/ 5),
      ));
    } else if (currentLevel < 20) {
      requirements.add(UpgradeRequirement(
        materialId: 'upgrade_stone_rare',
        quantity: 1 + ((currentLevel - 10) ~/ 5),
      ));
    } else {
      requirements.add(UpgradeRequirement(
        materialId: 'upgrade_stone_epic',
        quantity: 1 + ((currentLevel - 20) ~/ 5),
      ));
    }

    // 高稀有度武将需要额外材料
    if (rarity >= 4) {
      requirements.add(UpgradeRequirement(
        materialId: 'exp_scroll_large',
        quantity: 1,
      ));
    } else if (rarity >= 3) {
      requirements.add(UpgradeRequirement(
        materialId: 'exp_scroll_medium',
        quantity: 2,
      ));
    } else {
      requirements.add(UpgradeRequirement(
        materialId: 'exp_scroll_small',
        quantity: 3,
      ));
    }

    return requirements;
  }

  // 获取材料数量
  static int getMaterialQuantity(
    List<MaterialStack> playerMaterials,
    String materialId,
  ) {
    final stack = playerMaterials.firstWhere(
      (stack) => stack.material.id == materialId,
      orElse: () => MaterialStack(
        material: _materials[materialId]!,
        quantity: 0,
      ),
    );
    return stack.quantity;
  }

  // 获取缺少的材料信息
  static List<String> getMissingMaterialsInfo(
    List<MaterialStack> playerMaterials,
    List<UpgradeRequirement> requirements,
  ) {
    final missingInfo = <String>[];
    
    for (final requirement in requirements) {
      // 跳过银币，银币的检查应该在调用方处理
      if (requirement.materialId == 'coins') {
        continue;
      }
      
      final material = _materials[requirement.materialId];
      if (material == null) continue;
      
      final playerQuantity = getMaterialQuantity(playerMaterials, requirement.materialId);
      final needed = requirement.quantity - playerQuantity;
      
      if (needed > 0) {
        missingInfo.add('${material.name}: 缺少 $needed 个');
      }
    }
    
    return missingInfo;
  }

  // 获取完整的缺少材料信息（包括银币）
  static List<String> getCompleteMissingMaterialsInfo(
    List<MaterialStack> playerMaterials,
    int playerCoins,
    List<UpgradeRequirement> requirements,
  ) {
    final missingInfo = <String>[];
    
    for (final requirement in requirements) {
      final material = _materials[requirement.materialId];
      if (material == null) continue;
      
      int playerQuantity;
      if (requirement.materialId == 'coins') {
        playerQuantity = playerCoins;
      } else {
        playerQuantity = getMaterialQuantity(playerMaterials, requirement.materialId);
      }
      
      final needed = requirement.quantity - playerQuantity;
      
      if (needed > 0) {
        missingInfo.add('${material.name}: 缺少 $needed 个');
      }
    }
    
    return missingInfo;
  }

  // 初始化新玩家的材料
  static List<MaterialStack> getInitialMaterials() {
    return [
      MaterialStack(
        material: _materials['exp_scroll_small']!,
        quantity: 10,
      ),
      MaterialStack(
        material: _materials['upgrade_stone_common']!,
        quantity: 5,
      ),
    ];
  }
}