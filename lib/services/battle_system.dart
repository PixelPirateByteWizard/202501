import 'dart:math' as math;
import '../models/battle.dart';
import '../models/general.dart';
import 'ai_service.dart';

class BattleSystem {
  static final math.Random _random = math.Random();

  // 计算伤害
  static int calculateDamage({
    required BattleUnit attacker,
    required BattleUnit defender,
    required Formation attackerFormation,
    double skillMultiplier = 1.0,
  }) {
    // 基础攻击力 = 攻击者兵力 * (1 + (武力-50)*0.01)
    final baseAttack = attacker.currentTroops * (1 + (attacker.general.stats.force - 50) * 0.01);
    
    // 阵型加成
    final formationBonus = _getFormationBonus(attacker.position, attackerFormation, 'damage');
    
    // 技能倍率
    final skillDamage = baseAttack * skillMultiplier * (1 + formationBonus);
    
    // 随机波动 (0.9 ~ 1.1)
    final randomFactor = 0.9 + _random.nextDouble() * 0.2;
    
    // 最终伤害
    final finalDamage = (skillDamage * randomFactor).floor();
    
    return math.max(0, finalDamage);
  }

  // 计算暴击率
  static bool isCriticalHit(BattleUnit attacker, BattleUnit defender) {
    final baseCritRate = 0.05; // 基础5%暴击率
    final statDiff = (attacker.general.stats.force - defender.general.stats.intelligence) * 0.001;
    final finalCritRate = math.max(0.05, baseCritRate + statDiff);
    
    return _random.nextDouble() < finalCritRate;
  }

  // 计算行动顺序
  static List<BattleUnit> calculateTurnOrder(List<BattleUnit> allUnits) {
    final activeUnits = allUnits.where((unit) => unit.isAlive).toList();
    
    // 按照 统率 + 0.3*智力 + 速度 排序
    activeUnits.sort((a, b) {
      final aSpeed = a.general.stats.leadership + 
                    0.3 * a.general.stats.intelligence + 
                    a.general.stats.speed;
      final bSpeed = b.general.stats.leadership + 
                    0.3 * b.general.stats.intelligence + 
                    b.general.stats.speed;
      return bSpeed.compareTo(aSpeed);
    });
    
    return activeUnits;
  }

  // 执行攻击
  static Future<BattleResult> executeAttack({
    required BattleUnit attacker,
    required BattleUnit target,
    required Formation attackerFormation,
    required Formation defenderFormation,
    Skill? skill,
  }) async {
    final skillMultiplier = skill != null ? 1.5 : 1.0;
    final isCrit = isCriticalHit(attacker, target);
    final critMultiplier = isCrit ? 1.5 : 1.0;
    
    final baseDamage = calculateDamage(
      attacker: attacker,
      defender: target,
      attackerFormation: attackerFormation,
      skillMultiplier: skillMultiplier,
    );
    
    final finalDamage = (baseDamage * critMultiplier).floor();
    final newTroops = math.max(0, target.currentTroops - finalDamage);
    
    // 生成战斗报告
    final actionName = skill?.name ?? '普通攻击';
    final battleReport = await AIService.generateBattleReport(
      attackerName: attacker.general.name,
      defenderName: target.general.name,
      action: actionName,
      isSuccess: finalDamage > 0,
      isCritical: isCrit,
    );
    
    return BattleResult(
      attacker: attacker,
      target: target.copyWith(currentTroops: newTroops),
      damage: finalDamage,
      isCritical: isCrit,
      battleLogs: battleReport.map((log) => BattleLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: log,
        type: BattleLogType.attack,
        timestamp: DateTime.now(),
        unitId: attacker.general.id,
      )).toList(),
    );
  }

  // 检查战斗结束条件
  static BattleEndResult? checkBattleEnd(List<BattleUnit> playerUnits, List<BattleUnit> enemyUnits) {
    final alivePlayerUnits = playerUnits.where((unit) => unit.isAlive).length;
    final aliveEnemyUnits = enemyUnits.where((unit) => unit.isAlive).length;
    
    if (alivePlayerUnits == 0) {
      return BattleEndResult(isVictory: false, message: '全军覆没，败北而归...');
    } else if (aliveEnemyUnits == 0) {
      return BattleEndResult(isVictory: true, message: '大获全胜，敌军溃散！');
    }
    
    return null;
  }

  // 获取阵型加成
  static double _getFormationBonus(int position, Formation formation, String bonusType) {
    if (position < 0 || position >= formation.positions.length) return 0.0;
    
    final positionBonus = formation.positions[position].bonuses[bonusType] ?? 0.0;
    final formationBonus = formation.bonuses[bonusType] ?? 0.0;
    
    return positionBonus + formationBonus;
  }

  // 应用状态效果
  static BattleUnit applyStatusEffects(BattleUnit unit) {
    var updatedUnit = unit;
    final updatedEffects = <StatusEffect>[];
    
    for (final effect in unit.statusEffects) {
      if (effect.duration > 0) {
        // 应用效果
        // 这里可以根据效果类型应用不同的逻辑
        
        // 减少持续时间
        updatedEffects.add(effect.copyWith(duration: effect.duration - 1));
      }
    }
    
    return updatedUnit.copyWith(statusEffects: updatedEffects);
  }

  // 获取可用技能
  static List<Skill> getAvailableSkills(BattleUnit unit) {
    return unit.general.skills.where((skill) => 
      skill.type == SkillType.active && skill.currentCooldown == 0
    ).toList();
  }

  // 使用技能后更新冷却
  static General updateSkillCooldown(General general, String skillId) {
    final updatedSkills = general.skills.map((skill) {
      if (skill.id == skillId) {
        return skill.copyWith(currentCooldown: skill.cooldown);
      }
      return skill;
    }).toList();
    
    return general.copyWith(skills: updatedSkills);
  }

  // 减少技能冷却
  static General reduceSkillCooldowns(General general) {
    final updatedSkills = general.skills.map((skill) {
      if (skill.currentCooldown > 0) {
        return skill.copyWith(currentCooldown: skill.currentCooldown - 1);
      }
      return skill;
    }).toList();
    
    return general.copyWith(skills: updatedSkills);
  }
}

class BattleResult {
  final BattleUnit attacker;
  final BattleUnit target;
  final int damage;
  final bool isCritical;
  final List<BattleLog> battleLogs;

  BattleResult({
    required this.attacker,
    required this.target,
    required this.damage,
    required this.isCritical,
    required this.battleLogs,
  });
}

class BattleEndResult {
  final bool isVictory;
  final String message;

  BattleEndResult({
    required this.isVictory,
    required this.message,
  });
}