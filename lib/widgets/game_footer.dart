import 'package:flutter/material.dart';
import '../models/game_state.dart';

class GameFooter extends StatelessWidget {
  final GameState gameState;
  final VoidCallback onAddBottle;
  final VoidCallback onRemoveColor;
  final VoidCallback onUndo;

  const GameFooter({
    super.key,
    required this.gameState,
    required this.onAddBottle,
    required this.onRemoveColor,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Add bottle button
          Expanded(
            child: _PowerUpButton(
              icon: Icons.add_box,
              label: 'Add Bottle',
              gradient: const LinearGradient(
                colors: [Color(0xFFFDE047), Color(0xFFFACC15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onPressed: gameState.bottles.length < 10 ? onAddBottle : null,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Eliminate button
          Expanded(
            child: _PowerUpButton(
              icon: Icons.auto_fix_high,
              label: 'Remove Color',
              gradient: const LinearGradient(
                colors: [Color(0xFFF472B6), Color(0xFFA855F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              textColor: Colors.white,
              onPressed: !gameState.isRemovingColor ? onRemoveColor : null,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Undo button
          Expanded(
            child: _PowerUpButton(
              icon: Icons.undo,
              label: 'Undo',
              gradient: const LinearGradient(
                colors: [Color(0xFFE5E7EB), Color(0xFFD1D5DB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              badge: gameState.undoCount.toString(),
              onPressed: gameState.undoCount > 0 ? onUndo : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _PowerUpButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final Color textColor;
  final String? badge;
  final VoidCallback? onPressed;

  const _PowerUpButton({
    required this.icon,
    required this.label,
    required this.gradient,
    this.textColor = Colors.black87,
    this.badge,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: onPressed != null ? gradient : null,
            color: onPressed == null ? Colors.grey[300] : null,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: onPressed != null ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ] : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 28,
                      color: onPressed != null ? textColor : Colors.grey[600],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: onPressed != null ? textColor : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Badge
        if (badge != null)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}