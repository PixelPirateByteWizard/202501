import 'package:flutter/material.dart';
import 'dart:math' as math;

/// 增强版卡通风格UI组件 - 专为平行界面优化
class EnhancedCartoonUI {
  // 主色调
  static const Color primaryPurple = Color(0xFF6B2C9E);
  static const Color secondaryPink = Color(0xFFFF2A6D);
  static const Color lightPurple = Color(0xFF4A1A6B);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentBlue = Color(0xFF4ECDC4);
  static const Color backgroundLight = Color(0xFFFAF9FC);
  static const Color cardBackground = Colors.white;

  /// 创建增强版卡通卡片 - 带有悬浮动画和互动效果
  static Widget enhancedCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    double borderRadius = 24,
    bool withShadow = true,
    bool withHoverEffect = true,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: primaryPurple.withValues(alpha: 0.1),
          highlightColor: primaryPurple.withValues(alpha: 0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: backgroundColor ?? cardBackground,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: Colors.grey.withValues(alpha: 0.1),
                width: 1,
              ),
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
          ),
        ),
      ),
    );
  }

  /// 创建角色卡片 - 专为平行时空角色设计
  static Widget characterCard({
    required String name,
    required String description,
    required String avatarUrl,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
    List<Color>? gradientColors,
    bool isOnline = false,
  }) {
    final gradient = gradientColors ?? _getDreamyGradient();

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradient,
            stops: const [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(28), // 大圆角矩形
          boxShadow: [
            BoxShadow(
              color: gradient.first.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 装饰元素
            _buildCardDecorations(),
            
            // 主要内容
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部区域：头像和在线状态
                  Row(
                    children: [
                      _buildDreamyAvatar(avatarUrl, isOnline),
                      const Spacer(),
                      if (isOnline) _buildDreamyOnlineIndicator(),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 角色名称 - 白色粗体叠加
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 角色描述 - 白色粗体叠加
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.4,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const Spacer(),
                  
                  // 底部操作区域
                  Row(
                    children: [
                      // 聊天按钮
                      Expanded(
                        child: _buildDreamyMiniButton(
                          icon: Icons.chat_bubble_outline,
                          text: '对话',
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 更多按钮
                      _buildDreamyIconButton(
                        icon: Icons.more_horiz,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建头像组件
  static Widget _buildAvatar(String avatarUrl, bool isOnline) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    primaryPurple.withValues(alpha: 0.3),
                    secondaryPink.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 28,
              ),
            );
          },
        ),
      ),
    );
  }

  /// 构建在线状态指示器
  static Widget _buildOnlineIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            '在线',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建迷你按钮
  static Widget _buildMiniButton({
    required IconData icon,
    required String text,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建图标按钮
  static Widget _buildIconButton({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
      ),
    );
  }

  /// 创建浮动操作按钮
  static Widget floatingActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
    String? tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFf093fb).withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 装饰星星
          Positioned(
            top: 8,
            right: 12,
            child: Icon(
              Icons.star,
              color: Colors.white.withValues(alpha: 0.4),
              size: 12,
            ),
          ),
          FloatingActionButton(
            onPressed: onPressed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            tooltip: tooltip,
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  /// 创建搜索栏
  static Widget searchBar({
    required TextEditingController controller,
    String? hintText,
    VoidCallback? onFilterTap,
    Function(String)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30), // 更大的圆角
        border: Border.all(
          color: const Color(0xFFE1BEE7).withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFf093fb).withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText ?? '搜索平行时空...',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 20,
            ),
          ),
          suffixIcon: onFilterTap != null
              ? GestureDetector(
                  onTap: onFilterTap,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFa8edea), Color(0xFF4facfe)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  /// 创建分类标签
  static Widget categoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(25), // 更大的圆角
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : const Color(0xFFE1BEE7).withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFf093fb).withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                    spreadRadius: 0,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : const Color(0xFF6B2C9E),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF6B2C9E),
                fontWeight: FontWeight.bold,
                fontSize: 14,
                shadows: isSelected 
                    ? [
                        const Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 创建统计卡片
  static Widget statsCard({
    required String title,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    final cardColor = color ?? primaryPurple;
    final gradientColors = _getStatsGradient(cardColor);
    
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(22), // 大圆角
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 装饰星星
          Positioned(
            top: 5,
            right: 10,
            child: Icon(
              Icons.star,
              color: Colors.white.withValues(alpha: 0.3),
              size: 14,
            ),
          ),
          // 主要内容
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 获取统计卡片渐变色
  static List<Color> _getStatsGradient(Color baseColor) {
    if (baseColor == const Color(0xFF4CAF50)) {
      // 绿色渐变
      return [const Color(0xFF4CAF50), const Color(0xFF66BB6A)];
    } else if (baseColor == const Color(0xFFFF6B35)) {
      // 橙色渐变
      return [const Color(0xFFFF6B35), const Color(0xFFFF8A65)];
    } else {
      // 默认紫色渐变
      return [const Color(0xFF6B2C9E), const Color(0xFF8E24AA)];
    }
  }

  /// 生成随机渐变色
  static List<Color> generateRandomGradient() {
    final random = math.Random();
    final gradients = [
      // 粉色渐变
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      // 橙粉色渐变
      [const Color(0xFFffecd2), const Color(0xFFfcb69f)],
      // 淡紫色渐变
      [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
      // 蓝绿色渐变
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      // 温暖橙黄渐变
      [const Color(0xFFffecd2), const Color(0xFFfcb69f)],
      // 梦幻紫色渐变
      [const Color(0xFF667eea), const Color(0xFF764ba2)],
      // 柔和粉紫渐变
      [const Color(0xFFffecd2), const Color(0xFFfed6e3)],
      // 清新蓝绿渐变
      [const Color(0xFFa8edea), const Color(0xFF4facfe)],
    ];
    
    return gradients[random.nextInt(gradients.length)];
  }

  /// 获取梦幻渐变色
  static List<Color> _getDreamyGradient() {
    return [const Color(0xFFf093fb), const Color(0xFFf5576c)];
  }

  /// 构建卡片装饰元素
  static Widget _buildCardDecorations() {
    return Stack(
      children: [
        // 星星装饰
        Positioned(
          top: 20,
          right: 25,
          child: Icon(
            Icons.star,
            color: Colors.white.withValues(alpha: 0.4),
            size: 18,
          ),
        ),
        Positioned(
          top: 40,
          right: 45,
          child: Icon(
            Icons.star,
            color: Colors.white.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        // 闪光装饰
        Positioned(
          bottom: 30,
          right: 20,
          child: Icon(
            Icons.auto_awesome,
            color: Colors.white.withValues(alpha: 0.35),
            size: 16,
          ),
        ),
        // 音符装饰
        Positioned(
          top: 60,
          left: 20,
          child: Icon(
            Icons.music_note,
            color: Colors.white.withValues(alpha: 0.25),
            size: 16,
          ),
        ),
        // 更多星星
        Positioned(
          bottom: 60,
          left: 30,
          child: Icon(
            Icons.star,
            color: Colors.white.withValues(alpha: 0.2),
            size: 12,
          ),
        ),
      ],
    );
  }

  /// 构建梦幻头像组件
  static Widget _buildDreamyAvatar(String avatarUrl, bool isOnline) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.3),
                    Colors.white.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 32,
              ),
            );
          },
        ),
      ),
    );
  }

  /// 构建梦幻在线状态指示器
  static Widget _buildDreamyOnlineIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            '在线',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建梦幻迷你按钮
  static Widget _buildDreamyMiniButton({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建梦幻图标按钮
  static Widget _buildDreamyIconButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}