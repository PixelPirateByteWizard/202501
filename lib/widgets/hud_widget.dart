import 'package:flutter/material.dart';
import '../models/game_piece_model.dart';
import '../utils/colors.dart';

/// Heads-Up Display widget showing score, moves, and objectives.
class HudWidget extends StatelessWidget {
  final int score;
  final int moves;
  final Map<PieceColor, int> objectives;
  final int levelNumber;

  const HudWidget({
    Key? key,
    required this.score,
    required this.moves,
    required this.objectives,
    required this.levelNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Level info and Score/Moves
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level $levelNumber',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.cyanAccent,
                    ),
                  ),
                  Text(
                    _getLevelDescription(levelNumber),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildInfoItem(Icons.star, '$score', AppColors.accent),
                  const SizedBox(width: 16),
                  _buildInfoItem(
                      Icons.directions_walk, '$moves', AppColors.primaryText),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Objectives
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                "Alchemist's Order",
                style: SafeFonts.imFellEnglishSc(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 12),
              _buildObjectivesRow(),
            ],
          ),
        ),
      ],
    );
  }

  String _getLevelDescription(int level) {
    switch (level) {
      case 1:
        return 'Novice Alchemist';
      case 2:
        return 'Apprentice Mixer';
      default:
        return 'Master Alchemist';
    }
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildObjectivesRow() {
    if (objectives.values.every((val) => val <= 0)) {
      return const Text(
        'All orders complete!',
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final objectiveWidgets = objectives.entries
        .where((entry) => entry.value > 0)
        .map((entry) => _buildObjectiveItem(entry.key, entry.value))
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: objectiveWidgets,
    );
  }

  Widget _buildObjectiveItem(PieceColor color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.get(color),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24, width: 2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$count',
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
