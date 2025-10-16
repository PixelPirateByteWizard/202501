import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomProgressBar extends StatefulWidget {
  final double value;
  final Color color;
  final double height;
  final bool animated;

  const CustomProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.height = 10,
    this.animated = true,
  });

  @override
  State<CustomProgressBar> createState() => _CustomProgressBarState();
}

class _CustomProgressBarState extends State<CustomProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    if (widget.animated) {
      _shimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.slateBlue,
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      child: Stack(
        children: [
          // Progress fill
          FractionallySizedBox(
            widthFactor: widget.value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(widget.height / 2),
              ),
            ),
          ),

          // Shimmer effect
          if (widget.animated)
            AnimatedBuilder(
              animation: _shimmerAnimation,
              builder: (context, child) {
                return FractionallySizedBox(
                  widthFactor: widget.value.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.height / 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.height / 2),
                      child: Transform.translate(
                        offset: Offset(_shimmerAnimation.value * 200, 0),
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.3),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
