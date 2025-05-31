import 'dart:math';
import 'package:flutter/material.dart';

// Position class for tracking object positions in the game
class Position {
  double x;
  double y;

  Position({required this.x, required this.y});

  // Calculate distance to another position
  double distanceTo(Position other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }

  // Move towards target position by specified distance
  void moveTowards(Position target, double distance) {
    final directionX = target.x - x;
    final directionY = target.y - y;
    final magnitude = sqrt(directionX * directionX + directionY * directionY);

    if (magnitude <= distance) {
      x = target.x;
      y = target.y;
    } else {
      x += (directionX / magnitude) * distance;
      y += (directionY / magnitude) * distance;
    }
  }

  // Convert position to Offset (for drawing)
  Offset toOffset() => Offset(x, y);

  // Create a copy
  Position copy() => Position(x: x, y: y);

  // Create position from JSON
  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      x: json['x'] as double,
      y: json['y'] as double,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }
}

// Generate random position (at screen edge)
Position generateRandomEnemyPosition(Size screenSize) {
  final random = Random();
  final side = random.nextInt(4); // 0=top, 1=right, 2=bottom, 3=left

  switch (side) {
    case 0: // Top
      return Position(
        x: random.nextDouble() * screenSize.width,
        y: 0,
      );
    case 1: // Right
      return Position(
        x: screenSize.width,
        y: random.nextDouble() * screenSize.height,
      );
    case 2: // Bottom
      return Position(
        x: random.nextDouble() * screenSize.width,
        y: screenSize.height,
      );
    case 3: // Left
      return Position(
        x: 0,
        y: random.nextDouble() * screenSize.height,
      );
    default:
      return Position(x: 0, y: 0);
  }
}

// Constants definition
class GameConstants {
  static const double characterSize = 60.0;
  static const double enemySize = 40.0;
  static const double bulletSize = 20.0;

  // Adjust base enemy speed and bullet speed to optimize game pacing
  static const double baseEnemySpeed = 1.2;
  static const double bulletSpeed = 6.0;

  static const int baseEnemyHealth = 20;
  static const int baseEnemyDamage = 10;
  static const int baseBulletDamage = 12;

  // Increase base rewards to accelerate early game progression
  static const int baseCultivationReward = 15;
  static const double baseEnlightenmentGain = 0.12;

  // Shorten enemy spawn intervals to increase game tension
  static const Duration enemySpawnInterval = Duration(milliseconds: 1800);
  static const Duration bulletFireInterval = Duration(milliseconds: 450);
  static const Duration gameTickInterval =
      Duration(milliseconds: 16); // ~60 FPS

  // Add combo system constants
  static const int comboTimeWindow = 3000; // Combo window (milliseconds)
  static const double comboMultiplierMax =
      2.0; // Maximum combo reward multiplier

  // Level difficulty pacing control
  static const int bossWaveInterval = 5; // Boss appears every 5 waves
  static const double waveScalingFactor = 0.15; // Difficulty increase per wave
  // No maximum wave limit, allowing infinite gameplay
  // static const int maxWaves = 30; // Maximum waves (full game length)

  // Knockback effect
  static const double knockbackForce = 25.0; // Knockback force

  // Infinite mode difficulty adjustment
  static const double advancedWaveScalingBonus =
      0.02; // After wave 20, each wave adds 2% extra difficulty
}

// Enemy type definitions
enum EnemyType {
  ghostFiend, // Ghost Demon
  demonBeast, // Demon Beast
  evilCultist, // Evil Cultivator
  undeadSoul, // Undead Soul
  bossFiend // Demon Lord
}

// Bullet type definitions
enum BulletType {
  bolt, // Lightning
  flame, // Fire
  frost, // Ice
  spirit, // Spirit Energy
  tornado // Storm
}

// Get icon from BulletType
IconData getBulletIcon(BulletType type) {
  switch (type) {
    case BulletType.bolt:
      return Icons.bolt;
    case BulletType.flame:
      return Icons.local_fire_department;
    case BulletType.frost:
      return Icons.ac_unit;
    case BulletType.spirit:
      return Icons.brightness_high;
    case BulletType.tornado:
      return Icons.air;
  }
}

// Get color from BulletType
Color getBulletColor(BulletType type) {
  switch (type) {
    case BulletType.bolt:
      return Colors.amber;
    case BulletType.flame:
      return Colors.deepOrange;
    case BulletType.frost:
      return Colors.lightBlue;
    case BulletType.spirit:
      return Colors.purple;
    case BulletType.tornado:
      return Colors.teal;
  }
}

// Get icon from EnemyType
IconData getEnemyIcon(EnemyType type) {
  switch (type) {
    case EnemyType.ghostFiend:
      return Icons.face;
    case EnemyType.demonBeast:
      return Icons.pest_control;
    case EnemyType.evilCultist:
      return Icons.person;
    case EnemyType.undeadSoul:
      return Icons.warning;
    case EnemyType.bossFiend:
      return Icons.whatshot;
  }
}

