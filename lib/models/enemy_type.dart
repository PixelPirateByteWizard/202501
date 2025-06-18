import 'package:flutter/material.dart';

class EnemyType {
  final String name;
  final double baseSpeed;
  final Color color;
  final IconData icon;
  final String behavior; // 'scavenger', 'charger', 'standard'
  final int baseBlades;

  const EnemyType({
    required this.name,
    required this.baseSpeed,
    required this.color,
    required this.icon,
    required this.behavior,
    required this.baseBlades,
  });

  static const EnemyType scout = EnemyType(
    name: 'Scout',
    baseSpeed: 2.8,
    color: Color(0xFF22d3ee), // cyan-400
    icon: Icons.directions_run,
    behavior: 'scavenger',
    baseBlades: 3,
  );

  static const EnemyType brute = EnemyType(
    name: 'Brute',
    baseSpeed: 1.2,
    color: Color(0xFFa855f7), // purple-500
    icon: Icons.shield,
    behavior: 'standard',
    baseBlades: 18,
  );

  static const EnemyType hunter = EnemyType(
    name: 'Hunter',
    baseSpeed: 2.2,
    color: Color(0xFFf97316), // orange-500
    icon: Icons.flash_on,
    behavior: 'charger',
    baseBlades: 8,
  );

  static const EnemyType assassin = EnemyType(
    name: 'Assassin',
    baseSpeed: 3.2,
    color: Color(0xFFdc2626), // red-600
    icon: Icons.flash_auto,
    behavior: 'charger',
    baseBlades: 12,
  );

  static const EnemyType titan = EnemyType(
    name: 'Titan',
    baseSpeed: 0.8,
    color: Color(0xFF7c3aed), // violet-600
    icon: Icons.auto_awesome,
    behavior: 'standard',
    baseBlades: 25,
  );

  static List<EnemyType> get allTypes =>
      [scout, brute, hunter, assassin, titan];
}
