import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_screen.dart';

class GameWrapper extends StatefulWidget {
  const GameWrapper({super.key});

  @override
  State<GameWrapper> createState() => _GameWrapperState();
}

class _GameWrapperState extends State<GameWrapper> {
  @override
  void initState() {
    super.initState();
    _setGameMode();
  }

  @override
  void dispose() {
    _setDefaultMode();
    super.dispose();
  }

  void _setGameMode() {
    // 设置沉浸式全屏模式
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // 将方向设置为竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _setDefaultMode() {
    // 退出游戏时恢复系统UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return const GameScreen();
  }
}
