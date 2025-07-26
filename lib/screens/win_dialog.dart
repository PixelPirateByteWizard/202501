import 'package:flutter/material.dart';
import '../models/game_level.dart';
import '../utils/colors.dart';

class WinDialog extends StatefulWidget {
  final int levelNumber;
  final int moveCount;
  final VoidCallback onNextLevel;

  const WinDialog({
    super.key,
    required this.levelNumber,
    required this.moveCount,
    required this.onNextLevel,
  });

  @override
  State<WinDialog> createState() => _WinDialogState();
}

class _WinDialogState extends State<WinDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _starController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _starAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _starController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
    
    _starAnimation = CurvedAnimation(
      parent: _starController,
      curve: Curves.bounceOut,
    );
    
    // Start animations
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _starController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final level = GameLevel.getLevel(widget.levelNumber);
    final stars = level?.calculateStars(widget.moveCount) ?? 1;

    return Material(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Text(
                  'Excellent!',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF59E0B),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Stars
                AnimatedBuilder(
                  animation: _starAnimation,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final isActive = index < stars;
                        final delay = index * 0.2;
                        final animationValue = (_starAnimation.value - delay).clamp(0.0, 1.0);
                        
                        return Transform.scale(
                          scale: isActive ? (0.8 + animationValue * 0.4) : 0.8,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.star,
                              size: 48,
                              color: isActive 
                                  ? GameColors.starFilledColor
                                  : GameColors.starEmptyColor,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Move count
                Text(
                  'You completed the level in ${widget.moveCount} moves!',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Next level button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: widget.onNextLevel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 8,
                    ),
                    child: const Text(
                      'Next Level',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}