import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/game_engine.dart';
import '../widgets/game_board.dart';
import '../styles/app_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late GameEngine _gameEngine;
  Timer? _timer;
  Duration _duration = Duration.zero;
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _gameEngine = GameEngine();
    _gameEngine.addListener(_onGameStateChanged);
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _startGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _gameEngine.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _startGame() {
    _gameEngine.initialize();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = _gameEngine.playDuration;
      });
    });
  }

  void _onGameStateChanged() {
    setState(() {});
    if (_gameEngine.isSolved) {
      _timer?.cancel();
      _confettiController.forward(from: 0);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.military_tech,
              color: AppTheme.secondaryColor,
              size: 32,
            ),
            const SizedBox(width: 8),
            const Text('大获全胜！'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '智勇双全，运筹帷幄！',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatRow(
              icon: Icons.timer,
              label: '征战用时',
              value: _formatDuration(_duration),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              icon: Icons.directions_walk,
              label: '调度次数',
              value: '${_gameEngine.moves}次',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showDifficultyDialog();
            },
            child: const Text('更换难度'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startGame();
            },
            child: const Text('再战一局'),
          ),
        ],
      ),
    );
  }

  void _showDifficultyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择难度'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: GameDifficulty.values.map((difficulty) {
            final isSelected = difficulty == _gameEngine.difficulty;
            return ListTile(
              title: Text(
                difficulty.label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected ? AppTheme.primaryColor : AppTheme.textColor,
                ),
              ),
              subtitle: Text('${difficulty.gridSize}x${difficulty.gridSize}'),
              leading: Icon(
                Icons.grid_4x4,
                color: isSelected ? AppTheme.primaryColor : Colors.grey,
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: AppTheme.primaryColor,
                    )
                  : null,
              onTap: () {
                Navigator.pop(context);
                _gameEngine.setDifficulty(difficulty);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_gameEngine.difficulty.label}模式',
          style: const TextStyle(letterSpacing: 4),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_4x4),
            tooltip: '选择难度',
            onPressed: _showDifficultyDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重新开始',
            onPressed: _startGame,
          ),
        ],
      ),
      body: Container(
        decoration: AppTheme.backgroundDecoration,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoCard(
                      icon: Icons.timer,
                      label: '用时',
                      value: _formatDuration(_duration),
                    ),
                    _buildInfoCard(
                      icon: Icons.directions_walk,
                      label: '步数',
                      value: '${_gameEngine.moves}步',
                    ),
                    _buildInfoCard(
                      icon: Icons.grid_4x4,
                      label: '难度',
                      value: _gameEngine.difficulty.label,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GameBoard(
                    gameEngine: _gameEngine,
                    onTileTapped: (position) {
                      _gameEngine.moveTile(position);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.borderColor,
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.surfaceColor,
              AppTheme.surfaceColor.withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: AppTheme.primaryColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textColor.withOpacity(0.7),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.textColor,
          ),
        ),
      ],
    );
  }
}
