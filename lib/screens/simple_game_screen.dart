import 'package:flutter/material.dart';
import '../models/game_piece_model.dart';
import '../models/level_model.dart';
import '../services/game_logic_service.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';
import '../services/achievement_service.dart';
import '../utils/colors.dart';
import '../widgets/game_over_dialog.dart';
import '../widgets/tutorial_overlay.dart';
import '../widgets/achievement_notification.dart';

class SimpleGameScreen extends StatefulWidget {
  const SimpleGameScreen({super.key});

  @override
  State<SimpleGameScreen> createState() => _SimpleGameScreenState();
}

class _SimpleGameScreenState extends State<SimpleGameScreen>
    with TickerProviderStateMixin {
  final GameLogicService _logic = GameLogicService();
  final StorageService _storage = StorageService();
  final AudioService _audio = AudioService();
  final AchievementService _achievementService = AchievementService();
  List<List<GamePiece?>> board = [];
  bool _isProcessing = false;
  bool _showTutorial = false;
  bool _isFirstTime = true;
  Point? _selectedPiece;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkFirstTime();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _checkFirstTime() async {
    final highestLevel = await _storage.loadHighestLevel();
    setState(() {
      _isFirstTime = highestLevel == 1;
      _showTutorial = _isFirstTime;
    });

    if (!_showTutorial) {
      _startLevel(1);
    }
  }

  void _startLevel(int levelNumber) {
    final level = Level.getLevel(levelNumber);
    _logic.loadLevel(level);
    setState(() {
      board = _logic.board;
      _selectedPiece = null;
      _isProcessing = false;
    });
  }

  void _onTutorialComplete() {
    setState(() {
      _showTutorial = false;
    });
    _startLevel(1);
  }

  void _handlePieceTap(int row, int col) {
    if (_isProcessing || _logic.checkGameStatus() != GameStatus.playing) return;

    final piece = board[row][col];
    if (piece == null) return;

    if (_selectedPiece == null) {
      // Select the piece
      _audio.tapFeedback();
      setState(() {
        _selectedPiece = Point(col, row);
      });
    } else {
      // Try to swap with selected piece
      final selectedRow = _selectedPiece!.y;
      final selectedCol = _selectedPiece!.x;

      if (selectedRow == row && selectedCol == col) {
        // Deselect if tapping the same piece
        setState(() {
          _selectedPiece = null;
        });
        return;
      }

      // Check if pieces are adjacent
      final deltaR = (row - selectedRow).abs();
      final deltaC = (col - selectedCol).abs();

      if ((deltaR == 1 && deltaC == 0) || (deltaR == 0 && deltaC == 1)) {
        _performSwap(selectedRow, selectedCol, row, col);
      } else {
        // Select new piece if not adjacent
        _audio.tapFeedback();
        setState(() {
          _selectedPiece = Point(col, row);
        });
      }
    }
  }

  void _performSwap(int r1, int c1, int r2, int c2) {
    setState(() {
      _isProcessing = true;
      _selectedPiece = null;
    });

    final moveWasValid = _logic.attemptSwap(r1, c1, r2, c2);

    if (moveWasValid) {
      _audio.playSynthesisSound();
      _recordAchievementProgress();
    } else {
      _audio.playInvalidMoveSound();
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        board = _logic.board;
        _isProcessing = false;
      });
      _checkGameState();
    });
  }

  Future<void> _recordAchievementProgress() async {
    // Record synthesis achievement
    final synthAchievements = await _achievementService.recordSynthesis();
    for (final achievement in synthAchievements) {
      AchievementOverlay.show(achievement);
    }

    // Record match achievement (this might be called multiple times during processing)
    final matchAchievements = await _achievementService.recordMatch();
    for (final achievement in matchAchievements) {
      AchievementOverlay.show(achievement);
    }
  }

  void _checkGameState() {
    final status = _logic.checkGameStatus();
    if (status != GameStatus.playing) {
      Future.delayed(const Duration(milliseconds: 300), () async {
        final currentLevel = _logic.currentLevel.levelNumber;
        final nextLevel =
            status == GameStatus.win ? currentLevel + 1 : currentLevel;

        // Save progress and record achievements if level completed
        if (status == GameStatus.win) {
          await _storage.saveHighestLevel(nextLevel);
          _audio.playLevelCompleteSound();

          // Record level completion achievements
          final movesUsed = _logic.currentLevel.moves - _logic.movesLeft;
          final levelAchievements =
              await _achievementService.recordLevelCompletion(
            currentLevel,
            _logic.score,
            movesUsed,
            _logic.movesLeft,
          );

          // Show level completion achievements
          for (final achievement in levelAchievements) {
            AchievementOverlay.show(achievement);
          }
        }

        if (mounted) {
          showGameOverDialog(
            context: context,
            isWin: status == GameStatus.win,
            onRestart: () => _startLevel(nextLevel),
          );
        }
      });
    }
  }

  void _showTutorialAgain() {
    setState(() {
      _showTutorial = true;
    });
  }

  void _resetProgress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryContainer,
        title: Text(
          'Reset Progress',
          style: TextStyle(color: AppColors.accent),
        ),
        content: const Text(
          'Are you sure you want to reset your progress? This will restart from Level 1.',
          style: TextStyle(color: AppColors.primaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _storage.saveHighestLevel(1);
              _startLevel(1);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AchievementOverlay(
      child: Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F172A),
          elevation: 0,
          title: Text(
            "Alchemist's Palette",
            style: SafeFonts.imFellEnglishSc(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFDE047),
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: AppColors.primaryContainer,
              onSelected: (value) {
                switch (value) {
                  case 'tutorial':
                    _showTutorialAgain();
                    break;
                  case 'reset':
                    _resetProgress();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'tutorial',
                  child: Row(
                    children: [
                      Icon(Icons.help_outline, color: AppColors.accent),
                      SizedBox(width: 8),
                      Text(
                        'Show Tutorial',
                        style: TextStyle(color: AppColors.primaryText),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'reset',
                  child: Row(
                    children: [
                      Icon(Icons.refresh, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Reset Progress',
                        style: TextStyle(color: AppColors.primaryText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // Main game content
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // HUD
                      _buildHUD(),
                      const SizedBox(height: 16),

                      // Objectives
                      _buildObjectives(),
                      const SizedBox(height: 16),

                      // Game Board
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _buildGameBoard(),
                      ),
                      const SizedBox(height: 16),

                      // Synthesis Rules
                      _buildSynthesisRules(),

                      // Processing indicator
                      if (_isProcessing) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFDE047),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Processing...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(
                          height: 100), // Extra space for better scrolling
                    ],
                  ),
                ),
              ),

              // Tutorial overlay
              if (_showTutorial)
                TutorialOverlay(onComplete: _onTutorialComplete),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHUD() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level ${_logic.currentLevel.levelNumber}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF67E8F9),
                ),
              ),
              Text(
                _getLevelDescription(_logic.currentLevel.levelNumber),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFCBD5E1),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Color(0xFFFDE047), size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${_logic.score}',
                    style: const TextStyle(
                      color: Color(0xFFFDE047),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.directions_walk,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${_logic.movesLeft}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildObjectives() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            "Alchemist's Order",
            style: SafeFonts.imFellEnglishSc(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFDE047),
            ),
          ),
          const SizedBox(height: 12),
          _buildObjectivesRow(),
        ],
      ),
    );
  }

  Widget _buildObjectivesRow() {
    if (_logic.objectives.values.every((val) => val <= 0)) {
      return const Text(
        'All orders complete!',
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final objectiveWidgets = _logic.objectives.entries
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
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
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

  Widget _buildGameBoard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double boardSize = constraints.maxWidth;
        final double cellSize = boardSize / 8;

        return Container(
          width: boardSize,
          height: boardSize,
          decoration: BoxDecoration(
            color: const Color(0xFF334155),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Grid lines
              CustomPaint(
                size: Size(boardSize, boardSize),
                painter: GridPainter(cellSize: cellSize),
              ),
              // Game pieces - 只有当 board 不为空时才渲染
              if (board.isNotEmpty && board.length >= 8)
                ...List.generate(8, (r) {
                  if (r >= board.length) return <Widget>[];
                  return List.generate(8, (c) {
                    if (c >= board[r].length) return const SizedBox.shrink();
                    final piece = board[r][c];
                    if (piece == null) return const SizedBox.shrink();

                    final isSelected =
                        _selectedPiece?.x == c && _selectedPiece?.y == r;

                    return Positioned(
                      left: c * cellSize,
                      top: r * cellSize,
                      width: cellSize,
                      height: cellSize,
                      child: GestureDetector(
                        onTap: () => _handlePieceTap(r, c),
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            final scale =
                                isSelected ? _pulseAnimation.value : 1.0;
                            return Transform.scale(
                              scale: scale,
                              child: Padding(
                                padding: EdgeInsets.all(cellSize * 0.08),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      center: const Alignment(-0.3, -0.3),
                                      radius: 1.0,
                                      colors: [
                                        AppColors.get(piece.color)
                                            .withOpacity(0.3),
                                        AppColors.get(piece.color),
                                        AppColors.get(piece.color)
                                            .withOpacity(0.8),
                                      ],
                                      stops: const [0.0, 0.7, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.get(piece.color)
                                            .withOpacity(0.4),
                                        spreadRadius: 2,
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                      if (isSelected)
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.8),
                                          spreadRadius: 3,
                                          blurRadius: 8,
                                          offset: const Offset(0, 0),
                                        ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Main highlight
                                      Positioned(
                                        top: cellSize * 0.15,
                                        left: cellSize * 0.15,
                                        child: Container(
                                          width: cellSize * 0.25,
                                          height: cellSize * 0.25,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      // Type indicator for secondary pieces
                                      if (piece.type == PieceType.secondary)
                                        Center(
                                          child: Container(
                                            width: cellSize * 0.1,
                                            height: cellSize * 0.1,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  });
                }).expand((widgets) => widgets),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSynthesisRules() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Synthesis Rules',
            style: SafeFonts.imFellEnglishSc(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFDE047),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSynthesisRule(
                PieceColor.red,
                PieceColor.yellow,
                PieceColor.orange,
              ),
              _buildSynthesisRule(
                PieceColor.red,
                PieceColor.blue,
                PieceColor.purple,
              ),
              _buildSynthesisRule(
                PieceColor.yellow,
                PieceColor.blue,
                PieceColor.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSynthesisRule(
      PieceColor color1, PieceColor color2, PieceColor result) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildColorCircle(color1, 16),
        const Text(
          ' + ',
          style: TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildColorCircle(color2, 16),
        const Text(
          ' → ',
          style: TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildColorCircle(result, 16),
      ],
    );
  }

  Widget _buildColorCircle(PieceColor color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.get(color),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.get(color).withOpacity(0.6),
          width: 1,
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double cellSize;

  GridPainter({required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F172A).withOpacity(0.3)
      ..strokeWidth = 1.0;

    // Draw vertical lines
    for (int i = 0; i <= 8; i++) {
      final x = i * cellSize;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (int i = 0; i <= 8; i++) {
      final y = i * cellSize;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simple class to represent a point on the grid.
class Point {
  final int x;
  final int y;
  const Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
