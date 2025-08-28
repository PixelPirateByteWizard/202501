import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import '../models/reality_model.dart';
import '../utils/navigation.dart';
import 'chat_page.dart';

// 透明图片的字节数据 - 用作FadeInImage的占位符
final Uint8List kTransparentImage = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82
]);

class RealityDetailPage extends StatefulWidget {
  final Reality reality;

  const RealityDetailPage({super.key, required this.reality});

  @override
  State<RealityDetailPage> createState() => _RealityDetailPageState();
}

class _RealityDetailPageState extends State<RealityDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;
  bool _isConnecting = false;
  String _connectionStatus = "正在建立跨时空通讯...";

  @override
  void initState() {
    super.initState();

    // 初始化动画控制器
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // 启动动画
    _controller.repeat(reverse: true);

    // 模拟加载过程
    _simulateLoading();
  }

  void _simulateLoading() {
    // 模拟连接过程
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _connectionStatus = "正在同步量子状态...";
        });
      }
    });

    Timer(const Duration(milliseconds: 1600), () {
      if (mounted) {
        setState(() {
          _connectionStatus = "正在调整跨维度频率...";
        });
      }
    });

    Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        setState(() {
          _connectionStatus = "已建立稳定连接";
          _isLoading = false;
        });
      }
    });

    // 完成后自动跳转到聊天界面
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() {
          _isConnecting = true;
        });

        Timer(const Duration(milliseconds: 500), () {
          if (mounted) {
            NavigationUtil.navigateReplace(
              context,
              ChatPage(reality: widget.reality),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 点击空白区域收起键盘
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // 背景图片
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isConnecting ? 0.0 : 1.0,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    // 使用Stack和FadeInImage来提高背景图片加载的可靠性
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 背景图片
                        FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: widget.reality.effectiveBackgroundUrl,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 300),
                          imageErrorBuilder: (context, error, stackTrace) {
                            // 如果当前未使用备用URL，则尝试使用备用URL
                            if (!widget.reality.isUsingFallbackBackground &&
                                widget.reality.fallbackBackgroundUrl != null) {
                              // 标记主图片加载失败，下次将使用备用图片
                              widget.reality.markBackgroundLoadFailed();
                              // 强制重建组件
                              if (mounted) {
                                Future.microtask(() => setState(() {}));
                              }
                              // 显示渐变背景作为临时替代
                              return _buildFallbackGradientBackground();
                            }

                            // 如果备用图片也加载失败，显示渐变背景
                            return _buildFallbackGradientBackground();
                          },
                        ),
                        // 轻微暗化滤镜层，保留原始图片的视觉效果
                        Container(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        // 动画效果层
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.center,
                                radius: 1.0,
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF6B2C9E).withAlpha(
                                    (_fadeAnimation.value * 20).toInt(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // 内容
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _isConnecting ? 0.0 : 1.0,
              child: SafeArea(
                child: Column(
                  children: [
                    // 返回按钮
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // 角色信息
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 角色头像 - 使用Hero动画和更可靠的图片加载
                          Hero(
                            tag: 'avatar-${widget.reality.id}',
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF6B2C9E),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF6B2C9E).withAlpha(60),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: widget.reality.avatarUrl,
                                  fit: BoxFit.cover,
                                  fadeInDuration:
                                      const Duration(milliseconds: 300),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    // 头像加载失败时显示默认头像
                                    return Container(
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.grey[500],
                                        size: 60,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // 角色名称
                          Hero(
                            tag: 'name-${widget.reality.id}',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                widget.reality.name,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // 角色描述
                          Hero(
                            tag: 'desc-${widget.reality.id}',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                widget.reality.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // 连接状态
                          _buildConnectionStatus(),
                        ],
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建渐变备用背景 - 当所有图片加载失败时使用
  Widget _buildFallbackGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFF5F0FA),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Column(
      children: [
        if (_isLoading) ...[
          // 加载动画
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF6B2C9E),
              ),
              strokeWidth: 2,
            ),
          ),
          const SizedBox(height: 16),
        ] else ...[
          // 连接成功图标
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withAlpha(30),
              border: Border.all(
                color: Colors.green.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.check,
              color: Colors.green,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 状态文本
        Text(
          _connectionStatus,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _isLoading ? const Color(0xFF4A1A6B) : Colors.green,
          ),
        ),
      ],
    );
  }
}
