import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphicContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double blur;
  final Alignment alignment;
  final Widget child;
  final LinearGradient linearGradient;
  final LinearGradient borderGradient;
  final double border;

  const GlassmorphicContainer({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.blur,
    required this.alignment,
    required this.child,
    required this.linearGradient,
    required this.borderGradient,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: linearGradient,
        ),
        child: Stack(
          children: [
            // Blur effect
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: blur,
                sigmaY: blur,
              ),
              child: Container(),
            ),

            // Gradient background
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: linearGradient,
              ),
            ),

            // Border
            if (border > 0)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    width: border,
                  ),
                  gradient: borderGradient,
                ),
              ),

            // Child content
            Container(
              alignment: alignment,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
