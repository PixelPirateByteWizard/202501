import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ScoreWidget extends StatelessWidget {
  final String label;
  final int score;
  final double width;

  const ScoreWidget({
    super.key,
    required this.label,
    required this.score,
    this.width = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(
        vertical: UIConstants.SPACING_MEDIUM,
        horizontal: UIConstants.SPACING_MEDIUM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            UIConstants.CARD_GRADIENT_START.withOpacity(0.8),
            UIConstants.CARD_GRADIENT_END.withOpacity(0.9),
          ],
          stops: const [0.2, 0.9],
        ),
        borderRadius: BorderRadius.circular(UIConstants.BORDER_RADIUS_LARGE),
        boxShadow: [
          BoxShadow(
            color: UIConstants.ACCENT_GLOW.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              letterSpacing: 2.0,
              color: UIConstants.TEXT_SECONDARY_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  UIConstants.CYAN_COLOR,
                  UIConstants.PURPLE_COLOR.withOpacity(0.8),
                ],
                stops: const [0.2, 0.6, 1.0],
              ).createShader(bounds);
            },
            child: Text(
              _formatScore(score),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatScore(int score) {
    if (score < 1000) {
      return score.toString();
    } else if (score < 10000) {
      return '${(score / 1000).toStringAsFixed(1)}k';
    } else {
      return '${(score / 1000).toStringAsFixed(0)}k';
    }
  }
}
