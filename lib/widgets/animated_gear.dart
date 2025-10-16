import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedGear extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;
  final bool clockwise;
  final double opacity;

  const AnimatedGear({
    super.key,
    required this.size,
    required this.color,
    this.duration = const Duration(seconds: 8),
    this.clockwise = true,
    this.opacity = 1.0,
  });

  @override
  State<AnimatedGear> createState() => _AnimatedGearState();
}

class _AnimatedGearState extends State<AnimatedGear>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: widget.clockwise ? 2 * math.pi : -2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat();
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
          scale: _pulseAnimation.value * 0.1 + 0.95, // Subtle pulsing
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Opacity(
              opacity: widget.opacity,
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: GearPainter(
                  color: widget.color,
                  animationValue: _controller.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class GearPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  GearPainter({required this.color, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw main gear body
    canvas.drawCircle(center, radius * 0.7, paint);

    // Draw gear teeth
    const teethCount = 12;
    final angleStep = 2 * math.pi / teethCount;

    for (int i = 0; i < teethCount; i++) {
      final angle = i * angleStep;

      // Draw tooth as a small rectangle
      final toothPath = Path();
      final toothWidth = angleStep * 0.3;

      toothPath.moveTo(
        center.dx + math.cos(angle - toothWidth / 2) * radius * 0.7,
        center.dy + math.sin(angle - toothWidth / 2) * radius * 0.7,
      );
      toothPath.lineTo(
        center.dx + math.cos(angle - toothWidth / 2) * radius,
        center.dy + math.sin(angle - toothWidth / 2) * radius,
      );
      toothPath.lineTo(
        center.dx + math.cos(angle + toothWidth / 2) * radius,
        center.dy + math.sin(angle + toothWidth / 2) * radius,
      );
      toothPath.lineTo(
        center.dx + math.cos(angle + toothWidth / 2) * radius * 0.7,
        center.dy + math.sin(angle + toothWidth / 2) * radius * 0.7,
      );
      toothPath.close();

      canvas.drawPath(toothPath, paint);
    }

    // Draw center hole
    final holePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.25, holePaint);

    // Add some shine effect
    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - radius * 0.2, center.dy - radius * 0.2),
      radius * 0.15,
      shinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
