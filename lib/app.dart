import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'pages/realities_page.dart';
import 'pages/encounter_page.dart';
import 'pages/radio_page.dart';
import 'pages/music_page.dart';
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
    const MusicPage(),
    const SettingsPage(),
  ];

  // 页面标题
  final List<String> _titles = [
    '平行时空',
    '遇见',
    '时空之声',
    '音律',
    '我的',
  ];

  // 页面图标 - 使用更圆润的图标
  final List<IconData> _icons = [
    Icons.blur_circular_rounded, // 平行时空
    Icons.auto_awesome_rounded, // 遇见
    Icons.radio_rounded, // 时空之声
    Icons.music_note_rounded, // 音律
    Icons.person_rounded, // 我的
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // 轻盈的背景渐变 - 卡通风格
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAF9FC), // 浅紫色
            Color(0xFFF5F0FA), // 更浅的紫色
            Colors.white,
          ],
          stops: [0.0, 0.6, 1.0],
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
      height: 65 + bottomPadding, // 进一步优化导航栏高度
      decoration: BoxDecoration(
        // 白色半透明背景，保持轻盈感
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32), // 更大的圆角
          topRight: Radius.circular(32),
        ),
        // 柔和的阴影效果
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: const Color(0xFF6B2C9E).withValues(alpha: 0.05),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, -8),
          ),
        ],
        // 顶部分隔线
        border: Border(
          top: BorderSide(
            color: Colors.grey.withValues(alpha: 0.1),
            width: 1.0,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: bottomPadding,
              top: 8, // 减少顶部内边距
            ),
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

    // 计算每个导航项的宽度，避免溢出
    final itemWidth = math.min(MediaQuery.of(context).size.width / 5, 85.0);

    return SizedBox(
      width: itemWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _currentIndex = index),
          borderRadius: BorderRadius.circular(24), // 更圆润的点击区域
          splashColor: const Color(0xFF6B2C9E).withValues(alpha: 0.1),
          highlightColor: const Color(0xFF6B2C9E).withValues(alpha: 0.05),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              // 活跃状态使用渐变背景
              gradient: isActive
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF6B2C9E).withValues(alpha: 0.15),
                        const Color(0xFF4A1A6B).withValues(alpha: 0.1),
                      ],
                    )
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 图标容器
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: isActive ? 36 : 32,
                  width: isActive ? 36 : 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // 活跃状态使用渐变背景
                    gradient: isActive
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF6B2C9E),
                              Color(0xFF4A1A6B),
                            ],
                          )
                        : null,
                    // 非活跃状态使用浅色背景
                    color: isActive ? null : Colors.grey.withValues(alpha: 0.1),
                    // 柔和的阴影
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: const Color(0xFF6B2C9E).withValues(alpha: 0.3),
                              blurRadius: 12,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 图标
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          _icons[index],
                          key: ValueKey('${index}_${isActive}'),
                          size: isActive ? 20 : 18,
                          color: isActive ? Colors.white : Colors.grey[600],
                        ),
                      ),
                      // 活跃状态的光晕效果
                      if (isActive)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withValues(alpha: 0.2),
                                  Colors.transparent,
                                ],
                                stops: const [0.3, 1.0],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 1),

                // 标题文本 - 使用Flexible避免溢出
                Flexible(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: isActive ? 9 : 8,
                      color: isActive 
                          ? const Color(0xFF2A0B47) 
                          : Colors.grey[600],
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                    child: Text(
                      _titles[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // 移除指示点以节省空间
              ],
            ),
          ),
        ),
      ),
    );
  }
}
