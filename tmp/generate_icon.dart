import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  // Initialize Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Create a simple icon
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // Draw background
  final bgPaint = Paint()
    ..shader = ui.Gradient.linear(
      const Offset(0, 0),
      const Offset(1024, 1024),
      [const Color(0xFF0D0D0D), const Color(0xFF1C1C1E)],
    );
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 1024, 1024),
      const Radius.circular(240),
    ),
    bgPaint,
  );

  // Draw glow effect
  final glowPaint = Paint()
    ..color = const Color(0xFF805AD5).withOpacity(0.1)
    ..style = PaintingStyle.fill;
  canvas.drawCircle(const Offset(300, 300), 400, glowPaint);

  // Draw tiles
  canvas.save();
  canvas.translate(512, 512);
  canvas.scale(0.8);

  // Blue "1" tile
  canvas.save();
  canvas.translate(-250, -250);
  final bluePaint = Paint()
    ..shader = ui.Gradient.linear(const Offset(0, 0), const Offset(200, 200), [
      const Color(0xFF3B82F6),
      const Color(0xFF1E40AF),
    ]);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 200, 200),
      const Radius.circular(24),
    ),
    bluePaint,
  );

  // Draw "1" text
  final textPainter1 = TextPainter(
    text: const TextSpan(
      text: '1',
      style: TextStyle(
        color: Colors.white,
        fontSize: 120,
        fontWeight: FontWeight.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter1.layout();
  textPainter1.paint(
    canvas,
    Offset(100 - textPainter1.width / 2, 120 - textPainter1.height / 2),
  );
  canvas.restore();

  // Red "2" tile
  canvas.save();
  canvas.translate(50, -250);
  final redPaint = Paint()
    ..shader = ui.Gradient.linear(const Offset(0, 0), const Offset(200, 200), [
      const Color(0xFFEF4444),
      const Color(0xFFB91C1C),
    ]);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 200, 200),
      const Radius.circular(24),
    ),
    redPaint,
  );

  // Draw "2" text
  final textPainter2 = TextPainter(
    text: const TextSpan(
      text: '2',
      style: TextStyle(
        color: Colors.white,
        fontSize: 120,
        fontWeight: FontWeight.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter2.layout();
  textPainter2.paint(
    canvas,
    Offset(100 - textPainter2.width / 2, 120 - textPainter2.height / 2),
  );
  canvas.restore();

  // White "3" tile
  canvas.save();
  canvas.translate(-100, 50);
  final whitePaint = Paint()..color = Colors.white;
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, 0, 200, 200),
      const Radius.circular(24),
    ),
    whitePaint,
  );

  // Draw "3" text
  final textPainter3 = TextPainter(
    text: const TextSpan(
      text: '3',
      style: TextStyle(
        color: Colors.black,
        fontSize: 120,
        fontWeight: FontWeight.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter3.layout();
  textPainter3.paint(
    canvas,
    Offset(100 - textPainter3.width / 2, 120 - textPainter3.height / 2),
  );
  canvas.restore();

  canvas.restore();

  // Convert to image
  final picture = recorder.endRecording();
  final image = await picture.toImage(1024, 1024);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();

  // Save to file
  final file = File('assets/icons/app_icon.png');
  await file.writeAsBytes(buffer);

  print('Icon generated successfully!');
  exit(0);
}
