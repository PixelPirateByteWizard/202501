import 'package:flutter/material.dart';
import '../models/goal.dart';
import 'goal_card.dart';

class AnimatedGoalCard extends StatefulWidget {
  final Goal goal;
  final VoidCallback onDelete;
  final Function(double progress, {double? value, String? note, bool isTotal})
      onProgressUpdate;
  final int index;

  const AnimatedGoalCard({
    Key? key,
    required this.goal,
    required this.onDelete,
    required this.onProgressUpdate,
    required this.index,
  }) : super(key: key);

  @override
  State<AnimatedGoalCard> createState() => _AnimatedGoalCardState();
}

class _AnimatedGoalCardState extends State<AnimatedGoalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Delay animation to create cascade effect
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: GoalCard(
        goal: widget.goal,
        onDelete: widget.onDelete,
        onProgressUpdate: widget.onProgressUpdate,
      ),
    );
  }
}
