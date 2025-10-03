import 'package:flutter/material.dart';
import '../utils/constants.dart';

class BackgroundPatternWidget extends StatelessWidget {
  const BackgroundPatternWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: BackgroundPatternPainter(), child: Container());
  }
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Draw subtle grid pattern
    final gridPaint = Paint()
      ..color = UIConstants.GRID_LINE_COLOR.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Horizontal lines
    final double gridSpacing = 40;
    for (double y = 0; y < height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Vertical lines
    for (double x = 0; x < width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, height), gridPaint);
    }

    // Draw accent circles
    final accentPaint = Paint()
      ..color = UIConstants.ACCENT_GLOW
      ..style = PaintingStyle.fill;

    // Top-right accent
    canvas.drawCircle(
      Offset(width * 0.85, height * 0.15),
      width * 0.2,
      accentPaint,
    );

    // Bottom-left accent
    canvas.drawCircle(
      Offset(width * 0.15, height * 0.85),
      width * 0.15,
      accentPaint,
    );

    // Draw diagonal lines
    final linePaint = Paint()
      ..color = UIConstants.GRID_LINE_COLOR.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Top-left to bottom-right
    canvas.drawLine(Offset(0, 0), Offset(width, height), linePaint);

    // Top-right to bottom-left
    canvas.drawLine(Offset(width, 0), Offset(0, height), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
