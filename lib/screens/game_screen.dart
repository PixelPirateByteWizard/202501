import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/game_level.dart';
import '../models/bottle.dart';
import '../services/game_service.dart';
import '../services/sound_service.dart';
import '../services/achievement_service.dart';
import '../services/hint_service.dart';
import '../widgets/game_header.dart';
import '../widgets/game_footer.dart';
import '../widgets/bottle_widget.dart';
import '../widgets/shelf_widget.dart';
import '../widgets/particle_effect.dart';
import '../widgets/achievement_notification.dart';
import 'win_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  final GameService _gameService = GameService();
  late GameState _gameState;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  
  bool _showWinDialog = false;
  final List<Widget> _particleEffects = [];
  final List<Widget> _achievementNotifications = [];
  HintMove? _currentHint;

  @override
  void initState() {
    super.initState();
    
    // Initialize sound service
    SoundService.initialize();
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _waveAnimation = Tween<double>(
      begin: 0,
      end: 6.28318, // 2 * PI
    ).animate(_waveController);
    
    // Initialize with default state
    _gameState = GameState(
      bottles: [],
      currentLevel: 1,
      moveCount: 0,
      undoCount: 5,
    );
    
    // Initialize with level 1
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLevel(1);
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _initializeLevel(int levelNumber) {
    setState(() {
      _showWinDialog = false;
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      final gameAreaSize = Size(
        screenSize.width,
        screenSize.height - 200, // Account for header and footer
      );
      
      setState(() {
        _gameState = _gameService.initializeLevel(levelNumber, gameAreaSize);
      });
    });
  }

  void _handleBottleClick(int bottleIndex) {
    if (_gameState.isAnimating || _showWinDialog) return;
    
    final clickedBottle = _gameState.bottles[bottleIndex];
    final currentState = _gameState;
    final newState = _gameService.handleBottleClick(currentState, clickedBottle);
    
    if (newState != null) {
      setState(() {
        _gameState = newState;
      });
      
      // Check win condition after each move
      if (_gameState.isWon) {
        _gameService.saveProgress(_gameState);
        _checkAchievements();
        _addParticleEffect(clickedBottle);
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _showWinDialog = true;
            });
          }
        });
      } else if (newState.moveCount > currentState.moveCount) {
        // Add particle effect for successful move (pour or remove)
        _addParticleEffect(clickedBottle);
      }
    }
  }

  void _handleUndo() {
    final newState = _gameService.undoMove(_gameState);
    if (newState != null) {
      setState(() {
        _gameState = newState;
      });
    }
  }

  void _handleAddBottle() {
    final newState = _gameService.addEmptyBottle(_gameState);
    if (newState != _gameState) {
      final screenSize = MediaQuery.of(context).size;
      final gameAreaSize = Size(
        screenSize.width,
        screenSize.height - 200,
      );
      
      setState(() {
        _gameState = _gameService.repositionBottles(newState, gameAreaSize);
      });
    }
  }

  void _handleRemoveColor() {
    setState(() {
      _gameState = _gameService.activateRemoveColor(_gameState);
    });
  }

  void _handleRestart() {
    _initializeLevel(_gameState.currentLevel);
  }

  void _handleNextLevel() {
    final nextLevel = _gameState.currentLevel + 1;
    final maxLevel = GameLevel.levels.length - 1;
    
    if (nextLevel <= maxLevel) {
      _initializeLevel(nextLevel);
    } else {
      // If it's the last level, show a congratulatory message or go back to level selection
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Congratulations! You have completed all levels!'),
          duration: Duration(seconds: 2),
        ),
      );
      // You can choose to go back to the first level or the level selection screen
      Navigator.of(context).pop();
    }
  }

  void _handleHint(HintMove hint) {
    setState(() {
      _currentHint = hint;
      _gameState = _gameService.useHint(_gameState);
    });
    
    // Clear hint after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentHint = null;
        });
      }
    });
  }

  void _addParticleEffect(Bottle bottle) {
    final effectKey = UniqueKey();
    final effect = Positioned(
      key: effectKey,
      left: bottle.x + 25,
      top: bottle.y + 100,
      child: ParticleEffect(
        position: Offset(bottle.x + 25, bottle.y + 100),
        color: bottle.topColor ?? Colors.blue,
        onComplete: () {
          setState(() {
            _particleEffects.removeWhere((widget) => widget.key == effectKey);
          });
        },
      ),
    );
    
    setState(() {
      _particleEffects.add(effect);
    });
  }

  Future<void> _checkAchievements() async {
    final achievements = await AchievementService.checkAchievements(
      _gameState,
      _gameState.elapsedTimeInSeconds,
      _gameState.usedUndo,
    );
    
    for (final achievement in achievements) {
      _showAchievementNotification(achievement);
    }
  }

  void _showAchievementNotification(achievement) {
    final notification = AchievementNotification(
      achievement: achievement,
      onDismiss: () {
        setState(() {
          _achievementNotifications.removeWhere((widget) => 
              widget is AchievementNotification && 
              widget.achievement.id == achievement.id);
        });
      },
    );
    
    setState(() {
      _achievementNotifications.add(notification);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/background/background_2.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                GameHeader(
                  gameState: _gameState,
                  onRestart: _handleRestart,
                  onHintSelected: _handleHint,
                ),
                
                // Game area
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          // Shelves
                          ShelfWidget(
                            bottles: _gameState.bottles,
                            screenSize: constraints.biggest,
                          ),
                          
                          // Bottles
                          ...List.generate(_gameState.bottles.length, (index) {
                            final bottle = _gameState.bottles[index];
                            final isHintBottle = _currentHint != null && 
                                (bottle == _currentHint!.fromBottle || 
                                 bottle == _currentHint!.toBottle);
                            
                            return BottleWidget(
                              key: ValueKey('bottle_$index'),
                              bottle: bottle,
                              isSelected: _gameState.selectedBottle == bottle,
                              isRemovingColor: _gameState.isRemovingColor,
                              onTap: () => _handleBottleClick(index),
                              waveAnimation: _waveAnimation,
                              isHinted: isHintBottle,
                            );
                          }),
                          
                          // Particle effects
                          ..._particleEffects,
                        ],
                      );
                    },
                  ),
                ),
                
                // Footer
                GameFooter(
                  gameState: _gameState,
                  onAddBottle: _handleAddBottle,
                  onRemoveColor: _handleRemoveColor,
                  onUndo: _handleUndo,
                ),
              ],
            ),
          ),
          
          // Win dialog overlay
          if (_showWinDialog)
            WinDialog(
              levelNumber: _gameState.currentLevel,
              moveCount: _gameState.moveCount,
              onNextLevel: _handleNextLevel,
            ),
          
          // Achievement notifications
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              children: _achievementNotifications,
            ),
          ),
        ],
      ),
    );
  }
}