import 'dart:math';
import 'package:flutter/material.dart';
import '../models/player.dart';
import '../utils/game_utils.dart';

class GameCharacter extends StatefulWidget {
  final String? characterAsset;
  final IconData? icon;
  final double size;
  final Player? player;
  final bool isInvulnerable;
  final int comboCount;
  final bool compactMode;

  const GameCharacter({
    Key? key,
    this.characterAsset,
    this.icon,
    required this.size,
    this.player,
    this.isInvulnerable = false,
    this.comboCount = 0,
    this.compactMode = false,
  }) : super(key: key);

  @override
  State<GameCharacter> createState() => _GameCharacterState();
}

class _GameCharacterState extends State<GameCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // 設置呼吸脈動動畫
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size + (widget.compactMode ? 10 : 30),
      height: widget.size + (widget.compactMode ? 10 : 30),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.loose,
        children: [
          // 角色基礎容器
          Positioned.fill(
            child: Center(
              child: _buildBaseCharacter(),
            ),
          ),

          // 如果有連擊，顯示連擊數
          if (widget.comboCount > 1) _buildComboCounter(),

          // 顯示玩家境界（如果有）
          if (widget.player != null) _buildRealmIndicator(),
        ],
      ),
    );
  }

  // 構建基礎角色
  Widget _buildBaseCharacter() {
    // 決定角色顏色
    Color primaryColor = widget.player != null
        ? _getRealmColor(widget.player!.cultivationRealm)
        : Colors.amber;

    // 決定輪廓顏色
    Color outlineColor = widget.player != null
        ? _getRealmOutlineColor(widget.player!.cultivationRealm)
        : Colors.deepOrange;

    // 無敵狀態顏色
    if (widget.isInvulnerable) {
      primaryColor = Colors.white;
      outlineColor = Colors.yellow;
    }

    // 建立基本角色容器
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black45,
            border: Border.all(
              color: outlineColor,
              width: widget.compactMode ? 1.5 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.6),
                blurRadius:
                    (widget.compactMode ? 6 : 10) * _pulseAnimation.value,
                spreadRadius:
                    (widget.compactMode ? 1 : 2) * _pulseAnimation.value,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 基本角色图像或图标
              Center(
                child: widget.characterAsset != null
                    ? ClipOval(
                        child: Image.asset(
                          widget.characterAsset!,
                          width: widget.size * 0.9,
                          height: widget.size * 0.9,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        widget.icon ?? Icons.person,
                        color: primaryColor,
                        size: widget.size * 0.6,
                      ),
              ),

              // 添加更高效的特效
              if (!widget.compactMode ||
                  widget.player?.passiveSkills.length == 1)
                ...buildSpecialEffects(),

              // 簡化的特效模式
              if (widget.compactMode &&
                  (widget.player?.passiveSkills.length ?? 0) > 1)
                _buildCompactEffects(),

              // 無敵特效
              if (widget.isInvulnerable) _buildInvulnerabilityEffect(),
            ],
          ),
        );
      },
    );
  }

  // 簡化特效顯示
  Widget _buildCompactEffects() {
    if (widget.player == null || widget.player!.passiveSkills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '${widget.player!.passiveSkills.length}',
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.size * 0.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // 構建連擊計數器
  Widget _buildComboCounter() {
    final offsetMultiplier = widget.compactMode ? 0.7 : 1.0;

    return Positioned(
      top: -15 * offsetMultiplier,
      right: -15 * offsetMultiplier,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.9, end: 1.1),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: widget.compactMode ? 6 : 8,
              vertical: widget.compactMode ? 2 : 4),
          decoration: BoxDecoration(
            color: Colors.red.shade700,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Text(
            '${widget.comboCount}x',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: widget.compactMode ? 10 : 12,
            ),
          ),
        ),
      ),
    );
  }

  // 構建境界指示器
  Widget _buildRealmIndicator() {
    if (widget.player == null) return const SizedBox.shrink();

    final offsetMultiplier = widget.compactMode ? 0.7 : 1.0;

    return Positioned(
      bottom: -12 * offsetMultiplier,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: widget.compactMode ? 4 : 6,
              vertical: widget.compactMode ? 1 : 2),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _getRealmColor(widget.player!.cultivationRealm),
              width: 1,
            ),
          ),
          child: Text(
            widget.player!.cultivationRealm,
            style: TextStyle(
              color: _getRealmColor(widget.player!.cultivationRealm),
              fontSize: widget.compactMode ? 8 : 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // 構建無敵效果
  Widget _buildInvulnerabilityEffect() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 2 * pi),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return CustomPaint(
          painter: InvulnerabilityPainter(
            rotationAngle: value,
            isCompact: widget.compactMode,
          ),
          child: child,
        );
      },
    );
  }

  // 構建特殊效果
  List<Widget> buildSpecialEffects() {
    final effects = <Widget>[];

    // 如果有玩家數據，添加被動技能效果
    if (widget.player != null) {
      // 檢查被動技能
      for (final skill in widget.player!.passiveSkills) {
        switch (skill) {
          case '靈力回復':
            effects.add(
              Positioned.fill(
                child: CustomPaint(
                  painter: RecoveryAuraPainter(
                    isCompact: widget.compactMode,
                  ),
                ),
              ),
            );
            break;

          case '靈氣護盾':
            effects.add(
              Positioned.fill(
                child: CustomPaint(
                  painter: ShieldAuraPainter(
                    level: widget.player!.getPassiveSkillLevel(skill),
                    isCompact: widget.compactMode,
                  ),
                ),
              ),
            );
            break;

          case '五行相生':
            effects.add(
              Positioned.fill(
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 2 * pi),
                  duration: const Duration(seconds: 5),
                  builder: (context, value, child) {
                    return CustomPaint(
                      painter: ElementalOrbitalPainter(
                        rotationAngle: value,
                        orbCount:
                            min(widget.player!.getPassiveSkillLevel(skill), 5),
                        isCompact: widget.compactMode,
                      ),
                    );
                  },
                ),
              ),
            );
            break;
        }
      }
    }

    return effects;
  }

  // 根據境界獲取顏色
  Color _getRealmColor(String realm) {
    switch (realm) {
      case '築基期':
        return Colors.green.shade400;
      case '結丹期':
        return Colors.blue.shade400;
      case '元嬰期':
        return Colors.purple.shade400;
      case '化神期':
        return Colors.amber.shade400;
      case '煉虛期':
        return Colors.red.shade400;
      case '大乘期':
        return Colors.pink.shade300;
      case '渡劫期':
        return Colors.white;
      default: // 煉氣期
        return Colors.cyan.shade300;
    }
  }

  // 根據境界獲取輪廓顏色
  Color _getRealmOutlineColor(String realm) {
    switch (realm) {
      case '築基期':
        return Colors.green.shade700;
      case '結丹期':
        return Colors.blue.shade700;
      case '元嬰期':
        return Colors.purple.shade700;
      case '化神期':
        return Colors.amber.shade700;
      case '煉虛期':
        return Colors.red.shade700;
      case '大乘期':
        return Colors.pink.shade700;
      case '渡劫期':
        return Colors.yellow;
      default: // 煉氣期
        return Colors.cyan.shade700;
    }
  }
}

