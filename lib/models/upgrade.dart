import 'dart:math';
import 'package:flutter/material.dart';

class Upgrade {
  String id; // Unique identifier
  String name; // Name
  String description; // Description
  IconData icon; // Icon
  String effect; // Effect type
  double value; // Effect value
  String rarity; // Rarity: common, uncommon, rare, epic, legendary
  int level; // Upgradeable times
  int maxLevel; // Maximum level
  bool
      isTechnique; // Whether it's a special technique rather than normal upgrade

  Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.effect,
    required this.value,
    this.rarity = 'common',
    this.level = 1,
    this.maxLevel = 5,
    this.isTechnique = false,
  });

  // Get upgrade quality color
  Color get rarityColor {
    switch (rarity) {
      case 'common':
        return Colors.grey;
      case 'uncommon':
        return Colors.green;
      case 'rare':
        return Colors.blue;
      case 'epic':
        return Colors.purple;
      case 'legendary':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Get upgrade description (including level info)
  String get fullDescription {
    if (level > 1) {
      return '$description (Level $level/$maxLevel)';
    }
    return description;
  }

  // Get next level effect value
  double get nextLevelValue {
    if (level >= maxLevel) return value;

    // Different growth curves for different effects
    switch (effect) {
      case 'bolt_damage':
      case 'fire_rate':
      case 'multi_shot':
        return value * 1.5; // Damage multiplier increases by 50% per level
      case 'max_health':
      case 'health_regen':
      case 'enlightenment_gain':
      case 'cultivation_gain':
        return value *
            1.3; // Health and experience multiplier increases by 30% per level
      default:
        return value * 1.2;
    }
  }

  // Create upgrade copy with increased level
  Upgrade upgrade() {
    if (level >= maxLevel) return this;

    return Upgrade(
      id: id,
      name: name,
      description: description,
      icon: icon,
      effect: effect,
      value: nextLevelValue,
      rarity: rarity,
      level: level + 1,
      maxLevel: maxLevel,
      isTechnique: isTechnique,
    );
  }

  // Generate random upgrade options
  static List<Upgrade> generateUpgradeOptions(
    List<String> currentBullets,
    int playerLevel,
    List<String> acquiredUpgrades,
  ) {
    final List<Upgrade> allUpgrades = _getAllPossibleUpgrades(currentBullets);
    final random = Random();
    final List<Upgrade> availableUpgrades = [];

    // Adjust probability of different rarity upgrades based on player level
    final double legendaryChance = min(0.05 + playerLevel * 0.003, 0.2);
    final double epicChance = min(0.1 + playerLevel * 0.005, 0.3);
    final double rareChance = min(0.2 + playerLevel * 0.008, 0.4);
    final double uncommonChance = min(0.4 + playerLevel * 0.01, 0.6);

    // Check player health status, increase healing chance if below 50%
    final bool needsHealing = false; // Get this value from GameState

    // Set of acquired upgrade IDs
    final acquiredUpgradeIds = Set<String>.from(acquiredUpgrades);

    // Filter available upgrade options
    for (final upgrade in allUpgrades) {
      // Skip upgrades that have reached maximum level
      if (acquiredUpgradeIds.contains(upgrade.id) &&
          upgrade.level >= upgrade.maxLevel) {
        continue;
      }

      // For bullet unlock upgrades, check if already owned
      if (upgrade.effect == 'unlock_bullet') {
        final bulletTypes = ['flame', 'frost', 'spirit', 'tornado'];
        final index = upgrade.value.toInt();
        if (index >= 0 && index < bulletTypes.length) {
          final bulletType = bulletTypes[index];
          if (currentBullets.contains(bulletType)) {
            continue; // Already owns this bullet type, skip
          }
        }
      }

      // Filter based on rarity and level
      final double rarityRoll = random.nextDouble();
      bool passRarityCheck = false;

      switch (upgrade.rarity) {
        case 'legendary':
          passRarityCheck = rarityRoll < legendaryChance;
          break;
        case 'epic':
          passRarityCheck = rarityRoll < epicChance;
          break;
        case 'rare':
          passRarityCheck = rarityRoll < rareChance;
          break;
        case 'uncommon':
          passRarityCheck = rarityRoll < uncommonChance;
          break;
        default: // common
          passRarityCheck = true;
          break;
      }

      // Pass rarity check and not an owned technique type upgrade
      if (passRarityCheck &&
          !(upgrade.isTechnique && acquiredUpgradeIds.contains(upgrade.id))) {
        // If it's an owned upgradeable item, create next level version
        if (acquiredUpgradeIds.contains(upgrade.id)) {
          final nextLevelUpgrade = upgrade.upgrade();
          availableUpgrades.add(nextLevelUpgrade);
        } else {
          availableUpgrades.add(upgrade);
        }
      }
    }

    // If healing is needed, increase weight of healing options
    if (needsHealing) {
      final healingUpgrades = availableUpgrades
          .where(
              (u) => u.effect == 'instant_health' || u.effect == 'health_regen')
          .toList();

      // Add repeatedly to increase weight
      availableUpgrades.addAll(healingUpgrades);
    }

    // Randomly select three non-duplicate upgrade options
    final selectedUpgrades = <Upgrade>[];
    while (selectedUpgrades.length < 3 && availableUpgrades.isNotEmpty) {
      final index = random.nextInt(availableUpgrades.length);
      selectedUpgrades.add(availableUpgrades[index]);

      // Remove selected upgrade and other upgrades with same ID (avoid selecting different levels of same upgrade)
      availableUpgrades.removeWhere((u) => u.id == availableUpgrades[index].id);
    }

    // If available upgrades are less than three, fill with default options
    while (selectedUpgrades.length < 3) {
      selectedUpgrades.add(Upgrade(
        id: 'health_small',
        name: 'Spirit Energy',
        description: 'Recovers 10 spirit power',
        icon: Icons.healing,
        effect: 'instant_health',
        value: 10,
        rarity: 'common',
      ));
    }

    return selectedUpgrades;
  }

  // Get all possible upgrades
  static List<Upgrade> _getAllPossibleUpgrades(List<String> currentBullets) {
    List<Upgrade> upgrades = [];

    // Basic upgrades
    upgrades.addAll([
      Upgrade(
        id: 'bolt_damage',
        name: 'Lightning Enhancement',
        description: 'Increases lightning spell damage',
        icon: Icons.flash_on,
        effect: 'bolt_damage',
        value: 1.5,
        rarity: 'common',
      ),
      Upgrade(
        id: 'fire_rate',
        name: 'Spell Haste',
        description: 'Increases spell casting speed',
        icon: Icons.speed,
        effect: 'fire_rate',
        value: 1.3,
        rarity: 'common',
      ),
      Upgrade(
        id: 'max_health',
        name: 'Spirit Power Enhancement',
        description: 'Increases maximum spirit power',
        icon: Icons.favorite,
        effect: 'max_health',
        value: 20,
        rarity: 'common',
      ),
      Upgrade(
        id: 'health_regen',
        name: 'Spirit Recovery',
        description: 'Gradually recovers spirit power',
        icon: Icons.healing,
        effect: 'health_regen',
        value: 2,
        rarity: 'uncommon',
      ),
    ]);

    // New bullet types (only if not owned)
    if (!currentBullets.contains('flame')) {
      upgrades.add(Upgrade(
        id: 'unlock_flame',
        name: 'Flame Technique',
        description: 'Unlocks flame spells with burning effect',
        icon: Icons.local_fire_department,
        effect: 'unlock_bullet',
        value: 0, // flame
        rarity: 'rare',
        isTechnique: true,
      ));
    }

    if (!currentBullets.contains('frost')) {
      upgrades.add(Upgrade(
        id: 'unlock_frost',
        name: 'Frost Technique',
        description: 'Unlocks frost spells that slow enemies',
        icon: Icons.ac_unit,
        effect: 'unlock_bullet',
        value: 1, // frost
        rarity: 'rare',
        isTechnique: true,
      ));
    }

    if (!currentBullets.contains('spirit')) {
      upgrades.add(Upgrade(
        id: 'unlock_spirit',
        name: 'Spirit Energy Technique',
        description: 'Unlocks spirit energy that penetrates enemies',
        icon: Icons.auto_awesome,
        effect: 'unlock_bullet',
        value: 2, // spirit
        rarity: 'epic',
        isTechnique: true,
      ));
    }

    if (!currentBullets.contains('tornado')) {
      upgrades.add(Upgrade(
        id: 'unlock_tornado',
        name: 'Storm Technique',
        description: 'Unlocks storm spells that knock back enemies',
        icon: Icons.tornado,
        effect: 'unlock_bullet',
        value: 3, // tornado
        rarity: 'epic',
        isTechnique: true,
      ));
    }

    // Advanced upgrades
    upgrades.addAll([
      Upgrade(
        id: 'multi_shot',
        name: 'Multi-cast',
        description: 'Casts multiple spells at once',
        icon: Icons.scatter_plot,
        effect: 'multi_shot',
        value: 2,
        rarity: 'epic',
      ),
      Upgrade(
        id: 'damage_reflect',
        name: 'Spirit Shield',
        description: 'Reflects part of damage back to enemies',
        icon: Icons.shield,
        effect: 'damage_reflect',
        value: 0.3,
        rarity: 'rare',
      ),
      Upgrade(
        id: 'enlightenment_gain',
        name: 'Enlightenment Acceleration',
        description: 'Increases enlightenment progress gain',
        icon: Icons.psychology,
        effect: 'enlightenment_gain',
        value: 1.5,
        rarity: 'uncommon',
      ),
      Upgrade(
        id: 'cultivation_gain',
        name: 'Cultivation Acceleration',
        description: 'Increases cultivation experience gain',
        icon: Icons.trending_up,
        effect: 'cultivation_gain',
        value: 1.5,
        rarity: 'uncommon',
      ),
      Upgrade(
        id: 'instant_health',
        name: 'Instant Recovery',
        description: 'Immediately restores spirit power',
        icon: Icons.medical_services,
        effect: 'instant_health',
        value: 50,
        rarity: 'rare',
      ),
    ]);

    return upgrades;
  }

  // Convert upgrade options to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_code': icon.codePoint,
      'icon_font': icon.fontFamily,
      'effect': effect,
      'value': value,
      'rarity': rarity,
      'level': level,
      'max_level': maxLevel,
      'is_technique': isTechnique,
    };
  }

  // Create upgrade options from JSON
  factory Upgrade.fromJson(Map<String, dynamic> json) {
    return Upgrade(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: IconData(
        json['icon_code'] as int,
        fontFamily: json['icon_font'] as String?,
      ),
      effect: json['effect'] as String,
      value: json['value'] as double,
      rarity: json['rarity'] as String? ?? 'common',
      level: json['level'] as int? ?? 1,
      maxLevel: json['max_level'] as int? ?? 3,
      isTechnique: json['is_technique'] as bool? ?? false,
    );
  }
}
