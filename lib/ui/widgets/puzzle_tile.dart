import 'package:flutter/material.dart';
import '../styles/app_theme.dart';

class PuzzleTileWidget extends StatelessWidget {
  final int value;
  final bool isCorrect;
  final bool isBlank;
  final VoidCallback onTap;

  const PuzzleTileWidget({
    super.key,
    required this.value,
    required this.isCorrect,
    required this.isBlank,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isBlank) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isCorrect ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isCorrect
                ? [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ]
                : [
                    Colors.white,
                    Colors.grey[100]!,
                  ],
          ),
        ),
        child: Stack(
          children: [
            if (isCorrect)
              Positioned(
                right: 4,
                top: 4,
                child: Icon(
                  Icons.check_circle,
                  size: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            Center(
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
