import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParticleEffect extends StatefulWidget {
  final Offset position;
  final Color color;
  final VoidCallback? onComplete;

  const ParticleEffect({
    super.key,
    required this.position,
    required this.color,
    this.onComplete,
  });

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _particles = List.generate(12, (index) {
      final angle = (index * 30.0) * (math.pi / 180);
      return Particle(
        startX: widget.position.dx,
        startY: widget.position.dy,
        velocityX: math.cos(angle) * (50 + math.Random().nextDouble() * 50),
        velocityY: math.sin(angle) * (50 + math.Random().nextDouble() * 50),
        color: widget.color,
        size: 3 + math.Random().nextDouble() * 4,
      );
    });

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: ParticlePainter(
            particles: _particles,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class Particle {
  final double startX;
  final double startY;
  final double velocityX;
  final double velocityY;
  final Color color;
  final double size;

  Particle({
    required this.startX,
    required this.startY,
    required this.velocityX,
    required this.velocityY,
    required this.color,
    required this.size,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final x = particle.startX + particle.velocityX * progress;
      final y = particle.startY + particle.velocityY * progress - (0.5 * 200 * progress * progress); // Gravity
      
      final opacity = (1.0 - progress).clamp(0.0, 1.0);
      paint.color = particle.color.withOpacity(opacity);
      
      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1.0 - progress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}