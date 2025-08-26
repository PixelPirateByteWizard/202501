import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../group_generator/group_model.dart';

class PlayerTag extends StatelessWidget {
  final Player player;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  const PlayerTag({
    super.key,
    required this.player,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget playerTagContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? AppConstants.cosmicBlue.withOpacity(0.3)
            : AppConstants.spaceIndigo700.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? AppConstants.cosmicBlue
              : AppConstants.cosmicBlue.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppConstants.cosmicBlue.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              player.name,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (player.skill != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getSkillColor(player.skill!).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getSkillColor(player.skill!).withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Text(
                player.skill!,
                style: TextStyle(
                  color: _getSkillColor(player.skill!),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    // 使用普通的GestureDetector
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: playerTagContent,
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
