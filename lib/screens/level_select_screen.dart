import 'package:flutter/material.dart';
import 'game_levels/level_one.dart';

import 'package:flutter/services.dart'; // 添加字体支持
import 'package:shared_preferences/shared_preferences.dart';
import '../globals.dart'; // 添加此行以导入 Globals 类
import 'settings_screen.dart'; // 导入设置界面
import 'character_screen.dart';
import 'custom_story_screen.dart';

class LevelProgressService {
  static const _prefix = 'level_progress_';

  static Future<double> getProgress(int levelId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('$_prefix$levelId') ?? 0.0;
  }

  static Future<void> updateProgress(int levelId, double progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('$_prefix$levelId', progress.clamp(0.0, 1.0));
  }
}

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  Future<Map<int, double>>? _progressFuture;

  @override
  void initState() {
    super.initState();
    _refreshProgress();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preload the background image for SettingsScreen
    precacheImage(const AssetImage('assets/bj/xybj7.png'), context);
    // Preload the background image
    precacheImage(const AssetImage('assets/bj/xybj1.png'), context);
  }

  void _refreshProgress() {
    setState(() {
      _progressFuture = _loadLevelProgress();
    });
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required String title,
    required Widget levelScreen,
    required double progress,
    required int levelId,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade100.withOpacity(0.3),
            Colors.amber.shade200.withOpacity(0.4),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Preload the level background image
            precacheImage(const AssetImage('assets/bj/xybj5.png'), context);
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    levelScreen,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = 0.0;
                  const end = 1.0;
                  const curve = Curves.easeIn;
                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var opacityAnimation = animation.drive(tween);
                  return FadeTransition(
                    opacity: opacityAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题和图标整合
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'ZHSGuFeng',
                          color: Colors.amber.shade200,
                          shadows: const [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 8,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      // 根据 levelId 显示不同的图标
                      Icon(
                        levelId == 1
                            ? Icons.temple_buddhist_rounded // 第一个卡片图标
                            : (levelId == 2
                                ? Icons.water
                                : Icons.landscape), // 第二个和第三个卡片图标
                        color: Colors.amber.shade200,
                        size: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 状态标签
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(levelId),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getDifficultyText(levelId),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 添加关卡描述
                  Text(
                    _getLevelDescription(title), // 根据标题获取描述
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red.shade300;
    if (progress < 0.7) return Colors.amber.shade300;
    return Colors.green.shade300;
  }

  Color _getStatusColor(double progress) {
    if (progress == 0) return Colors.blueGrey.shade600;
    if (progress < 1) return Colors.amber.shade700;
    return Colors.green.shade700;
  }

  String _getStatusText(double progress) {
    if (progress == 0) return '等待启程';
    if (progress < 1) return '修行中 ${(progress * 100).toInt()}%';
    return '功德圆满';
  }

  Color _getDifficultyColor(int levelId) {
    switch (levelId) {
      case 1:
        return Colors.green.shade300;
      case 2:
        return Colors.amber.shade300;
      case 3:
        return Colors.red.shade300;
      default:
        return Colors.grey;
    }
  }

  String _getDifficultyText(int levelId) {
    switch (levelId) {
      case 1:
        return '简单';
      case 2:
        return '中等';
      case 3:
        return '困难';
      default:
        return '未知';
    }
  }

  String _getLevelDescription(String title) {
    switch (title) {
      case '金蝉启程':
        return '这是一个简单的开始，适合新手。'; // 描述内容
      case '八十一难':
        return '挑战中等难度，考验你的技巧。'; // 描述内容
      case '灵山终局':
        return '最终的挑战，只有最强者才能完成。'; // 描述内容
      default:
        return '未知关卡'; // 默认描述
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bj/xybj1.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black54,
                BlendMode.darken,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.amber.shade200.withOpacity(0.8),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0x4D3A2418),
                        Color(0x802C1810),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 第一行：角色按钮、设置按钮和法力值
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // 添加角色按钮
                          IconButton(
                            icon: const Icon(Icons.person, color: Colors.amber),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CharacterScreen(),
                                ),
                              );
                            },
                          ),
                          // 添加设置按钮
                          IconButton(
                            icon:
                                const Icon(Icons.settings, color: Colors.amber),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                          const Spacer(), // 添加 Spacer 以推送法力值到右侧
                          // 添加法力值显示
                          ValueListenableBuilder<int>(
                            valueListenable: Globals.manaPoints,
                            builder: (context, manaPointsValue, child) {
                              return Text(
                                '法力值: $manaPointsValue',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.amber.shade200,
                                  fontFamily: 'ZHSGuFeng',
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 4,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16), // 添加间距
                      // 第二行：主标题
                      Text(
                        '西游降妖',
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'ZHSGuFeng',
                          color: Colors.amber.shade200,
                          shadows: const [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 8,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8), // 添加间距
                      // 第三行：副标题
                      Text(
                        '探索神话的奇幻旅程',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'ZHSGuFeng',
                          color: Colors.amber.shade100,
                          shadows: const [
                            Shadow(
                              color: Colors.black54,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: _progressFuture,
                    builder: (context, snapshot) {
                      final levels = [
                        _LevelData('金蝉启程', LevelOne(levelId: 1), 1),
                        _LevelData('八十一难', LevelOne(levelId: 2), 2),
                        _LevelData('灵山终局', LevelOne(levelId: 3), 3),
                      ];

                      return ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          // 添加自定义故事按钮
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber.withOpacity(0.3),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color:
                                        Colors.amber.shade200.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CustomStoryScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                '创建自定义故事',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'ZHSGuFeng',
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ),
                          // 预设关卡列表
                          ...levels.map((level) => _buildLevelCard(
                                context: context,
                                title: level.title,
                                levelScreen: level.screen,
                                progress: snapshot.hasData
                                    ? (snapshot.data! as Map<int, double>)[
                                            level.levelId] ??
                                        0.0
                                    : 0.0,
                                levelId: level.levelId,
                              )),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<int, double>> _loadLevelProgress() async {
    return {
      1: await LevelProgressService.getProgress(1),
      2: await LevelProgressService.getProgress(2),
      3: await LevelProgressService.getProgress(3),
    };
  }
}

class _ProgressIndicator extends StatelessWidget {
  final double progress;
  final int levelId;

  const _ProgressIndicator({required this.progress, required this.levelId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 取消进度条的显示
        // SizedBox(
        //   width: 60,
        //   height: 60,
        //   child: CircularProgressIndicator(
        //     value: progress,
        //     strokeWidth: 4,
        //     backgroundColor: Colors.grey.shade800,
        //     valueColor: AlwaysStoppedAnimation<Color>(
        //       _getProgressColor(progress),
        //     ),
        //   ),
        // ),
        // 修改图标为河流或山川
        Icon(
          progress == 0.0
              ? Icons.temple_buddhist_rounded
              : (levelId == 2
                  ? Icons.water
                  : Icons.landscape), // 使用 landscape 图标表示山川
          color: Colors.amber.shade200,
          size: 30,
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red.shade300;
    if (progress < 0.7) return Colors.amber.shade300;
    return Colors.green.shade300;
  }
}

class _LevelData {
  final String title;
  final Widget screen;
  final int levelId;

  const _LevelData(this.title, this.screen, this.levelId);
}
