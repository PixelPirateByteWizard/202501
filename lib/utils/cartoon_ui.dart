import 'package:flutter/material.dart';

/// 卡通风格UI组件工具类
class CartoonUI {
  // 主色调
  static const Color primaryPurple = Color(0xFF6B2C9E);
  static const Color secondaryPink = Color(0xFFFF2A6D);
  static const Color lightPurple = Color(0xFF4A1A6B);
  static const Color backgroundLight = Color(0xFFFAF9FC);
  static const Color cardBackground = Colors.white;

  /// 创建卡通风格的卡片
  static Widget cartoonCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double borderRadius = 24,
    bool withShadow = true,
  }) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? cardBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: primaryPurple.withValues(alpha: 0.08),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  /// 创建卡通风格的按钮
  static Widget cartoonButton({
    required String text,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    double borderRadius = 24,
    EdgeInsetsGeometry? padding,
    bool isOutlined = false,
  }) {
    final bgColor = backgroundColor ?? primaryPurple;
    final txtColor = textColor ?? Colors.white;

    return Container(
      decoration: BoxDecoration(
        gradient: isOutlined
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  bgColor,
                  bgColor.withBlue((bgColor.blue + 20).clamp(0, 255)),
                ],
              ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: isOutlined
            ? Border.all(color: bgColor, width: 2)
            : null,
        boxShadow: isOutlined
            ? null
            : [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: isOutlined ? bgColor : txtColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: isOutlined ? bgColor : txtColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 创建卡通风格的输入框
  static Widget cartoonTextField({
    required TextEditingController controller,
    String? hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    bool obscureText = false,
    int maxLines = 1,
    double borderRadius = 24,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: primaryPurple.withValues(alpha: 0.7),
                  size: 20,
                )
              : null,
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: onSuffixTap,
                  child: Icon(
                    suffixIcon,
                    color: primaryPurple.withValues(alpha: 0.7),
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  /// 创建卡通风格的图标容器
  static Widget cartoonIconContainer({
    required IconData icon,
    Color? backgroundColor,
    Color? iconColor,
    double size = 48,
    double iconSize = 24,
    bool withGradient = true,
  }) {
    final bgColor = backgroundColor ?? primaryPurple;
    final icColor = iconColor ?? Colors.white;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: withGradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  bgColor,
                  bgColor.withValues(alpha: 0.8),
                ],
              )
            : null,
        color: withGradient ? null : bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: bgColor.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: icColor,
        size: iconSize,
      ),
    );
  }

  /// 创建卡通风格的标签
  static Widget cartoonTag({
    required String text,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    double borderRadius = 16,
  }) {
    final bgColor = backgroundColor ?? primaryPurple.withValues(alpha: 0.1);
    final txtColor = textColor ?? primaryPurple;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: primaryPurple.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: txtColor,
              size: 14,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: txtColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 创建卡通风格的分隔线
  static Widget cartoonDivider({
    double height = 1,
    Color? color,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 16),
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            color ?? Colors.grey[300]!,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  /// 创建卡通风格的加载指示器
  static Widget cartoonLoading({
    String? text,
    Color? color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? primaryPurple,
            ),
          ),
        ),
        if (text != null) ...[
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}