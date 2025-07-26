import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/constants.dart';

class LiquidWidget extends StatelessWidget {
  final Color color;
  final int index;
  final int totalLiquids;
  final bool isTopLayer;
  final double bottleWidth;
  final Animation<double>? waveAnimation;

  const LiquidWidget({
    super.key,
    required this.color,
    required this.index,
    required this.totalLiquids,
    required this.isTopLayer,
    required this.bottleWidth,
    this.waveAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: index * GameConstants.liquidHeight,
      left: 0,
      child: SizedBox(
        width: bottleWidth,
        height: GameConstants.liquidHeight,
        child: isTopLayer && waveAnimation != null
            ? AnimatedBuilder(
                animation: waveAnimation!,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(bottleWidth, GameConstants.liquidHeight),
                    painter: WaveLiquidPainter(
                      color: color,
                      waveOffset: waveAnimation!.value,
                    ),
                  );
                },
              )
            : Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
      ),
    );
  }
}

class WaveLiquidPainter extends CustomPainter {
  final Color color;
  final double waveOffset;

  WaveLiquidPainter({
    required this.color,
    required this.waveOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Create wave effect on top
    path.moveTo(0, size.height);
    path.lineTo(0, 8);
    
    for (double x = 0; x <= size.width; x += 2) {
      final y = 8 + (sin((x / size.width * 2 * 3.14159) + waveOffset) * 3);
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is WaveLiquidPainter && oldDelegate.waveOffset != waveOffset;
  }
}