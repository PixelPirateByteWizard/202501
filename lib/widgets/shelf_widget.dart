import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/constants.dart';
import '../models/bottle.dart';

class ShelfWidget extends StatelessWidget {
  final List<Bottle> bottles;
  final Size screenSize;

  const ShelfWidget({
    super.key,
    required this.bottles,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    if (bottles.isEmpty) return const SizedBox.shrink();

    final bottlesPerRow = math.min(GameConstants.maxBottlesPerRow,
        (screenSize.width / (GameConstants.bottleWidth + GameConstants.bottleSpacing)).floor());
    final rowCount = (bottles.length / bottlesPerRow).ceil();
    
    final totalHeight = rowCount * (GameConstants.bottleHeight + 60) - 60;
    final startY = (screenSize.height - totalHeight) / 2 + 20;

    return CustomPaint(
      size: screenSize,
      painter: ShelfPainter(
        rowCount: rowCount,
        startY: startY,
        screenWidth: screenSize.width,
      ),
    );
  }
}

class ShelfPainter extends CustomPainter {
  final int rowCount;
  final double startY;
  final double screenWidth;

  ShelfPainter({
    required this.rowCount,
    required this.startY,
    required this.screenWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shelfPaint = Paint()
      ..color = GameConstants.shelfColor
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = GameConstants.shelfShadowColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < rowCount; i++) {
      final yPos = startY + GameConstants.bottleHeight + 10 + i * (GameConstants.bottleHeight + 60);
      
      // Draw shelf base
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, yPos, screenWidth, 20),
          const Radius.circular(5),
        ),
        shelfPaint,
      );
      
      // Draw shelf shadow
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, yPos + 20, screenWidth, 5),
          const Radius.circular(5),
        ),
        shadowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is ShelfPainter &&
        (oldDelegate.rowCount != rowCount ||
         oldDelegate.startY != startY ||
         oldDelegate.screenWidth != screenWidth);
  }
}