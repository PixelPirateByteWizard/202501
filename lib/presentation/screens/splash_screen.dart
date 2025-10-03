import 'package:flutter/material.dart';
import '../utils/app_icon.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _loadingAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Fade in animation for text
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
      ),
    );

    // Scale animation for text
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // Special animation for the app icon
    _iconScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Animation for the loading indicator
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    // Background glow animation
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _controller.forward();

    // Navigate to home screen after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const HomeScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = 0.0;
                  const end = 1.0;
                  const curve = Curves.easeInOut;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  var fadeAnimation = animation.drive(tween);

                  return FadeTransition(opacity: fadeAnimation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.BACKGROUND_COLOR,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.0,
                colors: [
                  Color.lerp(
                    UIConstants.BACKGROUND_COLOR,
                    UIConstants.PURPLE_COLOR.withOpacity(0.3),
                    _backgroundAnimation.value,
                  )!,
                  UIConstants.BACKGROUND_COLOR,
                ],
                stops: const [0.0, 0.5],
              ),
            ),
            child: Stack(
              children: [
                // Background particles effect (subtle)
                if (_backgroundAnimation.value > 0.5)
                  ...List.generate(10, (index) {
                    final size = 4.0 + (index * 2);
                    // Calculate delay with a cap to prevent Interval begin value from exceeding 1.0
                    final delay =
                        index *
                        0.07; // Reduced from 0.1 to ensure max value is under 1.0
                    final beginValue = 0.3 + delay;
                    // Ensure begin value never exceeds 0.95 (leaving room for the interval)
                    final safeBeginValue = beginValue > 0.95
                        ? 0.95
                        : beginValue;
                    final animation = Tween<double>(begin: 0.0, end: 1.0)
                        .animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Interval(
                              safeBeginValue,
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          ),
                        );

                    return Positioned(
                      left:
                          MediaQuery.of(context).size.width *
                          (0.2 + index * 0.06),
                      top:
                          MediaQuery.of(context).size.height *
                          (0.2 + index * 0.05),
                      child: Opacity(
                        opacity: animation.value * 0.4,
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index % 2 == 0
                                ? UIConstants.PURPLE_COLOR
                                : UIConstants.CYAN_COLOR,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (index % 2 == 0
                                            ? UIConstants.PURPLE_COLOR
                                            : UIConstants.CYAN_COLOR)
                                        .withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                // Main content
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App icon with its own animation
                      Transform.scale(
                        scale: _iconScaleAnimation.value,
                        child: const AppIcon(size: 120),
                      ),
                      const SizedBox(height: 24),

                      // App name and tagline
                      FadeTransition(
                        opacity: _fadeInAnimation,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    colors: [
                                      Colors.white,
                                      UIConstants.PURPLE_COLOR,
                                    ],
                                    stops: [0.4, 1.0],
                                  ).createShader(bounds);
                                },
                                child: const Text(
                                  TextConstants.APP_NAME,
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -2.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                TextConstants.APP_TAGLINE,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFA0AEC0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Loading indicator with fade in
                      FadeTransition(
                        opacity: _loadingAnimation,
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              UIConstants.PURPLE_COLOR,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
