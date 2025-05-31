import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/game_utils.dart';

class Enemy {
  String type; // 敵人類型名稱
  int health; // 敵人生命值
  int maxHealth; // 最大生命值
  double speed; // 移動速度
  double baseSpeed; // 基礎速度（未受效果影響時）
  String assetPath; // 敵人圖像路徑
  Position position; // 位置
  int damage; // 攻擊傷害
  int reward; // 擊敗獎勵
  bool isActive; // 是否活躍

  // 新增特性屬性
  String specialty; // 特性類型
  double specialtyChance; // 特性觸發概率
  bool isSpecialtyActive; // 特性是否啟動
  int specialtyDuration; // 特性持續時間（毫秒）
  int specialtyTimer; // 特性計時器

  // 新增狀態效果
  bool isStunned; // 是否被暈眩
  int stunDuration; // 暈眩持續時間
  bool isBurning; // 是否灼燒
  int burnDuration; // 灼燒持續時間
  int burnDamage; // 灼燒傷害
  bool isSlowed; // 是否減速
  int slowDuration; // 減速持續時間
  double slowFactor; // 減速因子

  // AI行為模式
  String
      movementPattern; // 移動模式：'direct'（直線）, 'zigzag'（之字形）, 'circle'（環繞）, 'teleport'（瞬移）
  int patternTimer; // 行為模式計時器
  Position lastTargetPosition; // 上次目標位置，用於計算變向
  double patternPhase; // 模式階段（用於之字形或環形移動）

  Enemy({
    required this.type,
    required this.health,
    required this.speed,
    required this.assetPath,
    required this.position,
    required this.damage,
    required this.reward,
    this.isActive = true,
    this.specialty = '',
    this.specialtyChance = 0.0,
    this.isSpecialtyActive = false,
    this.specialtyDuration = 0,
    this.specialtyTimer = 0,
    this.isStunned = false,
    this.stunDuration = 0,
    this.isBurning = false,
    this.burnDuration = 0,
    this.burnDamage = 0,
    this.isSlowed = false,
    this.slowDuration = 0,
    this.slowFactor = 1.0,
    this.movementPattern = 'direct',
    this.patternTimer = 0,
    Position? lastTargetPosition,
    this.patternPhase = 0.0,
  })  : maxHealth = health,
        baseSpeed = speed,
        lastTargetPosition = lastTargetPosition ?? Position(x: 0, y: 0);

  // 獲取敵人圖片路徑
  static String getEnemyAssetPath(EnemyType enemyType) {
    switch (enemyType) {
      case EnemyType.ghostFiend:
        return 'assets/images/enemies/enemies_1.png';
      case EnemyType.demonBeast:
        return 'assets/images/enemies/enemies_3.png';
      case EnemyType.evilCultist:
        return 'assets/images/enemies/enemies_5.png';
      case EnemyType.undeadSoul:
        return 'assets/images/enemies/enemies_7.png';
      case EnemyType.bossFiend:
        return 'assets/images/enemies/enemies_11.png';
      default:
        return 'assets/images/enemies/enemies_1.png';
    }
  }

