import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'main_menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _snakeController;
  late AnimationController _textController;
  late AnimationController _loadingController;
  late Animation<double> _snakeAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _loadingAnimation;
  final List<Offset> _snakePoints = [];
  final int _numPoints = 20;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateSnakePoints();
    _startAnimations();

    // Navigate to main menu after animations
    Future.delayed(const Duration(milliseconds: 4000), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const MainMenu(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  void _initializeAnimations() {
    // Snake movement animation
    _snakeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _snakeAnimation = CurvedAnimation(
      parent: _snakeController,
      curve: Curves.easeInOut,
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _textScaleAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.elasticOut,
    );
    _textSlideAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    );

    // Loading animation
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _loadingAnimation = CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    );
  }

  void _generateSnakePoints() {
    final random = math.Random();
    for (int i = 0; i < _numPoints; i++) {
      _snakePoints.add(
        Offset(random.nextDouble() * 2 - 1, random.nextDouble() * 2 - 1),
      );
    }
  }

  void _startAnimations() {
    _snakeController.repeat();
    _textController.forward();
    _loadingController.repeat();
  }

  @override
  void dispose() {
    _snakeController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          // Animated snake background
          AnimatedBuilder(
            animation: _snakeAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: SnakeBackgroundPainter(
                  points: _snakePoints,
                  progress: _snakeAnimation.value,
                  baseColor: const Color(0xFF4EABE9),
                ),
                size: Size.infinite,
              );
            },
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Snake icon with glow
                ScaleTransition(
                  scale: _textScaleAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4EABE9).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.sports_esports,
                      size: 80,
                      color: Color(0xFF4EABE9),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Game title
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(_textSlideAnimation),
                  child: const Column(
                    children: [
                      Text(
                        'SNAKE',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 8,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ZYPHYN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF4EABE9),
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // Custom loading animation
                AnimatedBuilder(
                  animation: _loadingAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: LoadingPainter(
                        progress: _loadingAnimation.value,
                        color: const Color(0xFF4EABE9),
                      ),
                      size: const Size(160, 4),
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
}

class SnakeBackgroundPainter extends CustomPainter {
  final List<Offset> points;
  final double progress;
  final Color baseColor;

  SnakeBackgroundPainter({
    required this.points,
    required this.progress,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = baseColor.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final path = Path();
    final scaledPoints =
        points.map((point) {
          return Offset(
            point.dx * size.width + size.width / 2,
            point.dy * size.height + size.height / 2,
          );
        }).toList();

    for (var i = 0; i < scaledPoints.length - 1; i++) {
      final current = scaledPoints[i];
      final next = scaledPoints[i + 1];
      final startPoint =
          Offset.lerp(
            current,
            next,
            (progress + i / scaledPoints.length) % 1.0,
          )!;
      final endPoint =
          Offset.lerp(
            current,
            next,
            (progress + (i + 1) / scaledPoints.length) % 1.0,
          )!;

      if (i == 0) {
        path.moveTo(startPoint.dx, startPoint.dy);
      }
      path.quadraticBezierTo(current.dx, current.dy, endPoint.dx, endPoint.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SnakeBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class LoadingPainter extends CustomPainter {
  final double progress;
  final Color color;

  LoadingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round;

    // Draw background line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Draw animated progress
    final progressPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round;

    final progressWidth = size.width * 0.3; // Width of the moving segment
    final startX = (size.width + progressWidth) * progress - progressWidth;

    canvas.drawLine(
      Offset(startX, size.height / 2),
      Offset(startX + progressWidth, size.height / 2),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(LoadingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
