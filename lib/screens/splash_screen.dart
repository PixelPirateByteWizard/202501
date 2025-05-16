import 'package:flutter/material.dart';
import 'dart:math' as math;

class Particle {
  Offset position;
  Color color;
  double size;
  double speed;
  double angle;

  Particle({
    required this.position,
    required this.color,
    required this.size,
    required this.speed,
    required this.angle,
  });

  void update(double delta, Size screenSize) {
    final dx = math.cos(angle) * speed * delta;
    final dy = math.sin(angle) * speed * delta;

    position = Offset(position.dx + dx, position.dy + dy);

    // Bounce off walls
    if (position.dx < 0 || position.dx > screenSize.width) {
      angle = math.pi - angle;
    }

    if (position.dy < 0 || position.dy > screenSize.height) {
      angle = -angle;
    }
  }
}

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _textOpacityAnimation;
  late List<Particle> _particles;

  final _random = math.Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
      ),
    );

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.8, curve: Curves.easeIn),
      ),
    );

    _particles = [];

    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
        widget.onComplete();
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeParticles();
  }

  void _initializeParticles() {
    final size = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    _particles = List.generate(30, (_) {
      final isUsingPrimary = _random.nextBool();
      return Particle(
        position: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        ),
        color: isUsingPrimary
            ? primaryColor.withOpacity(_random.nextDouble() * 0.6 + 0.2)
            : secondaryColor.withOpacity(_random.nextDouble() * 0.6 + 0.2),
        size: _random.nextDouble() * 12 + 3,
        speed: _random.nextDouble() * 50 + 20,
        angle: _random.nextDouble() * 2 * math.pi,
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
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Stack(
        children: [
          // Particle effect background
          CustomPaint(
            size: size,
            painter: ParticlePainter(
              particles: _particles,
              progress: _controller.value,
            ),
          ),

          // Radial gradient background
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.1),
                radius: 1.0,
                colors: [
                  theme.colorScheme.primary.withOpacity(0.15),
                  theme.colorScheme.background.withOpacity(0.1),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated clock widget
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: CustomPaint(
                                painter: ClockPainter(
                                  color: Colors.white,
                                  progress: _controller.value,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Animated text
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textOpacityAnimation.value,
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    Colors.white,
                                    theme.colorScheme.secondary,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: const Text(
                                'DYSPHOR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Focus your time, enhance your life',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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
    for (var particle in particles) {
      // Update particle position
      particle.update(0.016, size); // Assuming 60fps

      // Draw particle
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(particle.position, particle.size, paint);

      // Draw glow
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

      canvas.drawCircle(particle.position, particle.size * 1.5, glowPaint);
    }

    // Draw some connecting lines between particles
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (var i = 0; i < particles.length; i++) {
      for (var j = i + 1; j < particles.length; j++) {
        final distance =
            (particles[i].position - particles[j].position).distance;
        if (distance < 100) {
          // Draw line with opacity based on distance
          final opacity = 1.0 - (distance / 100);
          linePaint.color = Colors.white.withOpacity(opacity * 0.1);
          canvas.drawLine(
              particles[i].position, particles[j].position, linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ClockPainter extends CustomPainter {
  final Color color;
  final double progress;

  ClockPainter({
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw clock face
    final facePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius * 0.8, facePaint);

    // Draw hour markers
    final markerPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 12; i++) {
      final angle = i * math.pi / 6;
      final outerRadius = radius * 0.8;
      final innerRadius = i % 3 == 0 ? radius * 0.7 : radius * 0.75;

      final x1 = center.dx + outerRadius * math.sin(angle);
      final y1 = center.dy - outerRadius * math.cos(angle);
      final x2 = center.dx + innerRadius * math.sin(angle);
      final y2 = center.dy - innerRadius * math.cos(angle);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), markerPaint);
    }

    // Draw hour hand
    final hourHandPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final hourAngle = progress * 2 * math.pi;
    final hourHandLength = radius * 0.4;
    final hourHandX = center.dx + hourHandLength * math.sin(hourAngle);
    final hourHandY = center.dy - hourHandLength * math.cos(hourAngle);

    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandPaint);

    // Draw minute hand
    final minuteHandPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final minuteAngle = progress * 6 * math.pi;
    final minuteHandLength = radius * 0.6;
    final minuteHandX = center.dx + minuteHandLength * math.sin(minuteAngle);
    final minuteHandY = center.dy - minuteHandLength * math.cos(minuteAngle);

    canvas.drawLine(center, Offset(minuteHandX, minuteHandY), minuteHandPaint);

    // Draw second hand
    final secondHandPaint = Paint()
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final secondAngle = progress * 12 * math.pi;
    final secondHandLength = radius * 0.7;
    final secondHandX = center.dx + secondHandLength * math.sin(secondAngle);
    final secondHandY = center.dy - secondHandLength * math.cos(secondAngle);

    canvas.drawLine(center, Offset(secondHandX, secondHandY), secondHandPaint);

    // Draw center dot
    final centerDotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 4, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
