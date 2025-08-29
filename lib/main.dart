import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/shared_prefs.dart';
import 'pages/splash_screen.dart';
// import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置状态栏样式 - 适配亮色主题
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // 透明状态栏
    statusBarIconBrightness: Brightness.dark, // 深色图标
    systemNavigationBarColor: Colors.white, // 白色导航栏
    systemNavigationBarIconBrightness: Brightness.dark, // 深色导航栏图标
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
        brightness: Brightness.light, // 改为亮色主题
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6B2C9E), // 主紫色
          secondary: Color(0xFFFF2A6D), // 品红色
          tertiary: Color(0xFF4A1A6B), // 中紫色
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Color(0xFF2A0B47),
        ),
        // 卡片主题 - 更圆润的设计
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 8,
          shadowColor: const Color(0xFF6B2C9E).withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        // 输入框主题 - 卡通圆润风格
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: Colors.grey[200]!,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: Colors.grey[200]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(
              color: Color(0xFF6B2C9E),
              width: 2,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        // 按钮主题 - 渐变和圆润设计
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B2C9E),
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: const Color(0xFF6B2C9E).withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          ),
        ),
        // 文本主题 - 适配亮色主题
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: Color(0xFF2A0B47),
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2A0B47),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF2A0B47),
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            height: 1.4,
          ),
        ),
        // 图标主题 - 适配亮色主题
        iconTheme: const IconThemeData(
          color: Color(0xFF6B2C9E),
          size: 24,
        ),
        // AppBar主题
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF2A0B47)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2A0B47),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