// 恢復光環畫筆
class RecoveryAuraPainter extends CustomPainter {
  final bool isCompact;

  RecoveryAuraPainter({this.isCompact = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 光暈效果
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.green.withOpacity(isCompact ? 0.3 : 0.5),
          Colors.green.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);

    // 減少氣泡數量
    if (isCompact) return;

    // 小氣泡效果
    final bubblePaint = Paint()..color = Colors.green.withOpacity(0.7);

    final random = Random();
    for (var i = 0; i < (isCompact ? 3 : 5); i++) {
      final angle = random.nextDouble() * 2 * pi;
      final distance = random.nextDouble() * radius * 0.8;
      final bubbleSize =
          random.nextDouble() * (isCompact ? 3 : 4) + (isCompact ? 1 : 2);

      final bubblePos = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance,
      );

      canvas.drawCircle(bubblePos, bubbleSize, bubblePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

// 護盾光環畫筆
class ShieldAuraPainter extends CustomPainter {
  final int level;
  final bool isCompact;

  ShieldAuraPainter({this.level = 1, this.isCompact = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isCompact ? (0.7 + level * 0.3) : (1.0 + level * 0.5);

    // 減少護盾層數
    final maxLayers = isCompact ? 2 : 3;
    for (var i = 0; i < min(level, maxLayers); i++) {
      canvas.drawCircle(
          center, radius * (0.8 + i * (isCompact ? 0.08 : 0.1)), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      oldDelegate is ShieldAuraPainter &&
      (oldDelegate.level != level || oldDelegate.isCompact != isCompact);
}

// 五行相生畫筆
class ElementalOrbitalPainter extends CustomPainter {
  final double rotationAngle;
  final int orbCount;
  final bool isCompact;

  ElementalOrbitalPainter({
    required this.rotationAngle,
    this.orbCount = 5,
    this.isCompact = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 五行顏色
    final colors = [
      Colors.green, // 木
      Colors.red, // 火
      Colors.amber, // 土
      Colors.grey, // 金
      Colors.blue, // 水
    ];

    // 繪製環繞的五行珠
    for (var i = 0; i < min(orbCount, colors.length); i++) {
      final angle = rotationAngle + (i * 2 * pi / orbCount);
      final orbPos = Offset(
        center.dx + cos(angle) * radius * (isCompact ? 0.85 : 0.9),
        center.dy + sin(angle) * radius * (isCompact ? 0.85 : 0.9),
      );

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      // 繪製元素珠
      final orbSize = isCompact ? radius * 0.1 : radius * 0.15;
      canvas.drawCircle(orbPos, orbSize, paint);

      // 只在非緊湊模式下繪製光暈
      if (!isCompact) {
        final glowPaint = Paint()
          ..shader = RadialGradient(
            colors: [
              colors[i].withOpacity(0.7),
              colors[i].withOpacity(0.0),
            ],
          ).createShader(
              Rect.fromCircle(center: orbPos, radius: radius * 0.25));

        canvas.drawCircle(orbPos, radius * 0.25, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant ElementalOrbitalPainter oldDelegate) =>
      oldDelegate.rotationAngle != rotationAngle ||
      oldDelegate.orbCount != orbCount ||
      oldDelegate.isCompact != isCompact;
}

// 無敵效果畫筆
class InvulnerabilityPainter extends CustomPainter {
  final double rotationAngle;
  final bool isCompact;

  InvulnerabilityPainter({
    required this.rotationAngle,
    this.isCompact = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 金色屏障
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(isCompact ? 0.4 : 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isCompact ? 1.5 : 2;

    canvas.drawCircle(center, radius * (isCompact ? 1.05 : 1.1), paint);

    // 在緊湊模式下減少紋路
    if (isCompact) return;

    // 旋轉的護盾紋路
    final pathPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 繪製兩個相交的圓形紋路
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);

    // 第一個橢圓
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 1.2,
        height: size.height * 0.7,
      ),
      pathPaint,
    );

    // 第二個橢圓（垂直於第一個）
    canvas.rotate(pi / 2);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 1.2,
        height: size.height * 0.7,
      ),
      pathPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant InvulnerabilityPainter oldDelegate) =>
      oldDelegate.rotationAngle != rotationAngle ||
      oldDelegate.isCompact != isCompact;
}

// 輔助函數
int min(int a, int b) {
  return a < b ? a : b;
}
