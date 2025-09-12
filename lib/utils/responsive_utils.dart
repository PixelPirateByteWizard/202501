import 'package:flutter/material.dart';

class ResponsiveUtils {
  // 屏幕尺寸断点
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // 获取屏幕类型
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return ScreenType.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }

  // 判断是否为小屏幕
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  // 判断是否为超小屏幕
  static bool isExtraSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  // 获取响应式字体大小
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize * 0.85; // 超小屏幕缩小15%
    } else if (screenWidth < 400) {
      return baseSize * 0.9; // 小屏幕缩小10%
    }
    return baseSize;
  }

  // 获取响应式间距
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSpacing * 0.7; // 超小屏幕缩小30%
    } else if (screenWidth < 400) {
      return baseSpacing * 0.8; // 小屏幕缩小20%
    }
    return baseSpacing;
  }

  // 获取响应式内边距
  static EdgeInsets getResponsivePadding(BuildContext context, EdgeInsets basePadding) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return basePadding * 0.7; // 超小屏幕缩小30%
    } else if (screenWidth < 400) {
      return basePadding * 0.8; // 小屏幕缩小20%
    }
    return basePadding;
  }

  // 获取网格列数
  static int getGridColumns(BuildContext context, {int defaultColumns = 2}) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 1; // 超小屏幕单列
    } else if (screenWidth < 500) {
      return defaultColumns.clamp(1, 2); // 小屏幕最多2列
    }
    return defaultColumns;
  }

  // 获取卡片高宽比
  static double getCardAspectRatio(BuildContext context, {double defaultRatio = 0.85}) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return 1.2; // 超小屏幕更高的卡片
    } else if (screenWidth < 400) {
      return 1.0; // 小屏幕正方形卡片
    }
    return defaultRatio;
  }

  // 获取按钮高度
  static double getButtonHeight(BuildContext context, {double defaultHeight = 48}) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return defaultHeight * 0.85; // 超小屏幕缩小按钮
    }
    return defaultHeight;
  }

  // 获取图标大小
  static double getIconSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize * 0.8; // 超小屏幕缩小图标
    }
    return baseSize;
  }

  // 获取对话框最大宽度
  static double getDialogMaxWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth * 0.9).clamp(280.0, 400.0);
  }

  // 获取底部弹窗初始高度
  static double getBottomSheetInitialHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 600) {
      return 0.8; // 小屏幕占用更多空间
    }
    return 0.7;
  }

  // 获取安全区域内边距
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.only(
      top: mediaQuery.padding.top,
      bottom: mediaQuery.padding.bottom,
      left: mediaQuery.padding.left,
      right: mediaQuery.padding.right,
    );
  }

  // 获取状态栏高度
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  // 获取底部安全区域高度
  static double getBottomSafeAreaHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  // 判断是否为横屏
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // 获取可用屏幕高度（减去状态栏和底部安全区域）
  static double getAvailableHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom;
  }

  // 获取可用屏幕宽度（减去左右安全区域）
  static double getAvailableWidth(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width - mediaQuery.padding.left - mediaQuery.padding.right;
  }
}

enum ScreenType {
  mobile,
  tablet,
  desktop,
}

// 响应式文本样式扩展
extension ResponsiveTextStyle on TextStyle {
  TextStyle responsive(BuildContext context) {
    final fontSize = this.fontSize ?? 14.0;
    return copyWith(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, fontSize),
    );
  }
}

// 响应式边距扩展
extension ResponsiveEdgeInsets on EdgeInsets {
  EdgeInsets responsive(BuildContext context) {
    return ResponsiveUtils.getResponsivePadding(context, this);
  }
}