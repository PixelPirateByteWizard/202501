import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameInfoScreen extends StatefulWidget {
  const GameInfoScreen({super.key});

  @override
  State<GameInfoScreen> createState() => _GameInfoScreenState();
}

class _GameInfoScreenState extends State<GameInfoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<GameInfoSection> _sections = [
    GameInfoSection(
      title: 'Game Overview',
      icon: Icons.games_rounded,
      color: Colors.blue,
      content: [
        'Welcome to Zyphyn - an exciting snake game that combines classic gameplay with modern twists!',
        'Navigate through increasingly challenging levels, collect points, and master the art of portal transportation.',
        'With 6 unique levels, each featuring different obstacles and portal configurations, your skills will be put to the test.',
      ],
    ),
    GameInfoSection(
      title: 'How to Play',
      icon: Icons.sports_esports_rounded,
      color: Colors.green,
      content: [
        'Control Direction: Swipe in any direction to guide your snake',
        'Collect Points: Eat the glowing orbs to grow longer and score points',
        'Use Portals: Travel through matching colored portals for strategic advantage',
        'Avoid Collisions: Don\'t hit walls, obstacles, or your own tail',
        'Complete Levels: Reach the target score to advance to the next level',
      ],
    ),
    GameInfoSection(
      title: 'Special Features',
      icon: Icons.auto_awesome_rounded,
      color: Colors.amber,
      content: [
        'Portal System: Strategic teleportation between paired portals',
        'Dynamic Obstacles: Each level features unique obstacle patterns',
        'Progressive Difficulty: Speed and complexity increase as you advance',
        'Achievement System: Unlock special achievements as you complete levels',
        'Lives System: Three chances to complete each level',
      ],
    ),
    GameInfoSection(
      title: 'Scoring System',
      icon: Icons.stars_rounded,
      color: Colors.orange,
      content: [
        'Basic Points: +1 point for each collected orb',
        'Level Completion: Bonus points for completing levels quickly',
        'Target Scores: Each level has a specific target score to achieve',
        'Perfect Run: Additional bonus for completing a level without dying',
      ],
    ),
    GameInfoSection(
      title: 'Controls & Interface',
      icon: Icons.touch_app_rounded,
      color: Colors.purple,
      content: [
        'Swipe Controls: Intuitive touch controls for movement',
        'Pause/Resume: Tap the pause button to take a break',
        'Status Bar: Track your level, score, and remaining lives',
        'Progress Indicator: Monitor your progress towards the level target',
        'Expandable Panel: Toggle the bottom info panel for a larger game area',
      ],
    ),
    GameInfoSection(
      title: 'Tips & Tricks',
      icon: Icons.lightbulb_rounded,
      color: Colors.deepOrange,
      content: [
        'Plan Your Route: Look ahead and plan your path through obstacles',
        'Portal Strategy: Use portals to escape tight situations',
        'Space Management: Keep track of your snake\'s length when navigating',
        'Pattern Recognition: Learn the obstacle patterns in each level',
        'Timing is Key: Master the speed changes between levels',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4EABE9).withOpacity(0.1),
              const Color(0xFFF5FAFD),
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              stretch: true,
              backgroundColor: const Color(0xFF4EABE9),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Game Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF4EABE9),
                        const Color(0xFF4EABE9).withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index >= _sections.length) return null;
                  return FadeTransition(
                    opacity: _animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 0.1 * (index + 1)),
                        end: Offset.zero,
                      ).animate(_animation),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildInfoCard(_sections[index]),
                      ),
                    ),
                  );
                }, childCount: _sections.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(GameInfoSection section) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, const Color(0xFFF5FAFD)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: section.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: section.color.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(section.icon, color: section.color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    section.content.map((text) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: section.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameInfoSection {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> content;

  GameInfoSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
  });
}
