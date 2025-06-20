import 'package:flutter/material.dart';
import 'enemy_type.dart';

class Character {
  String id;
  Offset pos;
  int bladeCount;
  bool isActive = true;
  EnemyType? type; // null indicates player
  String name;

  // AI-related state
  bool isCharging = false;
  DateTime chargeEndTime = DateTime.now();
  DateTime lastClashTime = DateTime.now();
  Offset moveVector = Offset.zero;

  // Player dash functionality
  bool isDashing = false;
  DateTime dashEndTime = DateTime.now();
  DateTime lastDashTime = DateTime.now();
  static const Duration dashDuration = Duration(milliseconds: 300);
  static const Duration dashCooldown = Duration(seconds: 2);

  Character({
    required this.id,
    required this.pos,
    required this.bladeCount,
    this.type,
    String? customName,
  }) : name = customName ?? (type?.name ?? 'You');

  // Dynamic calculated properties
  double get speed => type?.baseSpeed ?? 3.0;

  double get bladesRadius => (30 + bladeCount * 1.2).clamp(30.0, 250.0);

  double get fullRadius => bladesRadius + 20.0; // Used for collision detection

  Color get color => type?.color ?? Colors.yellow;

  IconData get icon => type?.icon ?? Icons.person;

  String get behavior => type?.behavior ?? 'player';

  // Blade visual styling based on count
  BladeStyle get bladeStyle {
    if (bladeCount >= 100) {
      return const BladeStyle(
        color: Color(0xFFef4444), // red-500
        size: 32.0,
        labelColor: Color(0xFFdc2626), // red-600
      );
    }
    if (bladeCount >= 10) {
      return const BladeStyle(
        color: Color(0xFF4ade80), // green-400
        size: 24.0,
        labelColor: Color(0xFF16a34a), // green-600
      );
    }
    return const BladeStyle(
      color: Colors.white,
      size: 16.0,
      labelColor: Color(0xFF6b7280), // gray-500
    );
  }

  void takeClashDamage() {
    if (bladeCount > 0) {
      bladeCount--;
    }
    if (bladeCount <= 0) {
      isActive = false;
    }
    lastClashTime = DateTime.now();
  }

  void addBlade() {
    bladeCount++;
  }

  bool canClash() {
    final now = DateTime.now();
    return now.difference(lastClashTime).inMilliseconds > 200; // 200ms cooldown
  }

  void startCharging() {
    isCharging = true;
    chargeEndTime = DateTime.now().add(const Duration(milliseconds: 500));
  }

  void updateCharging() {
    if (isCharging && DateTime.now().isAfter(chargeEndTime)) {
      isCharging = false;
    }
    if (isDashing && DateTime.now().isAfter(dashEndTime)) {
      isDashing = false;
    }
  }

  double get currentSpeed {
    if (isDashing) {
      return speed * 5.0; // Dash speed multiplier (higher than charge)
    }
    if (isCharging) {
      return speed * 3.0; // Charge speed multiplier
    }
    return speed;
  }

  // Player dash methods
  bool canDash() {
    final now = DateTime.now();
    return now.difference(lastDashTime) >= dashCooldown;
  }

  void startDash() {
    if (canDash()) {
      isDashing = true;
      dashEndTime = DateTime.now().add(dashDuration);
      lastDashTime = DateTime.now();
    }
  }

  double get dashCooldownProgress {
    final now = DateTime.now();
    final elapsed = now.difference(lastDashTime);
    if (elapsed >= dashCooldown) return 1.0;
    return elapsed.inMilliseconds / dashCooldown.inMilliseconds;
  }
}

class BladeStyle {
  final Color color;
  final double size;
  final Color labelColor;

  const BladeStyle({
    required this.color,
    required this.size,
    required this.labelColor,
  });
}
