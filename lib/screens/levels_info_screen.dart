import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LevelsInfoScreen extends StatefulWidget {
  const LevelsInfoScreen({super.key});

  @override
  State<LevelsInfoScreen> createState() => _LevelsInfoScreenState();
}

class _LevelsInfoScreenState extends State<LevelsInfoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<LevelInfo> _levels = [
    LevelInfo(
      level: 1,
      title: "Beginner's Path",
      description:
          "Welcome to your first challenge! This introductory level features simple obstacles and a single portal pair. Perfect for mastering the basic mechanics and getting familiar with portal transportation.",
      features: [
        "Speed: 250ms - A gentle pace to start your journey",
        "Target Score: 15 points - Achievable goal for newcomers",
        "Initial Snake Length: 6 units - Manageable size for learning",
        "Portals: 1 pair - Introduction to portal mechanics",
        "Obstacles: Corner barriers for basic navigation practice",
      ],
      tips: [
        "Take your time to understand the controls",
        "Practice using the portal for quick escapes",
        "Focus on collecting orbs near the edges first",
        "Keep track of your snake's length when using portals",
      ],
      icon: Icons.looks_one_rounded,
      color: Colors.blue,
    ),
    LevelInfo(
      level: 2,
      title: "Growing Challenge",
      description:
          "Step up your game with increased complexity! This level introduces a central cross obstacle pattern and two portal pairs, requiring more strategic thinking and careful navigation.",
      features: [
        "Speed: 220ms - Slightly faster pace",
        "Target Score: 20 points - Higher goal for growing skills",
        "Initial Snake Length: 8 units - Increased challenge",
        "Portals: 1 pair - Strategic portal placement",
        "Obstacles: Central cross pattern + corner barriers",
      ],
      tips: [
        "Use the central cross as a reference point",
        "Plan your route around obstacles carefully",
        "Utilize portals to avoid tight situations",
        "Watch your tail length when navigating corners",
      ],
      icon: Icons.looks_two_rounded,
      color: Colors.green,
    ),
    LevelInfo(
      level: 3,
      title: "Portal Master",
      description:
          "Time to master the art of portal navigation! This level challenges you with complex obstacle patterns and multiple portal pairs, testing your ability to think quickly and move strategically.",
      features: [
        "Speed: 190ms - Increased reaction requirements",
        "Target Score: 25 points - Test your portal mastery",
        "Initial Snake Length: 10 units - Greater spatial awareness needed",
        "Portals: 2 pairs - Advanced portal combinations",
        "Obstacles: Complex central area + edge barriers",
      ],
      tips: [
        "Learn to chain portal jumps effectively",
        "Keep track of both portal pairs",
        "Use edge barriers to your advantage",
        "Plan your growth pattern carefully",
      ],
      icon: Icons.looks_3_rounded,
      color: Colors.orange,
    ),
    LevelInfo(
      level: 4,
      title: "Maze Runner",
      description:
          "Navigate through an intricate maze-like environment! This level combines challenging obstacle patterns with strategic portal placement, requiring quick thinking and precise movement control.",
      features: [
        "Speed: 160ms - Fast-paced challenge",
        "Target Score: 30 points - High skill requirement",
        "Initial Snake Length: 12 units - Complex navigation",
        "Portals: 2 pairs - Strategic escape routes",
        "Obstacles: Maze-like patterns + strategic barriers",
      ],
      tips: [
        "Study the maze pattern before rushing in",
        "Use portals to bypass difficult sections",
        "Create a mental map of safe zones",
        "Time your portal usage carefully",
      ],
      icon: Icons.looks_4_rounded,
      color: Colors.purple,
    ),
    LevelInfo(
      level: 5,
      title: "Speed Demon",
      description:
          "Push your reflexes to the limit! This high-speed challenge features a complex maze and three portal pairs, designed to test even the most experienced players.",
      features: [
        "Speed: 130ms - Lightning-fast reactions needed",
        "Target Score: 35 points - Expert level challenge",
        "Initial Snake Length: 14 units - Maximum awareness required",
        "Portals: 3 pairs - Multiple escape options",
        "Obstacles: Complex maze + strategic barriers",
      ],
      tips: [
        "Stay calm under pressure",
        "Master all three portal pairs",
        "Use quick direction changes",
        "Plan several moves ahead",
      ],
      icon: Icons.looks_5_rounded,
      color: Colors.red,
    ),
    LevelInfo(
      level: 6,
      title: "Ultimate Challenge",
      description:
          "The final test of your mastery! This level combines all previous challenges with maximum difficulty, featuring intricate obstacle patterns and strategic portal placement. Only the most skilled players will prevail!",
      features: [
        "Speed: 100ms - Maximum speed challenge",
        "Target Score: 45 points - Ultimate goal",
        "Initial Snake Length: 16 units - Supreme control required",
        "Portals: 3 pairs - Master portal navigation",
        "Obstacles: Extreme maze + strategic barriers",
      ],
      tips: [
        "Utilize every available space",
        "Master portal chain movements",
        "Stay focused and patient",
        "Remember your training from previous levels",
      ],
      icon: Icons.workspace_premium_rounded,
      color: Colors.amber,
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
                  'Level Information',
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
                  if (index >= _levels.length) return null;
                  return FadeTransition(
                    opacity: _animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 0.1 * (index + 1)),
                        end: Offset.zero,
                      ).animate(_animation),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildLevelCard(_levels[index]),
                      ),
                    ),
                  );
                }, childCount: _levels.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(LevelInfo level) {
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
            _buildLevelHeader(level),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle(
                    'Level Features',
                    Icons.featured_play_list_rounded,
                    level.color,
                  ),
                  const SizedBox(height: 8),
                  ...level.features.map(
                    (feature) => _buildBulletPoint(feature, level.color),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle(
                    'Pro Tips',
                    Icons.tips_and_updates_rounded,
                    level.color,
                  ),
                  const SizedBox(height: 8),
                  ...level.tips.map(
                    (tip) => _buildBulletPoint(tip, level.color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelHeader(LevelInfo level) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: level.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: level.color.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(level.icon, color: level.color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level ${level.level}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: level.color,
                  ),
                ),
                Text(
                  level.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
  }
}

class LevelInfo {
  final int level;
  final String title;
  final String description;
  final List<String> features;
  final List<String> tips;
  final IconData icon;
  final Color color;

  LevelInfo({
    required this.level,
    required this.title,
    required this.description,
    required this.features,
    required this.tips,
    required this.icon,
    required this.color,
  });
}