  // 工廠方法，根據敵人類型和波數創建敵人
  factory Enemy.create(EnemyType enemyType, int wave, Position position) {
    int health = 0;
    double speed = 0;
    int damage = 0;
    int reward = 0;

    // 基本屬性設置
    switch (enemyType) {
      case EnemyType.ghostFiend: // 鬼煞（靈活但脆弱的敵人）
        health = GameConstants.baseEnemyHealth ~/ 2;
        speed = GameConstants.baseEnemySpeed * 1.5;
        damage = GameConstants.baseEnemyDamage ~/ 2;
        reward = GameConstants.baseCultivationReward;
        break;

      case EnemyType.demonBeast: // 妖獸（強壯但緩慢的敵人）
        health = GameConstants.baseEnemyHealth * 2;
        speed = GameConstants.baseEnemySpeed * 0.7;
        damage = GameConstants.baseEnemyDamage;
        reward = (GameConstants.baseCultivationReward * 2).round();
        break;

      case EnemyType.evilCultist: // 邪修（平衡型敵人，可召喚幻影）
        health = GameConstants.baseEnemyHealth;
        speed = GameConstants.baseEnemySpeed;
        damage = GameConstants.baseEnemyDamage;
        reward = (GameConstants.baseCultivationReward * 1.5).round();
        break;

      case EnemyType.undeadSoul: // 怨魂（會恢復的敵人）
        health = GameConstants.baseEnemyHealth;
        speed = GameConstants.baseEnemySpeed * 0.9;
        damage = GameConstants.baseEnemyDamage;
        reward = GameConstants.baseCultivationReward;
        break;

      case EnemyType.bossFiend: // 魔王（強大的Boss）
        health = GameConstants.baseEnemyHealth * 6;
        speed = GameConstants.baseEnemySpeed * 0.8;
        damage = GameConstants.baseEnemyDamage * 2;
        reward = (GameConstants.baseCultivationReward * 5).round();
        break;
    }

    // 根據波數調整難度
    double waveMultiplier = 1.0 + (wave - 1) * GameConstants.waveScalingFactor;

    // 無限模式難度調整: 波數超過20後，額外增加難度
    if (wave > 20) {
      // 波數越高，難度指數級提升
      waveMultiplier += (wave - 20) * GameConstants.advancedWaveScalingBonus;

      // 每50波額外增加10%的基礎難度
      int extraTierBonus = (wave / 50).floor();
      if (extraTierBonus > 0) {
        waveMultiplier *= (1.0 + extraTierBonus * 0.1);
      }
    }

    // 應用難度倍數
    health = (health * waveMultiplier).round();
    speed = speed * (1 + (wave - 1) * 0.05);
    damage = (damage * waveMultiplier).round();
    reward = (reward * waveMultiplier).round();

    // 獲取敵人圖像路徑
    final assetPath = getEnemyAssetPath(enemyType);

    return Enemy(
      type: enemyType.toString().split('.').last,
      health: health,
      speed: speed,
      assetPath: assetPath,
      position: position,
      damage: damage,
      reward: reward,
      specialty: '',
      specialtyChance: 0.0,
      isSpecialtyActive: false,
      specialtyDuration: 0,
      specialtyTimer: 0,
      isStunned: false,
      stunDuration: 0,
      isBurning: false,
      burnDuration: 0,
      burnDamage: 0,
      isSlowed: false,
      slowDuration: 0,
      slowFactor: 1.0,
      movementPattern: 'direct',
      patternTimer: 0,
      patternPhase: 0.0,
    );
  }

  // 隨機生成敵人
  static Enemy generateRandom(int wave, Size screenSize) {
    final random = Random();

    // 根據波數調整不同敵人類型的概率
    EnemyType enemyType;

    // 每固定波數出現一次Boss
    if (wave % GameConstants.bossWaveInterval == 0) {
      enemyType = EnemyType.bossFiend;
    }
    // 高波數時增加Boss出現概率
    else if (wave > 50) {
      final bossChance = min(0.15, (wave - 50) * 0.002); // 每多50波增加10%概率，最高15%

      if (random.nextDouble() < bossChance) {
        enemyType = EnemyType.bossFiend;
      } else {
        // 普通敵人概率分配
        final randomValue = random.nextDouble();

        // 高波數時增加更強的敵人出現概率
        final strongEnemyChance =
            min(0.7, 0.4 + (wave - 50) * 0.005); // 強力敵人概率隨波數增加

        if (randomValue < 0.3) {
          enemyType = EnemyType.ghostFiend;
        } else if (randomValue < 0.5) {
          enemyType = EnemyType.demonBeast;
        } else if (randomValue < 0.7) {
          enemyType = EnemyType.evilCultist;
        } else {
          enemyType = EnemyType.undeadSoul;
        }
      }
    } else {
      final randomValue = random.nextDouble();

      if (randomValue < 0.3) {
        enemyType = EnemyType.ghostFiend;
      } else if (randomValue < 0.6) {
        enemyType = EnemyType.demonBeast;
      } else if (randomValue < 0.8) {
        enemyType = EnemyType.evilCultist;
      } else {
        enemyType = EnemyType.undeadSoul;
      }
    }

    // 生成隨機位置
    final position = generateRandomEnemyPosition(screenSize);

    return Enemy.create(enemyType, wave, position);
  }

  // 受到傷害
  void takeDamage(int amount) {
    // 檢查特殊能力是否觸發
    if (specialty == 'dodge' && !isStunned) {
      // 鬼煞有機會閃避攻擊
      if (Random().nextDouble() < specialtyChance) {
        // 閃避成功，不受傷害
        isSpecialtyActive = true;
        specialtyTimer = 500; // 顯示閃避效果500毫秒
        return;
      }
    } else if (specialty == 'armor' && !isStunned) {
      // 妖獸有傷害減免
      amount = (amount * (1 - specialtyChance)).round();
    } else if (specialty == 'phase' && !isStunned) {
      // 怨魂有機會進入無實體狀態
      if (Random().nextDouble() < specialtyChance && !isSpecialtyActive) {
        isSpecialtyActive = true;
        specialtyTimer = 1500; // 無實體狀態持續1.5秒
        return; // 無實體狀態下不受傷害
      }
    }

    health -= amount;

    // 檢查特殊技能 - 邪修受傷時有機會召喚幻影
    if (specialty == 'summon' && health > 0 && !isStunned) {
      if (Random().nextDouble() < specialtyChance && !isSpecialtyActive) {
        isSpecialtyActive = true;
        specialtyTimer = 3000; // 標記召喚狀態，3秒內不會再次觸發
        // 注意：實際的幻影召喚邏輯需要在GameService中實現
      }
    }

    // 檢查特殊技能 - 魔王憤怒模式
    if (specialty == 'rage' &&
        health > 0 &&
        health < maxHealth / 2 &&
        !isStunned) {
      if (!isSpecialtyActive) {
        isSpecialtyActive = true;
        damage = (damage * 1.5).round(); // 增加50%傷害
      }
    }

    if (health <= 0) {
      health = 0;
      isActive = false;
    }
  }

