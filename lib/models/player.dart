import '../utils/game_utils.dart';

class Player {
  int health; // Spirit power
  int maxHealth; // Maximum spirit power
  int cultivationLevel; // Cultivation level
  int wave; // Current tribulation
  int maxWave; // Maximum tribulation
  double enlightenmentProgress; // Enlightenment progress
  List<String> bullets; // Owned bullet types
  String characterAsset; // Character image path

  // New properties
  String cultivationRealm; // Cultivation realm
  List<String> passiveSkills; // Passive skills
  Map<String, int> skillLevels; // Skill levels

  // Combo system
  int comboCount; // Combo count
  int comboTimer; // Combo timer
  double comboMultiplier; // Combo multiplier

  // Statistics
  int totalEnemiesDefeated; // Total enemies defeated
  int totalBosses; // Total bosses defeated
  int highestCombo; // Highest combo

  Player({
    this.health = 100,
    this.maxHealth = 100,
    this.cultivationLevel = 1,
    this.wave = 1,
    this.maxWave = 1, // Initial max wave is 1, allows infinite progression
    this.enlightenmentProgress = 0.0,
    this.bullets = const ['bolt'],
    this.characterAsset = 'assets/images/characters/character_1.png',
    String? cultivationRealm,
    List<String>? passiveSkills,
    Map<String, int>? skillLevels,
    this.comboCount = 0,
    this.comboTimer = 0,
    this.comboMultiplier = 1.0,
    this.totalEnemiesDefeated = 0,
    this.totalBosses = 0,
    this.highestCombo = 0,
  })  : cultivationRealm = cultivationRealm ?? 'Qi Refining',
        passiveSkills = passiveSkills ?? [],
        skillLevels = skillLevels ?? {};

  // Whether spirit power is depleted
  bool get isDead => health <= 0;

  // Whether upgrade is possible
  bool get canLevelUp => enlightenmentProgress >= 100.0;

  // Get current cultivation realm
  String getCultivationRealm() {
    if (cultivationLevel < 10) {
      return 'Qi Refining';
    } else if (cultivationLevel < 25) {
      return 'Foundation Establishment';
    } else if (cultivationLevel < 50) {
      return 'Core Formation';
    } else if (cultivationLevel < 100) {
      return 'Nascent Soul';
    } else if (cultivationLevel < 200) {
      return 'Soul Transformation';
    } else if (cultivationLevel < 400) {
      return 'Void Refinement';
    } else if (cultivationLevel < 800) {
      return 'Body Integration';
    } else if (cultivationLevel < 1600) {
      return 'Tribulation Transcendence';
    }
    return 'Immortal';
  }

  // Update cultivation realm
  void updateCultivationRealm() {
    final newRealm = getCultivationRealm();
    if (newRealm != cultivationRealm) {
      cultivationRealm = newRealm;
      // When breaking through realms, new passive skills can be unlocked
      _unlockRealmSkills(newRealm);
    }
  }

  // Unlock realm-corresponding passive skills
  void _unlockRealmSkills(String realm) {
    switch (realm) {
      case 'Foundation Establishment':
        addPassiveSkill('Spirit Recovery');
        break;
      case 'Core Formation':
        addPassiveSkill('Spirit Shield');
        break;
      case 'Nascent Soul':
        addPassiveSkill('Spirit Sensing');
        break;
      case 'Soul Transformation':
        addPassiveSkill('Five Elements Harmony');
        break;
      case 'Void Refinement':
        addPassiveSkill('Heaven Earth Resonance');
        break;
      case 'Body Integration':
        addPassiveSkill('Supreme Sword Intent');
        break;
      case 'Tribulation Transcendence':
        addPassiveSkill('Immortal Golden Body');
        break;
    }
  }

  // Add passive skill
  void addPassiveSkill(String skill) {
    if (!passiveSkills.contains(skill)) {
      passiveSkills.add(skill);
      skillLevels[skill] = 1;
    }
  }

  // Upgrade passive skill level
  void upgradePassiveSkill(String skill) {
    if (passiveSkills.contains(skill)) {
      skillLevels[skill] = (skillLevels[skill] ?? 1) + 1;
    }
  }

  // Get passive skill level
  int getPassiveSkillLevel(String skill) {
    return skillLevels[skill] ?? 0;
  }

  // Update combo system
  void updateCombo(int deltaTime) {
    comboTimer -= deltaTime;
    if (comboTimer <= 0) {
      // Combo interrupted
      resetCombo();
    }
  }

  // Increase combo
  void increaseCombo() {
    comboCount++;
    if (comboCount > highestCombo) {
      highestCombo = comboCount;
    }

    // Reset combo timer
    comboTimer = 3000; // 3 seconds

    // Calculate combo multiplier (with upper limit)
    comboMultiplier = (1.0 + (comboCount * 0.1)).clamp(1.0, 3.0);
  }

  // Reset combo
  void resetCombo() {
    comboCount = 0;
    comboTimer = 0;
    comboMultiplier = 1.0;
  }

  // Increase cultivation value
  void increaseCultivation(int amount) {
    // Apply combo multiplier
    final bonusAmount = (amount * comboMultiplier).round();
    cultivationLevel += bonusAmount;
    updateCultivationRealm();
  }

