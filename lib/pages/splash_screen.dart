import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import '../app.dart';
import '../utils/cartoon_ui.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _eulaAccepted = false;
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _checkboxAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 20,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6),
    ));

    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi * 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));

    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeInOut),
    ));

    _textSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOutCubic),
    ));

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    _checkboxAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 0.9, curve: Curves.elasticOut),
    ));

    _buttonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.8, 1.0, curve: Curves.elasticOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchEulaUrl() async {
    final Uri url = Uri.parse(
        'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('无法打开网页链接')),
        );
      }
    }
  }

  void _navigateToApp() {
    if (_eulaAccepted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AppScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先同意EULA'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取屏幕尺寸，用于布局计算
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
        child: Stack(
          children: [
            // 粒子效果背景
            AnimatedBuilder(
              animation: _particleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: SimpleParticlesPainter(
                    progress: _particleAnimation.value,
                    particleColor: Theme.of(context).colorScheme.primary,
                  ),
                  size: size,
                );
              },
            ),
            // 主内容
            SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: size.height -
                          MediaQuery.of(context).padding.vertical),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: isSmallScreen ? 40 : 80),
                        // Logo 动画 - 卡通风格，确保居中
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Center(
                              child: Transform.scale(
                                scale: _logoScaleAnimation.value,
                                child: Transform.rotate(
                                  angle: _logoRotationAnimation.value,
                                  child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF6B2C9E),
                                        Color(0xFF4A1A6B),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF6B2C9E).withValues(alpha: 0.3),
                                        blurRadius: 30,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 10),
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 20,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // 内部光晕
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.white.withValues(alpha: 0.3),
                                              Colors.transparent,
                                            ],
                                            stops: const [0.3, 1.0],
                                          ),
                                        ),
                                      ),
                                      // 主图标
                                      const Icon(
                                        Icons.blur_circular_rounded,
                                        size: 80,
                                        color: Colors.white,
                                      ),
                                      // 装饰性小圆点
                                      Positioned(
                                        top: 20,
                                        right: 25,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        // 文字动画 - 卡通风格，确保居中
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _textOpacityAnimation.value,
                              child: Transform.translate(
                                offset: Offset(0, _textSlideAnimation.value),
                                child: Center(
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [
                                        Color(0xFF6B2C9E),
                                        Color(0xFF4A1A6B),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                    child: const Text(
                                      'Luvimestra',
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _textOpacityAnimation.value,
                              child: Transform.translate(
                                offset: Offset(0, _textSlideAnimation.value),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '探索平行时空的奇妙旅程',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                        letterSpacing: 0.8,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: isSmallScreen ? 60 : 120),
                        // 协议勾选 - 卡通风格，确保居中
                        AnimatedBuilder(
                          animation: _checkboxAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: math.min(1.0, _checkboxAnimation.value),
                              child: Opacity(
                                opacity: math.min(1.0, _checkboxAnimation.value),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 15,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: IntrinsicWidth(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color: _eulaAccepted 
                                                  ? const Color(0xFF6B2C9E)
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: _eulaAccepted 
                                                    ? const Color(0xFF6B2C9E)
                                                    : Colors.grey[400]!,
                                                width: 2,
                                              ),
                                            ),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _eulaAccepted = !_eulaAccepted;
                                                  });
                                                },
                                                borderRadius: BorderRadius.circular(8),
                                                child: _eulaAccepted
                                                    ? const Icon(
                                                        Icons.check_rounded,
                                                        color: Colors.white,
                                                        size: 18,
                                                      )
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          RichText(
                                            text: TextSpan(
                                              text: '我同意 ',
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 14,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'EULA',
                                                  style: const TextStyle(
                                                    color: Color(0xFF6B2C9E),
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = _launchEulaUrl,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // 进入按钮 - 卡通风格，确保居中
                        AnimatedBuilder(
                          animation: _buttonAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: math.min(1.0, _buttonAnimation.value),
                              child: Opacity(
                                opacity: math.min(1.0, _buttonAnimation.value),
                                child: Center(
                                  child: CartoonUI.cartoonButton(
                                    text: '开始探索',
                                    icon: Icons.rocket_launch_rounded,
                                    onPressed: _navigateToApp,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 48,
                                      vertical: 18,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: isSmallScreen ? 20 : 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 简化版粒子绘制器，移除可能导致透明度错误的代码
class SimpleParticlesPainter extends CustomPainter {
  final double progress;
  final Color particleColor;

  // 使用静态变量存储粒子，避免重复创建
  static final List<SimpleParticle> _particles = [];
  static const int _particleCount = 20; // 减少粒子数量
  static final math.Random _random = math.Random();

  SimpleParticlesPainter(
      {required this.progress, required this.particleColor}) {
    _initParticlesIfNeeded();
  }

  void _initParticlesIfNeeded() {
    if (_particles.isEmpty) {
      for (int i = 0; i < _particleCount; i++) {
        _particles.add(SimpleParticle(
          x: _random.nextDouble() * 400,
          y: _random.nextDouble() * 800,
          size: 1.5 + _random.nextDouble() * 2.5, // 减小粒子尺寸
          speed: 0.1 + _random.nextDouble() * 0.4, // 减慢速度
        ));
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    try {
      // 使用柔和的紫色粒子，适配亮色主题
      final paint = Paint()..color = const Color(0xFF6B2C9E).withValues(alpha: 0.2);

      for (var particle in _particles) {
        // 简化位置计算
        final currentX = (particle.x * size.width / 400) % size.width;
        final currentY =
            (particle.y + progress * 50 * particle.speed) % size.height;

        // 绘制简单圆形粒子
        canvas.drawCircle(
          Offset(currentX, currentY),
          particle.size,
          paint,
        );
      }
    } catch (e) {
      debugPrint('Particle painting error: $e');
    }
  }

  @override
  bool shouldRepaint(SimpleParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// 简化的粒子数据类
class SimpleParticle {
  final double x;
  final double y;
  final double size;
  final double speed;

  const SimpleParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}
