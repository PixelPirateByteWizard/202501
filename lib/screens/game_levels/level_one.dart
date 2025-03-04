import 'package:flutter/material.dart';
import '../../services/ai_service.dart';
import '../../models/story.dart';
import '../../models/chapter_narrative.dart';
import '../../screens/level_select_screen.dart';
import 'dart:async';
import '../../globals.dart';
import '../../data/story_data.dart';

class LevelOne extends StatefulWidget {
  final int levelId;
  final ChapterNarrative? customNarrative;

  const LevelOne({
    super.key,
    required this.levelId,
    this.customNarrative,
  });

  @override
  State<LevelOne> createState() => _LevelOneState();
}

class _LevelOneState extends State<LevelOne>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isLoading = false;
  bool showingReview = false;
  int currentChapterIndex = 0;
  int currentStoryIndex = 0;
  int correctChoices = 0;
  List<Story>? aiGeneratedStories;

  final Map<int, int> chapterStoryCounts = {
    0: 5, // 第一章节需要5个故事
  };

  // 添加背景图片控制
  int _currentBgIndex = 0;
  final List<String> _backgroundImages = [
    'assets/bj/xybj1.png',
    'assets/bj/xybj2.png',
    'assets/bj/xybj3.png',
    'assets/bj/xybj4.png',
    'assets/bj/xybj5.png',
    'assets/bj/xybj6.png',
    'assets/bj/xybj7.png',
  ];
  Timer? _bgTimer;

  bool _didInitialize = false; // 添加初始化标记

  late final List<ChapterNarrative> narratives;

  @override
  void initState() {
    super.initState();
    narratives = widget.customNarrative != null
        ? [widget.customNarrative!]
        : StoryData.levelNarratives[widget.levelId] ?? [];

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.forward();
    _startBackgroundTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitialize) {
      // 在这里预加载图片
      for (var image in _backgroundImages) {
        precacheImage(AssetImage(image), context);
      }
      _didInitialize = true;
    }
  }

  void _startBackgroundTimer() {
    _bgTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentBgIndex = (_currentBgIndex + 1) % _backgroundImages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _bgTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _showManaExhaustedDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('灵力不足'),
        content: const Text('你的灵力点数已耗尽，需要休息恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void onOptionSelected(bool isCorrect) async {
    if (Globals.manaPoints.value <= 0) {
      await _showManaExhaustedDialog();
      return;
    }

    Globals.manaPoints.value--;
    Globals.manaPoints.notifyListeners();

    if (isCorrect) {
      correctChoices++;
    }

    await _animationController.reverse();

    if (!mounted) return;

    final currentNarrative = narratives[currentChapterIndex];
    final totalStories = chapterStoryCounts[currentChapterIndex] ?? 0;

    if (currentStoryIndex < totalStories - 1) {
      setState(() {
        currentStoryIndex++;
        isLoading = true;
      });

      try {
        if (currentStoryIndex >= currentNarrative.initialStories.length) {
          final story = await AIService.generateSingleStory(
            currentNarrative.title,
            [
              ...currentNarrative.initialStories,
              if (aiGeneratedStories != null) ...aiGeneratedStories!
            ],
            currentStoryIndex - currentNarrative.initialStories.length,
            totalStories - currentNarrative.initialStories.length,
          );

          if (!mounted) return;

          setState(() {
            aiGeneratedStories ??= [];
            aiGeneratedStories!.add(story);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error generating next story: $e');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      setState(() {
        showingReview = true;
      });
    }

    await _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final currentNarrative = narratives[currentChapterIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundImages[_currentBgIndex]),
            fit: BoxFit.cover,
            colorFilter: const ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(currentNarrative),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: showingReview
                      ? _buildReviewScreen(currentNarrative)
                      : _buildStoryScreen(currentNarrative),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(ChapterNarrative narrative) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.3),
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.amber),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              narrative.title,
              style: const TextStyle(
                fontSize: 24,
                fontFamily: 'ZHSGuFeng',
                color: Colors.amber,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // 平衡布局
        ],
      ),
    );
  }

  Widget _buildStoryScreen(ChapterNarrative narrative) {
    Story? currentStory;
    if (currentStoryIndex < narrative.initialStories.length) {
      currentStory = narrative.initialStories[currentStoryIndex];
    } else if (aiGeneratedStories != null) {
      final aiIndex = currentStoryIndex - narrative.initialStories.length;
      if (aiIndex < aiGeneratedStories!.length) {
        currentStory = aiGeneratedStories![aiIndex];
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.amber.shade200.withOpacity(0.8),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0x4D3A2418),
            const Color(0x802C1810),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Text(
                currentStory?.content ?? "加载中...",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'ZHSGuFeng',
                  color: Colors.amber.shade100,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (!isLoading && currentStory != null)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: currentStory.options.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.withOpacity(0.3),
                        foregroundColor: Colors.amber.shade200,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.amber.shade200.withOpacity(0.5),
                          ),
                        ),
                      ),
                      onPressed: () => onOptionSelected(
                        entry.key == currentStory!.correctOption,
                      ),
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'ZHSGuFeng',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewScreen(ChapterNarrative narrative) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.amber.shade200.withOpacity(0.8),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x4D3A2418),
            Color(0x802C1810),
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                narrative.review,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'ZHSGuFeng',
                  color: Colors.amber.shade100,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.withOpacity(0.3),
              foregroundColor: Colors.amber.shade200,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.amber.shade200.withOpacity(0.5),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LevelSelectScreen(),
                ),
              );
            },
            child: const Text(
              '返回关卡选择',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'ZHSGuFeng',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
