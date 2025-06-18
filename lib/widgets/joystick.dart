import 'package:flutter/material.dart';
import 'dart:math' as math;

class Joystick extends StatefulWidget {
  final Function(Offset) onMove;
  final double size;

  const Joystick({
    super.key,
    required this.onMove,
    this.size = 160.0,
  });

  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  Offset _thumbPosition = Offset.zero;

  void _handlePanUpdate(Offset localPosition) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final position = localPosition - center;
    final distance = position.distance;
    final maxDistance = widget.size / 2;

    Offset newThumbPosition;
    if (distance <= maxDistance) {
      newThumbPosition = position;
    } else {
      newThumbPosition = Offset.fromDirection(position.direction, maxDistance);
    }

    final maxMoveDistance = widget.size / 4;
    final moveVectorDistance = newThumbPosition.distance;
    final normalizedVector = moveVectorDistance > 0
        ? Offset(
            (newThumbPosition.dx / maxMoveDistance).clamp(-1.0, 1.0),
            (newThumbPosition.dy / maxMoveDistance).clamp(-1.0, 1.0),
          )
        : Offset.zero;

    widget.onMove(normalizedVector);
    setState(() {
      _thumbPosition = newThumbPosition;
    });
  }

  void _handlePanEnd() {
    setState(() {
      _thumbPosition = Offset.zero;
    });
    widget.onMove(Offset.zero);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: GestureDetector(
        onPanStart: (details) => _handlePanUpdate(details.localPosition),
        onPanUpdate: (details) => _handlePanUpdate(details.localPosition),
        onPanEnd: (details) => _handlePanEnd(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Center(
            child: Transform.translate(
              offset: _thumbPosition,
              child: Container(
                width: widget.size * 0.4,
                height: widget.size * 0.4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
