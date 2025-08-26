import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SportCard extends StatelessWidget {
  final String sportName;
  final String emoji;
  final bool isActive;
  final VoidCallback onTap;

  const SportCard({
    super.key,
    required this.sportName,
    required this.emoji,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isActive
              ? AppConstants.spaceIndigo600.withOpacity(0.5)
              : AppConstants.spaceIndigo700.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppConstants.cosmicBlue : Colors.transparent,
            width: 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppConstants.cosmicBlue.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              sportName,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
