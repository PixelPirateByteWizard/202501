import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/glass_card_widget.dart';
import '../widgets/glow_button_widget.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;
  final String? gameOverTitle;
  final String? gameOverSubtitle;

  const GameOverScreen({
    super.key,
    required this.score,
    required this.onRestart,
    this.gameOverTitle,
    this.gameOverSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.BACKGROUND_COLOR,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              UIConstants.PURPLE_COLOR.withOpacity(0.3),
              UIConstants.BACKGROUND_COLOR.withOpacity(0.95),
              UIConstants.BACKGROUND_COLOR,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background pattern elements
            Positioned(
              top: -50,
              right: -30,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      UIConstants.PURPLE_COLOR.withOpacity(0.3),
                      UIConstants.PURPLE_COLOR.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -70,
              left: -40,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      UIConstants.CYAN_COLOR.withOpacity(0.2),
                      UIConstants.CYAN_COLOR.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(UIConstants.SPACING_LARGE),
                child: GlassCard(
                  padding: const EdgeInsets.all(UIConstants.SPACING_LARGE),
                  borderRadius: BorderRadius.circular(
                    UIConstants.BORDER_RADIUS_XLARGE,
                  ),
                  backgroundColor: Colors.black.withOpacity(0.4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Game over title with gradient effect
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              UIConstants.PURPLE_COLOR,
                              UIConstants.CYAN_COLOR,
                            ],
                            stops: const [0.2, 0.6, 1.0],
                          ).createShader(bounds);
                        },
                        child: Text(
                          gameOverTitle ?? TextConstants.BOARD_LOCKED,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: UIConstants.SPACING_SMALL),

                      // Subtitle with subtle animation
                      Text(
                        gameOverSubtitle ?? TextConstants.MOMENT_OF_PEACE,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: UIConstants.TEXT_SECONDARY_COLOR,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: UIConstants.SPACING_LARGE * 1.5),

                      // Enhanced final score display
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: UIConstants.SPACING_LARGE,
                          horizontal: UIConstants.SPACING_LARGE,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(0.5),
                              UIConstants.SURFACE_COLOR.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            UIConstants.BORDER_RADIUS_LARGE,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: UIConstants.ACCENT_GLOW.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              TextConstants.FINAL_SCORE,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    letterSpacing: 2.0,
                                    color: UIConstants.TEXT_SECONDARY_COLOR,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                            ),
                            const SizedBox(height: UIConstants.SPACING_MEDIUM),
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    UIConstants.CYAN_COLOR,
                                    UIConstants.PURPLE_COLOR,
                                  ],
                                  stops: const [0.2, 0.5, 0.8],
                                ).createShader(bounds);
                              },
                              child: Text(
                                _formatScore(score),
                                style: const TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -1.0,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: UIConstants.SPACING_LARGE * 1.5),

                      // Enhanced action buttons
                      Row(
                        children: [
                          // Try Again button
                          Expanded(
                            child: GlowButton(
                              type: GlowButtonType.glass,
                              onPressed: onRestart,
                              borderRadius: BorderRadius.circular(
                                UIConstants.BORDER_RADIUS_LARGE,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: UIConstants.SPACING_MEDIUM * 1.2,
                                horizontal: UIConstants.SPACING_MEDIUM,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.refresh_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: UIConstants.SPACING_SMALL,
                                  ),
                                  const Text(
                                    TextConstants.TRY_AGAIN,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: UIConstants.SPACING_LARGE),

                          // Back to Home button with enhanced styling
                          Expanded(
                            child: GlowButton(
                              type: GlowButtonType
                                  .secondary, // Changed to secondary type (cyan color)
                              borderRadius: BorderRadius.circular(
                                UIConstants.BORDER_RADIUS_LARGE,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: UIConstants.SPACING_MEDIUM * 1.2,
                                horizontal: UIConstants.SPACING_MEDIUM,
                              ),
                              onPressed: () {
                                // Navigate back to home screen
                                Navigator.of(
                                  context,
                                ).popUntil((route) => route.isFirst);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.home_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: UIConstants.SPACING_SMALL,
                                  ),
                                  const Text(
                                    TextConstants.BACK_TO_HOME,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
