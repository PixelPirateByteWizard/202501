import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/game_screen.dart';
import '../screens/achievements_screen.dart';
import '../screens/settings_screen.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu>
    with WidgetsBindingObserver, RouteAware {
  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  @override
  void initState() {
    super.initState();
    // 添加观察者
    WidgetsBinding.instance.addObserver(this);
    // 确保设置为横屏模式
    _setLandscapeMode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 注册路由观察者
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    // 确保横屏模式
    _setLandscapeMode();
  }

  @override
  void dispose() {
    // 移除观察者
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // 添加一个方法来设置横屏模式
  void _setLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 当应用程序从后台恢复时，确保仍然是横屏
    if (state == AppLifecycleState.resumed) {
      _setLandscapeMode();
    }
  }

  @override
  void didPopNext() {
    // 当其他页面被弹出（返回到这个页面）时调用
    _setLandscapeMode();
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
              const Color(0xFF4EABE9),
              const Color(0xFF4EABE9).withOpacity(0.9),
              const Color(0xFF4EABE9).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              // 游戏标题
              ShaderMask(
                shaderCallback:
                    (bounds) => LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.9)],
                    ).createShader(bounds),
                child: const Text(
                  'SNAKE',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'THE CLASSIC GAME',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 4,
                ),
              ),
              const Spacer(),
              // 主按钮区域
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // 开始游戏按钮
                    MainButton(
                      icon: Icons.play_arrow_rounded,
                      text: 'PLAY NOW',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GameScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // 成就和设置按钮行
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            icon: Icons.emoji_events_rounded,
                            text: 'ACHIEVEMENTS',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const AchievementsScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SecondaryButton(
                            icon: Icons.settings_rounded,
                            text: 'SETTINGS',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class MainButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const MainButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(32),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: Colors.white),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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

class SecondaryButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const SecondaryButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
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
