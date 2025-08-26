import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'app.dart';
import 'utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controllers for various animations
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;
  late AnimationController _particleController;

  // Animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _loadingAnimation;

  // Particles for cosmic effect
  final List<Particle> _particles = [];
  final int _particleCount = 30;

  @override
  void initState() {
    super.initState();

    // Initialize particles
    _initParticles();

    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Text animation controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Loading animation controller
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Particle animation controller
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Logo rotation animation
    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Text slide animation
    _textSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Loading animation
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    // We removed the unused _fadeAnimation

    // Start animations with slight delays
    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 400), () {
      _textController.forward();
    });

    // Navigate to main app after animations
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const VerzephronixApp(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  void _initParticles() {
    final random = math.Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(
        Particle(
          position: Offset(
            random.nextDouble() * 400 - 200,
            random.nextDouble() * 400 - 200,
          ),
          speed: 0.5 + random.nextDouble() * 2.0,
          radius: 1.0 + random.nextDouble() * 2.0,
          color: Colors.white.withOpacity(0.3 + random.nextDouble() * 0.7),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.spaceIndigo900,
      body: Stack(
        children: [
          // Animated particles background
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  particles: _particles,
                  animation: _particleController.value,
                ),
                size: MediaQuery.of(context).size,
              );
            },
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Transform.rotate(
                        angle: _logoRotateAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppConstants.spaceIndigo700,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppConstants.cosmicBlue.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.sports_score_outlined,
                              color: AppConstants.cosmicBlue,
                              size: 60,
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
                  animation: _textController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _textSlideAnimation.value),
                      child: Opacity(
                        opacity: 1.0 - _textSlideAnimation.value / 50.0,
                        child: Column(
                          children: [
                            // App name with animated letters
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildAnimatedText(
                                AppConstants.appName,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Tagline
                            Text(
                              "Your Ultimate Sports Companion",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 60),

                // Custom loading animation
                AnimatedBuilder(
                  animation: _loadingController,
                  builder: (context, child) {
                    return SizedBox(
                      width: 120,
                      height: 4,
                      child: CustomPaint(
                        painter: LoadingPainter(
                          animation: _loadingAnimation.value,
                          color: AppConstants.cosmicBlue,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnimatedText(String text) {
    List<Widget> result = [];

    for (int i = 0; i < text.length; i++) {
      // 确保延迟值不会导致interval超出范围
      // 将字符的延迟时间映射到0.0-0.6的范围内，这样即使有很多字符也不会超出1.0
      final maxDelay = 0.6; // 最大延迟时间
      final delay = (i * 0.1) * (maxDelay / (text.length * 0.1));

      // 确保结束值不超过1.0
      final endValue = math.min(delay + 0.4, 1.0);

      final letterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _textController,
          curve: Interval(delay, endValue, curve: Curves.easeOut),
        ),
      );

      result.add(
        AnimatedBuilder(
          animation: letterAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: letterAnimation.value,
              child: Opacity(
                opacity: letterAnimation.value,
                child: Text(
                  text[i],
                  style: TextStyle(
                    color: AppConstants.cosmicBlue,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: AppConstants.cosmicBlue.withOpacity(0.7),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return result;
  }
}

// Particle class for cosmic background effect
class Particle {
  Offset position;
  final double speed;
  final double radius;
  final Color color;

  Particle({
    required this.position,
    required this.speed,
    required this.radius,
    required this.color,
  });
}

// Painter for cosmic particles
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;

  ParticlePainter({required this.particles, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Update particle position based on animation
      final offset = Offset(
        size.width / 2 + particle.position.dx * (0.5 + animation * 0.5),
        size.height / 2 + particle.position.dy * (0.5 + animation * 0.5),
      );

      // Draw particle
      canvas.drawCircle(
        offset,
        particle.radius * (0.5 + math.sin(animation * 2 * math.pi) * 0.5),
        Paint()..color = particle.color.withOpacity(0.5 + animation * 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

// Custom loading animation painter
class LoadingPainter extends CustomPainter {
  final double animation;
  final Color color;

  LoadingPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Create a pulsing wave effect
    final path = Path();

    for (double i = 0; i < size.width; i++) {
      final x = i;
      final waveHeight = 2.0;
      final y =
          size.height / 2 +
          math.sin(animation * 2 * math.pi + i / 10) * waveHeight;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw the wave
    canvas.drawPath(path, paint);

    // Draw the moving dot
    final dotPosition = size.width * animation;
    final dotY =
        size.height / 2 +
        math.sin(animation * 2 * math.pi + dotPosition / 10) * 2.0;

    canvas.drawCircle(Offset(dotPosition, dotY), 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(LoadingPainter oldDelegate) => true;
}
