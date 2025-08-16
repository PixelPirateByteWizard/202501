import 'package:flutter/material.dart';

class ThemedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Border? border;
  final Gradient? gradient;

  const ThemedCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.border,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF2D3447).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: border ?? Border.all(color: Colors.white.withOpacity(0.08)),
        gradient: gradient,
      ),
      child: child,
    );
  }
}