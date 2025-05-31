import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/storage_service.dart';

class GameOverScreen extends StatefulWidget {
  final int score;
  final int wave;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const GameOverScreen({
    Key? key,
    required this.score,
    required this.wave,
    required this.onRestart,
    required this.onExit,
  }) : super(key: key);

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _highScore = 0;
  int _maxWave = 0;
  bool _isNewHighScore = false;
  bool _isNewMaxWave = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final highScore = await StorageService.loadHighScore();
    final maxWave = await StorageService.loadMaxWave();

    setState(() {
      _highScore = highScore;
      _maxWave = maxWave;
      _isNewHighScore = widget.score > highScore;
      _isNewMaxWave = widget.wave > maxWave;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstants.gameOverScreenGradient,
        ),
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            );
          },
          child: Center(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.red.shade900,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.shade900.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.mood_bad,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tribulation Failed',
                    style: AppConstants.headlineMedium.copyWith(
                      color: Colors.red.shade300,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildStatRow('Final Cultivation', widget.score.toString(),
                      isHighlighted: _isNewHighScore),
                  const SizedBox(height: 12),
                  _buildStatRow('Highest Tribulation', widget.wave.toString(),
                      isHighlighted: _isNewMaxWave),
                  if (_isNewHighScore || _isNewMaxWave) ...[
                    const SizedBox(height: 16),
                    Text(
                      _isNewHighScore && _isNewMaxWave
                          ? 'Congratulations on breaking both cultivation and tribulation records!'
                          : _isNewHighScore
                              ? 'Congratulations on breaking the cultivation record!'
                              : 'Congratulations on breaking the tribulation record!',
                      style: AppConstants.bodyLarge.copyWith(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: widget.onRestart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          foregroundColor: AppConstants.darkTextColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.replay),
                            SizedBox(width: 8),
                            Text('Restart Journey'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: widget.onExit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.home),
                            SizedBox(width: 8),
                            Text('Return Home'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value,
      {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppConstants.bodyLarge.copyWith(
            color: Colors.grey.shade300,
          ),
        ),
        Row(
          children: [
            if (isHighlighted)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.new_releases,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
            Text(
              value,
              style: AppConstants.bodyLarge.copyWith(
                color: isHighlighted ? Colors.amber : Colors.white,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
