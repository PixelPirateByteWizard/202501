import 'package:flutter/material.dart';
import '../utils/constants.dart';

class GameTipWidget extends StatefulWidget {
  const GameTipWidget({super.key});

  @override
  State<GameTipWidget> createState() => _GameTipWidgetState();
}

class _GameTipWidgetState extends State<GameTipWidget> {
  int _currentTipIndex = 0;
  final List<GameTip> _tips = [
    GameTip(
      text: "1 and 2 merge into 3, other identical tiles double in value",
      icon: Icons.add_circle_outline,
    ),
    GameTip(
      text: "New tiles appear from the edge opposite to your swipe",
      icon: Icons.arrow_forward,
    ),
    GameTip(
      text: "Keep high-value tiles in corners to save space",
      icon: Icons.lightbulb_outline,
    ),
    GameTip(
      text: "Numbers 3 and above only merge with identical values",
      icon: Icons.merge_type,
    ),
    GameTip(
      text: "Watch the \"NEXT\" indicator to plan your moves",
      icon: Icons.visibility,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 每8秒切换一次提示
    _startTipRotation();
  }

  void _startTipRotation() {
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _currentTipIndex = (_currentTipIndex + 1) % _tips.length;
        });
        _startTipRotation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTip = _tips[_currentTipIndex];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
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
      child: Container(
        key: ValueKey<int>(_currentTipIndex),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              UIConstants.PURPLE_COLOR.withOpacity(0.15),
              UIConstants.CYAN_COLOR.withOpacity(0.1),
            ],
            stops: const [0.3, 1.0],
          ),
          borderRadius: BorderRadius.circular(UIConstants.BORDER_RADIUS_LARGE),
          border: Border.all(
            color: UIConstants.PURPLE_COLOR.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: UIConstants.ACCENT_GLOW.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: UIConstants.PURPLE_COLOR.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                currentTip.icon,
                size: 18,
                color: UIConstants.PURPLE_COLOR,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, UIConstants.CYAN_COLOR],
                  ).createShader(bounds);
                },
                child: Text(
                  currentTip.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                    height: 1.3,
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

class GameTip {
  final String text;
  final IconData icon;

  GameTip({required this.text, required this.icon});
}