  // 更新敵人狀態
  void update(int deltaTimeMs) {
    // 更新特性計時器
    if (specialtyTimer > 0) {
      specialtyTimer -= deltaTimeMs;
      if (specialtyTimer <= 0) {
        specialtyTimer = 0;
        isSpecialtyActive = false;
      }
    }

    // 更新行為模式計時器
    patternTimer += deltaTimeMs;

    // 更新暈眩狀態
    if (isStunned) {
      stunDuration -= deltaTimeMs;
      if (stunDuration <= 0) {
        isStunned = false;
        stunDuration = 0;
      }
    }

    // 更新灼燒狀態
    if (isBurning) {
      burnDuration -= deltaTimeMs;

      // 定期造成灼燒傷害（每500毫秒）
      if (burnDuration % 500 < deltaTimeMs) {
        health -= burnDamage;
        if (health <= 0) {
          health = 0;
          isActive = false;
        }
      }

      if (burnDuration <= 0) {
        isBurning = false;
        burnDuration = 0;
      }
    }

    // 更新減速狀態
    if (isSlowed) {
      slowDuration -= deltaTimeMs;
      if (slowDuration <= 0) {
        isSlowed = false;
        slowDuration = 0;
        // 恢復正常速度
        speed = baseSpeed;
      }
    }
  }

  // 向角色移動
  void moveTowardsCharacter(Position characterPosition) {
    // 如果被暈眩，無法移動
    if (isStunned) return;

    // 保存上次的目標位置，用於變向計算
    lastTargetPosition = characterPosition.copy();

    // 根據移動模式選擇不同的移動方式
    switch (movementPattern) {
      case 'direct':
        // 直線移動
        _directMovement(characterPosition);
        break;
      case 'zigzag':
        // 之字形移動
        _zigzagMovement(characterPosition);
        break;
      case 'circle':
        // 環繞移動
        _circleMovement(characterPosition);
        break;
      case 'teleport':
        // 瞬移移動（僅適用於Boss）
        _teleportMovement(characterPosition);
        break;
      default:
        // 默認直線移動
        _directMovement(characterPosition);
    }
  }

  // 直線移動
  void _directMovement(Position target) {
    // 計算實際速度（考慮減速效果）
    final actualSpeed = isSlowed ? speed * slowFactor : speed;
    position.moveTowards(target, actualSpeed);
  }

  // 之字形移動
  void _zigzagMovement(Position target) {
    // 每2秒改變一次方向
    patternPhase += 0.05;

    // 計算實際速度
    final actualSpeed = isSlowed ? speed * slowFactor : speed;

    // 計算基本方向向量
    final dx = target.x - position.x;
    final dy = target.y - position.y;
    final distance = sqrt(dx * dx + dy * dy);

    // 添加正弦波動以產生之字形運動
    final amplitude = 20.0; // 振幅
    final sideOffset = sin(patternPhase * 2) * amplitude;

    // 計算垂直於目標方向的向量
    final normalX = -dy / distance;
    final normalY = dx / distance;

    // 創建偏移目標位置
    final offsetTarget = Position(
      x: target.x + normalX * sideOffset,
      y: target.y + normalY * sideOffset,
    );

    // 向偏移目標移動
    position.moveTowards(offsetTarget, actualSpeed);
  }

  // 環繞移動
  void _circleMovement(Position target) {
    // 計算與目標的距離
    final distance = position.distanceTo(target);

    // 如果距離太遠，先直接靠近
    if (distance > 150) {
      _directMovement(target);
      return;
    }

    // 計算實際速度
    final actualSpeed = isSlowed ? speed * slowFactor : speed;

    // 更新環繞角度
    patternPhase += 0.03;

    // 計算環繞半徑
    final radius = 120.0;

    // 計算環繞位置
    final circleX = target.x + cos(patternPhase) * radius;
    final circleY = target.y + sin(patternPhase) * radius;

    // 向環繞位置移動
    position.moveTowards(Position(x: circleX, y: circleY), actualSpeed);
  }

