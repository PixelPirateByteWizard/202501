import 'package:flutter/material.dart';
import '../models/achievement_model.dart';
import '../utils/colors.dart';

class AchievementNotification extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback? onDismiss;

  const AchievementNotification({
    super.key,
    required this.achievement,
    this.onDismiss,
  });

  @override
  State<AchievementNotification> createState() =>
      _AchievementNotificationState();
}

class _AchievementNotificationState extends State<AchievementNotification>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _glowController.repeat(reverse: true);

    // Auto dismiss after 4 seconds
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      _dismiss();
    }
  }

  void _dismiss() async {
    _glowController.stop();
    await _slideController.reverse();
    if (widget.onDismiss != null) {
      widget.onDismiss!();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          Listenable.merge([_slideAnimation, _scaleAnimation, _glowAnimation]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(
                      (0.3 * _glowAnimation.value).clamp(0.0, 1.0)),
                  spreadRadius: 4 * _glowAnimation.value,
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
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
                onTap: _dismiss,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.accent.withOpacity(0.9),
                        AppColors.cyanAccent.withOpacity(0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Achievement Icon
                      Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            _getIconFromName(widget.achievement.iconName),
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Achievement Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Achievement Unlocked!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white.withOpacity(0.9),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '+${widget.achievement.points} pts',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.achievement.title,
                              style: SafeFonts.imFellEnglishSc(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.achievement.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Dismiss Button
                      IconButton(
                        onPressed: _dismiss,
                        icon: Icon(
                          Icons.close,
                          color: Colors.white.withOpacity(0.7),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'science':
        return Icons.science;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'stars':
        return Icons.stars;
      case 'celebration':
        return Icons.celebration;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'flag':
        return Icons.flag;
      case 'military_tech':
        return Icons.military_tech;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'trending_up':
        return Icons.trending_up;
      case 'show_chart':
        return Icons.show_chart;
      case 'speed':
        return Icons.speed;
      case 'diamond':
        return Icons.diamond;
      default:
        return Icons.emoji_events;
    }
  }
}

/// Overlay widget to show achievement notifications
/// 显示成就通知的覆盖组件
class AchievementOverlay extends StatefulWidget {
  final Widget child;

  const AchievementOverlay({super.key, required this.child});

  static GlobalKey<_AchievementOverlayState>? _key;

  static void show(Achievement achievement) {
    _key?.currentState?.showAchievement(achievement);
  }

  @override
  State<AchievementOverlay> createState() => _AchievementOverlayState();
}

class _AchievementOverlayState extends State<AchievementOverlay> {
  final List<Achievement> _pendingAchievements = [];
  Achievement? _currentAchievement;

  @override
  void initState() {
    super.initState();
    AchievementOverlay._key = GlobalKey<_AchievementOverlayState>();
  }

  void showAchievement(Achievement achievement) {
    if (_currentAchievement == null) {
      setState(() {
        _currentAchievement = achievement;
      });
    } else {
      _pendingAchievements.add(achievement);
    }
  }

  void _onAchievementDismissed() {
    setState(() {
      _currentAchievement = null;
    });

    // Show next achievement if any
    if (_pendingAchievements.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          final nextAchievement = _pendingAchievements.removeAt(0);
          showAchievement(nextAchievement);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_currentAchievement != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            child: AchievementNotification(
              achievement: _currentAchievement!,
              onDismiss: _onAchievementDismissed,
            ),
          ),
      ],
    );
  }
}
