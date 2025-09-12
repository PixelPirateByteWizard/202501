import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _textAnimationController;
  late AnimationController _particleAnimationController;
  late AnimationController _swordAnimationController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _swordAnimation;
  
  final List<Particle> _particles = [];
  Timer? _splashTimer;
  
  // 三国名言列表
  final List<String> _quotes = [
    '天下大势，分久必合，合久必分',
    '既生瑜，何生亮',
    '鞠躬尽瘁，死而后已',
    '宁教我负天下人，休教天下人负我',
    '治世之能臣，乱世之奸雄',
    '桃园三结义，不求同年同月同日生',
    '温酒斩华雄，千里走单骑',
    '草船借箭，火烧赤壁',
  ];
  
  String _currentQuote = '';
  int _quoteIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // 初始化动画控制器
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _particleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _swordAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // 设置动画
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    ));
    
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _textSlideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOutBack,
    ));
    
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleAnimationController);
    
    _swordAnimation = Tween<double>(
      begin: -200.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _swordAnimationController,
      curve: Curves.easeOutQuart,
    ));
    
    // 初始化粒子
    _initParticles();
    
    // 初始化名言
    _currentQuote = _quotes[0];
    
    // 启动动画序列
    _startAnimationSequence();
    
    // 启动名言轮播
    _startQuoteRotation();
    
    // 设置跳转定时器
    _splashTimer = Timer(const Duration(milliseconds: 5000), () {
      _navigateToHome();
    });
  }
  
  void _initParticles() {
    final random = math.Random();
    for (int i = 0; i < 30; i++) {
      _particles.add(Particle(
        x: random.nextDouble() * 400,
        y: random.nextDouble() * 800,
        size: random.nextDouble() * 6 + 3,
        speed: random.nextDouble() * 3 + 0.5,
        color: [
          AppTheme.accentColor,
          const Color(0xFFffd700),
          Colors.red.shade300,
          Colors.orange.shade300,
          Colors.pink.shade200,
          Colors.purple.shade200,
        ][random.nextInt(6)],
        rotation: random.nextDouble() * 2 * math.pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 0.1,
      ));
    }
  }
  
  void _startAnimationSequence() async {
    // 启动粒子动画
    _particleAnimationController.repeat();
    
    // 延迟启动logo动画
    await Future.delayed(const Duration(milliseconds: 500));
    _logoAnimationController.forward();
    
    // 延迟启动文字动画
    await Future.delayed(const Duration(milliseconds: 800));
    _textAnimationController.forward();
    
    // 延迟启动剑的动画
    await Future.delayed(const Duration(milliseconds: 1200));
    _swordAnimationController.forward();
  }
  
  void _startQuoteRotation() {
    Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (mounted) {
        setState(() {
          _quoteIndex = (_quoteIndex + 1) % _quotes.length;
          _currentQuote = _quotes[_quoteIndex];
        });
      } else {
        timer.cancel();
      }
    });
  }
  
  void _navigateToHome() {
    // 轻微震动反馈
    HapticFeedback.lightImpact();
    
    // 取消定时器
    _splashTimer?.cancel();
    
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }
  
  @override
  void dispose() {
    _splashTimer?.cancel();
    _logoAnimationController.dispose();
    _textAnimationController.dispose();
    _particleAnimationController.dispose();
    _swordAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Color(0xFF2d1b69),
              AppTheme.primaryColor,
              AppTheme.secondaryColor,
              AppTheme.darkColor,
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // 背景粒子效果
            AnimatedBuilder(
              animation: _particleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(_particles, _particleAnimation.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // 主要内容
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo区域
                  AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Transform.rotate(
                          angle: _logoRotationAnimation.value,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [
                                  AppTheme.accentColor,
                                  Color(0xFFffd700),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accentColor.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                '三\n国',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  height: 1.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // 标题文字
                  AnimatedBuilder(
                    animation: _textAnimationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textSlideAnimation.value),
                        child: Opacity(
                          opacity: _textFadeAnimation.value,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    AppTheme.accentColor,
                                    Color(0xFFffd700),
                                    AppTheme.accentColor,
                                  ],
                                ).createShader(bounds),
                                child: const Text(
                                  '烽尘绘谱',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.accentColor.withOpacity(0.3),
                                      AppTheme.accentColor.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppTheme.accentColor.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: const Text(
                                  '字里行间，自有千军万马',
                                  style: TextStyle(
                                    color: AppTheme.lightColor,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // 剑的装饰
                  AnimatedBuilder(
                    animation: _swordAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_swordAnimation.value, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSword(true),
                            const SizedBox(width: 40),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.accentColor.withOpacity(0.3),
                                    AppTheme.accentColor.withOpacity(0.1),
                                  ],
                                ),
                                border: Border.all(
                                  color: AppTheme.accentColor.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.sports_martial_arts,
                                color: AppTheme.accentColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 40),
                            _buildSword(false),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // 名言显示区域
            Positioned(
              bottom: 160,
              left: 20,
              right: 20,
              child: AnimatedBuilder(
                animation: _textAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textFadeAnimation.value,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 800),
                      child: Container(
                        key: ValueKey(_currentQuote),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.cardColor.withOpacity(0.3),
                              AppTheme.cardColor.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppTheme.accentColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _currentQuote,
                          style: const TextStyle(
                            color: AppTheme.lightColor,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // 底部加载提示
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _textAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textFadeAnimation.value,
                    child: Column(
                      children: [
                        const Text(
                          '正在进入三国世界...',
                          style: TextStyle(
                            color: AppTheme.lightColor,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: LinearProgressIndicator(
                            backgroundColor: AppTheme.lightColor.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // 跳过按钮
            Positioned(
              top: 50,
              right: 20,
              child: AnimatedBuilder(
                animation: _textAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textFadeAnimation.value * 0.8,
                    child: GestureDetector(
                      onTap: _navigateToHome,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.cardColor.withOpacity(0.3),
                              AppTheme.cardColor.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.accentColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          '跳过',
                          style: TextStyle(
                            color: AppTheme.lightColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // 版本信息
            Positioned(
              bottom: 20,
              right: 20,
              child: AnimatedBuilder(
                animation: _textAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textFadeAnimation.value * 0.7,
                    child: const Text(
                      'v1.0.0',
                      style: TextStyle(
                        color: AppTheme.lightColor,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSword(bool isLeft) {
    return Transform.rotate(
      angle: isLeft ? -math.pi / 6 : math.pi / 6,
      child: Container(
        width: 4,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFc0c0c0),
              Color(0xFF808080),
              AppTheme.accentColor,
            ],
          ),
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final Color color;
  double opacity;
  double rotation;
  final double rotationSpeed;
  
  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
    this.opacity = 1.0,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  
  ParticlePainter(this.particles, this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (final particle in particles) {
      // 更新粒子位置和旋转
      particle.y -= particle.speed;
      particle.rotation += particle.rotationSpeed;
      
      // 添加轻微的水平漂移
      particle.x += math.sin(particle.y * 0.01) * 0.5;
      
      if (particle.y < -10) {
        particle.y = size.height + 10;
        particle.x = math.Random().nextDouble() * size.width;
      }
      
      // 计算透明度（基于动画值和距离中心的距离）
      final centerX = size.width / 2;
      final centerY = size.height / 2;
      final distance = math.sqrt(
        math.pow(particle.x - centerX, 2) + math.pow(particle.y - centerY, 2),
      );
      final maxDistance = math.sqrt(
        math.pow(centerX, 2) + math.pow(centerY, 2),
      );
      final distanceOpacity = 1.0 - (distance / maxDistance);
      
      particle.opacity = (math.sin(animationValue * 2 * math.pi) * 0.3 + 0.7) * 
                        distanceOpacity * 0.6;
      
      paint.color = particle.color.withOpacity(particle.opacity);
      
      // 保存画布状态
      canvas.save();
      
      // 移动到粒子位置并旋转
      canvas.translate(particle.x, particle.y);
      canvas.rotate(particle.rotation);
      
      // 绘制花瓣形状而不是圆形
      _drawPetal(canvas, paint, particle.size);
      
      // 恢复画布状态
      canvas.restore();
    }
  }
  
  void _drawPetal(Canvas canvas, Paint paint, double size) {
    final path = Path();
    
    // 创建花瓣形状
    path.moveTo(0, -size);
    path.quadraticBezierTo(size * 0.5, -size * 0.5, size * 0.3, 0);
    path.quadraticBezierTo(size * 0.5, size * 0.5, 0, size * 0.8);
    path.quadraticBezierTo(-size * 0.5, size * 0.5, -size * 0.3, 0);
    path.quadraticBezierTo(-size * 0.5, -size * 0.5, 0, -size);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}