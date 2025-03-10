import 'package:flutter/material.dart';

class AppTheme {
  // 定义三国主题配色
  static const primaryColor = Color(0xFF8B0000); // 深红色，象征权力与威严
  static const secondaryColor = Color(0xFFD4AF37); // 金色，象征皇权与荣耀
  static const backgroundColor = Color(0xFFF5E6CA); // 米黄色，象征古代纸张
  static const surfaceColor = Color(0xFFFFF8E7); // 浅米色，象征羊皮纸
  static const textColor = Color(0xFF2C1810); // 深褐色，象征古代墨迹

  // 装饰性边框颜色
  static const borderColor = Color(0xFFB87333); // 古铜色

  // 渐变色
  static const gradientColors = [
    Color(0xFF8B0000), // 深红
    Color(0xFF800000), // 暗红
  ];

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          secondary: secondaryColor,
          background: backgroundColor,
          surface: surfaceColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),
          color: surfaceColor,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: 1.5,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
            letterSpacing: 1,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: borderColor,
                width: 1,
              ),
            ),
          ),
        ),
      );

  // 自定义装饰
  static BoxDecoration get menuButtonDecoration => BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get backgroundDecoration => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.8),
          ],
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/background_texture.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.1,
        ),
      );

  static BoxDecoration get puzzleTileDecoration => BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            surfaceColor,
            surfaceColor.withOpacity(0.9),
          ],
        ),
      );

  // 文字样式
  static const titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textColor,
    letterSpacing: 4,
  );

  static const subtitleStyle = TextStyle(
    fontSize: 16,
    color: textColor,
    letterSpacing: 2,
  );

  static BoxDecoration get gameBoardDecoration => BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      );
}
