import 'package:flutter/material.dart';
import '../utils/colors.dart';

class TutorialOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const TutorialOverlay({super.key, required this.onComplete});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<TutorialStep> _steps = [
    TutorialStep(
      title: "Welcome, Alchemist!",
      description:
          "Welcome to Alchemist's Palette! Your goal is to combine primary colors to create secondary colors and complete orders.",
      icon: Icons.auto_awesome,
    ),
    TutorialStep(
      title: "Primary Colors",
      description:
          "Red, Yellow, and Blue are primary colors. They cannot be matched directly but can be combined through synthesis.",
      icon: Icons.palette,
    ),
    TutorialStep(
      title: "Synthesis Magic",
      description:
          "Tap two adjacent primary colors to synthesize them:\n• Red + Yellow = Orange\n• Red + Blue = Purple\n• Yellow + Blue = Green",
      icon: Icons.science,
    ),
    TutorialStep(
      title: "Secondary Colors",
      description:
          "Orange, Green, and Purple are secondary colors. Match 3 or more in a row to clear them and earn points!",
      icon: Icons.stars,
    ),
    TutorialStep(
      title: "Complete Orders",
      description:
          "Check the Alchemist's Order section to see what colors you need to collect. Complete all orders to win the level!",
      icon: Icons.task_alt,
    ),
    TutorialStep(
      title: "Ready to Begin!",
      description:
          "You have limited moves, so plan carefully. Tap pieces to select them, then tap an adjacent piece to interact. Good luck!",
      icon: Icons.play_arrow,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      _fadeController.reverse().then((_) {
        setState(() {
          _currentStep++;
        });
        _fadeController.forward();
      });
    } else {
      _fadeController.reverse().then((_) {
        widget.onComplete();
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _fadeController.reverse().then((_) {
        setState(() {
          _currentStep--;
        });
        _fadeController.forward();
      });
    }
  }

  void _skipTutorial() {
    _fadeController.reverse().then((_) {
      widget.onComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress indicator
                Row(
                  children: [
                    for (int i = 0; i < _steps.length; i++)
                      Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(
                            right: i < _steps.length - 1 ? 8 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: i <= _currentStep
                                ? AppColors.accent
                                : AppColors.accent.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    step.icon,
                    size: 40,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  step.title,
                  textAlign: TextAlign.center,
                  style: SafeFonts.imFellEnglishSc(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  step.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip button
                    TextButton(
                      onPressed: _skipTutorial,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    // Step indicator
                    Text(
                      '${_currentStep + 1} / ${_steps.length}',
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                      ),
                    ),

                    // Navigation buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_currentStep > 0)
                          IconButton(
                            onPressed: _previousStep,
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.accent,
                            ),
                          ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: _nextStep,
                          child: Text(
                            _currentStep < _steps.length - 1
                                ? 'Next'
                                : 'Start!',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final IconData icon;

  TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
  });
}
