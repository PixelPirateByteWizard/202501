import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/character.dart';
import '../models/collectable.dart';
import '../models/particle.dart';
import 'package:flutter/rendering.dart' as ui;

class GameCanvas extends StatefulWidget {
  final Listenable repaint;
  final Character? player;
  final List<Character> enemies;
  final List<Collectable> collectables;
  final List<Particle> particles;
  final Offset cameraPos;
  final int backgroundIndex;

  const GameCanvas({
    super.key,
    required this.repaint,
    required this.player,
    required this.enemies,
    required this.collectables,
    required this.particles,
    required this.cameraPos,
    this.backgroundIndex = 1,
  });

  @override
  State<GameCanvas> createState() => _GameCanvasState();
}

class _GameCanvasState extends State<GameCanvas>
    with SingleTickerProviderStateMixin {
  // Store previous camera position to calculate movement speed
  Offset _prevCameraPos = Offset.zero;
  double _movementSpeed = 0.0;

  @override
  void initState() {
    super.initState();
    _prevCameraPos = widget.cameraPos;
  }

  @override
  void didUpdateWidget(GameCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Calculate movement speed based on camera position change
    if (_prevCameraPos != widget.cameraPos) {
      final distance = (widget.cameraPos - _prevCameraPos).distance;
      _movementSpeed =
          (_movementSpeed * 0.8) + (distance * 0.2); // Smooth the speed
      _prevCameraPos = widget.cameraPos;
    } else {
      _movementSpeed *= 0.9; // Decay when not moving
    }
  }

  @override
  Widget build(BuildContext context) {
    final String bgPath = 'assets/bg/BG_${widget.backgroundIndex}.png';

    // Calculate parallax offset based on camera position
    // The background moves slower than the foreground for a parallax effect
    final parallaxFactor = 0.15; // Increased to make movement more noticeable

    // Add speed-based parallax enhancement
    final speedBoost = _movementSpeed / 10;
    final effectiveParallaxFactor = parallaxFactor * (1.0 + speedBoost);

    final safeCameraPos = Offset(
      widget.cameraPos.dx.isFinite ? widget.cameraPos.dx : 0.0,
      widget.cameraPos.dy.isFinite ? widget.cameraPos.dy : 0.0,
    );

    // Determine if player is in danger (blade count <= 5)
    final bool isPlayerInDanger =
        widget.player != null && widget.player!.bladeCount <= 5;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background with infinite repeating pattern
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: widget.repaint,
            builder: (context, _) {
              // Calculate parallax offset
              final parallaxOffsetX =
                  safeCameraPos.dx * effectiveParallaxFactor;
              final parallaxOffsetY =
                  safeCameraPos.dy * effectiveParallaxFactor;

              return RepeatableImageBackground(
                imagePath: bgPath,
                offset: Offset(-parallaxOffsetX, -parallaxOffsetY),
              );
            },
          ),
        ),
        // Overlay to reduce visual impact
        Container(
          color: Colors.black
              .withOpacity(0.65), // Dark overlay to make gameplay more visible
        ),
        // Movement speed indicator - subtle blur effect when moving fast
        if (_movementSpeed > 2.0)
          Container(
            color: Colors.white.withOpacity((_movementSpeed - 2.0) / 20.0),
          ),
        // Danger overlay - pulsing red when player is in danger
        if (isPlayerInDanger)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Container(
                color: Colors.red.withOpacity(
                  0.15 + 0.1 * math.sin(value * math.pi * 2),
                ),
              );
            },
            child: Container(),
            onEnd: () {
              // This forces the animation to rebuild and start over
              if (isPlayerInDanger) {
                (context as Element).markNeedsBuild();
              }
            },
          ),
        // Game canvas
        SizedBox.expand(
          child: CustomPaint(
            painter: GamePainter(
              player: widget.player,
              enemies: widget.enemies,
              collectables: widget.collectables,
              particles: widget.particles,
              cameraPos: widget.cameraPos,
              repaint: widget.repaint,
            ),
            isComplex: true,
            willChange: true,
          ),
        ),
        // Character images overlay
        CharacterImagesOverlay(
          player: widget.player,
          enemies: widget.enemies,
          cameraPos: widget.cameraPos,
          repaint: widget.repaint,
        ),
      ],
    );
  }
}

// Widget to overlay character images on top of the game canvas
class CharacterImagesOverlay extends StatelessWidget {
  final Character? player;
  final List<Character> enemies;
  final Offset cameraPos;
  final Listenable repaint;

  const CharacterImagesOverlay({
    super.key,
    required this.player,
    required this.enemies,
    required this.cameraPos,
    required this.repaint,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repaint,
      builder: (context, _) {
        final allCharacters = [
          if (player != null && player!.isActive) player!,
          ...enemies.where((e) => e.isActive),
        ];

        return Stack(
          fit: StackFit.expand,
          children: [
            for (final character in allCharacters)
              _buildCharacterImage(context, character),
          ],
        );
      },
    );
  }

