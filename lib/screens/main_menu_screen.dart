import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/achievement_service.dart';
import 'simple_game_screen.dart';
import 'stats_screen.dart';
import 'achievements_screen.dart';
import 'settings_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  final AchievementService _achievementService = AchievementService();
  late AnimationController _titleController;
  late AnimationController _buttonController;
  late Animation<double> _titleAnimation;
  late Animation<double> _buttonAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeServices();
  }

  void _initializeAnimations() {
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.elasticOut),
    );
    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOutBack),
    );
  }

  Future<void> _initializeServices() async {
    await _achievementService.initialize();
    setState(() {
      _isLoading = false;
    });

    _titleController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _navigateToGame() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SimpleGameScreen(),
      ),
    );
  }

  void _navigateToStats() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const StatsScreen(),
      ),
    );
  }

  void _navigateToAchievements() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AchievementsScreen(),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.background,
                AppColors.background.withOpacity(0.8),
                AppColors.primaryContainer.withOpacity(0.3),
              ],
            ),
          ),
          child: Column(
            children: [
              // Title Section
              Expanded(
                flex: 2,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _titleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _titleAnimation.value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Game Icon
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.accent.withOpacity(0.3),
                                    AppColors.accent,
                                    AppColors.cyanAccent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 20,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.palette,
                                size: 60,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Game Title
                            Text(
                              "Alchemist's Palette",
                              textAlign: TextAlign.center,
                              style: SafeFonts.imFellEnglishSc(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ).copyWith(
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Subtitle
                            Text(
                              'Master the Art of Color Synthesis',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.secondaryText,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Menu Buttons Section
              Expanded(
                flex: 3,
                child: AnimatedBuilder(
                  animation: _buttonAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - _buttonAnimation.value)),
                      child: Opacity(
                        opacity: _buttonAnimation.value.clamp(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildMenuButton(
                                icon: Icons.play_arrow,
                                title: 'Start Game',
                                subtitle: 'Begin your alchemical journey',
                                onTap: _navigateToGame,
                                isPrimary: true,
                              ),
                              const SizedBox(height: 16),
                              _buildMenuButton(
                                icon: Icons.analytics,
                                title: 'Statistics',
                                subtitle: 'View your game history',
                                onTap: _navigateToStats,
                              ),
                              const SizedBox(height: 16),
                              _buildMenuButton(
                                icon: Icons.emoji_events,
                                title: 'Achievements',
                                subtitle:
                                    '${_achievementService.achievements.where((a) => a.isUnlocked).length}/${_achievementService.achievements.length} unlocked',
                                onTap: _navigateToAchievements,
                              ),
                              const SizedBox(height: 16),
                              _buildMenuButton(
                                icon: Icons.settings,
                                title: 'Settings',
                                subtitle: 'Audio, haptics & more',
                                onTap: _navigateToSettings,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Total Achievement Points: ${_achievementService.getTotalPoints()}',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isPrimary
            ? LinearGradient(
                colors: [AppColors.accent, AppColors.cyanAccent],
              )
            : null,
        color: isPrimary ? null : AppColors.primaryContainer.withOpacity(0.7),
        border: Border.all(
          color: isPrimary
              ? Colors.transparent
              : AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                (isPrimary ? AppColors.accent : Colors.black).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPrimary
                        ? Colors.black.withOpacity(0.2)
                        : AppColors.accent.withOpacity(0.2),
                  ),
                  child: Icon(
                    icon,
                    color: isPrimary ? Colors.black : AppColors.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              isPrimary ? Colors.black : AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: isPrimary
                              ? Colors.black.withOpacity(0.7)
                              : AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isPrimary
                      ? Colors.black.withOpacity(0.5)
                      : AppColors.secondaryText,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
