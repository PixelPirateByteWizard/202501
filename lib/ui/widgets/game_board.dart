import 'package:flutter/material.dart';
import '../../core/game_engine.dart';
import 'puzzle_tile.dart';

class GameBoard extends StatelessWidget {
  final GameEngine gameEngine;
  final Function(int) onTileTapped;

  const GameBoard({
    super.key,
    required this.gameEngine,
    required this.onTileTapped,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gameEngine.gridSize,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: gameEngine.tiles.length,
            itemBuilder: (context, index) {
              final tile = gameEngine.tiles[index];
              return PuzzleTileWidget(
                value: tile.value,
                isCorrect: tile.isInCorrectPosition,
                isBlank: tile.isBlank,
                onTap: () => onTileTapped(tile.currentPosition),
              );
            },
          ),
        ),
      ),
    );
  }
}
