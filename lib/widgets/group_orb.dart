import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../group_generator/group_model.dart';

class GroupOrb extends StatelessWidget {
  final Group group;
  final VoidCallback? onTap;
  final bool isSelected;

  const GroupOrb({
    super.key,
    required this.group,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(0.3, 0.3),
            colors: isSelected
                ? [AppConstants.cosmicBlue, AppConstants.spaceIndigo700]
                : [AppConstants.spaceIndigo600, AppConstants.spaceIndigo700],
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppConstants.cosmicBlue.withOpacity(0.5)
                  : AppConstants.cosmicBlue.withOpacity(0.3),
              blurRadius: isSelected ? 25 : 20,
              spreadRadius: isSelected ? 2 : 0,
            ),
          ],
          border: Border.all(
            color: isSelected
                ? AppConstants.cosmicBlue
                : AppConstants.cosmicBlue.withOpacity(0.5),
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Stack(
          children: [
            // Animated border effect
            Positioned.fill(child: _buildAnimatedBorder()),

            // Content
            Center(
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.spaceIndigo900.withOpacity(0.7),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      group.name,
                      style: TextStyle(
                        color: isSelected
                            ? AppConstants.cosmicBlue
                            : AppConstants.stardustGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${group.players.length} players',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    if (group.averageSkill != null) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: _getSkillColor(
                            group.averageSkill!,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          group.averageSkill!,
                          style: TextStyle(
                            color: _getSkillColor(group.averageSkill!),
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBorder() {
    return RotationTransition(
      turns: const AlwaysStoppedAnimation(0.25),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(
            colors: [
              Colors.transparent,
              AppConstants.cosmicBlue.withOpacity(0.6),
              Colors.transparent,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
      ),
    );
  }

  // 根据技能级别获取颜色
  Color _getSkillColor(String skill) {
    switch (skill.toLowerCase()) {
      case 'beginner':
      case '初级':
        return Colors.green;
      case 'intermediate':
      case '中级':
        return Colors.orange;
      case 'advanced':
      case '高级':
        return Colors.red;
      default:
        return AppConstants.cosmicBlue;
    }
  }
}
