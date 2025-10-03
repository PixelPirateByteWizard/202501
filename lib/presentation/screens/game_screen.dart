import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/game_model.dart';
import '../../data/repositories/local_game_repository.dart';
import '../../domain/entities/game_entity.dart';
import '../utils/constants.dart';
import '../utils/game_logic.dart';
import '../utils/haptic_feedback.dart';
import '../widgets/glass_card_widget.dart';
import '../widgets/score_popup_widget.dart';
import '../widgets/score_widget.dart';
import '../widgets/tile_widget.dart';
import '../widgets/tutorial_overlay_widget.dart';
import '../widgets/background_pattern_widget.dart';
import '../widgets/game_hint_widget.dart';
import '../widgets/game_tip_widget.dart';
import 'game_over_screen.dart';

// Class to track score popups
class ScorePopup {
  final int score;
  final int row;
  final int col;
  final DateTime createdAt;

  ScorePopup({
    required this.score,
    required this.row,
    required this.col,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Check if the popup should be removed (after 1 second)
  bool shouldRemove() {
    return DateTime.now().difference(createdAt).inMilliseconds > 1000;
  }
}

class GameScreen extends StatefulWidget {
  final GameMode gameMode;

  const GameScreen({super.key, this.gameMode = GameMode.classic});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

// Dark mode background painter
class _DarkModeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Create a dark gradient background
    final Paint backgroundPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topRight,
        radius: 1.2,
        colors: [
          UIConstants.DARK_MODE_ACCENT.withOpacity(0.2),
          UIConstants.DARK_MODE_BACKGROUND,
          Colors.black,
        ],
        stops: const [0.0, 0.4, 0.9],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), backgroundPaint);

    // Draw subtle stars/dots
    final Paint starPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final random = Random(42); // Fixed seed for consistent pattern

