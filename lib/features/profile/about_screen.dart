import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      body: SafeArea(
        child: Column(
          children: [
            // Navigation Bar
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Color(0xFFE6EDF3),
                      size: 28,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      '关于我们',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE6EDF3),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 28), // Balance the back button
                ],
              ),
            ),
            // Content
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.scatter_plot,
                        size: 120,
                        color: Color(0xFF4A90E2),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'CoinVerse',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFE6EDF3),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF8B949E),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '我们致力于在海量的加密世界噪音中，为您提炼真正有价值的决策信号。CoinVerse 不仅仅是资讯，更是您的专属AI加密策略师。',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFE6EDF3),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}