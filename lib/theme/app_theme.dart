import 'package:flutter/material.dart';

class AppTheme {
  // 主色调
  static const Color primaryColor = Color(0xFF1a365d);
  static const Color secondaryColor = Color(0xFF2d3748);
  static const Color accentColor = Color(0xFFd4af37);
  static const Color lightColor = Color(0xFFe2e8f0);
  static const Color darkColor = Color(0xFF1a202c);
  static const Color cardColor = Color(0xFF2a4365);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: secondaryColor,
      cardColor: cardColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: cardColor,
        onPrimary: lightColor,
        onSecondary: primaryColor,
        onSurface: lightColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: lightColor,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(0, 44), // 确保按钮有足够的触摸区域
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor.withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: accentColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        elevation: 4,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: accentColor,
          fontSize: 28, // 从32减小到28
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: accentColor,
          fontSize: 22, // 从24减小到22
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: accentColor,
          fontSize: 18, // 从20减小到18
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: lightColor,
          fontSize: 15, // 从16减小到15
          height: 1.5, // 从1.6减小到1.5
        ),
        bodyMedium: TextStyle(
          color: lightColor,
          fontSize: 13, // 从14减小到13
        ),
        bodySmall: TextStyle(
          color: lightColor,
          fontSize: 11, // 从12减小到11
        ),
      ),
    );
  }

  // 获取响应式主题
  static ThemeData getResponsiveTheme(BuildContext context) {
    // 导入响应式工具类
    final screenWidth = MediaQuery.of(context).size.width;
    final baseTheme = darkTheme;
    
    if (screenWidth < 360) { // 超小屏幕
      return baseTheme.copyWith(
        textTheme: baseTheme.textTheme.copyWith(
          headlineLarge: baseTheme.textTheme.headlineLarge?.copyWith(fontSize: 24),
          headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(fontSize: 20),
          headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(fontSize: 16),
          bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(fontSize: 14),
          bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(fontSize: 12),
          bodySmall: baseTheme.textTheme.bodySmall?.copyWith(fontSize: 10),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: baseTheme.elevatedButtonTheme.style?.copyWith(
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            minimumSize: WidgetStateProperty.all(const Size(0, 40)),
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    } else if (screenWidth < 600) { // 小屏幕
      return baseTheme.copyWith(
        textTheme: baseTheme.textTheme.copyWith(
          headlineLarge: baseTheme.textTheme.headlineLarge?.copyWith(fontSize: 26),
          headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(fontSize: 21),
          headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(fontSize: 17),
          bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(fontSize: 14),
          bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(fontSize: 12),
          bodySmall: baseTheme.textTheme.bodySmall?.copyWith(fontSize: 10),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: baseTheme.elevatedButtonTheme.style?.copyWith(
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            ),
            minimumSize: WidgetStateProperty.all(const Size(0, 42)),
            textStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
    }
    
    return baseTheme;
  }
}