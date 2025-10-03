import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/glow_button_widget.dart';
import 'game_screen.dart';
import 'level_challenge_screen.dart';
import 'how_to_play_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Custom painter for subtle grid pattern
  static const double _gridSpacing = 40.0;

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
              UIConstants.PURPLE_COLOR.withOpacity(0.25),
              UIConstants.BACKGROUND_COLOR.withOpacity(0.9),
              UIConstants.BACKGROUND_COLOR,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -100,
              right: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      UIConstants.PURPLE_COLOR.withOpacity(0.25),
                      UIConstants.PURPLE_COLOR.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              left: -60,
              child: Container(
                width: 250,
                height: 250,
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

            // Subtle grid pattern
            CustomPaint(painter: _HomeGridPainter(), size: Size.infinite),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(UIConstants.SPACING_LARGE),
                child: Column(
                  children: [
                    // Enhanced title section
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // App logo/icon
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(
                                bottom: UIConstants.SPACING_LARGE,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    UIConstants.PURPLE_COLOR,
                                    UIConstants.CYAN_COLOR,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: UIConstants.PURPLE_COLOR.withOpacity(
                                      0.5,
                                    ),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: UIConstants.CYAN_COLOR.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 15,
                                    spreadRadius: 1,
                                    offset: const Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "C",
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // App title with gradient effect
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
                                  stops: const [0.2, 0.6, 1.0],
                                ).createShader(bounds);
                              },
                              child: const Text(
                                TextConstants.APP_NAME,
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -2.0,
                                  height: 0.9,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: UIConstants.SPACING_MEDIUM),
                            // Tagline with glowing effect
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: UIConstants.SPACING_LARGE,
                                vertical: UIConstants.SPACING_SMALL,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                  UIConstants.BORDER_RADIUS_LARGE,
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                TextConstants.APP_TAGLINE,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Enhanced buttons section with animation and improved styling
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          UIConstants.BORDER_RADIUS_LARGE,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: UIConstants.ACCENT_GLOW.withOpacity(0.1),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Start Game button - main action
                          GlowButton(
                            type: GlowButtonType.primary,
                            fullWidth: true,
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            borderRadius: BorderRadius.circular(
                              UIConstants.BORDER_RADIUS_LARGE,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const GameScreen(),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        const begin = Offset(0.0, 0.2);
                                        const end = Offset.zero;
                                        const curve = Curves.easeOutCubic;

                                        var tween = Tween(
                                          begin: begin,
                                          end: end,
                                        ).chain(CurveTween(curve: curve));
                                        var offsetAnimation = animation.drive(
                                          tween,
                                        );

                                        return FadeTransition(
                                          opacity: animation,
                                          child: SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          ),
                                        );
                                      },
                                  transitionDuration: const Duration(
                                    milliseconds: 500,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(
                                  width: UIConstants.SPACING_MEDIUM,
                                ),
                                const Text(
                                  TextConstants.START_GAME,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: UIConstants.SPACING_LARGE),

                          // Level Challenge button with enhanced styling
                          GlowButton(
                            type: GlowButtonType.glass,
                            fullWidth: true,
                            borderRadius: BorderRadius.circular(
                              UIConstants.BORDER_RADIUS_LARGE,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const LevelChallengeScreen(),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                  transitionDuration: const Duration(
                                    milliseconds: 400,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: UIConstants.PURPLE_COLOR.withOpacity(
                                      0.2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.layers_rounded,
                                    color: UIConstants.PURPLE_COLOR,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(
                                  width: UIConstants.SPACING_MEDIUM,
                                ),
                                ShaderMask(
                                  shaderCallback: (bounds) {
                                    return LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white,
                                        UIConstants.PURPLE_COLOR.withOpacity(
                                          0.8,
                                        ),
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: const Text(
                                    TextConstants.LEVEL_CHALLENGE,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: UIConstants.SPACING_MEDIUM),

                          // How to Play button with enhanced styling
                          GlowButton(
                            type: GlowButtonType.glass,
                            fullWidth: true,
                            borderRadius: BorderRadius.circular(
                              UIConstants.BORDER_RADIUS_LARGE,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const HowToPlayScreen(),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                  transitionDuration: const Duration(
                                    milliseconds: 400,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: UIConstants.CYAN_COLOR.withOpacity(
                                      0.2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.book_rounded,
                                    color: UIConstants.CYAN_COLOR,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(
                                  width: UIConstants.SPACING_MEDIUM,
                                ),
                                ShaderMask(
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
                                  child: const Text(
                                    TextConstants.HOW_TO_PLAY,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: UIConstants.SPACING_MEDIUM),

                          // Stats and Settings buttons with enhanced styling
                          Row(
                            children: [
                              // Stats button
                              Expanded(
                                child: GlowButton(
                                  type: GlowButtonType.glass,
                                  borderRadius: BorderRadius.circular(
                                    UIConstants.BORDER_RADIUS_LARGE,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                            ) => const StatsScreen(),
                                        transitionsBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                              child,
                                            ) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                        transitionDuration: const Duration(
                                          milliseconds: 400,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.bar_chart_rounded,
                                          color: Colors.green[400],
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: UIConstants.SPACING_SMALL,
                                      ),
                                      const Text(
                                        TextConstants.STATS,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: UIConstants.SPACING_LARGE),

                              // Settings button
                              Expanded(
                                child: GlowButton(
                                  type: GlowButtonType.glass,
                                  borderRadius: BorderRadius.circular(
                                    UIConstants.BORDER_RADIUS_LARGE,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                            ) => const SettingsScreen(),
                                        transitionsBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                              child,
                                            ) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                        transitionDuration: const Duration(
                                          milliseconds: 400,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.settings_rounded,
                                          color: Colors.grey[300],
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: UIConstants.SPACING_SMALL,
                                      ),
                                      const Text(
                                        TextConstants.SETTINGS,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for subtle grid pattern in home screen
class _HomeGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Draw subtle grid pattern
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Horizontal lines
    for (double y = 0; y < height; y += HomeScreen._gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }

    // Vertical lines
    for (double x = 0; x < width; x += HomeScreen._gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, height), gridPaint);
    }

    // Draw diagonal accent lines
    final accentPaint = Paint()
      ..color = UIConstants.PURPLE_COLOR.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Top-left to bottom-right
    canvas.drawLine(Offset(0, 0), Offset(width, height), accentPaint);

    // Top-right to bottom-left
    canvas.drawLine(Offset(width, 0), Offset(0, height), accentPaint);

    // Additional diagonal accents
    canvas.drawLine(
      Offset(width * 0.25, 0),
      Offset(width, height * 0.75),
      accentPaint,
    );
    canvas.drawLine(
      Offset(0, height * 0.25),
      Offset(width * 0.75, height),
      accentPaint,
    );

    canvas.drawLine(
      Offset(width * 0.75, 0),
      Offset(0, height * 0.75),
      accentPaint,
    );
    canvas.drawLine(
      Offset(width, height * 0.25),
      Offset(width * 0.25, height),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
