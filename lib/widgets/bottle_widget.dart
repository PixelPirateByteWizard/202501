import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/bottle.dart';
import '../utils/constants.dart';
import '../utils/colors.dart';
import 'liquid_widget.dart';

class BottleWidget extends StatefulWidget {
  final Bottle bottle;
  final bool isSelected;
  final bool isRemovingColor;
  final VoidCallback onTap;
  final Animation<double>? waveAnimation;
  final bool isHinted;

  const BottleWidget({
    super.key,
    required this.bottle,
    required this.isSelected,
    required this.isRemovingColor,
    required this.onTap,
    this.waveAnimation,
    this.isHinted = false,
  });

  @override
  State<BottleWidget> createState() => _BottleWidgetState();
}

class _BottleWidgetState extends State<BottleWidget>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _hintController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _hintAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: GameConstants.shakeDuration,
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));
    
    _hintController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _hintAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _hintController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BottleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Trigger shake animation if bottle is shaking
    if (widget.bottle.isShaking && !oldWidget.bottle.isShaking) {
      _shakeController.forward().then((_) {
        _shakeController.reset();
        widget.bottle.isShaking = false;
      });
    }
    
    // Trigger hint animation
    if (widget.isHinted && !oldWidget.isHinted) {
      _hintController.repeat(reverse: true);
    } else if (!widget.isHinted && oldWidget.isHinted) {
      _hintController.stop();
      _hintController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.bottle.x,
      top: widget.bottle.y,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            final shakeOffset = widget.bottle.isShaking
                ? math.sin(_shakeAnimation.value * math.pi * 8) * 5
                : 0.0;
            
            return AnimatedBuilder(
              animation: _hintAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isHinted ? _hintAnimation.value : 1.0,
                  child: Transform.translate(
                    offset: Offset(shakeOffset, widget.isSelected ? -15 : 0),
                    child: Container(
                      width: GameConstants.bottleWidth,
                      height: GameConstants.bottleHeight,
                      decoration: widget.isHinted ? BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.6),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ) : null,
                      child: Stack(
                  children: [
                    // Liquids
                    ...widget.bottle.liquids.asMap().entries.map((entry) {
                      final index = entry.key;
                      final color = entry.value;
                      final isTopLayer = index == widget.bottle.liquids.length - 1;
                      
                      return LiquidWidget(
                        color: color,
                        index: index,
                        totalLiquids: widget.bottle.liquids.length,
                        isTopLayer: isTopLayer,
                        bottleWidth: GameConstants.bottleWidth,
                        waveAnimation: isTopLayer ? widget.waveAnimation : null,
                      );
                    }),
                    
                    // Bottle outline and effects
                    CustomPaint(
                      size: const Size(GameConstants.bottleWidth, GameConstants.bottleHeight),
                      painter: BottlePainter(
                        isSelected: widget.isSelected,
                        isRemovingColor: widget.isRemovingColor,
                        isSorted: widget.bottle.isSorted && !widget.bottle.isEmpty,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
          },
        ),
      ),
    );
  }
}

class BottlePainter extends CustomPainter {
  final bool isSelected;
  final bool isRemovingColor;
  final bool isSorted;

  BottlePainter({
    required this.isSelected,
    required this.isRemovingColor,
    required this.isSorted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw bottle outline
    paint.color = GameColors.bottleOutlineColor.withOpacity(0.8);
    
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, 20);
    path.quadraticBezierTo(0, 0, 15, 0);
    path.lineTo(size.width - 15, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    
    canvas.drawPath(path, paint);
    
    // Draw bottom line
    canvas.drawLine(
      const Offset(0, GameConstants.bottleHeight),
      const Offset(GameConstants.bottleWidth, GameConstants.bottleHeight),
      paint,
    );

    // Draw highlight
    paint.color = GameColors.bottleHighlightColor.withOpacity(0.4);
    paint.strokeWidth = 2;
    canvas.drawArc(
      const Rect.fromLTWH(
        GameConstants.bottleWidth * 0.2,
        GameConstants.bottleHeight * 0.3,
        12,
        GameConstants.bottleHeight * 0.4,
      ),
      -math.pi / 2,
      math.pi,
      false,
      paint,
    );

    // Draw selection highlight
    if (isSelected || isRemovingColor) {
      paint.color = isRemovingColor
          ? GameColors.eliminatingBottleColor
          : GameColors.selectedBottleColor;
      paint.strokeWidth = 4;
      paint.style = PaintingStyle.stroke;
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-6, -10, size.width + 12, size.height + 15),
          const Radius.circular(20),
        ),
        paint,
      );
    }

    // Draw sorted indicator (cap)
    if (isSorted) {
      paint.style = PaintingStyle.fill;
      paint.color = Colors.grey[600]!;
      
      // Cap base
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width / 2 - 15, -10, 30, 8),
          const Radius.circular(4),
        ),
        paint,
      );
      
      // Cap top
      paint.color = Colors.grey[400]!;
      canvas.drawOval(
        Rect.fromLTWH(size.width / 2 - 15, -12, 30, 8),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is BottlePainter &&
        (oldDelegate.isSelected != isSelected ||
         oldDelegate.isRemovingColor != isRemovingColor ||
         oldDelegate.isSorted != isSorted);
  }
}