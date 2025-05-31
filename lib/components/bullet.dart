import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/game_utils.dart';

class Bullet extends StatelessWidget {
  final String type;
  final Position position;
  final double size;

  const Bullet({
    Key? key,
    required this.type,
    required this.position,
    this.size = GameConstants.bulletSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bulletType = bulletTypeFromString(type);
    final iconData = getBulletIcon(bulletType);
    final color = getBulletColor(bulletType);

    return Positioned(
      left: position.x - size / 2,
      top: position.y - size / 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          iconData,
          color: color,
          size: size * 0.8,
        ),
      ),
    );
  }
}

class BulletTrail extends StatelessWidget {
  final String type;
  final Position position;
  final Position direction;
  final double size;

  const BulletTrail({
    Key? key,
    required this.type,
    required this.position,
    required this.direction,
    this.size = GameConstants.bulletSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bulletType = bulletTypeFromString(type);
    final color = getBulletColor(bulletType);

    // Calculate trajectory length and angle
    final trailLength = size * 2;
    final angle = direction.y != 0
        ? atan2(direction.y, direction.x)
        : (direction.x >= 0 ? 0 : pi);

    return Positioned(
      left: position.x - size / 2,
      top: position.y - size / 2,
      child: Transform.rotate(
        angle: angle.toDouble(),
        child: Container(
          width: trailLength,
          height: size / 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.3),
                Colors.transparent,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(size / 6),
          ),
        ),
      ),
    );
  }
}

class BulletEffect extends StatelessWidget {
  final String type;
  final Position position;
  final double size;

  const BulletEffect({
    Key? key,
    required this.type,
    required this.position,
    this.size = GameConstants.enemySize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bulletType = bulletTypeFromString(type);
    final color = getBulletColor(bulletType);

    Widget effectWidget;

    switch (bulletType) {
      case BulletType.bolt: // Lightning effect
        effectWidget = _buildPulsingCircle(color);
        break;
      case BulletType.flame: // Fire effect
        effectWidget = _buildFlameEffect(color);
        break;
      case BulletType.frost: // Ice effect
        effectWidget = _buildFrostEffect(color);
        break;
      case BulletType.spirit: // Spirit effect
        effectWidget = _buildSpiritEffect(color);
        break;
      case BulletType.tornado: // Storm effect
        effectWidget = _buildTornadoEffect(color);
        break;
    }

    return Positioned(
      left: position.x - size / 2,
      top: position.y - size / 2,
      child: SizedBox(
        width: size,
        height: size,
        child: effectWidget,
      ),
    );
  }

  Widget _buildPulsingCircle(Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.7, end: 1.2),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: 2.0 - value,
          child: Transform.scale(
            scale: value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.3),
                border: Border.all(
                  color: color,
                  width: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFlameEffect(Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.2),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: 2.0 - value,
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_fire_department,
              color: color,
              size: size * value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFrostEffect(Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.2, end: 1.0),
      duration: const Duration(milliseconds: 400),
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(value),
              width: 2,
            ),
          ),
          child: CustomPaint(
            painter: _FrostPainter(
              color: color,
              value: value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpiritEffect(Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value * 2 * 3.14159,
          child: CustomPaint(
            painter: _SpiritPainter(
              color: color,
              value: value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTornadoEffect(Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset(
                  cos(value * 2 * 3.14159) * size * 0.3 * value,
                  sin(value * 2 * 3.14159) * size * 0.3 * value,
                ),
                child: Icon(
                  Icons.air,
                  color: color,
                  size: size * 0.5,
                ),
              ),
              Transform.translate(
                offset: Offset(
                  cos(value * 2 * 3.14159 + 2) * size * 0.3 * value,
                  sin(value * 2 * 3.14159 + 2) * size * 0.3 * value,
                ),
                child: Icon(
                  Icons.air,
                  color: color.withOpacity(0.8),
                  size: size * 0.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FrostPainter extends CustomPainter {
  final Color color;
  final double value;

  _FrostPainter({required this.color, required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    final paint = Paint()
      ..color = color.withOpacity(0.7 * (1 - value))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 6; i++) {
      final angle = i * 3.14159 / 3;
      final x = center.dx + cos(angle) * maxRadius * value;
      final y = center.dy + sin(angle) * maxRadius * value;

      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(_FrostPainter oldDelegate) =>
      color != oldDelegate.color || value != oldDelegate.value;
}

class _SpiritPainter extends CustomPainter {
  final Color color;
  final double value;

  _SpiritPainter({required this.color, required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    final path = Path();
    final numPoints = 5;

    for (int i = 0; i < numPoints; i++) {
      final angle = i * 2 * 3.14159 / numPoints;
      final x = center.dx + cos(angle) * maxRadius * value;
      final y = center.dy + sin(angle) * maxRadius * value;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();

    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SpiritPainter oldDelegate) =>
      color != oldDelegate.color || value != oldDelegate.value;
}
