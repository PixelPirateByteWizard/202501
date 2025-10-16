import 'package:flutter/material.dart';
import '../models/onboarding_page.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../services/onboarding_service.dart';
import 'main_menu_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  
  int _currentPage = 0;
  bool _isLastPage = false;
  final OnboardingService _onboardingService = OnboardingService();

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to',
      subtitle: 'Clockwork Legacy',
      description: 'Enter a world where steam meets mystery, and every gear tells a story of forgotten civilizations.',
      icon: Icons.settings,
      primaryColor: AppColors.vintageGold,
      secondaryColor: AppColors.deepNavy,
      features: [
        'Immersive steampunk atmosphere',
        'Rich Victorian-era setting',
        'Mysterious ancient technology',
      ],
    ),
    OnboardingPage(
      title: 'AI-Powered',
      subtitle: 'Dynamic Stories',
      description: 'Experience unique adventures with every playthrough. Our AI creates personalized stories based on your choices.',
      icon: Icons.auto_stories,
      primaryColor: AppColors.accentRose,
      secondaryColor: AppColors.slateBlue,
      features: [
        'Infinite story possibilities',
        'Personalized narratives',
        'Meaningful choices matter',
      ],
    ),
    OnboardingPage(
      title: 'Explore',
      subtitle: 'Multiple Worlds',
      description: 'Journey through the Overworld, delve into Underground tunnels, and soar to the Sky City.',
      icon: Icons.explore,
      primaryColor: AppColors.statusOptimal,
      secondaryColor: AppColors.deepNavy,
      features: [
        'Three unique map regions',
        'Hidden locations to discover',
        'Unlock new areas progressively',
      ],
    ),
    OnboardingPage(
      title: 'Build & Craft',
      subtitle: 'Your Legacy',
      description: 'Construct mechanical workshops, craft intricate devices, and uncover the secrets of clockwork technology.',
      icon: Icons.build_circle,
      primaryColor: AppColors.statusWarning,
      secondaryColor: AppColors.slateBlue,
      features: [
        'Mechanical workshop system',
        'Resource management',
        'Upgrade your equipment',
      ],
    ),
    OnboardingPage(
      title: 'Achieve',
      subtitle: 'Greatness',
      description: 'Complete daily quests, unlock achievements, and track your progress as you become a master inventor.',
      icon: Icons.emoji_events,
      primaryColor: AppColors.vintageGold,
      secondaryColor: AppColors.accentRose,
      features: [
        'Daily quest system',
        'Achievement rewards',
        'Progress tracking',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _startAnimations();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() async {
    await _onboardingService.completeOnboarding();
    
    if (!mounted) return;
    
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainMenuScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _pages[_currentPage].primaryColor.withValues(alpha: 0.8),
              _pages[_currentPage].secondaryColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Skip button
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.lavenderWhite,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Page indicators
                    Row(
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.vintageGold
                                : AppColors.lavenderWhite.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                      _isLastPage = index == _pages.length - 1;
                    });
                    _startAnimations();
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    // Previous button
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousPage,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.lavenderWhite),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Previous',
                            style: TextStyle(
                              color: AppColors.lavenderWhite,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),

                    const SizedBox(width: 16),

                    // Next/Get Started button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.vintageGold,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 8,
                        ),
                        child: Text(
                          _isLastPage ? 'Get Started' : 'Next',
                          style: const TextStyle(
                            color: AppColors.deepNavy,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),

          // Animated icon
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 0.1, // Subtle rotation
                child: FadeTransition(
                  opacity: _fadeController,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _scaleController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            page.primaryColor.withValues(alpha: 0.8),
                            page.primaryColor.withValues(alpha: 0.3),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: page.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        page.icon,
                        size: 60,
                        color: AppColors.lavenderWhite,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Title and subtitle
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _slideController,
              curve: Curves.easeOut,
            )),
            child: FadeTransition(
              opacity: _fadeController,
              child: Column(
                children: [
                  Text(
                    page.title,
                    style: const TextStyle(
                      color: AppColors.lavenderWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    page.subtitle,
                    style: TextStyle(
                      color: page.primaryColor,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Description
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _slideController,
              curve: Curves.easeOut,
            )),
            child: FadeTransition(
              opacity: _fadeController,
              child: GlassCard(
                child: Text(
                  page.description,
                  style: const TextStyle(
                    color: AppColors.lavenderWhite,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Features list
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _slideController,
              curve: Curves.easeOut,
            )),
            child: FadeTransition(
              opacity: _fadeController,
              child: Column(
                children: page.features.asMap().entries.map((entry) {
                  final index = entry.key;
                  final feature = entry.value;
                  
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: page.primaryColor,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: AppColors.deepNavy,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              color: AppColors.lavenderWhite,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}