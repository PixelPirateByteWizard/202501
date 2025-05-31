import 'dart:math';
import 'package:flutter/material.dart';
import 'player.dart';
import 'enemy.dart';
import 'upgrade.dart';
import '../utils/game_utils.dart';

class GameState {
  Player player;
  List<Enemy> enemies;
  List<String> activeBullets;
  bool isPaused;
  bool isGameOver;
  int score;

  // Game difficulty related
  Duration enemySpawnInterval;
  double spawnRateMultiplier;

  // Additional properties
  double healthRegenRate;
  double damageReflect;
  double fireRateMultiplier;
  int multiShotCount;
  double enlightenmentGainMultiplier;
  double cultivationGainMultiplier;
  Map<String, double> bulletDamageMultipliers;

  // Advanced skill properties
  bool isBulletHoming; // Bullet tracking effect
  double areaAttackChance; // Area attack trigger probability
  double criticalStrikeChance; // Critical strike probability
  int spiritBulletPierceCount; // Spirit bullet penetration count
  double flameBulletBurnDamage; // Flame bullet additional burn damage
  double frostBulletSlowFactor; // Frost bullet additional slow factor
  double
      tornadoBulletKnockbackFactor; // Tornado bullet additional knockback factor
  int lifeStealAmount; // Life steal amount

  GameState({
    required this.player,
    required this.enemies,
    required this.activeBullets,
    this.isPaused = false,
    this.isGameOver = false,
    this.score = 0,
    required this.enemySpawnInterval,
    this.spawnRateMultiplier = 1.0,
    this.healthRegenRate = 0.0,
    this.damageReflect = 0.0,
    this.fireRateMultiplier = 1.0,
    this.multiShotCount = 1,
    this.enlightenmentGainMultiplier = 1.0,
    this.cultivationGainMultiplier = 1.0,
    required this.bulletDamageMultipliers,
    this.isBulletHoming = false,
    this.areaAttackChance = 0.0,
    this.criticalStrikeChance = 0.0,
    this.spiritBulletPierceCount = 1,
    this.flameBulletBurnDamage = 0.0,
    this.frostBulletSlowFactor = 0.0,
    this.tornadoBulletKnockbackFactor = 0.0,
    this.lifeStealAmount = 0,
  });

  // Create new game
  factory GameState.newGame([Player? initialPlayer]) {
    return GameState(
      player: initialPlayer ?? Player(),
      enemies: [],
      activeBullets: initialPlayer?.bullets ?? ['bolt'],
      enemySpawnInterval: GameConstants.enemySpawnInterval,
      bulletDamageMultipliers: {
        'bolt': 1.0,
        'flame': 1.0,
        'frost': 1.0,
        'spirit': 1.0,
        'tornado': 1.0,
      },
    );
  }

  // Check if game is over
  bool checkGameOver() {
    if (player.isDead) {
      isGameOver = true;
      return true;
    }
    return false;
  }

  // Update enemy positions
  void updateEnemies(Size screenSize, Position characterPosition) {
    final activeEnemies = <Enemy>[];

    for (final enemy in enemies) {
      if (!enemy.isActive) continue;

      // Check collision with character
      if (enemy.isCollidingWith(
          characterPosition, GameConstants.characterSize)) {
        // Deal damage to character
        player.takeDamage(enemy.damage);

        // If there's damage reflection, deal reflect damage to enemy
        if (damageReflect > 0) {
          final reflectDamage = (enemy.damage * damageReflect).round();
          enemy.takeDamage(reflectDamage);
        }

        // If enemy is still active (might die from reflect damage)
        if (enemy.isActive) {
          // Push enemy away (simulate collision knockback)
          final randomAngle = Random().nextDouble() * 2 * pi;
          enemy.position = Position(
            x: characterPosition.x +
                cos(randomAngle) * GameConstants.characterSize * 1.5,
            y: characterPosition.y +
                sin(randomAngle) * GameConstants.characterSize * 1.5,
          );
          activeEnemies.add(enemy);
        } else {
          // Enemy defeated, add score
          score += enemy.reward;
          player.increaseCultivation(enemy.reward);
          player.increaseEnlightenment(GameConstants.baseEnlightenmentGain *
              enlightenmentGainMultiplier);
        }
      } else {
        // Enemy moves towards character
        enemy.moveTowardsCharacter(characterPosition);
        activeEnemies.add(enemy);
      }
    }

    enemies = activeEnemies;
  }

