import 'package:flutter/material.dart';
import 'constants.dart';

class AppIcon extends StatelessWidget {
  final double size;
  final bool animate;

  const AppIcon({super.key, this.size = 100.0, this.animate = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: animate
          ? TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: CustomPaint(
                    painter: AppIconPainter(),
                    size: Size(size, size),
                  ),
                );
              },
            )
          : CustomPaint(painter: AppIconPainter(), size: Size(size, size)),
    );
  }
}

class AppIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final tileSize = width / 2.2;
    final spacing = width * 0.05;

    // Background
    final backgroundPaint = Paint()
      ..color = UIConstants.BACKGROUND_COLOR
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), backgroundPaint);

    // Draw tiles in a grid pattern
    _drawTile(
      canvas,
      Offset(spacing, spacing),
      tileSize,
      UIConstants.TILE_ONE_COLOR,
      "1",
    );

    _drawTile(
      canvas,
      Offset(tileSize + spacing * 2, spacing),
      tileSize,
      UIConstants.TILE_TWO_COLOR,
      "2",
    );

    _drawTile(
      canvas,
      Offset(spacing, tileSize + spacing * 2),
      tileSize,
      UIConstants.TILE_THREE_PLUS_COLOR,
      "3",
      textColor: Colors.black,
    );

    // Draw a special tile for higher values
    _drawTile(
      canvas,
      Offset(tileSize + spacing * 2, tileSize + spacing * 2),
      tileSize,
      UIConstants.PURPLE_COLOR,
      "C",
    );

    // Draw glow effect
    final glowPaint = Paint()
      ..color = UIConstants.PURPLE_COLOR.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(Offset(width / 2, height / 2), width * 0.6, glowPaint);
  }

  void _drawTile(
    Canvas canvas,
    Offset position,
    double size,
    Color color,
    String text, {
    Color textColor = Colors.white,
  }) {
    // Draw tile shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(position.dx + 2, position.dy + 2, size, size),
        const Radius.circular(8),
      ),
      shadowPaint,
    );

    // Draw tile background with gradient
    final rect = Rect.fromLTWH(position.dx, position.dy, size, size);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, color.withOpacity(0.7)],
    );

    final tilePaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      tilePaint,
    );

    // Draw border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      borderPaint,
    );

    // Draw text
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: size * 0.5,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx + (size - textPainter.width) / 2,
        position.dy + (size - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
