import 'package:flutter/material.dart';
import 'dart:math';

class ParticleEffect extends StatefulWidget {
  final Color color;
  final Duration duration;
  final VoidCallback? onComplete;

  const ParticleEffect({
    super.key,
    required this.color,
    this.duration = const Duration(milliseconds: 1000),
    this.onComplete,
  });

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _generateParticles();
    _controller.forward().then((_) {
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  void _generateParticles() {
    _particles = List.generate(12, (index) {
      final angle = (index * 30.0) * (pi / 180.0); // 30 degrees apart
      final velocity = 50.0 + _random.nextDouble() * 50.0; // Random velocity
      final size = 3.0 + _random.nextDouble() * 4.0; // Random size

      return Particle(
        startX: 0,
        startY: 0,
        velocityX: cos(angle) * velocity,
        velocityY: sin(angle) * velocity,
        size: size,
        color: widget.color,
        life: 1.0,
      );
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
          size: const Size(100, 100),
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
  final double size;
  final Color color;
  final double life;

  Particle({
    required this.startX,
    required this.startY,
    required this.velocityX,
    required this.velocityY,
    required this.size,
    required this.color,
    required this.life,
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
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (final particle in particles) {
      final currentX =
          centerX + particle.startX + (particle.velocityX * progress);
      final currentY =
          centerY + particle.startY + (particle.velocityY * progress);

      // Fade out particles over time
      final alpha = (1.0 - progress).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = particle.color.withOpacity(alpha)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(currentX, currentY),
        particle.size * (1.0 - progress * 0.5), // Shrink over time
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class StarBurstEffect extends StatefulWidget {
  final Color color;
  final Duration duration;
  final VoidCallback? onComplete;

  const StarBurstEffect({
    super.key,
    required this.color,
    this.duration = const Duration(milliseconds: 800),
    this.onComplete,
  });

  @override
  State<StarBurstEffect> createState() => _StarBurstEffectState();
}

class _StarBurstEffectState extends State<StarBurstEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0),
    ));

    _controller.forward().then((_) {
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
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
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value.clamp(0.0, 1.0),
              child: Icon(
                Icons.auto_awesome,
                color: widget.color,
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }
}
