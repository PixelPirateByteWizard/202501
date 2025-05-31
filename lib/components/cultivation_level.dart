import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CultivationLevel extends StatelessWidget {
  final String level;
  final double progress;
  final bool showLevelUp;

  const CultivationLevel({
    Key? key,
    required this.level,
    required this.progress,
    this.showLevelUp = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelInfo = _getLevelInfo(level);
    final levelColor = levelInfo['color'] as Color;
    final levelName = levelInfo['name'] as String;
    final levelIcon = levelInfo['icon'] as IconData;

    // Wrap the Stack in a SizedBox to ensure it has definite size constraints
    return SizedBox(
      width: double.infinity, // Full width available
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: levelColor.withOpacity(0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: levelColor.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            // Add content inside container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          levelIcon,
                          color: levelColor,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          levelName,
                          style: AppConstants.headlineMedium.copyWith(
                            color: levelColor,
                            fontSize: 22, // Smaller than default headlineMedium
                          ),
                        ),
                      ],
                    ),
                    if (showLevelUp)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.amber,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.arrow_upward,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Breakthrough',
                              style: AppConstants.bodyMedium.copyWith(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 12, // Smaller than default bodyMedium
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade700,
                  valueColor: AlwaysStoppedAnimation<Color>(levelColor),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Get level related information
  Map<String, dynamic> _getLevelInfo(String level) {
    switch (level) {
      case 'Qi Refining':
        return {
          'name': 'Qi Refining',
          'color': const LinearGradient(
            colors: [
              Color(0xFF4F46E5),
              Color(0xFF3B82F6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          'icon': Icons.filter_vintage,
        };
      case 'Foundation Establishment':
        return {
          'name': 'Foundation Establishment',
          'color': const LinearGradient(
            colors: [
              Color(0xFF059669),
              Color(0xFF10B981),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          'icon': Icons.foundation,
        };
      case 'Core Formation':
        return {
          'name': 'Core Formation',
          'color': const LinearGradient(
            colors: [
              Color(0xFFD97706),
              Color(0xFFF59E0B),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          'icon': Icons.science,
        };
      case 'Nascent Soul':
        return {
          'name': 'Nascent Soul',
          'color': const LinearGradient(
            colors: [
              Color(0xFFDC2626),
              Color(0xFFEF4444),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          'icon': Icons.child_care,
        };
      case 'Soul Transformation':
        return {
          'name': 'Soul Transformation',
          'color': const LinearGradient(
            colors: [
              Color(0xFF7C3AED),
              Color(0xFF8B5CF6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          'icon': Icons.auto_fix_high,
        };
      case 'Void Refinement':
        return {
          'name': 'Void Refinement',
          'color': const LinearGradient(
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          'icon': Icons.whatshot,
        };
      case 'Body Integration':
        return {
          'name': 'Body Integration',
          'color': const LinearGradient(
            colors: [
              Color(0xFFFBBF24),
              Color(0xFFF59E0B),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          'icon': Icons.brightness_7,
        };
      case 'Tribulation Transcendence':
        return {
          'name': 'Tribulation Transcendence',
          'color': const LinearGradient(
            colors: [
              Color(0xFFEC4899),
              Color(0xFFF472B6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          'icon': Icons.flash_on,
        };
      default:
        return {
          'name': 'None',
          'color': Colors.grey.shade400,
          'icon': Icons.question_mark,
        };
    }
  }
}
