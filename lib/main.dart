import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/shared_prefs.dart';
import 'pages/splash_screen.dart';
// import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置状态栏样式
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF0F1A2C), // 深蓝色背景
    statusBarIconBrightness: Brightness.light,
  ));

  // // 初始化后台音频播放
  // try {
  //   await JustAudioBackground.init(
  //     androidNotificationChannelId: 'com.luvimestra.channel.audio',
  //     androidNotificationChannelName: 'Luvimestra Audio',
  //     androidNotificationOngoing: true,
  //     androidShowNotificationBadge: true,
  //   );
  // } catch (e) {
  //   print('初始化后台音频播放失败: $e');
  //   // 继续执行，不中断应用启动
  // }

  // 初始化SharedPreferences
  await SharedPrefs.init();

  runApp(const LuvimestraApp());
}

class LuvimestraApp extends StatelessWidget {
  const LuvimestraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luvimestra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6B2C9E), // 浅紫色 (brand-purple-light)
          secondary: Color(0xFFFF2A6D), // 品红色 (brand-magenta)
          tertiary: Color(0xFF4A1A6B), // 中紫色 (brand-purple-mid)
          surface: Color(0xFF2A0B47), // 深紫色 (brand-purple-deep)
        ),
        // 卡片主题
        cardColor: const Color(0xFF2A0B47),
        // 输入框主题
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.black.withAlpha(50),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        // 按钮主题
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B2C9E),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        // 文本主题
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFFCCCCCC),
          ),
        ),
        // 图标主题
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 24,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
