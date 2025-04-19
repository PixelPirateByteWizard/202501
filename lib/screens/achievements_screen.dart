import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final List<Achievement> _achievements = [
    Achievement(
      title: 'First Steps',
      description: 'Complete Level 1',
      praise: 'Great start! You\'re showing real potential!',
      icon: Icons.looks_one,
      level: 1,
      color: Colors.blue,
    ),
    Achievement(
      title: 'Rising Star',
      description: 'Complete Level 2',
      praise: 'Your skills are developing impressively!',
      icon: Icons.looks_two,
      level: 2,
      color: Colors.green,
    ),
    Achievement(
      title: 'Portal Prodigy',
      description: 'Complete Level 3',
      praise: 'Amazing portal mastery! Keep pushing forward!',
      icon: Icons.looks_3,
      level: 3,
      color: Colors.orange,
    ),
    Achievement(
      title: 'Maze Master',
      description: 'Complete Level 4',
      praise: 'Exceptional navigation skills! You\'re a natural!',
      icon: Icons.looks_4,
      level: 4,
      color: Colors.purple,
    ),
    Achievement(
      title: 'Speed Demon',
      description: 'Complete Level 5',
      praise: 'Incredible reflexes! You\'re among the elite!',
      icon: Icons.looks_5,
      level: 5,
      color: Colors.red,
    ),
    Achievement(
      title: 'Snake Legend',
      description: 'Complete Level 6',
      praise: 'Legendary achievement! You\'re truly unstoppable!',
      icon: Icons.workspace_premium,
      level: 6,
      color: Colors.amber,
    ),
  ];

  Map<int, bool> _unlockedAchievements = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _loadAchievements();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _unlockedAchievements = Map.fromEntries(
        _achievements.map(
          (achievement) => MapEntry(
            achievement.level,
            prefs.getBool('achievement_${achievement.level}') ?? false,
          ),
        ),
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int unlockedCount = _unlockedAchievements.values.where((v) => v).length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFE8F4FB), const Color(0xFFF5FAFD)],
          ),
        ),
        child: SafeArea(
          child:
              _isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4EABE9)),
                  )
                  : CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: const Color(0xFF4EABE9),
                        expandedHeight: 180,
                        pinned: true,
                        centerTitle: true,
                        title: const Text(
                          'Achievements',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF4EABE9),
                                  const Color(0xFF4EABE9).withOpacity(0.9),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 60),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: CircularProgressIndicator(
                                          value:
                                              unlockedCount /
                                              _achievements.length,
                                          strokeWidth: 6,
                                          backgroundColor: Colors.white24,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '${(unlockedCount / _achievements.length * 100).toInt()}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Unlocked $unlockedCount/${_achievements.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12.0,
                                crossAxisSpacing: 12.0,
                                childAspectRatio: 0.85,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final achievement = _achievements[index];
                            final isUnlocked =
                                _unlockedAchievements[achievement.level] ??
                                false;
                            return _buildAchievementCard(
                              achievement,
                              isUnlocked,
                            );
                          }, childCount: _achievements.length),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement, bool isUnlocked) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4EABE9).withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAchievementDetails(achievement, isUnlocked),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            isUnlocked
                                ? const Color(0xFF4EABE9).withOpacity(0.1)
                                : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        achievement.icon,
                        size: 32,
                        color:
                            isUnlocked
                                ? const Color(0xFF4EABE9)
                                : Colors.grey.shade400,
                      ),
                    ),
                    if (!isUnlocked)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  achievement.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        isUnlocked
                            ? const Color(0xFF4EABE9)
                            : Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                if (isUnlocked) ...[
                  const SizedBox(height: 8),
                  Text(
                    achievement.praise,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: achievement.color,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isUnlocked
                            ? const Color(0xFF4EABE9).withOpacity(0.1)
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isUnlocked ? Icons.check_circle : Icons.lock_clock,
                        size: 14,
                        color:
                            isUnlocked
                                ? const Color(0xFF4EABE9)
                                : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isUnlocked ? 'Completed' : 'Locked',
                        style: TextStyle(
                          color:
                              isUnlocked
                                  ? const Color(0xFF4EABE9)
                                  : Colors.grey.shade400,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement, bool isUnlocked) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.85,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4EABE9).withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color:
                                          isUnlocked
                                              ? const Color(
                                                0xFF4EABE9,
                                              ).withOpacity(0.1)
                                              : Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      achievement.icon,
                                      size: 48,
                                      color:
                                          isUnlocked
                                              ? const Color(0xFF4EABE9)
                                              : Colors.grey.shade400,
                                    ),
                                  ),
                                  if (!isUnlocked)
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.lock,
                                        size: 24,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                achievement.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      isUnlocked
                                          ? const Color(0xFF4EABE9)
                                          : Colors.grey.shade700,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                achievement.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                ),
                              ),
                              if (isUnlocked) ...[
                                const SizedBox(height: 16),
                                Text(
                                  achievement.praise,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: achievement.color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isUnlocked
                                          ? const Color(
                                            0xFF4EABE9,
                                          ).withOpacity(0.1)
                                          : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isUnlocked ? 'Unlocked' : 'Locked',
                                  style: TextStyle(
                                    color:
                                        isUnlocked
                                            ? const Color(0xFF4EABE9)
                                            : Colors.grey.shade400,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF4EABE9),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: const Color(
                            0xFF4EABE9,
                          ).withOpacity(0.1),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

class Achievement {
  final String title;
  final String description;
  final String praise;
  final IconData icon;
  final int level;
  final Color color;

  Achievement({
    required this.title,
    required this.description,
    required this.praise,
    required this.icon,
    required this.level,
    required this.color,
  });
}

// Static methods for updating achievement status
class AchievementManager {
  static Future<void> unlockAchievement(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('achievement_$level', true);
  }
}
