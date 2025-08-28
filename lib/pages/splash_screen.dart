import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import '../app.dart';

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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F1A2C), Color(0xFF1A0625)],
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
                      children: [
                        SizedBox(height: isSmallScreen ? 40 : 80),
                        // Logo 动画
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _logoScaleAnimation.value,
                              child: Transform.rotate(
                                angle: _logoRotationAnimation.value,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: ShaderMask(
                                      shaderCallback: (bounds) =>
                                          LinearGradient(
                                        colors: [
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ).createShader(bounds),
                                      child: const Icon(
                                        Icons.blur_circular,
                                        size: 80,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        // 文字动画
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _textOpacityAnimation.value,
                              child: Transform.translate(
                                offset: Offset(0, _textSlideAnimation.value),
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                    ],
                                  ).createShader(bounds),
                                  child: const Text(
                                    '摘星猫',
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _textOpacityAnimation.value,
                              child: Transform.translate(
                                offset: Offset(0, _textSlideAnimation.value),
                                child: Text(
                                  '探索平行时空的奇妙旅程',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[400],
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: isSmallScreen ? 60 : 120),
                        // 协议勾选
                        AnimatedBuilder(
                          animation: _checkboxAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: math.min(1.0, _checkboxAnimation.value),
                              child: Opacity(
                                opacity:
                                    math.min(1.0, _checkboxAnimation.value),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          unselectedWidgetColor:
                                              Colors.grey[600],
                                        ),
                                        child: Checkbox(
                                          value: _eulaAccepted,
                                          onChanged: (value) {
                                            setState(() {
                                              _eulaAccepted = value ?? false;
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          checkColor: Colors.white,
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: RichText(
                                        text: TextSpan(
                                          text: '我同意 ',
                                          style: const TextStyle(
                                              color: Colors.white70),
                                          children: [
                                            TextSpan(
                                              text: 'EULA',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = _launchEulaUrl,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // 进入按钮
                        AnimatedBuilder(
                          animation: _buttonAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: math.min(1.0, _buttonAnimation.value),
                              child: Opacity(
                                opacity: math.min(1.0, _buttonAnimation.value),
                                child: ElevatedButton(
                                  onPressed: _navigateToApp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 8,
                                    shadowColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.5),
                                  ),
                                  child: const Text(
                                    '进入应用',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
      // 使用固定不透明度，避免计算错误
      final paint = Paint()..color = particleColor.withOpacity(0.5);

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
