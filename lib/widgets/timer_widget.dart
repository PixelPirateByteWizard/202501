import 'package:flutter/material.dart';
import '../utils/time_utils.dart';

enum TimerMode { work, shortBreak, longBreak }

class TimerWidget extends StatelessWidget {
  final int currentTime; // in seconds
  final int totalTime; // in seconds
  final TimerMode timerMode;
  final String status;
  final VoidCallback onPlayPause;
  final VoidCallback onReset;
  final VoidCallback onSkip;
  final bool isPlaying;

  const TimerWidget({
    Key? key,
    required this.currentTime,
    required this.totalTime,
    required this.timerMode,
    required this.status,
    required this.onPlayPause,
    required this.onReset,
    required this.onSkip,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color progressColor;
    switch (timerMode) {
      case TimerMode.work:
        progressColor = const Color(0xFF2CB67D); // Accent green
        break;
      case TimerMode.shortBreak:
      case TimerMode.longBreak:
        progressColor = const Color(0xFFFF6B6B); // Accent red
        break;
    }

    return Column(
      children: [
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF24263A), // Dark card bg
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 240,
                height: 240,
                child: CircularProgressIndicator(
                  value:
                      totalTime > 0 ? (totalTime - currentTime) / totalTime : 0,
                  strokeWidth: 12.0,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formatTime(currentTime),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(
              Icons.refresh,
              onReset,
              const Color(0xFF24263A),
            ),
            const SizedBox(width: 16),
            _buildIconButton(
              isPlaying ? Icons.pause : Icons.play_arrow,
              onPlayPause,
              const Color(0xFF7F5AF0), // Primary purple
              size: 60,
              iconSize: 32,
            ),
            const SizedBox(width: 16),
            _buildIconButton(
              Icons.skip_next,
              onSkip,
              const Color(0xFF24263A),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(
    IconData icon,
    VoidCallback onPressed,
    Color backgroundColor, {
    double size = 45,
    double iconSize = 24,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          child: Icon(
            icon,
            size: iconSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
