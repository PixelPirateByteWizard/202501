import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final int backgroundIndex;
  final double overlayOpacity;

  const AppBackground({
    super.key,
    required this.child,
    this.backgroundIndex = 1,
    this.overlayOpacity = 0.7,
  });

  @override
  Widget build(BuildContext context) {
    final String bgPath = 'assets/bg/BG_$backgroundIndex.png';

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          bgPath,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        // Overlay to reduce visual impact
        Container(
          color: Colors.black.withOpacity(overlayOpacity),
        ),
        // Content
        child,
      ],
    );
  }
}
