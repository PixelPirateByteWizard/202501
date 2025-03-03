import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'globals.dart'; // 导入 Globals

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 设置全屏显示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await Globals.initialize(); // 初始化法力值
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '西游降妖',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