    // Draw 50 stars with varying sizes
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * width;
      final y = random.nextDouble() * height;
      final radius = random.nextDouble() * 1.5;

      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }

    // Draw a few larger, brighter stars
    final brightStarPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 10; i++) {
      final x = random.nextDouble() * width;
      final y = random.nextDouble() * height;
      final radius = 1.0 + random.nextDouble() * 2.0;

      canvas.drawCircle(Offset(x, y), radius, brightStarPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameEntity _game;
  final _repository = LocalGameRepository();
  bool _isLoading = true;
  DateTime? _gameStartTime;
  bool _hapticEnabled = false;
  bool _showTutorial = false;

  // Time challenge variables
  Timer? _timer;
  int _secondsRemaining = GameConstants.TIME_CHALLENGE_DURATION.inSeconds;
  late AnimationController _timeAnimationController;

  // Zen mode variables
  bool _isZenMode = false;

  // Dark mode variables
  bool _isDarkMode = false;

  // Current game mode
  late GameMode _gameMode;

  // List to track score popups
  final List<ScorePopup> _scorePopups = [];

  @override
  void initState() {
    super.initState();
    _gameMode = widget.gameMode;
    _isZenMode = _gameMode == GameMode.zen;
    _isDarkMode = _gameMode == GameMode.dark;

    // Initialize animation controller for time challenge
    _timeAnimationController = AnimationController(
      vsync: this,
      duration: GameConstants.TIME_CHALLENGE_DURATION,
    );

    if (_gameMode == GameMode.timeChallenge) {
      _startTimer();
    }

    _initializeGame();
    _loadSettings();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timeAnimationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          _timeAnimationController.value =
              1 -
              (_secondsRemaining /
                  GameConstants.TIME_CHALLENGE_DURATION.inSeconds);
        } else {
          _timer?.cancel();
          _handleTimeUp();
        }
      });
    });
  }

  void _handleTimeUp() {
    // Time's up! Show game over screen with current score
    if (mounted) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                GameOverScreen(
                  score: _game.score,
                  onRestart: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            GameScreen(gameMode: _gameMode),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeOutQuint;
                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                  gameOverTitle: TextConstants.TIME_UP,
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, -1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOutQuint;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  // Also animate opacity
                  var opacityTween = Tween(
                    begin: 0.0,
                    end: 1.0,
                  ).chain(CurveTween(curve: curve));
                  var opacityAnimation = animation.drive(opacityTween);

                  return FadeTransition(
                    opacity: opacityAnimation,
                    child: SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    ),
                  );
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      });
    }
  }

  Future<void> _loadSettings() async {
    final settings = await _repository.loadSettings();
    setState(() {
      _hapticEnabled = settings.hapticFeedbackEnabled;
      // Show tutorial for first-time users
      _showTutorial = settings.isFirstTime;
    });
    HapticFeedbackService.setEnabled(_hapticEnabled);

    // If this is the first time, update the setting
    if (settings.isFirstTime) {
      await _repository.saveSettings(settings.copyWith(isFirstTime: false));
    }
  }

  Future<void> _initializeGame() async {
    final bestScore = await _repository.loadBestScore();

    // Try to load a saved game
    final savedGame = await _repository.loadGame();

    setState(() {
      if (savedGame != null && !savedGame.isGameOver) {
        // Convert data model to domain entity
        _game = GameEntity(
          score: savedGame.score,
          bestScore: bestScore,
          board: GameLogic.boardFromModel(savedGame.board),
          nextTile: TileEntity(value: savedGame.nextTile),
          isGameOver: savedGame.isGameOver,
        );
      } else {
        // Start a new game
        _game = GameLogic.initializeGame(bestScore: bestScore);
      }

      _isLoading = false;
      _gameStartTime = DateTime.now();
    });
  }

  void _handleSwipe(Direction direction) {
    if (_game.isGameOver) return;

    final newGame = GameLogic.processMove(_game, direction);

    // If the board changed, update the game state
    if (newGame != _game) {
      // Provide haptic feedback for the move
      if (_hapticEnabled) {
        HapticFeedbackService.lightImpact();

        // Check if any tiles were merged and get the highest merged value
        bool hasMerges = false;
        int highestMergedValue = 0;

        // Clear old popups
        _scorePopups.removeWhere((popup) => popup.shouldRemove());

        for (int i = 0; i < GameConstants.BOARD_SIZE; i++) {
          for (int j = 0; j < GameConstants.BOARD_SIZE; j++) {
            if (newGame.board[i][j]?.isMerged ?? false) {
              hasMerges = true;
              final tileValue = newGame.board[i][j]!.value;

              if (tileValue > highestMergedValue) {
                highestMergedValue = tileValue;
              }

              // Add a score popup for this merge
              _scorePopups.add(ScorePopup(score: tileValue, row: i, col: j));
            }
          }
        }

        // Provide feedback based on merges and their values
        if (hasMerges) {
          // Use the new method that provides feedback based on tile value
          HapticFeedbackService.tileValueFeedback(highestMergedValue);
        }
      }

      setState(() {
        _game = newGame;
      });

      // Save the game state
      _saveGameState();

      // Check if the game is over
      if (newGame.isGameOver) {
        _handleGameOver();
      }
    }
  }

  Future<void> _saveGameState() async {
    // Convert domain entity to data model
    final boardModel = GameLogic.boardToModel(_game.board);
    final gameModel =
        await _repository.loadGame() ??
        GameModel.newGame().copyWith(
          score: _game.score,
          bestScore: _game.bestScore,
          board: boardModel,
          nextTile: _game.nextTile.value,
          isGameOver: _game.isGameOver,
        );

    await _repository.saveGame(gameModel);

    // Update statistics for merged tiles
    await _updateMergeStatistics();
  }

  Future<void> _updateMergeStatistics() async {
    // Get current stats
    final stats = await _repository.loadStats();
    final mergeStats = Map<int, int>.from(stats.tileMergeCount);

    // Check for merged tiles and update stats
    bool hasUpdates = false;
    for (int i = 0; i < GameConstants.BOARD_SIZE; i++) {
      for (int j = 0; j < GameConstants.BOARD_SIZE; j++) {
        if (_game.board[i][j]?.isMerged ?? false) {
          final tileValue = _game.board[i][j]!.value;
          mergeStats[tileValue] = (mergeStats[tileValue] ?? 0) + 1;
          hasUpdates = true;
        }
      }
    }

    // If we found merged tiles, update the stats
    if (hasUpdates) {
      await _repository.saveStats(
        stats.copyWith(
          tileMergeCount: mergeStats,
          maxTileValue: _findMaxTileValue(),
        ),
      );
    }
  }

  // Helper method to find the maximum tile value on the board
  int _findMaxTileValue() {
    int maxValue = 0;

    for (int i = 0; i < GameConstants.BOARD_SIZE; i++) {
      for (int j = 0; j < GameConstants.BOARD_SIZE; j++) {
        if (_game.board[i][j] != null) {
          maxValue = _game.board[i][j]!.value > maxValue
              ? _game.board[i][j]!.value
              : maxValue;
        }
      }
    }

    return maxValue;
  }

  // Helper method to get the game mode title
  String _getGameModeTitle() {
    switch (_gameMode) {
      case GameMode.zen:
        return TextConstants.ZEN_MODE;
      case GameMode.timeChallenge:
        return TextConstants.TIME_CHALLENGE;
      case GameMode.dark:
        return TextConstants.DARK_MODE;
      case GameMode.classic:
        return TextConstants.CLASSIC_MODE;
    }
  }

  // Helper method to build the timer widget for time challenge mode
  Widget _buildTimerWidget() {
    // Format the time as MM:SS
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(
        vertical: UIConstants.SPACING_MEDIUM,
        horizontal: UIConstants.SPACING_MEDIUM,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            UIConstants.CARD_GRADIENT_START.withOpacity(0.8),
            UIConstants.CARD_GRADIENT_END.withOpacity(0.9),
          ],
          stops: const [0.2, 0.9],
        ),
        borderRadius: BorderRadius.circular(UIConstants.BORDER_RADIUS_LARGE),
        boxShadow: [
          BoxShadow(
            color: UIConstants.ACCENT_GLOW.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            TextConstants.TIME_LEFT,
            style: TextStyle(
              letterSpacing: 2.0,
              color: UIConstants.TEXT_SECONDARY_COLOR,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  _secondsRemaining < 30 ? Colors.red : UIConstants.CYAN_COLOR,
                ],
              ).createShader(bounds);
            },
            child: Text(
              timeString,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Progress indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value:
                  _secondsRemaining /
                  GameConstants.TIME_CHALLENGE_DURATION.inSeconds,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                _secondsRemaining < 30 ? Colors.red : UIConstants.CYAN_COLOR,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGameOver() async {
    // In Zen mode, there's no game over
    if (_isZenMode) {
      // Just continue playing by resetting the board but keeping the score
      int currentScore = _game.score;
      int bestScore = _game.bestScore;

      setState(() {
        _game = GameLogic.initializeGame(bestScore: bestScore);
        _game = _game.copyWith(score: currentScore);
      });

      return;
    }

    // Provide haptic feedback for game over
    if (_hapticEnabled) {
      HapticFeedbackService.heavyImpact();
    }

    if (_gameStartTime != null) {
      final gameTime = DateTime.now().difference(_gameStartTime!);
      final stats = await _repository.loadStats();

      // Update stats
      await _repository.saveStats(
        stats.copyWith(
          maxTileValue: _findMaxTileValue(),
          totalGamesPlayed: stats.totalGamesPlayed + 1,
          totalPlayTime: Duration(
            seconds: stats.totalPlayTime.inSeconds + gameTime.inSeconds,
          ),
        ),
      );
    }

    // Navigate to game over screen
    if (mounted) {
      String? title;
      String? subtitle;

      // Set custom title and subtitle based on game mode
      if (_gameMode == GameMode.dark) {
        title = TextConstants.DARK_MODE_TITLE;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                GameOverScreen(
                  score: _game.score,
                  gameOverTitle: title,
                  gameOverSubtitle: subtitle,
                  onRestart: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            GameScreen(gameMode: _gameMode),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeOutQuint;
                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, -1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOutQuint;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  // Also animate opacity
                  var opacityTween = Tween(
                    begin: 0.0,
                    end: 1.0,
                  ).chain(CurveTween(curve: curve));
                  var opacityAnimation = animation.drive(opacityTween);

                  return FadeTransition(
                    opacity: opacityAnimation,
                    child: SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    ),
                  );
                },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: UIConstants.BACKGROUND_COLOR,
        body: Center(
          child: CircularProgressIndicator(color: UIConstants.PURPLE_COLOR),
        ),
      );
    }

    return Stack(
      children: [
        Scaffold(
          backgroundColor: _isDarkMode
              ? UIConstants.DARK_MODE_BACKGROUND
              : UIConstants.BACKGROUND_COLOR,
          body: Stack(
            children: [
              // Background pattern - only show in non-dark mode
              if (!_isDarkMode)
                const Positioned.fill(child: BackgroundPatternWidget()),

              // Dark mode background
              if (_isDarkMode)
                Positioned.fill(
                  child: CustomPaint(painter: _DarkModeBackgroundPainter()),
                ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(UIConstants.SPACING_MEDIUM),
                  child: Column(
                    children: [
                      // Game title with elegant styling
                      Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: _isDarkMode
                                  ? [Colors.white, UIConstants.DARK_MODE_ACCENT]
                                  : [Colors.white, UIConstants.CYAN_COLOR],
                            ).createShader(bounds);
                          },
                          child: Text(
                            _getGameModeTitle(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: UIConstants.SPACING_MEDIUM),

                      // Enhanced score display with animation
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: UIConstants.SPACING_SMALL,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ScoreWidget(
                              label: TextConstants.SCORE,
                              score: _game.score,
                              width: 140,
                            ),
                            const SizedBox(width: UIConstants.SPACING_LARGE),
                            // Show timer for time challenge mode, otherwise show best score
                            _gameMode == GameMode.timeChallenge
                                ? _buildTimerWidget()
                                : ScoreWidget(
                                    label: TextConstants.BEST,
                                    score: _game.bestScore,
                                    width: 140,
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: UIConstants.SPACING_SMALL),

                      // Game hint
                      const GameHintWidget(),

                      const SizedBox(height: UIConstants.SPACING_MEDIUM),

                      // Game board
                      Expanded(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: GestureDetector(
                              onVerticalDragEnd: (details) {
                                if (details.primaryVelocity! < 0) {
                                  _handleSwipe(Direction.up);
                                } else if (details.primaryVelocity! > 0) {
                                  _handleSwipe(Direction.down);
                                }
                              },
                              onHorizontalDragEnd: (details) {
                                if (details.primaryVelocity! < 0) {
                                  _handleSwipe(Direction.left);
                                } else if (details.primaryVelocity! > 0) {
                                  _handleSwipe(Direction.right);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: _isDarkMode
                                      ? LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            UIConstants.DARK_MODE_SURFACE
                                                .withOpacity(0.95),
                                            UIConstants.DARK_MODE_SURFACE,
                                            Colors.black,
                                          ],
                                          stops: const [0.0, 0.5, 1.0],
                                        )
                                      : LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            UIConstants.GRID_BACKGROUND_COLOR
                                                .withOpacity(0.95),
                                            UIConstants.GRID_BACKGROUND_COLOR,
                                            Color(0xFF1D1D22),
                                          ],
                                          stops: const [0.0, 0.5, 1.0],
                                        ),
                                  borderRadius: BorderRadius.circular(
                                    UIConstants.BORDER_RADIUS_LARGE,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _isDarkMode
                                          ? UIConstants.DARK_MODE_ACCENT
                                                .withOpacity(0.4)
                                          : UIConstants.ACCENT_GLOW.withOpacity(
                                              0.4,
                                            ),
                                      blurRadius: 25,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 0),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: _isDarkMode
                                        ? UIConstants.DARK_MODE_ACCENT
                                              .withOpacity(0.2)
                                        : Colors.white.withOpacity(0.1),
                                    width: 1.5,
                                  ),
                                ),
                                padding: const EdgeInsets.all(
                                  UIConstants.SPACING_SMALL,
                                ),
                                child: Stack(
                                  children: [
                                    // The game grid - wrapped in RepaintBoundary for better performance
                                    RepaintBoundary(
                                      child: GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  GameConstants.BOARD_SIZE,
                                              childAspectRatio: 1,
                                              crossAxisSpacing:
                                                  UIConstants.SPACING_SMALL,
                                              mainAxisSpacing:
                                                  UIConstants.SPACING_SMALL,
                                            ),
                                        itemCount:
                                            GameConstants.BOARD_SIZE *
                                            GameConstants.BOARD_SIZE,
                                        itemBuilder: (context, index) {
                                          final row =
                                              index ~/ GameConstants.BOARD_SIZE;
                                          final col =
                                              index % GameConstants.BOARD_SIZE;
                                          final tile = _game.board[row][col];

                                          if (tile != null) {
                                            // Determine if this is a new tile from an edge
                                            bool isFromEdge =
                                                tile.isNew &&
                                                tile.previousX == null &&
                                                tile.previousY == null;

                                            // Determine which edge the new tile is coming from
                                            Direction? fromDirection;
                                            if (isFromEdge) {
                                              // 修正：根据位置确定新牌的出现方向
                                              // 顶部行的新牌来自上方
                                              if (row == 0) {
                                                fromDirection = Direction.up;
                                              }
                                              // 底部行的新牌来自下方
                                              else if (row ==
                                                  GameConstants.BOARD_SIZE -
                                                      1) {
                                                fromDirection = Direction.down;
                                              }
                                              // 最左列的新牌来自左侧
                                              else if (col == 0) {
                                                fromDirection = Direction.left;
                                              }
                                              // 最右列的新牌来自右侧
                                              else if (col ==
                                                  GameConstants.BOARD_SIZE -
                                                      1) {
                                                fromDirection = Direction.right;
                                              }
                                            }

                                            return TileWidget(
                                              value: tile.value,
                                              isNew: tile.isNew,
                                              isMerging: tile.isMerged,
                                              previousX: tile.previousX,
                                              previousY: tile.previousY,
                                              currentX: col,
                                              currentY: row,
                                              isFromEdge: isFromEdge,
                                              fromDirection: fromDirection,
                                            );
                                          } else {
                                            return Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    UIConstants.EMPTY_CELL_COLOR
                                                        .withOpacity(0.9),
                                                    UIConstants.EMPTY_CELL_COLOR
                                                        .withOpacity(0.7),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      UIConstants
                                                          .BORDER_RADIUS_MEDIUM,
                                                    ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 4,
                                                    spreadRadius: 0,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 1,
                                                    spreadRadius: 0,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                                border: Border.all(
                                                  color: Colors.white
                                                      .withOpacity(0.05),
                                                  width: 0.5,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),

                                    // Score popups - wrapped in RepaintBoundary for better performance
                                    ...(_scorePopups.isEmpty
                                        ? []
                                        : [
                                            RepaintBoundary(
                                              child: Stack(
                                                children: _scorePopups.map((
                                                  popup,
                                                ) {
                                                  // Calculate position based on grid size
                                                  final gridSize =
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width -
                                                      UIConstants
                                                              .SPACING_MEDIUM *
                                                          2 -
                                                      UIConstants
                                                              .SPACING_SMALL *
                                                          2;
                                                  final tileSize =
                                                      (gridSize -
                                                          (GameConstants
                                                                      .BOARD_SIZE -
                                                                  1) *
                                                              UIConstants
                                                                  .SPACING_SMALL) /
                                                      GameConstants.BOARD_SIZE;
                                                  final spacing =
                                                      UIConstants.SPACING_SMALL;

                                                  // Calculate the position of the popup
                                                  final dx =
                                                      popup.col *
                                                          (tileSize + spacing) +
                                                      tileSize / 2 -
                                                      20;
                                                  final dy =
                                                      popup.row *
                                                          (tileSize + spacing) +
                                                      tileSize / 2 -
                                                      15;

                                                  return ScorePopupWidget(
                                                    score: popup.score,
                                                    position: Offset(dx, dy),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Game tip text
                      Container(
                        margin: const EdgeInsets.only(
                          top: UIConstants.SPACING_SMALL,
                          bottom: UIConstants.SPACING_MEDIUM,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: UIConstants.SPACING_SMALL,
                          horizontal: UIConstants.SPACING_MEDIUM,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              UIConstants.CARD_GRADIENT_START.withOpacity(0.3),
                              UIConstants.CARD_GRADIENT_END.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            UIConstants.BORDER_RADIUS_MEDIUM,
                          ),
                          border: Border.all(
                            color: UIConstants.GRID_LINE_COLOR.withOpacity(0.3),
                            width: 0.5,
                          ),
                        ),
                        child: const GameTipWidget(),
                      ),

                      // Next tile indicator and pause button
                      Padding(
                        padding: const EdgeInsets.only(
                          top: UIConstants.SPACING_MEDIUM,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  TextConstants.NEXT,
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(letterSpacing: 1.0),
                                ),
                                const SizedBox(height: 4),
                                TileWidget(
                                  value: _game.nextTile.value,
                                  size: 48,
                                  currentX: 0, // Placeholder position
                                  currentY: 0, // Placeholder position
                                ),
                              ],
                            ),
                            GlassCard(
                              padding: const EdgeInsets.all(
                                UIConstants.SPACING_SMALL,
                              ),
                              borderRadius: BorderRadius.circular(
                                UIConstants.BORDER_RADIUS_XLARGE,
                              ),
                              onTap: () {
                                // Provide haptic feedback for button press
                                if (_hapticEnabled) {
                                  HapticFeedbackService.vibrate();
                                }

                                // Show pause dialog
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: UIConstants.SURFACE_COLOR,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        UIConstants.BORDER_RADIUS_MEDIUM,
                                      ),
                                    ),
                                    title: const Text(
                                      'Game Paused',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            if (_hapticEnabled) {
                                              HapticFeedbackService.vibrate();
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Resume',
                                            style: TextStyle(
                                              color: UIConstants.PURPLE_COLOR,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (_hapticEnabled) {
                                              HapticFeedbackService.vibrate();
                                            }
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Quit Game',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.pause,
                                color: Colors.white70,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tutorial overlay for first-time users
        if (_showTutorial)
          TutorialOverlay(
            onClose: () {
              setState(() {
                _showTutorial = false;
              });
            },
          ),
      ],
    );
  }
}