  // Increase enlightenment progress
  void increaseEnlightenment(double amount) {
    // Apply combo multiplier
    final bonusAmount = amount * comboMultiplier;
    enlightenmentProgress += bonusAmount;
  }

  // Reset enlightenment progress (after leveling up)
  void resetEnlightenmentProgress() {
    enlightenmentProgress = 0.0;
  }

  // Take damage
  void takeDamage(int damage) {
    // Check if has spirit shield skill
    if (passiveSkills.contains('Spirit Shield')) {
      final shieldLevel = getPassiveSkillLevel('Spirit Shield');
      final damageReduction =
          shieldLevel * 0.05; // 5% damage reduction per level
      final reducedDamage = (damage * (1.0 - damageReduction)).round();
      health = (health - reducedDamage).clamp(0, maxHealth);
    } else {
      health = (health - damage).clamp(0, maxHealth);
    }

    // Reset combo when taking damage
    resetCombo();
  }

  // Heal
  void heal(int amount) {
    health = (health + amount).clamp(0, maxHealth);
  }

  // Increase maximum health
  void increaseMaxHealth(int amount) {
    maxHealth += amount;
    health = (health + amount).clamp(0, maxHealth);
  }

  // Add enemy defeat count
  void addEnemyDefeat(bool isBoss) {
    totalEnemiesDefeated++;
    if (isBoss) {
      totalBosses++;
    }
    increaseCombo();
  }

  // Add new bullet type
  void addBulletType(String bulletType) {
    if (!bullets.contains(bulletType)) {
      bullets.add(bulletType);
    }
  }

  // Enter next tribulation
  void nextWave() {
    wave++;
    if (wave > maxWave) {
      maxWave = wave;
    }
  }

  // Convert player data to JSON
  Map<String, dynamic> toJson() {
    return {
      'health': health,
      'maxHealth': maxHealth,
      'cultivationLevel': cultivationLevel,
      'wave': wave,
      'maxWave': maxWave,
      'enlightenmentProgress': enlightenmentProgress,
      'bullets': bullets,
      'characterAsset': characterAsset,
      'cultivationRealm': cultivationRealm,
      'passiveSkills': passiveSkills,
      'skillLevels': skillLevels,
      'comboCount': comboCount,
      'comboTimer': comboTimer,
      'comboMultiplier': comboMultiplier,
      'totalEnemiesDefeated': totalEnemiesDefeated,
      'totalBosses': totalBosses,
      'highestCombo': highestCombo,
    };
  }

  // Create player from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      health: json['health'] ?? 100,
      maxHealth: json['maxHealth'] ?? 100,
      cultivationLevel: json['cultivationLevel'] ?? 1,
      wave: json['wave'] ?? 1,
      maxWave: json['maxWave'] ?? 1,
      enlightenmentProgress: json['enlightenmentProgress']?.toDouble() ?? 0.0,
      bullets: List<String>.from(json['bullets'] ?? ['bolt']),
      characterAsset:
          json['characterAsset'] ?? 'assets/images/characters/character_1.png',
      cultivationRealm: json['cultivationRealm'] ?? 'Qi Refining',
      passiveSkills: List<String>.from(json['passiveSkills'] ?? []),
      skillLevels: Map<String, int>.from(json['skillLevels'] ?? {}),
      comboCount: json['comboCount'] ?? 0,
      comboTimer: json['comboTimer'] ?? 0,
      comboMultiplier: json['comboMultiplier']?.toDouble() ?? 1.0,
      totalEnemiesDefeated: json['totalEnemiesDefeated'] ?? 0,
      totalBosses: json['totalBosses'] ?? 0,
      highestCombo: json['highestCombo'] ?? 0,
    );
  }

  // Helper functions
  Player copyWith({
    int? health,
    int? maxHealth,
    int? cultivationLevel,
    int? wave,
    int? maxWave,
    double? enlightenmentProgress,
    List<String>? bullets,
    String? characterAsset,
    String? cultivationRealm,
    List<String>? passiveSkills,
    Map<String, int>? skillLevels,
    int? comboCount,
    int? comboTimer,
    double? comboMultiplier,
    int? totalEnemiesDefeated,
    int? totalBosses,
    int? highestCombo,
  }) {
    return Player(
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      cultivationLevel: cultivationLevel ?? this.cultivationLevel,
      wave: wave ?? this.wave,
      maxWave: maxWave ?? this.maxWave,
      enlightenmentProgress:
          enlightenmentProgress ?? this.enlightenmentProgress,
      bullets: bullets ?? List.from(this.bullets),
      characterAsset: characterAsset ?? this.characterAsset,
      cultivationRealm: cultivationRealm ?? this.cultivationRealm,
      passiveSkills: passiveSkills ?? List.from(this.passiveSkills),
      skillLevels: skillLevels ?? Map.from(this.skillLevels),
      comboCount: comboCount ?? this.comboCount,
      comboTimer: comboTimer ?? this.comboTimer,
      comboMultiplier: comboMultiplier ?? this.comboMultiplier,
      totalEnemiesDefeated: totalEnemiesDefeated ?? this.totalEnemiesDefeated,
      totalBosses: totalBosses ?? this.totalBosses,
      highestCombo: highestCombo ?? this.highestCombo,
    );
  }
}

// 輔助函數
int min(int a, int b) {
  return a < b ? a : b;
}

double minDouble(double a, double b) {
  return a < b ? a : b;
}
