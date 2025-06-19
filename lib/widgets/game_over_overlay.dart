import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRestart;
  final int finalScore;
  final int highScore;

  const GameOverOverlay({
    super.key,
    required this.onRestart,
    required this.finalScore,
    required this.highScore,
  });

  @override
  Widget build(BuildContext context) {
    final isNewHighScore = finalScore >= highScore && finalScore > 0;

    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isNewHighScore ? Colors.yellow : Colors.red,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isNewHighScore ? Colors.yellow : Colors.red)
                      .withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 5,
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '游戏结束',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.white, blurRadius: 2)]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (isNewHighScore) ...[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '新纪录！',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              _buildScoreRow('最终得分', finalScore, Colors.white),
              const SizedBox(height: 8),
              _buildScoreRow('最高纪录', highScore, Colors.yellow),
              const SizedBox(height: 32),
              SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    // 延迟执行返回主界面操作，避免在状态转换过程中触发错误
                    Future.delayed(const Duration(milliseconds: 50), () {
                      // 返回主界面
                      Navigator.of(context).pop();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 8),
                      Text('返回主界面'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, int score, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 18,
          ),
        ),
        Text(
          '$score',
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
