import 'package:flutter/material.dart';
import '../models/character.dart';

class Leaderboard extends StatelessWidget {
  final List<Character> characters;

  const Leaderboard({
    super.key,
    required this.characters,
  });

  @override
  Widget build(BuildContext context) {
    final sortedList = List<Character>.from(characters);
    sortedList.sort((a, b) => b.bladeCount.compareTo(a.bladeCount));
    final topCharacters = sortedList.take(5);

    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Colors.yellow,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  '排行榜',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.grey, height: 1),
          const SizedBox(height: 12),
          if (topCharacters.isEmpty)
            const Center(
              child: Text('...', style: TextStyle(color: Colors.grey)),
            )
          else
            ...topCharacters.map((character) {
              final isPlayer = character.type == null;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: isPlayer
                      ? BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        )
                      : null,
                  child: Row(
                    children: [
                      Icon(
                        character.icon,
                        color: character.color,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          character.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isPlayer ? Colors.yellow : Colors.white,
                            fontSize: 14,
                            fontWeight:
                                isPlayer ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${character.bladeCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
