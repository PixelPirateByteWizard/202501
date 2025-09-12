import 'general.dart';

class Battle {
  final String id;
  final String name;
  final String description;
  final List<BattleUnit> playerUnits;
  final List<BattleUnit> enemyUnits;
  final int currentTurn;
  final BattlePhase phase;
  final List<BattleLog> logs;
  final Formation playerFormation;
  final Formation enemyFormation;

  Battle({
    required this.id,
    required this.name,
    required this.description,
    required this.playerUnits,
    required this.enemyUnits,
    this.currentTurn = 1,
    this.phase = BattlePhase.preparation,
    this.logs = const [],
    required this.playerFormation,
    required this.enemyFormation,
  });

  Battle copyWith({
    String? id,
    String? name,
    String? description,
    List<BattleUnit>? playerUnits,
    List<BattleUnit>? enemyUnits,
    int? currentTurn,
    BattlePhase? phase,
    List<BattleLog>? logs,
    Formation? playerFormation,
    Formation? enemyFormation,
  }) {
    return Battle(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      playerUnits: playerUnits ?? this.playerUnits,
      enemyUnits: enemyUnits ?? this.enemyUnits,
      currentTurn: currentTurn ?? this.currentTurn,
      phase: phase ?? this.phase,
      logs: logs ?? this.logs,
      playerFormation: playerFormation ?? this.playerFormation,
      enemyFormation: enemyFormation ?? this.enemyFormation,
    );
  }
}

class BattleUnit {
  final General general;
  final int currentTroops;
  final int maxTroops;
  final List<StatusEffect> statusEffects;
  final int position; // 0-8 阵型位置
  final bool isPlayer;

  BattleUnit({
    required this.general,
    required this.currentTroops,
    required this.maxTroops,
    this.statusEffects = const [],
    required this.position,
    required this.isPlayer,
  });

  BattleUnit copyWith({
    General? general,
    int? currentTroops,
    int? maxTroops,
    List<StatusEffect>? statusEffects,
    int? position,
    bool? isPlayer,
  }) {
    return BattleUnit(
      general: general ?? this.general,
      currentTroops: currentTroops ?? this.currentTroops,
      maxTroops: maxTroops ?? this.maxTroops,
      statusEffects: statusEffects ?? this.statusEffects,
      position: position ?? this.position,
      isPlayer: isPlayer ?? this.isPlayer,
    );
  }

  double get troopsPercentage => currentTroops / maxTroops;
  bool get isAlive => currentTroops > 0;
}

class StatusEffect {
  final String id;
  final String name;
  final String description;
  final StatusEffectType type;
  final int duration;
  final Map<String, dynamic> effects;

  StatusEffect({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.duration,
    required this.effects,
  });

  StatusEffect copyWith({
    String? id,
    String? name,
    String? description,
    StatusEffectType? type,
    int? duration,
    Map<String, dynamic>? effects,
  }) {
    return StatusEffect(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      effects: effects ?? this.effects,
    );
  }
}

enum StatusEffectType {
  buff,
  debuff,
  neutral,
}

class BattleLog {
  final String id;
  final String message;
  final BattleLogType type;
  final DateTime timestamp;
  final String? unitId;

  BattleLog({
    required this.id,
    required this.message,
    required this.type,
    required this.timestamp,
    this.unitId,
  });
}

enum BattleLogType {
  attack,
  skill,
  damage,
  heal,
  statusEffect,
  turnStart,
  victory,
  defeat,
  info,
}

enum BattlePhase {
  preparation,
  combat,
  victory,
  defeat,
}

class Formation {
  final String id;
  final String name;
  final String description;
  final List<FormationPosition> positions;
  final Map<String, double> bonuses;

  Formation({
    required this.id,
    required this.name,
    required this.description,
    required this.positions,
    required this.bonuses,
  });
}

class FormationPosition {
  final int index; // 0-8
  final String name; // 前锋、中军、大营等
  final Map<String, double> bonuses;

  FormationPosition({
    required this.index,
    required this.name,
    required this.bonuses,
  });
}