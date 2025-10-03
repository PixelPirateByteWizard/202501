import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? blur;
  final VoidCallback? onTap;
  final Border? border;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.blur,
    this.onTap,
    this.border,
    this.width,
    this.height,
    this.constraints,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor =
        borderColor ?? UIConstants.GLASS_CARD_BORDER_COLOR;
    final effectiveBlur = blur ?? UIConstants.GLASS_CARD_BLUR;
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(UIConstants.BORDER_RADIUS_MEDIUM);

    final effectiveBorder =
        border ?? Border.all(color: effectiveBorderColor, width: 1);

    Widget content = ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
        child: Container(
          width: width,
          height: height,
          constraints: constraints,
          alignment: alignment,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                UIConstants.CARD_GRADIENT_START,
                UIConstants.CARD_GRADIENT_END,
              ],
            ),
            borderRadius: effectiveBorderRadius,
            border: effectiveBorder,
            boxShadow: [
              BoxShadow(
                color: UIConstants.ACCENT_GLOW,
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: padding ?? EdgeInsets.all(UIConstants.SPACING_MEDIUM),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}
