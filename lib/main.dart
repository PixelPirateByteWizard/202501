import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/colors.dart';
import 'screens/main_menu_screen.dart';

void main() {
  // Ensure Flutter bindings are initialized.
  // 确保 Flutter 绑定已初始化
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait mode for a consistent game experience.
  // 将方向锁定为竖屏模式以获得一致的游戏体验
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Alchemist's Palette",
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFFDE047), // amber-300
          secondary: const Color(0xFF67E8F9), // cyan-300
          surface: const Color(0xFF1E293B), // slate-800
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A), // slate-900
        textTheme: SafeFonts.notoSansTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: SafeFonts.imFellEnglishSc(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFDE047),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFDE047),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MainMenuScreen(),
    );
  }
}
