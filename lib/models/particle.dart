import 'package:flutter/material.dart';

class Particle {
  Offset pos;
  Offset velocity;
  Color color;
  double lifespan; // 1.0 (100%) decreases to 0.0
  final double size;

  Particle({
    required this.pos,
    required this.velocity,
    required this.color,
    this.lifespan = 1.0,
    this.size = 3.0,
  });

  void update() {
    // Basic position and velocity updates
    pos += velocity;
    velocity += const Offset(0, 0.1); // Simple gravity
    lifespan -= 0.03; // Fade over time

    // Simple bounds check - reset to zero if invalid
    if (!pos.dx.isFinite || !pos.dy.isFinite) {
      pos = Offset.zero;
    }
    if (!velocity.dx.isFinite || !velocity.dy.isFinite) {
      velocity = Offset.zero;
    }
  }

  bool get isDead => lifespan <= 0;
}
