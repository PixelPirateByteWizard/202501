import 'package:flutter/material.dart';
import '../../services/ai_service.dart';
import '../../models/story.dart';
import '../../models/chapter_narrative.dart';
import 'dart:collection';

import '../../screens/level_select_screen.dart';
import 'dart:async';
import '../../globals.dart'; // Import the globals file

class LevelTwo extends StatefulWidget {
  const LevelTwo({super.key});

  @override
  State<LevelTwo> createState() => _LevelTwoState();
}

class _LevelTwoState extends State<LevelTwo>
    with SingleTickerProviderStateMixin {
  final List<ChapterNarrative> narratives = [
    ChapterNarrative(
      title: "三打白骨精",
      prelude: '''
        在西行的路上，唐僧师徒遇到了一位貌美的女子，她的眼神如星辰般闪烁，仿佛在诉说着无尽的故事。然而，这位女子实则是白骨精化身，企图用美色迷惑唐僧。悟空的警觉让他看穿了她的诡计，决心不惜一切代价保护师父，展开一场智勇的较量。
      ''',
      review: '''
        经过一番斗智斗勇，悟空最终揭穿了白骨精的真面目，保护了师父的安全。师徒之间的信任在这场考验中愈发深厚，他们的心灵也在这次冒险中得到了升华。继续踏上取经之路，前方的挑战依然等待着他们。
      ''',
      initialStories: [
        Story(
          content: "白骨精化身为美丽女子，向唐僧求助：'师父，我被妖怪追赶，求您救我！'她的声音如同春风般柔和，令人心生怜悯。",
          options: ["立即帮助她", "保持警惕", "询问她的故事"],
          correctOption: 1,
        ),
        Story(
          content: "唐僧心生怜悯，决定帮助她，但悟空却提醒师父要小心，暗示她可能并不简单。唐僧犹豫不决，心中充满了矛盾。",
          options: ["继续帮助她", "询问妖怪的情况", "拒绝帮助"],
          correctOption: 1,
        ),
        Story(
          content: "白骨精露出真实面目，试图攻击唐僧，悟空及时出手相救，展开一场激烈的战斗。火光四射，妖气弥漫。",
          options: ["反击白骨精", "保护唐僧", "寻找逃跑的机会"],
          correctOption: 0,
        ),
      ],
    ),
    ChapterNarrative(
      title: "真假美猴王",
      prelude: '''
        在这一章中，悟空与假猴王展开了一场智力与勇气的较量。假猴王伪装成悟空，混入师徒之中，试图取代悟空的位置。师徒之间的信任面临着巨大的考验，悟空必须依靠自己的智慧和勇气，揭穿这个阴谋，保护师父的安全。
      ''',
      review: '''
        最终，悟空凭借机智和勇气，揭穿了假猴王的阴谋，保护了师父的安全。师徒之间的信任在这场考验中愈发深厚，继续西行，新的冒险在等待着他们。每一次的挑战都让他们更加团结，心灵的羁绊愈发牢固。
      ''',
      initialStories: [
        Story(
          content: "假猴王假装成悟空，混入师徒之中，试图取代悟空的位置，唐僧对此毫无察觉。假猴王的狡诈让人心生疑虑。",
          options: ["揭穿假猴王", "保持沉默", "观察其动向"],
          correctOption: 0,
        ),
        Story(
          content: "悟空通过细致的观察，发现假猴王的破绽，决定采取行动，揭露他的真实身份。师父的安危在此刻显得尤为重要。",
          options: ["直接对质", "设下圈套", "寻求师父的帮助"],
          correctOption: 1,
        ),
        Story(
          content: "经过一番斗智，悟空终于揭穿了假猴王的阴谋，师徒们团结一致，准备迎接新的挑战。信任的力量让他们更加坚定。",
          options: ["保护师父", "继续追击假猴王", "请求观音菩萨帮助"],
          correctOption: 0,
        ),
      ],
    ),
    ChapterNarrative(
      title: "勇闯火焰山",
      prelude: '''
        师徒一行在火焰山遇到困难，面临熊熊烈火的威胁。唐僧感到无比焦虑，心中充满了对未来的担忧。而悟空则在思考着如何渡过这道难关，面对火焰的挑战，他们必须团结一致，才能找到生路。
      ''',
      review: '''
        经过一番努力，悟空凭借智慧和勇气，成功获取了火焰山的火焰，继续西行。师徒之间的默契与信任在这一过程中得到了进一步的升华。每一次的挑战都让他们更加坚定，心中燃起了对未来的希望与勇气。
      ''',
      initialStories: [
        Story(
          content: "师徒来到火焰山，面临熊熊烈火，唐僧感到无比焦虑，心中充满了对未来的担忧。火焰的热浪让他们几乎窒息。",
          options: ["寻找水源", "请求帮助", "想办法渡过"],
          correctOption: 2,
        ),
        Story(
          content: "悟空决定利用自己的法力，寻找解决办法，试图用水魔法扑灭火焰。时间紧迫，他们必须迅速行动。",
          options: ["施展法术", "寻找其他妖怪", "请求观音菩萨的帮助"],
          correctOption: 0,
        ),
        Story(
          content: "经过一番努力，师徒终于成功渡过火焰山，感受到团结的力量。每个人的心中都燃起了希望的火焰。",
          options: ["继续前行", "休息片刻", "总结经验"],
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

  // 在_LevelTwoState类中添加这些成员变量
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
              image: AssetImage('assets/bj/xybj5.png'),
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
              image: AssetImage('assets/bj/xybj5.png'),
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
            image: AssetImage('assets/bj/xybj5.png'),
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
            image: AssetImage('assets/bj/xybj5.png'),
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
