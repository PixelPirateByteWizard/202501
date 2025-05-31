import 'dart:math';
import 'package:flutter/material.dart';
import '../models/enemy.dart';
import '../utils/constants.dart';
import '../utils/game_utils.dart';

class EnemyComponent extends StatelessWidget {
  final Enemy enemy;

  const EnemyComponent({
    Key? key,
    required this.enemy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 變換角度（用於敵人視覺效果）
    final angle = enemy.patternPhase;

    // 健康條寬度
    final healthBarWidth = GameConstants.enemySize * 1.2;

    return Positioned(
      left: enemy.position.x - GameConstants.enemySize / 2,
      top: enemy.position.y - GameConstants.enemySize / 2,
      child: Stack(
        children: [
          // 狀態效果顯示（在敵人下方）
          if (enemy.isBurning || enemy.isSlowed || enemy.isStunned)
            _buildStatusEffects(),

          // 主要敵人顯示
          Transform.rotate(
            angle: angle,
            child: Container(
              width: GameConstants.enemySize,
              height: GameConstants.enemySize,
              decoration: BoxDecoration(
                color: _getEnemyBaseColor().withOpacity(0.6),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getEnemyBorderColor(),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getEnemyBaseColor().withOpacity(0.3),
                    blurRadius: enemy.isSpecialtyActive ? 15 : 8,
                    spreadRadius: enemy.isSpecialtyActive ? 5 : 2,
                  ),
                ],
              ),
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    enemy.assetPath,
                    width: GameConstants.enemySize * 0.8,
                    height: GameConstants.enemySize * 0.8,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // 特殊能力效果
          if (enemy.isSpecialtyActive) _buildSpecialtyEffect(),

          // 健康條（在敵人上方）
          Positioned(
            top: -10,
            left: (GameConstants.enemySize - healthBarWidth) / 2,
            child: Container(
              width: healthBarWidth,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade800.withOpacity(0.7),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                children: [
                  Container(
                    width: healthBarWidth * (enemy.health / enemy.maxHealth),
                    decoration: BoxDecoration(
                      color: _getHealthColor(),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 根據敵人類型獲取基礎顏色
  Color _getEnemyBaseColor() {
    switch (enemy.type) {
      case 'ghostFiend': // 鬼煞
        return Colors.teal;
      case 'demonBeast': // 妖獸
        return Colors.deepOrange;
      case 'evilCultist': // 邪修
        return Colors.purple;
      case 'undeadSoul': // 怨魂
        return Colors.blueGrey;
      case 'bossFiend': // 魔王
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // 獲取邊框顏色（受狀態影響）
  Color _getEnemyBorderColor() {
    if (enemy.isStunned) {
      return Colors.yellow;
    } else if (enemy.isBurning) {
      return Colors.orange;
    } else if (enemy.isSlowed) {
      return Colors.lightBlue;
    } else {
      return _getEnemyBaseColor().withOpacity(0.8);
    }
  }

  // 根據健康百分比獲取顏色
  Color _getHealthColor() {
    final healthPercent = enemy.health / enemy.maxHealth;
    if (healthPercent > 0.6) {
      return Colors.green;
    } else if (healthPercent > 0.3) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  // 建構狀態效果顯示
  Widget _buildStatusEffects() {
    final effects = <Widget>[];

    // 添加灼燒效果
    if (enemy.isBurning) {
      effects.add(
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.orange.withOpacity(0.6),
                  Colors.orange.withOpacity(0.0),
                ],
              ),
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: Colors.deepOrange,
              size: 14,
            ),
          ),
        ),
      );
    }

    // 添加減速效果
    if (enemy.isSlowed) {
      effects.add(
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.lightBlue.withOpacity(0.7),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.slow_motion_video,
              color: Colors.lightBlue,
              size: 14,
            ),
          ),
        ),
      );
    }

    // 添加暈眩效果
    if (enemy.isStunned) {
      effects.add(
        Positioned.fill(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 2 * pi),
            duration: const Duration(seconds: 1),
            builder: (context, value, child) {
              return CustomPaint(
                painter: StunPainter(
                  color: Colors.yellow,
                  angle: value,
                ),
              );
            },
          ),
        ),
      );
    }

    // Add a SizedBox with definite size around the Stack
    return SizedBox(
      width: GameConstants.enemySize,
      height: GameConstants.enemySize,
      child: Stack(children: effects),
    );
  }

  // 建構特殊能力效果
  Widget _buildSpecialtyEffect() {
    switch (enemy.specialty) {
      case 'dodge': // 閃避效果
        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.8),
                width: 2,
              ),
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.8, end: 1.2),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.cyanAccent.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.air,
                      color: Colors.cyanAccent,
                      size: 18,
                    ),
                  ),
                );
              },
            ),
          ),
        );

      case 'armor': // 護甲效果
        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.orange.withOpacity(0.8),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.shield,
              color: Colors.orange,
              size: 18,
            ),
          ),
        );

      case 'summon': // 召喚效果
        return Positioned.fill(
          child: SizedBox(
            width: GameConstants.enemySize,
            height: GameConstants.enemySize,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 2 * pi),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return CustomPaint(
                  size: Size(GameConstants.enemySize, GameConstants.enemySize),
                  painter: SummonPainter(
                    color: Colors.purpleAccent,
                    angle: value,
                  ),
                );
              },
            ),
          ),
        );

      case 'phase': // 無實體效果
        return Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.5),
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.6, end: 0.9),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: const Icon(
                    Icons.blur_on,
                    color: Colors.white70,
                    size: 24,
                  ),
                );
              },
            ),
          ),
        );

      case 'rage': // 憤怒效果
        return Positioned.fill(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.9, end: 1.1),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.red.withOpacity(value * 0.6),
                      Colors.red.withOpacity(0),
                    ],
                  ),
                ),
                child: Transform.scale(
                  scale: value,
                  child: const Icon(
                    Icons.whatshot,
                    color: Colors.deepOrange,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

// 暈眩效果繪製器
class StunPainter extends CustomPainter {
  final Color color;
  final double angle;

  StunPainter({required this.color, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 繪製旋轉的星星
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    const starPoints = 4;
    final path = Path();

    for (int i = 0; i < starPoints; i++) {
      final outerAngle = i * 2 * pi / starPoints;
      final innerAngle = outerAngle + pi / starPoints;

      final outerX = cos(outerAngle) * radius;
      final outerY = sin(outerAngle) * radius;

      final innerX = cos(innerAngle) * radius * 0.4;
      final innerY = sin(innerAngle) * radius * 0.4;

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }

      path.lineTo(innerX, innerY);
    }

    path.close();
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(StunPainter oldDelegate) =>
      oldDelegate.angle != angle || oldDelegate.color != color;
}

// 召喚效果繪製器
class SummonPainter extends CustomPainter {
  final Color color;
  final double angle;

  SummonPainter({required this.color, required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 繪製符文圓圈
    canvas.drawCircle(center, radius * 0.7, paint);

    // 繪製圓周符文
    const runeCount = 5;
    final runePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);

    for (int i = 0; i < runeCount; i++) {
      final runeAngle = i * 2 * pi / runeCount;
      final runeX = cos(runeAngle) * radius * 0.7;
      final runeY = sin(runeAngle) * radius * 0.7;

      canvas.drawCircle(Offset(runeX, runeY), 2, runePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(SummonPainter oldDelegate) =>
      oldDelegate.angle != angle || oldDelegate.color != color;
}