  // Spawn new enemy
  void spawnEnemy(Size screenSize) {
    final enemy = Enemy.generateRandom(player.wave, screenSize);
    enemies.add(enemy);
  }

  // Update game difficulty
  void updateDifficulty() {
    // Adjust enemy spawn speed based on wave number
    final baseInterval = GameConstants.enemySpawnInterval.inMilliseconds;

    // Calculate wave modifier, higher waves have shorter spawn intervals
    double waveModifier;

    if (player.wave <= 20) {
      // First 20 waves, reduce spawn interval by 2% per wave
      waveModifier = 1.0 - (player.wave * 0.02);
    } else if (player.wave <= 50) {
      // Waves 20-50, reduce speed slightly slower
      waveModifier =
          0.6 - ((player.wave - 20) * 0.01); // Start from 0.6 and decrease
    } else {
      // Waves 50+, minimum not below 0.25x base interval
      waveModifier = 0.3 - ((player.wave - 50) * 0.001).clamp(0.0, 0.05);
      waveModifier = waveModifier.clamp(0.25, 0.3); // Ensure not below 0.25
    }

    // Calculate new enemy spawn interval with min/max limits
    final newInterval =
        (baseInterval * waveModifier).clamp(200, baseInterval).round();
    enemySpawnInterval = Duration(milliseconds: newInterval);

    // Calculate spawn rate multiplier, higher waves spawn more enemies
    if (player.wave <= 20) {
      // First 20 waves, increase spawn rate by 5% per wave
      spawnRateMultiplier = 1.0 + (player.wave * 0.05);
    } else if (player.wave <= 50) {
      // Waves 20-50, increase speed slightly faster
      spawnRateMultiplier = 2.0 + ((player.wave - 20) * 0.08);
    } else if (player.wave <= 100) {
      // Waves 50-100, further acceleration
      spawnRateMultiplier = 4.4 + ((player.wave - 50) * 0.1);
    } else {
      // Waves 100+, exponential increase
      spawnRateMultiplier = 9.4 + (player.wave - 100) * 0.15;
    }

    // Adjust boss frequency every 20 waves
    if (player.wave > 50) {
      // At high waves, bosses appear more frequently
      // This doesn't directly modify GameConstants.bossWaveInterval, but increases boss probability when generating enemies
      // This logic is handled in Enemy.generateRandom() method
    }
  }

