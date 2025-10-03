import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/haptic_feedback.dart';
import '../widgets/glass_card_widget.dart';
import '../widgets/background_pattern_widget.dart';
import 'game_screen.dart';

class LevelChallengeScreen extends StatefulWidget {
  const LevelChallengeScreen({super.key});

  @override
  State<LevelChallengeScreen> createState() => _LevelChallengeScreenState();
}

class _LevelChallengeScreenState extends State<LevelChallengeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.BACKGROUND_COLOR,
      body: Stack(
        children: [
          // Background pattern
          const Positioned.fill(child: BackgroundPatternWidget()),

          // Decorative elements
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

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back button and title
                  Row(
                    children: [
                      GlassCard(
                        padding: const EdgeInsets.all(
                          UIConstants.SPACING_SMALL,
                        ),
                        borderRadius: BorderRadius.circular(
                          UIConstants.BORDER_RADIUS_XLARGE,
                        ),
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.white70,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: UIConstants.SPACING_MEDIUM),
                      // Title with gradient effect
                      Expanded(
                        child: Center(
                          child: ShaderMask(
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
                              TextConstants.LEVEL_CHALLENGE,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: UIConstants.SPACING_MEDIUM),
                    ],
                  ),
                  const SizedBox(height: UIConstants.SPACING_MEDIUM),

                  // Intro text
                  Container(
                    padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(
                        UIConstants.BORDER_RADIUS_MEDIUM,
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      "Choose a game mode that matches your play style. Each mode offers a unique experience with different challenges.",
                      style: TextStyle(
                        color: UIConstants.TEXT_SECONDARY_COLOR,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  const SizedBox(height: UIConstants.SPACING_LARGE),

                  // Tab bar for mode selection
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: UIConstants.SURFACE_COLOR.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(
                        UIConstants.BORDER_RADIUS_LARGE,
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          UIConstants.BORDER_RADIUS_LARGE,
                        ),
                        color: _getTabColor(_selectedIndex).withOpacity(0.2),
                        border: Border.all(
                          color: _getTabColor(_selectedIndex),
                          width: 2,
                        ),
                      ),
                      labelColor: _getTabColor(_selectedIndex),
                      unselectedLabelColor: Colors.white.withOpacity(0.6),
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                      tabs: const [
                        Tab(text: "ZEN"),
                        Tab(text: "TIME"),
                        Tab(text: "DARK"),
                      ],
                    ),
                  ),
                  const SizedBox(height: UIConstants.SPACING_LARGE),

                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // Zen Mode Tab
                        _buildModeDetailView(
                          icon: Icons.self_improvement,
                          title: TextConstants.ZEN_MODE,
                          description: TextConstants.ZEN_MODE_DESC,
                          features: const [
                            "No game over - play forever",
                            "Board resets when full but keeps score",
                            "Perfect for relaxation and practice",
                            "Focus on strategy without pressure",
                          ],
                          color: UIConstants.PURPLE_COLOR,
                          onPlay: () => _launchGameMode(GameMode.zen),
                          imagePath: 'assets/zen_mode.png',
                        ),

                        // Time Challenge Tab
                        _buildModeDetailView(
                          icon: Icons.timer,
                          title: TextConstants.TIME_CHALLENGE,
                          description: TextConstants.TIME_CHALLENGE_DESC,
                          features: const [
                            "3-minute time limit",
                            "Race against the clock",
                            "Score as high as possible",
                            "Tests speed and efficiency",
                          ],
                          color: UIConstants.CYAN_COLOR,
                          onPlay: () => _launchGameMode(GameMode.timeChallenge),
                          imagePath: 'assets/time_challenge.png',
                        ),

                        // Dark Mode Tab
                        _buildModeDetailView(
                          icon: Icons.dark_mode,
                          title: TextConstants.DARK_MODE,
                          description:
                              "Experience the game in a starry night theme",
                          features: const [
                            "Beautiful starry background",
                            "Enhanced visual effects",
                            "Same gameplay as classic mode",
                            "Easier on the eyes in low light",
                          ],
                          color: UIConstants.DARK_MODE_ACCENT,
                          onPlay: () => _launchGameMode(GameMode.dark),
                          imagePath: 'assets/dark_mode.png',
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
    );
  }

  // Get color based on selected tab
  Color _getTabColor(int index) {
    switch (index) {
      case 0:
        return UIConstants.PURPLE_COLOR;
      case 1:
        return UIConstants.CYAN_COLOR;
      case 2:
        return UIConstants.DARK_MODE_ACCENT;
      default:
        return UIConstants.PURPLE_COLOR;
    }
  }

  // Launch selected game mode
  void _launchGameMode(GameMode mode) {
    // Provide haptic feedback
    HapticFeedbackService.vibrate();

    // Navigate to selected game mode
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            GameScreen(gameMode: mode),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.2);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // Build detailed view for each game mode
  Widget _buildModeDetailView({
    required IconData icon,
    required String title,
    required String description,
    required List<String> features,
    required Color color,
    required VoidCallback onPlay,
    String? imagePath,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode header with icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: UIConstants.SPACING_MEDIUM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: UIConstants.SPACING_LARGE),

          // Mode preview (placeholder for image)
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              vertical: UIConstants.SPACING_MEDIUM,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                UIConstants.BORDER_RADIUS_MEDIUM,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
              ),
              border: Border.all(color: color.withOpacity(0.5), width: 2),
            ),
            child: Center(child: _buildModePreview(color, title)),
          ),

          // Features list
          const SizedBox(height: UIConstants.SPACING_MEDIUM),
          const Text(
            "FEATURES",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: UIConstants.SPACING_SMALL),
          ...features.map((feature) => _buildFeatureItem(feature, color)),

          // Play button
          const SizedBox(height: UIConstants.SPACING_LARGE),
          GestureDetector(
            onTap: onPlay,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.8), color],
                ),
                borderRadius: BorderRadius.circular(
                  UIConstants.BORDER_RADIUS_LARGE,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      "PLAY ${title.toUpperCase()}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: UIConstants.SPACING_LARGE),
        ],
      ),
    );
  }

  // Build feature item with icon
  Widget _buildFeatureItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  // Build mode preview based on the mode
  Widget _buildModePreview(Color color, String mode) {
    if (mode == TextConstants.ZEN_MODE) {
      return _buildZenModePreview(color);
    } else if (mode == TextConstants.TIME_CHALLENGE) {
      return _buildTimeChallengePreview(color);
    } else {
      return _buildDarkModePreview(color);
    }
  }

  // Build preview for Zen mode
  Widget _buildZenModePreview(Color color) {
    return Stack(
      children: [
        // Background elements
        ...List.generate(5, (index) {
          return Positioned(
            left: 20.0 + (index * 30),
            top: 50.0 + (index % 3 * 25),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2 + (index * 0.1)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "${index * 3 + 3}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
        // Infinity symbol
        Center(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.all_inclusive,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }

  // Build preview for Time Challenge mode
  Widget _buildTimeChallengePreview(Color color) {
    return Stack(
      children: [
        // Timer circle
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 4),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "03:00",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "TIME LEFT",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Clock hands animation
        Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CustomPaint(painter: _ClockHandsPainter(color: color)),
          ),
        ),
      ],
    );
  }

  // Build preview for Dark mode
  Widget _buildDarkModePreview(Color color) {
    return Stack(
      children: [
        // Stars background
        ...List.generate(20, (index) {
          return Positioned(
            left: index * 10.0,
            top: (index % 5) * 30.0,
            child: Container(
              width: 2 + (index % 3),
              height: 2 + (index % 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
        // Moon
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ),
        // Moon shadow
        Positioned(
          top: 60,
          left: 120,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for clock hands animation
class _ClockHandsPainter extends CustomPainter {
  final Color color;

  _ClockHandsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Hour hand
    final hourHandPaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Minute hand
    final minuteHandPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Draw hour hand (pointing to 2)
    canvas.drawLine(
      center,
      center +
          Offset(
            radius * 0.4 * cos(2 * 3.14 / 12 * 2 - 3.14 / 2),
            radius * 0.4 * sin(2 * 3.14 / 12 * 2 - 3.14 / 2),
          ),
      hourHandPaint,
    );

    // Draw minute hand (pointing to 12)
    canvas.drawLine(
      center,
      center +
          Offset(
            radius * 0.6 * cos(2 * 3.14 / 60 * 0 - 3.14 / 2),
            radius * 0.6 * sin(2 * 3.14 / 60 * 0 - 3.14 / 2),
          ),
      minuteHandPaint,
    );

    // Center dot
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
