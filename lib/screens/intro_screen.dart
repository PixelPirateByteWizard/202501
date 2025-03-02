import 'package:flutter/material.dart';
import 'level_select_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Preload the background image
    precacheImage(const AssetImage('assets/bj/xybj4.png'), context);
    return WillPopScope(
      onWillPop: () async => false,
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
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Preload the level select screen background image
                      precacheImage(
                          const AssetImage('assets/bj/xybj1.png'), context);
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const LevelSelectScreen(),
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      '进入关卡',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
