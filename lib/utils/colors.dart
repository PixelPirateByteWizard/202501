import 'package:flutter/material.dart';
import '../models/game_piece_model.dart';

/// A utility class to manage all colors used in the game.
/// This centralizes color definitions for easy access and modification.
class AppColors {
  // --- UI Colors ---
  static const Color background = Color(0xFF0F172A); // bg-slate-900
  static const Color primaryContainer = Color(0xFF1E293B); // bg-slate-800
  static const Color secondaryContainer = Color(0xFF334155); // bg-slate-700
  static const Color accent = Color(0xFFFDE047); // amber-300
  static const Color primaryText = Colors.white;
  static const Color secondaryText = Color(0xFFCBD5E1); // slate-300
  static const Color cyanAccent = Color(0xFF67E8F9); // cyan-300

  // --- Game Piece Colors ---
  static const Map<PieceColor, Color> pieceColors = {
    PieceColor.red: Color(0xFFFF5050),
    PieceColor.yellow: Color(0xFFFFDC32),
    PieceColor.blue: Color(0xFF3296FF),
    PieceColor.orange: Color(0xFFFF9632),
    PieceColor.green: Color(0xFF50DC50),
    PieceColor.purple: Color(0xFFB450FF),
    PieceColor.petrified: Color(0xFF969696),
    PieceColor.rainbow:
        Colors.white, // Rainbow piece will be handled with a gradient
  };

  /// Returns the corresponding Flutter Color for a given PieceColor enum.
  static Color get(PieceColor color) {
    return pieceColors[color] ?? Colors.transparent;
  }
}

/// A utility class to provide consistent system fonts with elegant styling
/// 提供一致系统字体和优雅样式的工具类
class SafeFonts {
  /// Get elegant serif font style for titles (using system serif fonts)
  /// 获取优雅的衬线字体样式用于标题（使用系统衬线字体）
  static TextStyle imFellEnglishSc({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: 'serif',
      letterSpacing: 0.5,
    );
  }

  /// Get clean sans-serif font style for body text (using system sans-serif fonts)
  /// 获取清洁的无衬线字体样式用于正文（使用系统无衬线字体）
  static TextStyle notoSans({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: 'sans-serif',
    );
  }

  /// Get system sans-serif TextTheme
  /// 获取系统无衬线文本主题
  static TextTheme notoSansTextTheme(TextTheme textTheme) {
    return textTheme.apply(
      fontFamily: 'sans-serif',
    );
  }
}
