import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/character.dart';
import '../models/collectable.dart';
import '../models/particle.dart';

class GameCanvas extends StatelessWidget {
  final Listenable repaint;
  final Character? player;
  final List<Character> enemies;
  final List<Collectable> collectables;
  final List<Particle> particles;
  final Offset cameraPos;

  const GameCanvas({
    super.key,
    required this.repaint,
    required this.player,
    required this.enemies,
    required this.collectables,
    required this.particles,
    required this.cameraPos,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: GamePainter(
          player: player,
          enemies: enemies,
          collectables: collectables,
          particles: particles,
          cameraPos: cameraPos,
          repaint: repaint,
        ),
        isComplex: true,
        willChange: true,
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final Character? player;
  final List<Character> enemies;
  final List<Collectable> collectables;
  final List<Particle> particles;
  final Offset cameraPos;
  final Listenable repaint;

  // Reusable Paint objects for performance
  final Paint _starPaint = Paint()..color = Colors.white.withOpacity(0.6);
  final Paint _chargePaint = Paint()..style = PaintingStyle.fill;
  final Paint _corePaint = Paint()..style = PaintingStyle.fill;
  final Paint _coreStrokePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final Paint _bladePaint = Paint()..style = PaintingStyle.fill;
  final Paint _particlePaint = Paint()..style = PaintingStyle.fill;
  final Paint _labelBgPaint = Paint()..style = PaintingStyle.fill;
  final TextPainter _labelTextPainter = TextPainter(
      textAlign: TextAlign.center, textDirection: TextDirection.ltr);

  // Cache for blade Paths and icon TextPainters
  final Map<double, Path> _bladePathCache = {};
  final Map<IconData, TextPainter> _iconPainterCache = {};
  final double _time;

  GamePainter({
    required this.player,
    required this.enemies,
    required this.collectables,
    required this.particles,
    required this.cameraPos,
    required this.repaint,
  })  : _time = DateTime.now().millisecondsSinceEpoch / 1000.0,
        super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // Debug output to confirm rendering is happening
    // print('🎨 Painting: ${size.width}x${size.height}, Player: ${player?.bladeCount}, Enemies: ${enemies.length}');

    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    _drawStars(canvas, size);
    _drawCollectables(canvas, size);

    final allCharacters = [
      if (player != null && player!.isActive) player!,
      ...enemies.where((e) => e.isActive),
    ];
    allCharacters.sort((a, b) => a.pos.dy.compareTo(b.pos.dy));

    for (final character in allCharacters) {
      _drawCharacter(canvas, character, size);
    }

    _drawParticles(canvas, size);
  }

  void _drawStars(Canvas canvas, Size size) {
    final safeCameraPos = Offset(
      cameraPos.dx.isFinite ? cameraPos.dx : 0.0,
      cameraPos.dy.isFinite ? cameraPos.dy : 0.0,
    );

    final random = math.Random(0);
    final starCount = (size.width * size.height / 5000).clamp(50, 200).toInt();

    for (int i = 0; i < starCount; i++) {
      final starX = random.nextDouble() * 4000 - 2000;
      final starY = random.nextDouble() * 4000 - 2000;
      final parallaxFactor = (random.nextDouble() * 0.5) + 0.1;

      final screenPos = Offset(
        size.width / 2 + (starX - safeCameraPos.dx * parallaxFactor),
        size.height / 2 + (starY - safeCameraPos.dy * parallaxFactor),
      );

      final wrappedX = (screenPos.dx % size.width + size.width) % size.width;
      final wrappedY = (screenPos.dy % size.height + size.height) % size.height;

      final starSize = random.nextDouble() * 1.5 + 0.5;
      canvas.drawCircle(Offset(wrappedX, wrappedY), starSize, _starPaint);
    }
  }

  void _drawCollectables(Canvas canvas, Size size) {
    for (final collectable in collectables) {
      final screenPos = _worldToScreen(collectable.pos, size);

      if (_isOnScreen(screenPos, size, 100)) {
        _drawBlade(
            canvas, screenPos, collectable.radius, Colors.white, _time * 2);
      }
    }
  }

  void _drawCharacter(Canvas canvas, Character character, Size size) {
    final screenPos = _worldToScreen(character.pos, size);

    if (!_isOnScreen(screenPos, size, character.fullRadius * 2)) return;

    // 冲刺效果
    if (character.isDashing) {
      _chargePaint.color = Colors.cyan.withOpacity(0.4);
      canvas.drawCircle(screenPos, character.bladesRadius * 1.8, _chargePaint);

      // 冲刺光环效果
      final dashGlowPaint = Paint()
        ..color = Colors.cyan.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8.0);
      canvas.drawCircle(screenPos, character.bladesRadius + 10, dashGlowPaint);
    }

    if (character.isCharging) {
      _chargePaint.color = Colors.red.withOpacity(0.3);
      canvas.drawCircle(screenPos, character.bladesRadius * 1.5, _chargePaint);
    }

    _drawBlades(canvas, character, screenPos);

    _corePaint.color = character.color;
    canvas.drawCircle(screenPos, 20, _corePaint);
    canvas.drawCircle(screenPos, 20, _coreStrokePaint);

    _drawIcon(canvas, screenPos, character.icon, Colors.white, 16);
    _drawCharacterLabel(canvas, character, screenPos);
  }

