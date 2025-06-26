import 'package:flutter/material.dart';
import '../utils/colors.dart';

/// Shows a dialog when the game ends (win or lose).
void showGameOverDialog({
  required BuildContext context,
  required bool isWin,
  required VoidCallback onRestart,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accent,
              width: 2,
            ),
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
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isWin
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isWin ? Icons.celebration : Icons.refresh,
                  size: 40,
                  color: isWin ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                isWin ? 'Level Complete!' : 'Out of Moves',
                textAlign: TextAlign.center,
                style: SafeFonts.imFellEnglishSc(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                isWin
                    ? "You're a genius alchemist!"
                    : "Don't worry, try again!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isWin ? Colors.green : Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    isWin ? 'Next Level' : 'Try Again',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onRestart();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