  // Apply upgrade effects
  void applyUpgrade(Upgrade upgrade) {
    switch (upgrade.effect) {
      case 'bolt_damage':
        bulletDamageMultipliers['bolt'] =
            bulletDamageMultipliers['bolt']! + upgrade.value;
        break;
      case 'flame_damage':
        bulletDamageMultipliers['flame'] =
            bulletDamageMultipliers['flame']! + upgrade.value;
        flameBulletBurnDamage += 2; // Add 2 burn damage per level
        break;
      case 'frost_damage':
        bulletDamageMultipliers['frost'] =
            bulletDamageMultipliers['frost']! + upgrade.value;
        frostBulletSlowFactor += 0.1; // Add 10% slow effect per level
        break;
      case 'spirit_damage':
        bulletDamageMultipliers['spirit'] =
            bulletDamageMultipliers['spirit']! + upgrade.value;
        spiritBulletPierceCount += 1; // Add 1 pierce target per level
        break;
      case 'tornado_damage':
        bulletDamageMultipliers['tornado'] =
            bulletDamageMultipliers['tornado']! + upgrade.value;
        tornadoBulletKnockbackFactor +=
            0.3; // Add 30% knockback distance per level
        break;
      case 'unlock_bullet':
        final bulletTypes = ['flame', 'frost', 'spirit', 'tornado'];
        final index = upgrade.value.toInt();
        if (index >= 0 && index < bulletTypes.length) {
          final bulletType = bulletTypes[index];
          player.addBulletType(bulletType);
          activeBullets.add(bulletType);
        }
        break;
      case 'max_health':
        // Increase maximum spirit power
        final currentHealth = player.health;
        final maxHealthIncrease = (player.maxHealth * upgrade.value).round();
        player.maxHealth += maxHealthIncrease;
        player.health = currentHealth + maxHealthIncrease;
        break;
      case 'health_regen':
        // Increase spirit power recovery rate
        healthRegenRate += upgrade.value;
        break;
      case 'damage_reflect':
        // Increase damage reflection
        damageReflect += upgrade.value;
        break;
      case 'fire_rate':
        // Increase attack speed
        fireRateMultiplier += upgrade.value;
        break;
      case 'multi_shot':
        // Increase multi-shot count
        multiShotCount += upgrade.value.toInt();
        break;
      case 'enlightenment_gain':
        // Increase enlightenment progress gain speed
        enlightenmentGainMultiplier += upgrade.value;
        break;
      case 'cultivation_gain':
        // Increase cultivation gain speed
        cultivationGainMultiplier += upgrade.value;
        break;
      case 'instant_health':
        // Instantly recover spirit power
        player.heal(upgrade.value.toInt());
        break;
      case 'area_attack':
        // Area attack skill
        areaAttackChance = upgrade.value;
        break;
      case 'critical_strike':
        // Critical strike skill
        criticalStrikeChance = upgrade.value;
        break;
      case 'bullet_homing':
        // Bullet tracking skill
        isBulletHoming = true;
        break;
      case 'life_steal':
        // Life steal skill
        lifeStealAmount = upgrade.value.toInt();
        break;
    }

    // Reset enlightenment progress after upgrade
    player.resetEnlightenmentProgress();
  }

  // Check if upgrade is effective
  String verifyUpgrade() {
    // Build detailed upgrade status information string
    StringBuffer status = StringBuffer();

    // Basic information
    status.writeln('=== Upgrade Status Check ===');

    // Check bullet damage
    status.writeln('\nBullet Damage Multipliers:');
    bulletDamageMultipliers.forEach((type, multiplier) {
      status.writeln('- $type: ${multiplier.toStringAsFixed(2)}x');
    });

    // Check bullet special effects
    status.writeln('\nBullet Special Effects:');
    status.writeln(
        '- Flame burn damage: ${flameBulletBurnDamage.toStringAsFixed(1)}');
    status.writeln(
        '- Frost slow factor: ${frostBulletSlowFactor.toStringAsFixed(2)}');
    status.writeln('- Spirit pierce count: $spiritBulletPierceCount');
    status.writeln(
        '- Tornado knockback factor: ${tornadoBulletKnockbackFactor.toStringAsFixed(2)}');

    // Check active bullet types
    status.writeln('\nActive bullet types: ${activeBullets.join(', ')}');
    status.writeln('\nUnlocked bullet types: ${player.bullets.join(', ')}');

    // Check basic attributes
    status.writeln('\nBasic Attributes:');
    status.writeln('- Attack speed: ${fireRateMultiplier.toStringAsFixed(2)}x');
    status.writeln('- Multi-shot count: $multiShotCount');
    status.writeln(
        '- Bullet tracking: ${isBulletHoming ? 'Enabled' : 'Disabled'}');
    status.writeln(
        '- Area attack chance: ${(areaAttackChance * 100).toStringAsFixed(1)}%');
    status.writeln(
        '- Critical strike chance: ${(criticalStrikeChance * 100).toStringAsFixed(1)}%');
    status.writeln('- Life steal: $lifeStealAmount');
    status.writeln(
        '- Damage reflect: ${(damageReflect * 100).toStringAsFixed(1)}%');
    status.writeln(
        '- Spirit recovery rate: ${healthRegenRate.toStringAsFixed(2)}/sec');

    // Check passive skills
    status.writeln('\nPassive Skills:');
    for (final skill in player.passiveSkills) {
      status.writeln('- $skill (Level ${player.getPassiveSkillLevel(skill)})');
    }

    return status.toString();
  }