  Widget _buildCharacterImage(BuildContext context, Character character) {
    final size = MediaQuery.of(context).size;
    final screenPos = _worldToScreen(character.pos, size);

    // Skip if character is off-screen
    if (!_isOnScreen(screenPos, size, 50)) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: screenPos.dx - 20,
      top: screenPos.dy - 20,
      width: 40,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            character.imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Offset _worldToScreen(Offset worldPos, Size screenSize) {
    try {
      final safeWorldPos = Offset(
        worldPos.dx.isFinite ? worldPos.dx : 0.0,
        worldPos.dy.isFinite ? worldPos.dy : 0.0,
      );
      final safeCameraPos = Offset(
        cameraPos.dx.isFinite ? cameraPos.dx : 0.0,
        cameraPos.dy.isFinite ? cameraPos.dy : 0.0,
      );

      final screenX = safeWorldPos.dx - safeCameraPos.dx + screenSize.width / 2;
      final screenY =
          safeWorldPos.dy - safeCameraPos.dy + screenSize.height / 2;

      // 确保返回的坐标是有效的
      return Offset(
        screenX.isFinite ? screenX : 0.0,
        screenY.isFinite ? screenY : 0.0,
      );
    } catch (e) {
      // 如果计算出错，返回屏幕中心
      return Offset(screenSize.width / 2, screenSize.height / 2);
    }
  }

  bool _isOnScreen(Offset screenPos, Size screenSize, double margin) {
    return screenPos.dx > -margin &&
        screenPos.dx < screenSize.width + margin &&
        screenPos.dy > -margin &&
        screenPos.dy < screenSize.height + margin;
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
    // 安全检查
    if (size.width <= 0 || size.height <= 0) return;

    try {
      canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

      // 绘制星星背景
      _drawStars(canvas, size);

      // 绘制可收集物品
      _drawCollectables(canvas, size);

      // 绘制角色
      final allCharacters = [
        if (player != null && player!.isActive) player!,
        ...enemies.where((e) => e.isActive),
      ];

      // 按Y轴排序以确保正确的绘制顺序
      allCharacters.sort((a, b) => a.pos.dy.compareTo(b.pos.dy));

      for (final character in allCharacters) {
        _drawCharacter(canvas, character, size);
      }

      // 绘制粒子效果
      _drawParticles(canvas, size);
    } catch (e) {
      // 如果绘制过程中出现任何错误，至少绘制一个基本背景
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.black,
      );
    }
  }

  void _drawStars(Canvas canvas, Size size) {
    final safeCameraPos = Offset(
      cameraPos.dx.isFinite ? cameraPos.dx : 0.0,
      cameraPos.dy.isFinite ? cameraPos.dy : 0.0,
    );

    final random = math.Random(0);
    final starCount = (size.width * size.height / 5000).clamp(50, 200).toInt();

    // Reduce star opacity since we now have a background
    final starPaint = Paint()..color = Colors.white.withOpacity(0.3);

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
      canvas.drawCircle(Offset(wrappedX, wrappedY), starSize, starPaint);
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

    // Draw character core with transparent color (image will be overlaid)
    _corePaint.color = character.color.withOpacity(0.3);
    canvas.drawCircle(screenPos, 22, _corePaint);

    // Draw core border
    canvas.drawCircle(screenPos, 22, _coreStrokePaint);

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
    if (!center.dx.isFinite ||
        !center.dy.isFinite ||
        !size.isFinite ||
        !rotation.isFinite ||
        size <= 0) {
      return; // 如果参数无效，则跳过绘制
    }

    try {
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
    } catch (e) {
      // 忽略绘制错误
    }
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
    try {
      final safeWorldPos = Offset(
        worldPos.dx.isFinite ? worldPos.dx : 0.0,
        worldPos.dy.isFinite ? worldPos.dy : 0.0,
      );
      final safeCameraPos = Offset(
        cameraPos.dx.isFinite ? cameraPos.dx : 0.0,
        cameraPos.dy.isFinite ? cameraPos.dy : 0.0,
      );

      final screenX = safeWorldPos.dx - safeCameraPos.dx + screenSize.width / 2;
      final screenY =
          safeWorldPos.dy - safeCameraPos.dy + screenSize.height / 2;

      // 确保返回的坐标是有效的
      return Offset(
        screenX.isFinite ? screenX : screenSize.width / 2,
        screenY.isFinite ? screenY : screenSize.height / 2,
      );
    } catch (e) {
      // 如果计算出错，返回屏幕中心
      return Offset(screenSize.width / 2, screenSize.height / 2);
    }
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

class RepeatableImageBackground extends StatelessWidget {
  final String imagePath;
  final Offset offset;

  const RepeatableImageBackground({
    super.key,
    required this.imagePath,
    required this.offset,
  });

  @override
  Widget build(BuildContext context) {
    // 计算安全的偏移量，并减慢移动速度（除以4）
    final safeOffsetX = offset.dx.isFinite ? offset.dx / 4 : 0.0;
    final safeOffsetY = offset.dy.isFinite ? offset.dy / 4 : 0.0;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          repeat: ImageRepeat.repeat,
          // 放大图片4倍
          scale: 0.25,
          alignment: Alignment(
            (safeOffsetX / 1000).clamp(-1.0, 1.0),
            (safeOffsetY / 1000).clamp(-1.0, 1.0),
          ),
        ),
      ),
    );
  }
}
