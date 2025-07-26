import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/game_level.dart';
import '../utils/colors.dart';
import '../services/hint_service.dart';
import '../screens/settings_screen.dart';
import 'hint_button.dart';

class GameHeader extends StatelessWidget {
  final GameState gameState;
  final VoidCallback onRestart;
  final Function(HintMove)? onHintSelected;

  const GameHeader({
    super.key,
    required this.gameState,
    required this.onRestart,
    this.onHintSelected,
  });

  @override
  Widget build(BuildContext context) {
    final level = GameLevel.getLevel(gameState.currentLevel);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Top row with settings, level info, and restart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.settings,
                  size: 28,
                  color: Colors.grey,
                ),
              ),
              Column(
                children: [
                  Text(
                    'Level ${gameState.currentLevel}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Target: ${level?.targetMoves ?? 0} | Moves: ${gameState.moveCount} | Time: ${gameState.formattedTime}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (onHintSelected != null)
                    HintButton(
                      gameState: gameState,
                      onHintSelected: onHintSelected!,
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: onRestart,
                    icon: const Icon(
                      Icons.refresh,
                      size: 28,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Progress bar
          Container(
            width: double.infinity,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: gameState.progress,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  GameColors.progressStartColor,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Progress text
          Text(
            'Progress: ${(gameState.progress * 100).round()}%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}