  // 瞬移移動（僅適用於Boss）
  void _teleportMovement(Position target) {
    // 每3秒嘗試瞬移一次
    if (patternTimer > 3000) {
      patternTimer = 0;

      // 50%機率觸發瞬移
      if (Random().nextDouble() < 0.5) {
        // 計算與目標的當前距離
        final currentDistance = position.distanceTo(target);

        // 如果距離適中，進行瞬移
        if (currentDistance > 50 && currentDistance < 250) {
          // 瞬移到目標周圍的隨機位置
          final teleportDistance = 50.0 + Random().nextDouble() * 50.0;
          final teleportAngle = Random().nextDouble() * 2 * pi;

          position = Position(
            x: target.x + cos(teleportAngle) * teleportDistance,
            y: target.y + sin(teleportAngle) * teleportDistance,
          );

          isSpecialtyActive = true;
          specialtyTimer = 500; // 瞬移特效持續500毫秒
          return;
        }
      }
    }

    // 未觸發瞬移時，使用直線移動
    _directMovement(target);
  }

  // 設置暈眩效果
  void setStunned(int duration) {
    isStunned = true;
    stunDuration = duration;
  }

  // 設置灼燒效果
  void setBurning(int duration, int damage) {
    isBurning = true;
    burnDuration = duration;
    burnDamage = damage;
  }

  // 設置減速效果
  void setSlowed(int duration, double factor) {
    isSlowed = true;
    slowDuration = duration;
    slowFactor = factor;
    // 減速後的實際速度
    speed = baseSpeed * factor;
  }

  // 應用擊退效果
  void applyKnockback(Position source, double force) {
    // 計算方向
    final dx = position.x - source.x;
    final dy = position.y - source.y;
    final distance = sqrt(dx * dx + dy * dy);

    // 防止除以零
    if (distance < 0.1) return;

    // 標準化並應用力量
    final knockbackX = (dx / distance) * force;
    final knockbackY = (dy / distance) * force;

    // 應用擊退
    position.x += knockbackX;
    position.y += knockbackY;
  }

  // 檢查是否與角色碰撞
  bool isCollidingWith(Position characterPosition, double characterSize) {
    final distance = position.distanceTo(characterPosition);
    return distance < (GameConstants.enemySize + characterSize) / 2;
  }

  // 將敵人數據轉為JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'health': health,
      'max_health': maxHealth,
      'speed': speed,
      'base_speed': baseSpeed,
      'asset_path': assetPath,
      'position': position.toJson(),
      'damage': damage,
      'reward': reward,
      'is_active': isActive,
      'specialty': specialty,
      'specialty_chance': specialtyChance,
      'is_specialty_active': isSpecialtyActive,
      'specialty_duration': specialtyDuration,
      'specialty_timer': specialtyTimer,
      'is_stunned': isStunned,
      'stun_duration': stunDuration,
      'is_burning': isBurning,
      'burn_duration': burnDuration,
      'burn_damage': burnDamage,
      'is_slowed': isSlowed,
      'slow_duration': slowDuration,
      'slow_factor': slowFactor,
      'movement_pattern': movementPattern,
      'pattern_timer': patternTimer,
      'pattern_phase': patternPhase,
    };
  }

  // 從JSON創建敵人
  factory Enemy.fromJson(Map<String, dynamic> json) {
    return Enemy(
      type: json['type'] as String,
      health: json['health'] as int,
      speed: json['speed'] as double,
      assetPath: json['asset_path'] as String,
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
      damage: json['damage'] as int,
      reward: json['reward'] as int,
      isActive: json['is_active'] as bool,
      specialty: json['specialty'] as String? ?? '',
      specialtyChance: json['specialty_chance'] as double? ?? 0.0,
      isSpecialtyActive: json['is_specialty_active'] as bool? ?? false,
      specialtyDuration: json['specialty_duration'] as int? ?? 0,
      specialtyTimer: json['specialty_timer'] as int? ?? 0,
      isStunned: json['is_stunned'] as bool? ?? false,
      stunDuration: json['stun_duration'] as int? ?? 0,
      isBurning: json['is_burning'] as bool? ?? false,
      burnDuration: json['burn_duration'] as int? ?? 0,
      burnDamage: json['burn_damage'] as int? ?? 0,
      isSlowed: json['is_slowed'] as bool? ?? false,
      slowDuration: json['slow_duration'] as int? ?? 0,
      slowFactor: json['slow_factor'] as double? ?? 1.0,
      movementPattern: json['movement_pattern'] as String? ?? 'direct',
      patternTimer: json['pattern_timer'] as int? ?? 0,
      patternPhase: json['pattern_phase'] as double? ?? 0.0,
    );
  }
}