// Get BulletType from string
BulletType bulletTypeFromString(String type) {
  switch (type) {
    case 'bolt':
      return BulletType.bolt;
    case 'flame':
      return BulletType.flame;
    case 'frost':
      return BulletType.frost;
    case 'spirit':
      return BulletType.spirit;
    case 'tornado':
      return BulletType.tornado;
    default:
      return BulletType.bolt;
  }
}

// Get EnemyType from string
EnemyType enemyTypeFromString(String type) {
  switch (type) {
    case 'ghostFiend':
      return EnemyType.ghostFiend;
    case 'demonBeast':
      return EnemyType.demonBeast;
    case 'evilCultist':
      return EnemyType.evilCultist;
    case 'undeadSoul':
      return EnemyType.undeadSoul;
    case 'bossFiend':
      return EnemyType.bossFiend;
    default:
      return EnemyType.ghostFiend;
  }
}

// Add enemy trait acquisition functions
Map<String, dynamic> getEnemyTraits(EnemyType type) {
  switch (type) {
    case EnemyType.ghostFiend:
      return {
        'name': 'Ghost Demon',
        'description': 'Fast movement but fragile',
        'specialty': 'dodge', // Has chance to dodge attacks
        'specialtyChance': 0.2, // 20% chance to trigger trait
      };
    case EnemyType.demonBeast:
      return {
        'name': 'Demon Beast',
        'description': 'Strong but slow',
        'specialty': 'armor', // Reduces damage taken
        'specialtyChance': 0.3, // 30% damage reduction
      };
    case EnemyType.evilCultist:
      return {
        'name': 'Evil Cultivator',
        'description': 'Can summon phantom clones',
        'specialty': 'summon', // Has chance to summon phantoms when damaged
        'specialtyChance': 0.15, // 15% chance to summon phantom
      };
    case EnemyType.undeadSoul:
      return {
        'name': 'Undead Soul',
        'description': 'Can phase through attacks',
        'specialty': 'phase', // Brief invincibility state
        'specialtyChance': 0.25, // 25% chance to trigger brief invincibility
      };
    case EnemyType.bossFiend:
      return {
        'name': 'Demon Lord',
        'description': 'Powerful with multiple abilities',
        'specialty': 'rage', // Increases damage when health is low
        'specialtyChance': 0.5, // 50% damage increase when health below half
      };
  }
}

// Bullet type special effects
Map<String, dynamic> getBulletEffects(BulletType type) {
  switch (type) {
    case BulletType.bolt:
      return {
        'name': 'Lightning',
        'effect': 'stun', // Stun effect
        'effectChance': 0.3, // 30% chance to trigger stun
        'effectDuration': 1000, // Stun lasts 1 second
      };
    case BulletType.flame:
      return {
        'name': 'Fire',
        'effect': 'burn', // Burn effect
        'effectChance': 0.5, // 50% chance to trigger burn
        'effectDuration': 3000, // Burn lasts 3 seconds
        'effectDamage': 3, // 3 burn damage per second
      };
    case BulletType.frost:
      return {
        'name': 'Ice',
        'effect': 'slow', // Slow effect
        'effectChance': 0.7, // 70% chance to trigger slow
        'effectDuration': 2000, // Slow lasts 2 seconds
        'effectFactor': 0.5, // Movement speed reduced to 50%
      };
    case BulletType.spirit:
      return {
        'name': 'Spirit Energy',
        'effect': 'pierce', // Pierce effect
        'effectChance': 1.0, // 100% pierce
        'pierceCount': 2, // Can pierce 2 enemies
      };
    case BulletType.tornado:
      return {
        'name': 'Storm',
        'effect': 'knockback', // Knockback effect
        'effectChance': 0.8, // 80% chance to trigger knockback
        'knockbackForce': 30.0, // Knockback force
      };
  }
}

// Cultivation level
enum CultivationLevel {
  mortal, // Mortal
  qi, // Qi Period
  foundation, // Foundation Period
  core, // Core Period
  nascent, // Nascent Period
  soul, // Soul Period
  divinity, // Divinity Period
  ascension, // Ascension Period
  immortal, // Immortal Period
}

// Get CultivationLevel from string
CultivationLevel cultivationLevelFromString(String level) {
  switch (level.toLowerCase()) {
    case 'qi':
      return CultivationLevel.qi;
    case 'foundation':
      return CultivationLevel.foundation;
    case 'core':
      return CultivationLevel.core;
    case 'nascent':
      return CultivationLevel.nascent;
    case 'soul':
      return CultivationLevel.soul;
    case 'divinity':
      return CultivationLevel.divinity;
    case 'ascension':
      return CultivationLevel.ascension;
    case 'immortal':
      return CultivationLevel.immortal;
    default:
      return CultivationLevel.mortal;
  }
}
