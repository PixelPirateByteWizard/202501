import 'package:flutter/material.dart';
import '../models/game_level.dart';
import '../services/storage_service.dart';
import '../utils/colors.dart';
import 'game_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int _currentLevel = 1;
  Map<int, int> _levelStars = {};
  Map<int, int> _bestMoves = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final currentLevel = await StorageService.getCurrentLevel();
    final Map<int, int> levelStars = {};
    final Map<int, int> bestMoves = {};

    for (int i = 1; i < GameLevel.levels.length; i++) {
      levelStars[i] = await StorageService.getLevelStars(i);
      bestMoves[i] = await StorageService.getBestMoves(i);
    }

    setState(() {
      _currentLevel = currentLevel;
      _levelStars = levelStars;
      _bestMoves = bestMoves;
    });
  }

  void _playLevel(int levelNumber) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Level',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background/background_7.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: GameLevel.levels.length - 1, // Exclude placeholder
            itemBuilder: (context, index) {
              final levelNumber = index + 1;
              final level = GameLevel.getLevel(levelNumber);
              final isUnlocked = levelNumber <= _currentLevel;
              final stars = _levelStars[levelNumber] ?? 0;
              final bestMove = _bestMoves[levelNumber] ?? 999;

              return LevelCard(
                levelNumber: levelNumber,
                level: level!,
                isUnlocked: isUnlocked,
                stars: stars,
                bestMoves: bestMove < 999 ? bestMove : null,
                onTap: isUnlocked ? () => _playLevel(levelNumber) : null,
              );
            },
          ),
        ),
      ),
    );
  }
}

class LevelCard extends StatelessWidget {
  final int levelNumber;
  final GameLevel level;
  final bool isUnlocked;
  final int stars;
  final int? bestMoves;
  final VoidCallback? onTap;

  const LevelCard({
    super.key,
    required this.levelNumber,
    required this.level,
    required this.isUnlocked,
    required this.stars,
    this.bestMoves,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: isUnlocked
              ? LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.purple.shade50.withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.grey.shade300.withOpacity(0.9),
                    Colors.grey.shade400.withOpacity(0.9),
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Level number
            Text(
              '$levelNumber',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? Colors.purple : Colors.grey.shade600,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Stars
            if (isUnlocked)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    Icons.star,
                    size: 16,
                    color: index < stars 
                        ? GameColors.starFilledColor 
                        : GameColors.starEmptyColor,
                  );
                }),
              ),
            
            const SizedBox(height: 4),
            
            // Best moves
            if (bestMoves != null)
              Text(
                'Best: $bestMoves moves',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            
            // Lock icon for locked levels
            if (!isUnlocked)
              Icon(
                Icons.lock,
                color: Colors.grey.shade600,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}