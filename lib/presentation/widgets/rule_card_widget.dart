import 'package:flutter/material.dart';
import '../utils/constants.dart';

class RuleCardWidget extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const RuleCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: UIConstants.SPACING_MEDIUM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            UIConstants.CARD_GRADIENT_START,
            UIConstants.CARD_GRADIENT_END,
          ],
        ),
        borderRadius: BorderRadius.circular(UIConstants.BORDER_RADIUS_MEDIUM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: UIConstants.GRID_LINE_COLOR, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: UIConstants.PURPLE_COLOR.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: UIConstants.PURPLE_COLOR, size: 20),
            ),
            const SizedBox(width: UIConstants.SPACING_MEDIUM),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
