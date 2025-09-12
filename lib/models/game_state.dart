import 'general.dart';
import 'battle.dart';
import 'material.dart';

class GameState {
  final String playerId;
  final int currentChapter;
  final int currentSection;
  final List<General> generals;
  final List<Equipment> inventory;
  final List<MaterialStack> materials;
  final int coins;
  final Formation currentFormation;
  final List<String> unlockedChapters;
  final Map<String, dynamic> gameProgress;
  final PlayerStats playerStats;

  GameState({
    required this.playerId,
    this.currentChapter = 1,
    this.currentSection = 1,
    this.generals = const [],
    this.inventory = const [],
    this.materials = const [],
    this.coins = 1000,
    required this.currentFormation,
    this.unlockedChapters = const [],
    this.gameProgress = const {},
    required this.playerStats,
  });

  GameState copyWith({
    String? playerId,
    int? currentChapter,
    int? currentSection,
    List<General>? generals,
    List<Equipment>? inventory,
    List<MaterialStack>? materials,
    int? coins,
    Formation? currentFormation,
    List<String>? unlockedChapters,
    Map<String, dynamic>? gameProgress,
    PlayerStats? playerStats,
  }) {
    return GameState(
      playerId: playerId ?? this.playerId,
      currentChapter: currentChapter ?? this.currentChapter,
      currentSection: currentSection ?? this.currentSection,
      generals: generals ?? this.generals,
      inventory: inventory ?? this.inventory,
      materials: materials ?? this.materials,
      coins: coins ?? this.coins,
      currentFormation: currentFormation ?? this.currentFormation,
      unlockedChapters: unlockedChapters ?? this.unlockedChapters,
      gameProgress: gameProgress ?? this.gameProgress,
      playerStats: playerStats ?? this.playerStats,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'currentChapter': currentChapter,
      'currentSection': currentSection,
      'generals': generals.map((g) => g.toJson()).toList(),
      'inventory': inventory.map((e) => e.toJson()).toList(),
      'materials': materials.map((m) => m.toJson()).toList(),
      'coins': coins,
      'currentFormation': currentFormation.toJson(),
      'unlockedChapters': unlockedChapters,
      'gameProgress': gameProgress,
      'playerStats': playerStats.toJson(),
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      playerId: json['playerId'],
      currentChapter: json['currentChapter'] ?? 1,
      currentSection: json['currentSection'] ?? 1,
      generals: (json['generals'] as List? ?? [])
          .map((g) => General.fromJson(g))
          .toList(),
      inventory: (json['inventory'] as List? ?? [])
          .map((e) => Equipment.fromJson(e))
          .toList(),
      materials: (json['materials'] as List? ?? [])
          .map((m) => MaterialStack.fromJson(m))
          .toList(),
      coins: json['coins'] ?? 1000,
      currentFormation: FormationExtension.fromJson(json['currentFormation']),
      unlockedChapters: List<String>.from(json['unlockedChapters'] ?? []),
      gameProgress: Map<String, dynamic>.from(json['gameProgress'] ?? {}),
      playerStats: PlayerStats.fromJson(json['playerStats']),
    );
  }
}

class PlayerStats {
  final int level;
  final int experience;
  final int battlesWon;
  final int battlesLost;
  final int generalsRecruited;
  final int equipmentCollected;

  PlayerStats({
    this.level = 1,
    this.experience = 0,
    this.battlesWon = 0,
    this.battlesLost = 0,
    this.generalsRecruited = 0,
    this.equipmentCollected = 0,
  });

  PlayerStats copyWith({
    int? level,
    int? experience,
    int? battlesWon,
    int? battlesLost,
    int? generalsRecruited,
    int? equipmentCollected,
  }) {
    return PlayerStats(
      level: level ?? this.level,
      experience: experience ?? this.experience,
      battlesWon: battlesWon ?? this.battlesWon,
      battlesLost: battlesLost ?? this.battlesLost,
      generalsRecruited: generalsRecruited ?? this.generalsRecruited,
      equipmentCollected: equipmentCollected ?? this.equipmentCollected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'experience': experience,
      'battlesWon': battlesWon,
      'battlesLost': battlesLost,
      'generalsRecruited': generalsRecruited,
      'equipmentCollected': equipmentCollected,
    };
  }

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      level: json['level'] ?? 1,
      experience: json['experience'] ?? 0,
      battlesWon: json['battlesWon'] ?? 0,
      battlesLost: json['battlesLost'] ?? 0,
      generalsRecruited: json['generalsRecruited'] ?? 0,
      equipmentCollected: json['equipmentCollected'] ?? 0,
    );
  }
}

extension FormationExtension on Formation {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'positions': positions.map((p) => {
        'index': p.index,
        'name': p.name,
        'bonuses': p.bonuses,
      }).toList(),
      'bonuses': bonuses,
    };
  }

  static Formation fromJson(Map<String, dynamic> json) {
    return Formation(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      positions: (json['positions'] as List).map((p) => FormationPosition(
        index: p['index'],
        name: p['name'],
        bonuses: Map<String, double>.from(p['bonuses']),
      )).toList(),
      bonuses: Map<String, double>.from(json['bonuses']),
    );
  }
}