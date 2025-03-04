import 'package:flutter/material.dart';
import 'level_select_screen.dart';
import 'dart:async';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  Timer? _timer;
  bool _didInitialize = false;

  @override
  void initState() {
    super.initState();
    // 设置2秒后自动跳转
    _timer = Timer(const Duration(seconds: 2), () {
      _navigateToNextScreen();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitialize) {
      // 预加载下一个页面的背景图
      precacheImage(const AssetImage('assets/bj/xybj1.png'), context);
      precacheImage(const AssetImage('assets/bj/xybj4.png'), context);
      _didInitialize = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LevelSelectScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeIn;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var opacityAnimation = animation.drive(tween);
          return FadeTransition(
            opacity: opacityAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          _timer?.cancel();
          _navigateToNextScreen();
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bj/xybj4.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black54,
                  BlendMode.darken,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
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
                          const SizedBox(height: 8),
                          Text(
                            '神话序章',
                            style: TextStyle(
                              fontSize: 36,
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
                          const SizedBox(height: 4),
                          Text(
                            '在遥远的东土大唐，玄奘法师肩负着取经的重任，'
                            '他将踏上充满未知与挑战的西行之路。'
                            '沿途，他将遇见孙悟空、猪八戒和沙和尚，'
                            '这三位神话中的英雄将与他并肩作战，'
                            '共同面对八十一难，揭开天界与人间的秘密。\n\n'
                            '在这段旅程中，师徒四人将穿越险峻的山川，'
                            '跨越波涛汹涌的江河，'
                            '每一次选择都将影响他们的命运。'
                            '而在这条路上，隐藏着无数的妖魔鬼怪，'
                            '他们将用智慧与勇气，战胜重重困难，'
                            '最终实现取经的伟大使命。',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'ZHSGuFeng',
                              color: Colors.amber.shade100,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    '点击任意位置继续',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.amber,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
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
}
