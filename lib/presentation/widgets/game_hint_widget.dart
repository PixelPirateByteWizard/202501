import 'package:flutter/material.dart';
import '../utils/constants.dart';

class GameHintWidget extends StatefulWidget {
  const GameHintWidget({super.key});

  @override
  State<GameHintWidget> createState() => _GameHintWidgetState();
}

class _GameHintWidgetState extends State<GameHintWidget> {
  int _currentHintIndex = 0;
  final List<String> _hints = [
    "Tip: 1+2=3, same-value tiles merge into doubles",
    "Tip: When swiping up, new tiles appear from bottom",
    "Tip: Keep high-value tiles in corners",
    "Tip: Watch the \"NEXT\" hint to plan your moves",
    "Tip: Numbers 3+ only merge with identical values",
  ];

  @override
  void initState() {
    super.initState();
    // 每10秒切换一次提示
    _startHintRotation();
  }

  void _startHintRotation() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _currentHintIndex = (_currentHintIndex + 1) % _hints.length;
        });
        _startHintRotation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.SPACING_LARGE,
        vertical: UIConstants.SPACING_MEDIUM,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: UIConstants.SPACING_MEDIUM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            UIConstants.CYAN_COLOR.withOpacity(0.15),
            UIConstants.PURPLE_COLOR.withOpacity(0.15),
          ],
          stops: const [0.3, 1.0],
        ),
        borderRadius: BorderRadius.circular(UIConstants.BORDER_RADIUS_LARGE),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: UIConstants.ACCENT_GLOW.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.0, 0.15),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
        child: Row(
          key: ValueKey<int>(_currentHintIndex),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 18,
              color: UIConstants.CYAN_COLOR,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      UIConstants.CYAN_COLOR.withOpacity(0.8),
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  _hints[_currentHintIndex],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
