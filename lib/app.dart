import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'pages/realities_page.dart';
import 'pages/encounter_page.dart';
import 'pages/radio_page.dart';
import 'pages/settings_page.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _currentIndex = 0;

  // 页面列表
  final List<Widget> _pages = [
    const RealitiesPage(),
    const EncounterPage(),
    const RadioPage(),
    const SettingsPage(),
  ];

  // 页面标题
  final List<String> _titles = [
    '平行时空',
    '遇见',
    '时空之声',
    '我的',
  ];

  // 页面图标
  final List<IconData> _icons = [
    Icons.blur_circular, // 平行时空
    Icons.auto_awesome, // 遇见
    Icons.satellite_alt, // 时空之声
    Icons.person, // 我的
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // 背景渐变 - 使用主题中定义的颜色，不使用透明度
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F1A2C), // 深蓝色调
            Color(0xFF2A0B47), // 深紫色 (brand-purple-deep)
          ],
          stops: [0.2, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // 主体内容
        body: _pages[_currentIndex],
        // 底部导航栏
        bottomNavigationBar: _buildBottomNavigationBar(),
        extendBody: true, // 允许内容延伸到底部导航栏下方
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    // 获取底部安全区域高度
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 64 + bottomPadding, // 增加导航栏高度 + 底部安全区域
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2A0B47), // 深紫色 (brand-purple-deep)
            Color(0xFF1A0625), // 更深的紫色
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: Color(0xFF6B2C9E), // 使用固定颜色而不是透明度
            width: 1.0,
          ),
        ),
        // 优化阴影效果，使用固定颜色
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 0,
            spreadRadius: 1,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        // 移除BackdropFilter毛玻璃效果，使用普通Container
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                _pages.length,
                (index) => _buildNavItem(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isActive = _currentIndex == index;
    // 移除不必要的变量，使用固定颜色

    // 计算每个导航项的宽度，避免溢出
    final itemWidth = math.min(MediaQuery.of(context).size.width / 5, 80.0);

    return SizedBox(
      width: itemWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _currentIndex = index),
          borderRadius: BorderRadius.circular(20),
          splashColor: const Color(0xFF3A1257),
          highlightColor: const Color(0xFF2A0B47),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuint,
            // 减少垂直内边距，防止溢出
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // 移除透明度
              color: isActive ? Color(0xFF3A1257) : Colors.transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 确保列不会扩展超出其内容
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 图标和指示器
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // 活跃状态时的底部指示器 - 使用固定颜色
                    if (isActive)
                      Positioned(
                        top: 0, // 调整位置，避免溢出
                        child: Container(
                          width: 20,
                          height: 2, // 减小高度
                          decoration: BoxDecoration(
                            color: Color(0xFFFF2A6D), // 品红色 (brand-magenta)
                            borderRadius: BorderRadius.circular(2),
                            // 移除阴影以减少溢出风险
                          ),
                        ),
                      ),

                    // 图标容器 - 减小尺寸，移除渐变
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 26, // 减小高度
                      width: 26, // 减小宽度
                      decoration: isActive
                          ? const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF3A1257), // 使用固定颜色替代渐变
                            )
                          : null,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 图标 - 减小尺寸
                          Icon(
                            _icons[index],
                            size: isActive ? 22 : 20, // 减小图标尺寸
                            color: isActive
                                ? Color(0xFF6B2C9E)
                                : Color(0xCCFFFFFF), // 使用固定颜色
                          ),

                          // 移除光晕效果，避免溢出
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2), // 减小间距

                // 标题文本 - 简化样式
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 10, // 统一减小字体大小
                    color:
                        isActive ? Colors.white : Color(0xAAFFFFFF), // 使用固定颜色
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    letterSpacing: 0.2, // 统一字间距
                  ),
                  child: Text(
                    _titles[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
