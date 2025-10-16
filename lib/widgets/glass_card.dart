import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _borderAnimation =
        ColorTween(
          begin: AppColors.glassBorder,
          end: AppColors.vintageGold,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  void _onHover(bool isHovering) {
    if (isHovering) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin,
            child: Material(
              color: Colors.transparent,
              child: MouseRegion(
                onEnter: widget.onTap != null ? (_) => _onHover(true) : null,
                onExit: widget.onTap != null ? (_) => _onHover(false) : null,
                child: GestureDetector(
                  onTapDown: widget.onTap != null ? _onTapDown : null,
                  onTapUp: widget.onTap != null ? _onTapUp : null,
                  onTapCancel: widget.onTap != null ? _onTapCancel : null,
                  child: Container(
                    padding: widget.padding ?? const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.glassBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _borderAnimation.value ?? AppColors.glassBorder,
                        width: 1,
                      ),
                      boxShadow: widget.onTap != null
                          ? [
                              BoxShadow(
                                color:
                                    (_borderAnimation.value ??
                                            AppColors.glassBorder)
                                        .withValues(alpha: 0.2),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
