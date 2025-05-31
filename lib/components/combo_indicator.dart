import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ComboIndicator extends StatefulWidget {
  final int comboCount;
  final double comboMultiplier;

  const ComboIndicator({
    Key? key,
    required this.comboCount,
    required this.comboMultiplier,
  }) : super(key: key);

  @override
  State<ComboIndicator> createState() => _ComboIndicatorState();
}

class _ComboIndicatorState extends State<ComboIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _previousCombo = 0;

  @override
  void initState() {
    super.initState();
    _previousCombo = widget.comboCount;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(ComboIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.comboCount > _previousCombo) {
      _controller.forward(from: 0.0);
    }
    _previousCombo = widget.comboCount;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 如果沒有連擊，則不顯示
    if (widget.comboCount == 0) {
      return const SizedBox.shrink();
    }

    // 根據連擊數調整顏色
    Color comboColor;
    if (widget.comboCount >= 50) {
      comboColor = Colors.purple.shade300;
    } else if (widget.comboCount >= 30) {
      comboColor = Colors.red.shade300;
    } else if (widget.comboCount >= 15) {
      comboColor = Colors.orange.shade300;
    } else if (widget.comboCount >= 5) {
      comboColor = Colors.amber.shade300;
    } else {
      comboColor = Colors.white;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: comboColor.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 連擊計數
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.flash_on,
                  color: comboColor,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  '連擊 ${widget.comboCount}',
                  style: AppConstants.bodyLarge.copyWith(
                    color: comboColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // 倍率顯示
            Text(
              'x${widget.comboMultiplier.toStringAsFixed(1)}',
              style: TextStyle(
                color: comboColor.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
