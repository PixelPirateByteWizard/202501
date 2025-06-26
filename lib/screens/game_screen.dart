import 'package:flutter/material.dart';
import '../models/game_piece_model.dart';
import '../models/level_model.dart';
import '../services/game_logic_service.dart';
import '../utils/colors.dart'; // <-- Corrected import path
import '../widgets/game_board_widget.dart';
import '../widgets/game_over_dialog.dart';
import '../widgets/hud_widget.dart';
import '../widgets/synthesis_rules_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameLogicService _logic = GameLogicService();
  late List<List<GamePiece?>> _board;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _startLevel(1);
  }

  void _startLevel(int levelNumber) {
    // In a real app, levelNumber might exceed available levels.
    final levelIndex = (levelNumber - 1) % Level.levels.length;
    _logic.loadLevel(Level.levels[levelIndex]);
    setState(() {
      _board = _logic.board;
    });
  }

  void _handleSwap(int r1, int c1, int r2, int c2) {
    if (_isProcessing || _logic.checkGameStatus() != GameStatus.playing) return;

    setState(() {
      _isProcessing = true;
    });

    final bool moveWasValid = _logic.attemptSwap(r1, c1, r2, c2);

    // Use a short delay to allow animations to feel more natural
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _board = _logic.board;
        _isProcessing = false;
        _checkGameState();
      });
    });
  }

  void _checkGameState() {
    final status = _logic.checkGameStatus();
    if (status != GameStatus.playing) {
      // Add a slight delay before showing the dialog
      Future.delayed(const Duration(milliseconds: 300), () {
        showGameOverDialog(
          context: context,
          isWin: status == GameStatus.win,
          onRestart: () {
            _startLevel(status == GameStatus.win
                ? _logic.currentLevel.levelNumber + 1
                : _logic.currentLevel.levelNumber);
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header with title
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.secondaryContainer,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    "Alchemist's Palette",
                    style: SafeFonts.imFellEnglishSc(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Level info and HUD
                HudWidget(
                  score: _logic.score,
                  moves: _logic.movesLeft,
                  objectives: _logic.objectives,
                  levelNumber: _logic.currentLevel.levelNumber,
                ),
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
                  child: GameBoardWidget(
                    board: _board,
                    onSwap: _handleSwap,
                  ),
                ),
                const SizedBox(height: 16),

                // Synthesis Rules
                const SynthesisRulesWidget(),
                const SizedBox(height: 16),

                // Processing indicator
                if (_isProcessing)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Processing...',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
