import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6A4C93), Color(0xFF9B6DFF)],
                  stops: [0.2, 0.9],
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6A4C93).withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.white),
                        padding: EdgeInsets.zero,
                      ),
                      const Text(
                        'Help Center',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Everything you need to know about Joyee',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFF0F0F0),
                      letterSpacing: 0.5,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildHelpSection(
                    'Practice Features',
                    [
                      'Choose your preferred instrument from our extensive collection',
                      'Set custom practice duration and goals',
                      'Track your progress with detailed statistics',
                      'Get personalized practice recommendations',
                      'Record and playback your practice sessions',
                    ],
                    Icons.music_note,
                    const Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 16),
                  _buildHelpSection(
                    'Community Interaction',
                    [
                      'Connect with fellow musicians worldwide',
                      'Share your practice achievements and milestones',
                      'Join instrument-specific discussion groups',
                      'Get feedback from experienced players',
                      'Participate in weekly challenges and events',
                    ],
                    Icons.people,
                    const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 16),
                  _buildHelpSection(
                    'AI Assistant',
                    [
                      'Get instant answers to music theory questions',
                      'Receive personalized practice suggestions',
                      'Analyze your playing technique',
                      'Access comprehensive instrument guides',
                      'Learn about different musical styles and genres',
                    ],
                    Icons.psychology,
                    const Color(0xFF9C27B0),
                  ),
                  const SizedBox(height: 16),
                  _buildHelpSection(
                    'Progress Tracking',
                    [
                      'View detailed practice statistics and analytics',
                      'Set and monitor personal goals',
                      'Track your improvement over time',
                      'Earn achievements and rewards',
                      'Generate progress reports',
                    ],
                    Icons.trending_up,
                    const Color(0xFFFF9800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(
    String title,
    List<String> points,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...points
                .map((point) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF666666),
                                height: 1.5,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
