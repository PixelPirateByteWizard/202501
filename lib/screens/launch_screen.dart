import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_gear.dart';
import '../services/onboarding_service.dart';
import 'main_menu_screen.dart';
import 'onboarding_screen.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final OnboardingService _onboardingService = OnboardingService();

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startGame() async {
    final isOnboardingComplete = await _onboardingService.isOnboardingComplete();
    
    if (!mounted) return;
    
    Widget nextScreen;
    if (isOnboardingComplete) {
      nextScreen = const MainMenuScreen();
    } else {
      nextScreen = const OnboardingScreen();
    }
    
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepNavy, AppColors.slateBlue],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Animated Logo
                    AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationController.value * 2 * 3.14159,
                          child: Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.vintageGold,
                                width: 4,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    margin: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.vintageGold.withValues(
                                          alpha: 0.7,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    margin: const EdgeInsets.all(32),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.vintageGold.withValues(
                                          alpha: 0.5,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                const Center(
                                  child: AnimatedGear(
                                    size: 48,
                                    color: AppColors.vintageGold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Title
                    Text(
                      'Clockwork Legacy',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 36,
                        letterSpacing: 2,
                      ),
                  textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      '"Every Gear Tells a Story"',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.lavenderWhite.withValues(alpha: 0.8),
                        fontStyle: FontStyle.italic,
                      ),
                  textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 64),

                    // Start Button
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: ElevatedButton.icon(
                            onPressed: _startGame,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text(
                              'Start Game',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                const SizedBox(height: 64),
              // Bottom indicator
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.vintageGold.withValues(
                          alpha: _pulseAnimation.value,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
