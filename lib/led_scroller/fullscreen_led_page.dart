import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'message_model.dart';

/// 全屏LED滚动文本显示页面
/// 这是一个独立的页面，专门用于横屏全屏显示滚动文本
class FullscreenLedPage extends StatefulWidget {
  final Message message;
  final Color textColor;
  final Color backgroundColor;

  const FullscreenLedPage({
    //sdasdasdads
    //asdasdasdasd
    super.key,
    required this.message,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  State<FullscreenLedPage> createState() => _FullscreenLedPageState();
}

class _FullscreenLedPageState extends State<FullscreenLedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isScrolling = true;

  @override
  void initState() {
    super.initState();

    // 设置横屏方向
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // 隐藏所有系统UI，实现真正的全屏
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [], // 不显示任何系统UI
    );

    // 初始化动画控制器
    _animationController = AnimationController(
      vsync: this,
      duration: _calculateAnimationDuration(),
    );

    // 自动开始滚动
    _animationController.repeat();
  }

  @override
  void dispose() {
    // 停止动画
    _animationController.dispose();

    // 恢复竖屏方向
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // 恢复系统UI
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );

    super.dispose();
  }

  // 计算动画持续时间
  Duration _calculateAnimationDuration() {
    // 基础持续时间（秒）
    const baseDuration = 15.0;

    // 根据速度调整（1-10）
    // 速度1 = 最长持续时间，速度10 = 最短持续时间
    final speedFactor = (11 - widget.message.scrollSpeed) / 5;

    // 根据文本长度调整
    final lengthFactor = widget.message.text.length / 20;

    // 计算最终持续时间
    final durationInSeconds = baseDuration * speedFactor * lengthFactor;

    // 确保最小和最大持续时间
    final clampedDuration = durationInSeconds.clamp(5.0, 30.0);

    return Duration(seconds: clampedDuration.toInt());
  }

  void _toggleScrolling() {
    setState(() {
      _isScrolling = !_isScrolling;
      if (_isScrolling) {
        // 恢复滚动
        _animationController.repeat(
          // 从当前位置继续
          min: _animationController.value,
          max: 1.0,
        );
        // 显示短暂的状态提示
        _showStatusMessage("已恢复播放");
      } else {
        // 暂停滚动
        _animationController.stop();
        // 显示短暂的状态提示
        _showStatusMessage("已暂停");
      }
    });
  }

  // 显示状态消息的方法
  void _showStatusMessage(String message) {
    // 使用ScaffoldMessenger显示一个短暂的消息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1), // 显示1秒
        behavior: SnackBarBehavior.floating, // 浮动样式
        margin: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.black.withOpacity(0.7),
      ),
    );
  }

  void _exitFullscreen() async {
    // 提供轻微振动反馈
    await HapticFeedback.mediumImpact();

    // 显示退出提示
    _showStatusMessage("正在退出全屏模式");

    // 短暂延迟后退出，让用户看到提示
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      // 使用GestureDetector包装整个界面，处理单击和双击事件
      body: GestureDetector(
        // 单击事件：暂停/播放滚动
        onTap: () {
          print("单击事件触发：暂停/播放");
          _toggleScrolling();
        },
        // 双击事件：退出全屏
        onDoubleTap: () {
          print("双击事件触发：退出全屏");
          _exitFullscreen();
        },
        behavior: HitTestBehavior.opaque, // 确保即使点击空白区域也能捕获事件
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 滚动文本
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final screenWidth = MediaQuery.of(context).size.width;
                return Positioned(
                  left:
                      -100 + (_animationController.value * (screenWidth + 200)),
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      widget.message.text,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // 暂停状态指示器
            if (!_isScrolling)
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pause, color: Colors.white, size: 40),
                ),
              ),

            // 退出提示
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.touch_app, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '单击: 暂停/播放',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '双击: 退出',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
