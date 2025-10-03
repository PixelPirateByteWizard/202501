import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'glass_card_widget.dart';

class TutorialOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final int currentStep;

  const TutorialOverlay({
    super.key,
    required this.onClose,
    this.currentStep = 0,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late int _currentStep;

  final List<TutorialStep> _tutorialSteps = [
    TutorialStep(
      title: "Swipe & Merge",
      description:
          "Swipe in any direction to move all tiles. Tiles with the same value merge into higher values.",
      icon: Icons.swipe,
    ),
    TutorialStep(
      title: "Special Rules",
      description:
          "1 and 2 are special - they merge into 3. Other values only merge with identical values.",
      icon: Icons.add_circle_outline,
    ),
    TutorialStep(
      title: "Predict New Tiles",
      description:
          "After each swipe, a new tile appears from the edge opposite to your swipe direction.",
      icon: Icons.arrow_forward,
    ),
    TutorialStep(
      title: "Space Management",
      description:
          "Keep high-value tiles in corners to leave space for new tiles.",
      icon: Icons.grid_4x4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentStep = widget.currentStep;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _tutorialSteps.length - 1) {
      _controller.reverse().then((_) {
        setState(() {
          _currentStep++;
        });
        _controller.forward();
      });
    } else {
      widget.onClose();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _controller.reverse().then((_) {
        setState(() {
          _currentStep--;
        });
        _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTutorial = _tutorialSteps[_currentStep];

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Semi-transparent background
          GestureDetector(
            onTap: widget.onClose,
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),

          // Tutorial content
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: GlassCard(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(UIConstants.SPACING_LARGE),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: UIConstants.PURPLE_COLOR.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        currentTutorial.icon,
                        size: 40,
                        color: UIConstants.PURPLE_COLOR,
                      ),
                    ),
                    const SizedBox(height: UIConstants.SPACING_MEDIUM),

                    // Title
                    Text(
                      currentTutorial.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: UIConstants.SPACING_MEDIUM),

                    // Description
                    Text(
                      currentTutorial.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: UIConstants.SPACING_LARGE),

                    // Step indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_tutorialSteps.length, (index) {
                        return Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentStep
                                ? UIConstants.PURPLE_COLOR
                                : Colors.white.withOpacity(0.3),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: UIConstants.SPACING_LARGE),

                    // Navigation buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back button (hidden on first step)
                        _currentStep > 0
                            ? TextButton(
                                onPressed: _previousStep,
                                child: const Text(
                                  "Back",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              )
                            : const SizedBox(width: 80),

                        // Next/Finish button
                        ElevatedButton(
                          onPressed: _nextStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UIConstants.PURPLE_COLOR,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: UIConstants.SPACING_LARGE,
                              vertical: UIConstants.SPACING_SMALL,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            _currentStep < _tutorialSteps.length - 1
                                ? "Next"
                                : "Start Game",
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