  // Update per frame
  void update(double deltaTime, Size screenSize) {
    if (isPaused || isGameOver) return;

    // Character position (screen center)
    final characterPosition = Position(
      x: screenSize.width / 2,
      y: screenSize.height / 2,
    );

    // Update enemy positions
    updateEnemies(screenSize, characterPosition);

    // Spirit power recovery
    if (healthRegenRate > 0) {
      final healthToRegen = healthRegenRate * deltaTime;
      player.heal(healthToRegen.toInt());
    }

    // Update combo system
    player.updateCombo((deltaTime * 1000).toInt());

    // Check if game is over
    checkGameOver();
  }

  // Convert game state to JSON
  Map<String, dynamic> toJson() {
    return {
      'player': player.toJson(),
      'enemies': enemies.map((e) => e.toJson()).toList(),
      'active_bullets': activeBullets,
      'is_paused': isPaused,
      'is_game_over': isGameOver,
      'score': score,
      'enemy_spawn_interval': enemySpawnInterval.inMilliseconds,
      'spawn_rate_multiplier': spawnRateMultiplier,
      'health_regen_rate': healthRegenRate,
      'damage_reflect': damageReflect,
      'fire_rate_multiplier': fireRateMultiplier,
      'multi_shot_count': multiShotCount,
      'enlightenment_gain_multiplier': enlightenmentGainMultiplier,
      'cultivation_gain_multiplier': cultivationGainMultiplier,
      'bullet_damage_multipliers': bulletDamageMultipliers,
      'is_bullet_homing': isBulletHoming,
      'area_attack_chance': areaAttackChance,
      'critical_strike_chance': criticalStrikeChance,
      'spirit_bullet_pierce_count': spiritBulletPierceCount,
      'flame_bullet_burn_damage': flameBulletBurnDamage,
      'frost_bullet_slow_factor': frostBulletSlowFactor,
      'tornado_bullet_knockback_factor': tornadoBulletKnockbackFactor,
      'life_steal_amount': lifeStealAmount,
    };
  }

  // Create game state from JSON
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      enemies: (json['enemies'] as List)
          .map((e) => Enemy.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeBullets: List<String>.from(json['active_bullets'] as List),
      isPaused: json['is_paused'] as bool,
      isGameOver: json['is_game_over'] as bool,
      score: json['score'] as int,
      enemySpawnInterval:
          Duration(milliseconds: json['enemy_spawn_interval'] as int),
      spawnRateMultiplier: json['spawn_rate_multiplier'] as double,
      healthRegenRate: json['health_regen_rate'] as double,
      damageReflect: json['damage_reflect'] as double,
      fireRateMultiplier: json['fire_rate_multiplier'] as double,
      multiShotCount: json['multi_shot_count'] as int,
      enlightenmentGainMultiplier:
          json['enlightenment_gain_multiplier'] as double,
      cultivationGainMultiplier: json['cultivation_gain_multiplier'] as double,
      bulletDamageMultipliers:
          Map<String, double>.from(json['bullet_damage_multipliers'] as Map),
      isBulletHoming: json['is_bullet_homing'] as bool? ?? false,
      areaAttackChance: json['area_attack_chance'] as double? ?? 0.0,
      criticalStrikeChance: json['critical_strike_chance'] as double? ?? 0.0,
      spiritBulletPierceCount: json['spirit_bullet_pierce_count'] as int? ?? 1,
      flameBulletBurnDamage: json['flame_bullet_burn_damage'] as double? ?? 0.0,
      frostBulletSlowFactor: json['frost_bullet_slow_factor'] as double? ?? 0.0,
      tornadoBulletKnockbackFactor:
          json['tornado_bullet_knockback_factor'] as double? ?? 0.0,
      lifeStealAmount: json['life_steal_amount'] as int? ?? 0,
    );
  }
}