  void _drawBlades(Canvas canvas, Character character, Offset center) {
    if (character.bladeCount <= 0) return;

    final bladeStyle = character.bladeStyle;
    const layers = 4;
    final bladesPerLayer = (character.bladeCount / layers).ceil();
    final maxBladesInRing = 50;

    for (int layer = 0; layer < layers; layer++) {
      if (character.bladeCount < layer * (bladesPerLayer / 3)) continue;

      final layerBladeCount = math.min(bladesPerLayer, maxBladesInRing);
      if (layerBladeCount == 0) continue;

      final layerRadius = character.bladesRadius - (layer * 15.0);
      if (layerRadius < 20) continue;

      // 更复杂的旋转速度模式
      final baseRotationSpeed = 1.2 - (layer * 0.3);
      // 冲刺时武器旋转加速
      final speedMultiplier =
          character.isDashing ? 3.0 : (character.isCharging ? 2.0 : 1.0);
      final rotationSpeed = baseRotationSpeed * speedMultiplier;
      final direction = layer.isEven ? 1 : -1;
      final phaseOffset = layer * math.pi / 3; // 添加相位偏移
      final rotation = (_time * rotationSpeed * direction) + phaseOffset;

      final angleStep = (2 * math.pi) / layerBladeCount;

      for (int i = 0; i < layerBladeCount; i++) {
        final angle = (angleStep * i) + rotation;

        final bladePos = Offset(
          center.dx + math.cos(angle) * layerRadius,
          center.dy + math.sin(angle) * layerRadius,
        );

        final layerSizeMultiplier = 1.0 - (layer * 0.1);
        final bladeSize = (bladeStyle.size / 2) * layerSizeMultiplier;

        final depthAlpha = (0.6 + 0.4 * math.sin(angle)).clamp(0.3, 1.0);
        final layerColor = bladeStyle.color.withOpacity(depthAlpha);

        _drawBlade(canvas, bladePos, bladeSize, layerColor, angle);
      }
    }
  }

  void _drawBlade(
      Canvas canvas, Offset center, double size, Color color, double rotation) {
    _bladePaint.color = color;

    final path = _bladePathCache.putIfAbsent(size, () {
      final p = Path();
      // 创建细长的月牙形状
      final width = size * 1.5; // 月牙的宽度
      final height = size * 0.4; // 月牙的厚度

      // 外弧 (月牙的外边缘)
      p.addArc(
        Rect.fromCenter(
            center: Offset.zero, width: width * 2, height: width * 2),
        -0.3, // 开始角度
        0.6, // 扫过的角度
      );

      // 内弧 (月牙的内边缘) - 创建月牙的凹陷
      final innerRadius = width * 0.7;
      p.arcTo(
        Rect.fromCenter(
            center: Offset(-width * 0.15, 0),
            width: innerRadius * 2,
            height: innerRadius * 2),
        0.3, // 开始角度
        -0.6, // 扫过的角度 (反方向)
        false,
      );

      p.close();
      return p;
    });

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    // 添加发光效果
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3.0);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, _bladePaint);
    canvas.restore();
  }

  void _drawIcon(
      Canvas canvas, Offset center, IconData icon, Color color, double size) {
    final textPainter = _iconPainterCache.putIfAbsent(icon, () {
      final painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
        ),
      );
      painter.layout();
      return painter;
    });

    if ((textPainter.text as TextSpan?)?.style?.color != color) {
      textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
        ),
      );
      textPainter.layout();
    }

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  void _drawCharacterLabel(
      Canvas canvas, Character character, Offset screenPos) {
    final labelY = screenPos.dy - character.bladesRadius - 35;

    _labelTextPainter.text = TextSpan(
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(blurRadius: 2.0, color: Colors.black)]),
      children: [
        TextSpan(
          text: character.name,
          style: TextStyle(
              color: character.type == null ? Colors.yellow : Colors.white),
        ),
        TextSpan(
          text: '  ${character.bladeCount}',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );

    _labelTextPainter.layout();

    final bgWidth = _labelTextPainter.width + 16;
    final bgHeight = 22.0;
    _labelBgPaint.color = character.bladeStyle.labelColor.withOpacity(0.8);
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: Offset(screenPos.dx, labelY),
          width: bgWidth,
          height: bgHeight),
      const Radius.circular(11),
    );

    canvas.drawRRect(bgRect, _labelBgPaint);
    _labelTextPainter.paint(
      canvas,
      Offset(
        screenPos.dx - _labelTextPainter.width / 2,
        labelY - _labelTextPainter.height / 2,
      ),
    );
  }

  void _drawParticles(Canvas canvas, Size size) {
    for (final particle in particles) {
      final screenPos = _worldToScreen(particle.pos, size);

      if (_isOnScreen(screenPos, size, 20)) {
        _particlePaint.color =
            particle.color.withOpacity((particle.lifespan).clamp(0.0, 1.0));
        canvas.drawCircle(screenPos, particle.size, _particlePaint);
      }
    }
  }

  Offset _worldToScreen(Offset worldPos, Size screenSize) {
    final safeWorldPos = Offset(
      worldPos.dx.isFinite ? worldPos.dx : 0.0,
      worldPos.dy.isFinite ? worldPos.dy : 0.0,
    );
    final safeCameraPos = Offset(
      cameraPos.dx.isFinite ? cameraPos.dx : 0.0,
      cameraPos.dy.isFinite ? cameraPos.dy : 0.0,
    );

    return Offset(
      safeWorldPos.dx - safeCameraPos.dx + screenSize.width / 2,
      safeWorldPos.dy - safeCameraPos.dy + screenSize.height / 2,
    );
  }

  bool _isOnScreen(Offset screenPos, Size screenSize, double margin) {
    return screenPos.dx > -margin &&
        screenPos.dx < screenSize.width + margin &&
        screenPos.dy > -margin &&
        screenPos.dy < screenSize.height + margin;
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return oldDelegate.player != player ||
        oldDelegate.enemies != enemies ||
        oldDelegate.collectables != collectables ||
        oldDelegate.particles != particles ||
        oldDelegate.cameraPos != cameraPos;
  }
}
