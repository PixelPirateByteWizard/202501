import 'package:flutter/material.dart';
import '../../services/ai_service.dart';
import '../../models/story.dart';
import '../../models/chapter_narrative.dart';
import 'dart:collection';

import '../../screens/level_select_screen.dart';
import 'dart:async';
import '../../globals.dart'; // Import the globals file

class LevelThree extends StatefulWidget {
  const LevelThree({super.key});

  @override
  State<LevelThree> createState() => _LevelThreeState();
}

class _LevelThreeState extends State<LevelThree>
    with SingleTickerProviderStateMixin {
  final List<ChapterNarrative> narratives = [
    ChapterNarrative(
      title: "无字经书",
      prelude: '''
        在西行的路上，唐僧师徒偶然发现了一本古老的无字经书。书中蕴含着无尽的智慧与力量，传说这本经书能指引修行者走向更高的境界，但也隐藏着巨大的危险。师徒们心中充满了好奇与忐忑，决定深入探究，寻找其中的奥秘。每一页都仿佛在低语，召唤着他们去揭开那神秘的面纱。
      ''',
      review: '''
        经过一番探索，师徒们终于领悟了无字经书的真谛，明白了修行的真正意义。虽然面临重重考验，他们的心灵得到了升华，彼此之间的信任也愈发坚定。每一次的挑战都让他们更加团结，继续踏上取经之路，前方的挑战依然等待着他们，新的冒险即将展开。
      ''',
      initialStories: [
        Story(
          content:
              "唐僧翻开无字经书，感受到一股神秘的力量，心中暗想：'这本书似乎在向我传达什么深奥的道理。'他细细品味书中的每一个字句，仿佛能听到古老智慧的低语。",
          options: ["仔细研究经书", "询问悟空的看法", "继续前行"],
          correctOption: 0,
        ),
        Story(
          content:
              "悟空感到经书中的气息异常，眉头紧锁，提醒师父：'师父，这本书可能隐藏着危险。我们必须小心行事。'他警觉地环顾四周，似乎在寻找潜在的威胁。",
          options: ["继续研究", "放下经书", "寻找其他线索"],
          correctOption: 1,
        ),
        Story(
          content:
              "就在师徒们深入研究时，突然，一只守护经书的妖怪从阴影中跃出，怒吼着向他们扑来。唐僧和悟空迅速反应，准备迎接这场激烈的战斗。",
          options: ["反击妖怪", "寻找逃跑的机会", "请求观音菩萨的帮助"],
          correctOption: 0,
        ),
      ],
    ),
    ChapterNarrative(
      title: "凌云渡",
      prelude: '''
        师徒一行来到了凌云渡，这里云雾缭绕，宛如仙境。然而，渡口却被一只凶猛的妖怪所把守，阻挡了他们的去路。唐僧心中充满了对未来的担忧，而悟空则在思考着如何渡过这道难关。面对未知的挑战，师徒们必须团结一致，才能找到生路。每一步都充满了悬念，仿佛在考验着他们的勇气与智慧。
      ''',
      review: '''
        经过一番斗智斗勇，师徒们终于成功渡过凌云渡，妖怪被打败，继续向西行进。每一次的挑战都让他们更加团结，心灵的羁绊愈发牢固。此刻，他们不仅是师徒，更是并肩作战的战友，心中燃起了对未来的希望与勇气，新的冒险在等待着他们。
      ''',
      initialStories: [
        Story(
          content:
              "在凌云渡前，唐僧感到无比焦虑，心中暗想：'这妖怪如此强大，我们该如何渡过？'他深吸一口气，努力让自己冷静下来，思考着应对之策。",
          options: ["寻找水源", "请求帮助", "想办法渡过"],
          correctOption: 2,
        ),
        Story(
          content:
              "悟空决定利用自己的法力，寻找解决办法，心中默念咒语，试图用云雾遮挡妖怪的视线。他的眼中闪烁着坚定的光芒，准备迎接挑战。",
          options: ["施展法术", "寻找其他妖怪", "请求观音菩萨的帮助"],
          correctOption: 0,
        ),
        Story(
          content: "经过一番努力，师徒们终于成功渡过凌云渡，感受到团结的力量。唐僧感慨道：'只要我们齐心协力，就没有克服不了的困难！'",
          options: ["继续前行", "休息片刻", "总结经验"],
          correctOption: 0,
        ),
      ],
    ),
    ChapterNarrative(
      title: "真经归唐",
      prelude: '''
        在经历了无数磨难后，师徒们终于来到了真经归唐的地方。这里是取经的终点，也是他们修行的归宿。唐僧感到无比欣慰，心中充满了对未来的期待。每一段旅程都在他们心中留下了深刻的印记，仿佛在诉说着一个个动人的故事。
      ''',
      review: '''
        师徒们成功取回真经，完成了西行的使命。每个人的心中都燃起了希望的火焰，未来的道路依然漫长，但他们的心灵已然升华，团结的力量将继续指引他们前行。此刻，他们不仅是取经的旅者，更是心灵的探索者，新的篇章即将开启。
      ''',
      initialStories: [
        Story(
          content:
              "唐僧感慨万千，望着远方的天际，心中充满了感激：'经过这一路的艰辛，我们终于要回到唐朝了。'他知道，这段旅程将永远铭刻在他的心中。",
          options: ["继续前行", "回顾一路的经历", "总结修行的心得"],
          correctOption: 1,
        ),
        Story(
          content: "悟空回忆起一路上的冒险，感到无比自豪，兴奋地说道：'师父，我们的努力没有白费！每一次的挑战都让我们更加坚强！'",
          options: ["继续前行", "分享自己的感悟", "请求师父的指导"],
          correctOption: 1,
        ),
        Story(
          content: "在回归的路上，师徒们遇到了最后的考验，必须团结一致才能成功。唐僧坚定地说：'无论遇到什么困难，我们都要共同面对！'",
          options: ["共同面对考验", "寻找逃跑的机会", "请求观音菩萨的帮助"],
          correctOption: 0,
        ),
      ],
    ),
  ];

  int currentChapterIndex = 0;
  int currentStoryIndex = -1;
  List<Story>? aiGeneratedStories;
  bool isLoading = false;
  bool showingReview = false;

  // 每个章节的故事总数（包括预设和AI生成的）
  final List<int> chapterStoryCounts = [
    10, // 鹰愁涧收白龙：4个预设 + 6个AI生成
    8, // 高老庄降八戒：4个预设 + 4个AI生成
    10, // 流沙河伏悟净：4个预设 + 6个AI生成
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool isPreloading = false;
  Queue<Story> storyBuffer = Queue<Story>();
  static const int bufferSize = 3;

  // Add a flag to track if we should continue preloading
  bool _shouldContinuePreloading = true;

  // 增加加载超时时间（秒）
  static const _preloadTimeout = 15;
  static const _maxRetries = 3;
  int _currentRetryCount = 0;

  // 在_LevelThreeState类中添加这些成员变量
  late Stopwatch _loadingStopwatch;
  String _loadingStatus = '正在初始化...';
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _loadingStopwatch = Stopwatch();
    _setupAnimation();
    _initializeChapter();
    _loadInitialProgress();
    Globals.loadManaPoints(); // Load mana points on initialization
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  Future<void> _initializeChapter() async {
    setState(() => isLoading = true);

    try {
      // 立即开始预加载故事
      _preloadStories();

      // 显示前言并进入故事
      if (mounted) {
        setState(() {
          isLoading = false;
          currentStoryIndex = -1; // 显示前言
        });

        // 等待5-7秒
        await Future.delayed(const Duration(seconds: 6));

        // 确保widget还在树中且AI已生成至少一个故事
        if (mounted) {
          setState(() => currentStoryIndex = 0);
          _animationController.forward();
        }
      }
    } catch (e) {
      print('Error initializing chapter: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          currentStoryIndex = -1;
        });
      }
    }
  }

  Future<void> _preloadStories() async {
    if (!_shouldContinuePreloading || !mounted || isPreloading) return;

    print('Starting preload...');
    setState(() {
      isPreloading = true;
      _loadingStopwatch.reset();
      _loadingStopwatch.start();
      _currentRetryCount = 0;
      _progressValue = 0.0;
      // 确保列表初始化
      aiGeneratedStories ??= [];
    });

    final currentNarrative = narratives[currentChapterIndex];
    final totalNeeded = chapterStoryCounts[currentChapterIndex] -
        currentNarrative.initialStories.length;

    try {
      // 修改循环条件，使用安全访问
      while ((aiGeneratedStories?.length ?? 0) < totalNeeded &&
          _loadingStopwatch.elapsed.inSeconds < _preloadTimeout &&
          _currentRetryCount <= _maxRetries) {
        _updateLoadingStatus();

        final story = await AIService.generateSingleStory(
          currentNarrative.title,
          [...currentNarrative.initialStories, ...?aiGeneratedStories],
          aiGeneratedStories?.length ?? 0,
          totalNeeded,
        ).timeout(const Duration(seconds: _preloadTimeout));

        if (!mounted) return;

        setState(() {
          aiGeneratedStories?.add(story);
          _progressValue = (aiGeneratedStories?.length ?? 0) / totalNeeded;
        });
      }
    } on TimeoutException {
      print('Preloading timed out');
      _handlePreloadError('加载超时，正在尝试重新连接...');
    } catch (e) {
      print('Error generating story: $e');
      _handlePreloadError('遇到问题，正在重试...');
    } finally {
      if (mounted) {
        setState(() {
          isPreloading = false;
          _loadingStopwatch.stop();
          if ((aiGeneratedStories?.length ?? 0) < totalNeeded &&
              _currentRetryCount < _maxRetries) {
            Future.delayed(const Duration(seconds: 2), _preloadStories);
          }
        });
      }
    }
  }

  void _updateLoadingStatus() {
    final elapsed = _loadingStopwatch.elapsed.inSeconds;
    setState(() {
      if (elapsed < 5) {
        _loadingStatus = '正在生成剧情场景...';
        _progressValue += 0.1;
      } else if (elapsed < 10) {
        _loadingStatus = '优化战斗动画效果...';
        _progressValue += 0.05;
      } else {
        _loadingStatus = '正在最终检查...';
        _progressValue += 0.02;
      }
      _progressValue = _progressValue.clamp(0.0, 0.95);
    });
  }

  void _handlePreloadError(String message) {
    if (!mounted) return;

    setState(() {
      _currentRetryCount++;
      _loadingStatus = '$message (尝试 $_currentRetryCount/$_maxRetries)';
      _progressValue = 0.0;
    });

    if (_currentRetryCount > _maxRetries) {
      _showFallbackContent();
    }
  }

  void _showFallbackContent() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('温馨提示', style: TextStyle(color: Color(0xFFFFD700))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('网络连接不稳定，已启用本地剧情模式'),
            const SizedBox(height: 16),
            Image.asset('assets/images/fallback_scene.png', height: 120),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.8),
                foregroundColor: const Color(0xFFFFD700),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _initializeFallbackStories();
              },
              child: const Text('继续游戏'),
            ),
          ],
        ),
      ),
    );
  }

  void _initializeFallbackStories() {
    final currentNarrative = narratives[currentChapterIndex];
    final needed = chapterStoryCounts[currentChapterIndex] -
        currentNarrative.initialStories.length;

    setState(() {
      aiGeneratedStories = List.generate(
          needed,
          (index) => AIService.generateDynamicFallbackStory(
                currentNarrative.title,
                index,
                currentNarrative.initialStories,
              ));
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentNarrative = narratives[currentChapterIndex];

    // 只在第一章开始时显示前话
    if (currentStoryIndex == -1) {
      return _buildNarrativeScreen(
        currentNarrative.prelude,
        '开始章节',
        () {
          setState(() => currentStoryIndex = 0);
        },
      );
    }

    // 显示章节回顾
    if (showingReview) {
      String content = currentNarrative.review;
      String buttonText;
      VoidCallback onPressed;

      if (currentChapterIndex < narratives.length - 1) {
        buttonText = '进入下一章';
        onPressed = _preloadNextChapter;
      } else {
        buttonText = '完成章节';
        onPressed = () => Navigator.of(context).pop();
      }

      return _buildNarrativeScreen(content, buttonText, onPressed);
    }

    // 如果正在加载AI故事，显示加载指示器
    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bj/xybj3.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: _buildLoadingIndicator(),
        ),
      );
    }

    // 检查是否需要生成AI故事
    if (currentStoryIndex == currentNarrative.initialStories.length &&
        aiGeneratedStories == null) {
      _preloadStories();
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bj/xybj3.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: _buildLoadingIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/bj/xybj3.png'),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFFFD700).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBackButton(),
                        Text(
                          currentNarrative.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD700),
                            shadows: [
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 4.0,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress Bar
                    _buildProgressBar(),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                        child: Text(
                          '法力值: ${Globals.manaPoints.value}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.amber.shade200,
                            fontFamily: 'ZHSGuFeng',
                            shadows: const [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 4,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Story Content
              Expanded(
                child: _buildStoryContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNarrativeScreen(
      String content, String buttonText, VoidCallback? onPressed) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bj/xybj3.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  narratives[currentChapterIndex].title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 4.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFD700).withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            content,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              height: 1.8,
                            ),
                          ),
                          if (showingReview &&
                              currentChapterIndex == narratives.length - 1)
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: TweenAnimationBuilder<int>(
                                tween: IntTween(begin: 8, end: 0),
                                duration: const Duration(seconds: 8),
                                onEnd: () {
                                  // 倒计时结束后返回关卡选择界面
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LevelSelectScreen(),
                                    ),
                                  );
                                },
                                builder: (context, value, child) {
                                  return Text(
                                    '$value秒后返回关卡选择',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFFFD700),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoryContent() {
    final currentNarrative = narratives[currentChapterIndex];
    Story? currentStory;

    if (currentStoryIndex < 0) {
      return _buildPrelude(currentNarrative.prelude);
    }

    // 获取当前故事
    if (currentStoryIndex < currentNarrative.initialStories.length) {
      // 使用预设剧情
      currentStory = currentNarrative.initialStories[currentStoryIndex];
    } else {
      // 使用AI生成的剧情
      final aiStoryIndex =
          currentStoryIndex - currentNarrative.initialStories.length;
      if (aiGeneratedStories != null &&
          aiStoryIndex < aiGeneratedStories!.length) {
        currentStory = aiGeneratedStories![aiStoryIndex];
        // 如果还有更多故事需要生成，开始预加载
        if (aiStoryIndex >= aiGeneratedStories!.length - 1) {
          _preloadStories();
        }
      }
    }

    // 如果故事不可用，显示加载状态
    if (currentStory == null || isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
            ),
            const SizedBox(height: 20),
            Text(
              isPreloading ? '师徒正在赶路...' : '准备中...',
              style: TextStyle(
                color: const Color(0xFFFFD700),
                fontSize: 16,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 3.0,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // 确保选项数量正确
    if (currentStory.options.length != 3) {
      print(
          'Warning: Invalid options count for story: ${currentStory.options.length}');
      // 如果选项数量不正确，使用备用选项
      currentStory = Story(
        content: currentStory.content,
        options: [
          currentStory.options.firstOrNull ?? "继续",
          currentStory.options.length > 1 ? currentStory.options[1] : "思考",
          currentStory.options.length > 2 ? currentStory.options[2] : "等待",
        ],
        correctOption: currentStory.correctOption.clamp(0, 2),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Story Content Container
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFD700).withOpacity(0.7),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Story Text
                    Text(
                      currentStory?.content ?? '',
                      style: const TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        height: 1.8,
                        letterSpacing: 0.5,
                      ),
                    ),
                    // Loading Indicator (if needed)
                    if (isPreloading)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              '师徒正在赶路...',
                              style: TextStyle(
                                color: const Color(0xFFFFD700).withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Options Container
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFFFD700).withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildOptionButton(
                    currentStory?.options[index] ?? '',
                    () =>
                        onOptionSelected(index == currentStory?.correctOption),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String text, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFFFFD700),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: const Color(0xFFFFD700).withOpacity(0.7),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrelude(String prelude) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFFFD700).withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        prelude,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 添加加载提示
                      if (isPreloading || aiGeneratedStories == null)
                        Column(
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFFFD700)),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '正在准备故事情节...',
                              style: TextStyle(
                                color: const Color(0xFFFFD700).withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                            if (aiGeneratedStories != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '已生成: ${aiGeneratedStories!.length} / ${chapterStoryCounts[currentChapterIndex] - narratives[currentChapterIndex].initialStories.length}',
                                  style: TextStyle(
                                    color: const Color(0xFFFFD700)
                                        .withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
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
  }

  // 添加记录正确选择的变量
  int correctChoices = 0;
  // 添加通关所需的最低正确选择数（可以根据需要调整）
  final int requiredCorrectChoices = 20; // 比如总共30个选择中需要答对20个才能通关

  // 修改选项选择处理逻辑
  void onOptionSelected(bool isCorrect) {
    if (Globals.manaPoints.value > 0) {
      Globals.manaPoints.value--;
      Globals.manaPoints.notifyListeners();
    }
    // 记录正确选择
    if (isCorrect) {
      correctChoices++;
    }

    // 无论对错都继续剧情
    _animationController.reverse().then((_) {
      if (!mounted) return;

      final currentNarrative = narratives[currentChapterIndex];
      final totalStories = chapterStoryCounts[currentChapterIndex];

      setState(() {
        if (currentStoryIndex < totalStories - 1) {
          // 如果是预设剧情，直接进入下一个
          if (currentStoryIndex < currentNarrative.initialStories.length - 1) {
            currentStoryIndex++;
          }
          // 如果是最后一个预设剧情，检查AI故事是否准备好
          else if (currentStoryIndex ==
              currentNarrative.initialStories.length - 1) {
            if (aiGeneratedStories != null && aiGeneratedStories!.isNotEmpty) {
              currentStoryIndex++;
            } else {
              _preloadStories();
              isLoading = true;
            }
          }
          // 如果是AI生成的剧情
          else if (aiGeneratedStories != null &&
              currentStoryIndex - currentNarrative.initialStories.length <
                  aiGeneratedStories!.length) {
            currentStoryIndex++;
            _preloadStories();
          }
        } else {
          // 显示章节回顾
          showingReview = true;
          // 如果是最后一章，检查是否通关
          if (currentChapterIndex == narratives.length - 1) {
            _showCompletionDialog();
          } else {
            _preloadNextChapter();
          }
        }
      });

      _animationController.forward();
    });
  }

  // 添加显示通关结果的对话框
  Future<void> _showCompletionDialog() async {
    final bool passed = correctChoices >= requiredCorrectChoices;
    final double newProgress = passed
        ? 1.0
        : (correctChoices / requiredCorrectChoices).clamp(0.0, 1.0);

    await LevelProgressService.updateProgress(1, newProgress); // 更新第一关进度

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFFFD700), width: 2),
          ),
          title: Text(
            passed ? '恭喜通关！' : '通关失败',
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                passed
                    ? '你成功完成了第一关的挑战！\n正确选择: $correctChoices/${chapterStoryCounts.reduce((a, b) => a + b)}'
                    : '未能达到通关要求\n正确选择: $correctChoices/${chapterStoryCounts.reduce((a, b) => a + b)}\n需要至少 $requiredCorrectChoices 个正确选择',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LevelSelectScreen(),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFD700)),
                ),
                child: const Text(
                  '返回关卡选择',
                  style: TextStyle(color: Color(0xFFFFD700)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Set the flag to false to stop preloading
    _shouldContinuePreloading = false;
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFFFD700).withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xFFFFD700),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.grey[800],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(
          value:
              (currentStoryIndex + 1) / chapterStoryCounts[currentChapterIndex],
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: _progressValue,
              strokeWidth: 6,
              valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD700)),
              backgroundColor: Colors.grey[800],
            ),
            Icon(
              Icons.auto_stories_rounded,
              color: const Color(0xFFFFD700).withOpacity(0.8),
              size: 32,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          _loadingStatus,
          style: TextStyle(
            color: const Color(0xFFFFD700),
            fontSize: 16,
            shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 3.0,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '已生成: ${aiGeneratedStories?.length ?? 0}/'
          '${chapterStoryCounts[currentChapterIndex] - narratives[currentChapterIndex].initialStories.length}',
          style: TextStyle(
            color: const Color(0xFFFFD700).withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Future<void> _preloadNextChapter() async {
    if (currentChapterIndex + 1 < narratives.length && mounted) {
      // 显示当前章节回顾
      setState(() => showingReview = true);

      // 等待显示回顾8秒
      await Future.delayed(const Duration(seconds: 8));

      if (!mounted) return;

      setState(() {
        currentChapterIndex++; // 增加章节索引
        currentStoryIndex = 0; // 直接从预设剧情开始
        showingReview = false; // 关闭回顾显示
        storyBuffer.clear();
        aiGeneratedStories = null;
        isPreloading = false;
      });

      // 重置动画
      _animationController.reset();
      _animationController.forward();

      // 开始预加载新章节的故事
      _preloadStories();
    } else if (currentChapterIndex == narratives.length - 1 && mounted) {
      // 最后一章结束，显示回顾
      setState(() => showingReview = true);

      // 等待显示回顾8秒
      await Future.delayed(const Duration(seconds: 8));

      if (!mounted) return;

      // 返回关卡选择界面
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LevelSelectScreen(),
        ),
      );
    }
  }

  Future<void> _loadInitialProgress() async {
    final progress = await LevelProgressService.getProgress(1);
    if (mounted) {
      setState(() {
        _progressValue = progress;
      });
    }
  }
}
