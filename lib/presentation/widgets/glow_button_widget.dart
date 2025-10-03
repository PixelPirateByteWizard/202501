import 'package:flutter/material.dart';
import '../utils/constants.dart';

enum GlowButtonType { primary, secondary, glass }

class GlowButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final GlowButtonType type;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool fullWidth;
  final double? width;
  final double? height;

  const GlowButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.type = GlowButtonType.primary,
    this.padding,
    this.borderRadius,
    this.fullWidth = false,
    this.width,
    this.height,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Configure button appearance based on type
    BoxDecoration decoration;
    switch (widget.type) {
      case GlowButtonType.primary:
        decoration = BoxDecoration(
          gradient: const LinearGradient(
            colors: [UIConstants.PURPLE_COLOR, Color(0xFF4C1D95)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(UIConstants.BORDER_RADIUS_MEDIUM),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: UIConstants.PURPLE_COLOR.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        );
        break;
      case GlowButtonType.secondary:
        decoration = BoxDecoration(
          gradient: const LinearGradient(
            colors: [UIConstants.CYAN_COLOR, Color(0xFF0891B2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(UIConstants.BORDER_RADIUS_MEDIUM),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: UIConstants.CYAN_COLOR.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        );
        break;
      case GlowButtonType.glass:
        decoration = BoxDecoration(
          color: UIConstants.GLASS_CARD_COLOR,
          borderRadius:
              widget.borderRadius ??
              BorderRadius.circular(UIConstants.BORDER_RADIUS_MEDIUM),
          border: Border.all(
            color: UIConstants.GLASS_CARD_BORDER_COLOR,
            width: 1,
          ),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        );
        break;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.onPressed,
            child: Container(
              width: widget.fullWidth ? double.infinity : widget.width,
              height: widget.height,
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(
                    vertical: UIConstants.SPACING_MEDIUM,
                    horizontal: UIConstants.SPACING_LARGE,
                  ),
              decoration: decoration,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
