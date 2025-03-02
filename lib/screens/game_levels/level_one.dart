import 'package:flutter/material.dart';
import '../../services/ai_service.dart';
import '../../models/story.dart';
import '../../models/chapter_narrative.dart';
import 'dart:collection';

import '../../screens/level_select_screen.dart';
import 'dart:async';
import '../../globals.dart';

class LevelOne extends StatefulWidget {
  const LevelOne({super.key});

  @override
  State<LevelOne> createState() => _LevelOneState();
}

class _LevelOneState extends State<LevelOne>
    with SingleTickerProviderStateMixin {
  final List<ChapterNarrative> narratives = [
    ChapterNarrative(
      title: "鹰愁涧收白龙",
      prelude: '''
        西行路上，唐僧师徒来到了鹰愁涧前。这涧水汹涌澎湃，波涛翻滚，两岸悬崖峭壁，令人望而生畏。

        "师父，这鹰愁涧水势凶猛，怕是难以渡过。"悟空立于涧边，凝视着翻腾的浪花说道。

        唐僧望着眼前的险境，心中不敢生出几分忧虑。忽然，一阵狂风掀起巨浪，隐约可见水中有异样之处。

        "徒弟，你且去查看，这涧中可是有什么妖怪作祟？"唐僧问道。

        悟空火眼金睛一瞧，果然发现了端倪......
      ''',
      review: '''
        经过一番周折，白龙认识到自己的过错，幡然醒悟。这白龙原是天庭天马，因为失手打碎了琉璃盏，被贬下凡间。如今得遇点化，愿随师父西天取经，也是一场难得的机缘。

        然而，师徒一行刚离开鹰愁涧不久，就听闻前方高老庄有一妖怪作祟。这妖怪不仅占据高家花园，更是与高家小姐有了婚约。村民既想除之而后快，又似乎有所顾虑。这高老庄的妖怪，究竟有何来历？新的挑战即将开始......
      ''',
      initialStories: [
        Story(
          content: "悟空纵身一跃，落在涧边巨石之上。只见水中一条白龙正在兴风作浪，掀起滔天巨浪。'师父，这涧中果然有妖怪！'",
          options: ["上前询问", "立即动手", "先行观察"],
          correctOption: 0,
        ),
        Story(
          content:
              "那白龙见有人来，收敛了水势。原来他是天庭的天马，因失手打碎了玉帝的琉璃盏，被贬下凡。如今在此兴风作浪，就是为了引人注意，望能有人救他脱离苦海。",
          options: ["严厉斥责", "以理相劝", "置之不理"],
          correctOption: 1,
        ),
        Story(
          content: "白龙听闻悟空劝说，神色变得犹豫。'我已被贬下凡多年，即便想改过，又该如何是好？'悟空见他有悔意，心中已有计较。",
          options: ["建议随师西行", "威胁镇压", "请示唐僧"],
          correctOption: 0,
        ),
        Story(
          content: "白龙闻言大喜：'若能随师父西天取经，实乃我之福分！'然而就在此时，一道金光闪过，观音菩萨现身空中。",
          options: ["跪拜求情", "静观其变", "请求指点"],
          correctOption: 1,
        ),
      ],
    ),
    ChapterNarrative(
      title: "高老庄降八戒",
      prelude: "",
      review: '''
        原来这猪刚鬣竟是天蓬元帅转世，因贪杯调戏嫦娥，被贬下凡间。经过一番点化，他幡然醒悟，愿随师父西天取经，改名猪八戒。

        离开高老庄后，师徒三人继续西行。不料前方的流沙河中，又有一个来历不凡的水怪正在兴风作浪。这一路上的劫难，似乎永无止境......
      ''',
      initialStories: [
        Story(
          content:
              "唐僧师徒来到高老庄，只见村民神色慌张，纷纷躲避。打听之下，原来是有个叫猪刚鬣的妖怪占据了高家花园，更与高家小姐定下婚约。",
          options: ["直接前往", "暗中调查", "请求援助"],
          correctOption: 1,
        ),
        Story(
          content: "经过调查，悟空发现这猪刚鬣竟是天蓬元帅转世。'师父，此妖来历不凡，待我先去会他一会。'",
          options: ["强行降服", "以理相劝", "静观其变"],
          correctOption: 1,
        ),
        Story(
          content: "悟空化作一个书生，来到高家花园。猪刚鬣正在园中享受清福，见有人来，顿时警觉：'何人擅闯我的地盘？'",
          options: ["亮明身份", "虚与委蛇", "直接动手"],
          correctOption: 1,
        ),
        Story(
          content: "酒过三巡，猪刚鬣已有几分醉意。悟空见时机已到，突然显出真身：'天蓬元帅，别来无恙！'",
          options: ["趁机制服", "晓以大义", "召唤援军"],
          correctOption: 1,
        ),
      ],
    ),
    ChapterNarrative(
      title: "流沙河伏悟净",
      prelude: "",
      review: '''
        原来这流沙河中的卷帘大将，也是因过失被贬凡间。经过一番点化，他认识到自己的错误，愿意随师父西天取经，改名沙和尚。

        至此，西行队伍终于集齐。金蝉子转世的唐僧，天生石猴的孙悟空，天蓬元帅转世的猪八戒，以及卷帘大将转世的沙和尚，这支佛门队伍，将继续向西天迈进。

        然而，这仅仅是西天取经的开始。在这漫漫长路上，还有多少妖魔鬼怪在等待着他们？还有多少劫难等待他们去化解？更重要的是，这支队伍能否在重重考验中守护彼此，最终修得正果？

        一切尚未可知，但我们的故事，才刚刚开始......
      ''',
      initialStories: [
        Story(
          content: "来到流沙河前，八戒突然警觉：'师父，这河中有古怪！我方才见一黑影在水下晃动，比鹰愁涧的白龙还要凶猛！'",
          options: ["立即后退", "仔细观察", "强行渡河"],
          correctOption: 1,
        ),
        Story(
          content: "果然，河中突现一位手持宝杖的黑脸大汉，掀起滔天巨浪。悟空眼尖，认出此人竟是天庭的卷帘大将，如今也在此为妖。",
          options: ["直接开打", "询问来历", "召唤援助"],
          correctOption: 1,
        ),
        Story(
          content: "卷帘大将见是孙悟空，神色复杂：'我在此已多年，终日与这滔滔江水为伴，不知天庭可还记得我？'",
          options: ["嘲讽挑衅", "同情安慰", "点明因果"],
          correctOption: 2,
        ),
        Story(
          content: "悟空道出卷帘大将被贬下凡的原委，对方听后沉默良久。八戒在一旁插话：'老沙，不如随我们去西天取经，也好重归正道！'",
          options: ["立即同意", "继续劝说", "请示唐僧"],
          correctOption: 2,
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

  // 在_LevelOneState类中添加这些成员变量
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

      if (currentChapterIndex == 0) {
        // 第一章：显示前言5-7秒后自动进入故事
        setState(() {
          isLoading = false;
          currentStoryIndex = -1;
        });

        // 等待5-7秒
        await Future.delayed(const Duration(seconds: 6));

        // 确保widget还在树中且AI已生成至少一个故事
        if (mounted) {
          setState(() => currentStoryIndex = 0);
          _animationController.forward();
        }
      } else {
        // 其他章节：直接显示故事
        if (mounted) {
          setState(() {
            isLoading = false;
            currentStoryIndex = 0;
          });
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
    // Preload the background image
    precacheImage(const AssetImage('assets/bj/xybj5.png'), context);
    final currentNarrative = narratives[currentChapterIndex];

    // 只在第一章开始时显示前话
    if (currentStoryIndex == -1 && currentChapterIndex == 0) {
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
      body: Stack(
        children: [
          Container(
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
                        ValueListenableBuilder<int>(
                          valueListenable: Globals.manaPoints,
                          builder: (context, manaPoints, child) {
                            return Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, right: 8.0),
                                child: Text(
                                  '法力值: $manaPoints',
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
                            );
                          },
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
        ],
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
    // Check if mana points are available
    if (Globals.manaPoints.value <= 0) {
      _showManaExhaustedDialog();
      return;
    }

    // Consume one mana point
    Globals.manaPoints.value--;
    Globals.manaPoints.notifyListeners();

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

  void _showManaExhaustedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFFFD700), width: 2),
        ),
        title: const Text(
          '法力值耗尽',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          '法力值耗尽，请你及时补充法力值...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Return to the previous screen
            },
            child: const Text(
              '确定',
              style: TextStyle(
                color: Color(0xFFFFD700),
              ),
            ),
          ),
        ],
      ),
    );
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
