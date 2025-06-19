import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('关于我们'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        backgroundIndex: 7,
        overlayOpacity: 0.7,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome,
                        size: 80, color: Colors.blueAccent),
                    const SizedBox(height: 20),
                    Text(
                      '光刃工作室',
                      style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '我们是一个充满激情的小型独立开发团队，致力于创造简洁、有趣且富有挑战性的游戏体验。',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge
                          ?.copyWith(color: Colors.white70, height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 20),
                    Text(
                      '《神将GO》是我们对快节奏街机风格游戏的一次致敬，希望它能带给您片刻的纯粹乐趣。',
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                          color: Colors.white70, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 20),
                    _buildInfoRow('游戏版本', '1.0.0'),
                    const SizedBox(height: 10),
                    _buildInfoRow('联系我们', '通过"反馈"页面'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
