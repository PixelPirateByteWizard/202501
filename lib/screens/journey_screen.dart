import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/stage.dart';
import '../services/game_data_service.dart';
import 'battle_screen.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  List<Stage> _stages = [];
  int _currentChapter = 1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStages();
  }

  Future<void> _loadStages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stages = await GameDataService.getStages();
      print('Loaded ${stages.length} stages'); // 调试信息
      setState(() {
        _stages = stages;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading stages: $e'); // 调试信息
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载关卡失败: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  List<Stage> get _currentChapterStages {
    return _stages.where((stage) => stage.chapter == _currentChapter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg/BG_3.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppTheme.primaryGold),
                )
              : Column(
                  children: [
                    _buildHeader(),
                    _buildChapterInfo(),
                    Expanded(child: _buildStagesList()),
                  ],
                ),
        ),
      ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppTheme.primaryGold),
                  ),
              const SizedBox(width: 16),
              const Text(
            '征程',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          ),
    );
  }

  Widget _buildChapterInfo() {
    final completedStages = _currentChapterStages
        .where((stage) => stage.status == StageStatus.completed)
        .length;
    final totalStages = _currentChapterStages.length;
    final progress = totalStages > 0 ? completedStages / totalStages : 0.0;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _currentChapter > 1
                        ? () => _changeChapter(_currentChapter - 1)
                        : null,
                    icon: const Icon(Icons.chevron_left),
                    color: AppTheme.primaryGold,
          ),
                  Text(
                    '第$_currentChapter章',
                    style: const TextStyle(
                      color: AppTheme.primaryGold,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _hasNextChapter()
                        ? () => _changeChapter(_currentChapter + 1)
                        : null,
                    icon: const Icon(Icons.chevron_right),
                    color: AppTheme.primaryGold,
                  ),
                ],
              ),
              Text(
                '$completedStages/$totalStages',
                style: const TextStyle(color: AppTheme.textLight, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.cardBackgroundDark.withOpacity(0.8),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: AppTheme.goldGradient.copyWith(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Chapter Story
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBackgroundDark.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.book, color: AppTheme.primaryGold, size: 16),
                    SizedBox(width: 8),
                    Text(
                      '章节背景',
                      style: TextStyle(
                        color: AppTheme.primaryGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getChapterStory(_currentChapter),
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStagesList() {
    if (_currentChapterStages.isEmpty) {
      return const Center(
        child: Text(
          '该章节暂无关卡',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
        ),
      );
  }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _currentChapterStages.length,
      itemBuilder: (context, index) {
        final stage = _currentChapterStages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildStageCard(stage),
        );
      },
    );
  }

  Widget _buildStageCard(Stage stage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration.copyWith(
        color: stage.status == StageStatus.completed
            ? Colors.green.withOpacity(0.2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Status Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: _getStatusGradient(stage.status),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getStatusIcon(stage.status),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),

              // Stage Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stage.name,
                      style: const TextStyle(
                        color: AppTheme.primaryGold,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        stage.difficulty,
                        (index) => const Icon(
                          Icons.star,
                          color: AppTheme.primaryGold,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            stage.description,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Enemies
          Row(
            children: [
              const Text(
                '敌军: ',
                style: TextStyle(color: AppTheme.textLight, fontSize: 12),
              ),
              ...stage.enemies.map(
                (enemy) => Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      enemy[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: stage.status == StageStatus.locked
                  ? null
                  : () => _startBattle(stage),
              style: ElevatedButton.styleFrom(
                backgroundColor: stage.status == StageStatus.locked
                    ? Colors.grey
                    : AppTheme.primaryGold,
                foregroundColor: stage.status == StageStatus.locked
                    ? Colors.grey[600]
                    : AppTheme.darkBlue,
              ),
              child: Text(
                stage.status == StageStatus.completed
                    ? '重新挑战'
                    : stage.status == StageStatus.unlocked
                    ? '开始战斗'
                    : '未解锁',
              ),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getStatusGradient(StageStatus status) {
    switch (status) {
      case StageStatus.completed:
        return const LinearGradient(colors: [Colors.green, Colors.lightGreen]);
      case StageStatus.unlocked:
        return const LinearGradient(
          colors: [AppTheme.primaryGold, AppTheme.lightGold],
        );
      case StageStatus.locked:
        return const LinearGradient(colors: [Colors.grey, Colors.grey]);
    }
  }

  IconData _getStatusIcon(StageStatus status) {
    switch (status) {
      case StageStatus.completed:
        return Icons.check;
      case StageStatus.unlocked:
        return Icons.play_arrow;
      case StageStatus.locked:
        return Icons.lock;
    }
  }

  String _getChapterStory(int chapter) {
    switch (chapter) {
      case 1:
        return '东汉末年，天下大乱。黄巾起义席卷天下，各地豪杰纷纷起兵。刘备、关羽、张飞三人桃园结义，立志匡扶汉室，开始了他们的传奇征程。';
      case 2:
        return '董卓专权，祸乱朝纲。曹操挟天子以令诸侯，孙权据江东之地，刘备得诸葛亮辅佐。三足鼎立之势渐成，天下英雄各显神通。';
      case 3:
        return '三国鼎立，各据一方。关羽威震华夏却败走麦城，刘备为报仇伐吴却败于夷陵。英雄迟暮，时代更迭，新的格局正在形成。';
      case 4:
        return '蜀汉丞相诸葛亮六出祁山，北伐中原，欲恢复汉室。然天不假年，孔明病逝五丈原，蜀汉从此走向衰落。';
      case 5:
        return '司马氏专权，魏蜀吴三国相继灭亡。西晋建立，天下重归一统。三国时代落下帷幕，历史翻开新的篇章。';
      default:
        return '未知的征程等待着你...';
    }
  }

  void _startBattle(Stage stage) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BattleScreen(stage: stage)),
    );

    // 如果战斗完成，刷新关卡列表
    if (result == true) {
      await _loadStages();

      // 显示关卡完成提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('恭喜完成关卡：${stage.name}！'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _changeChapter(int chapter) {
    setState(() {
      _currentChapter = chapter;
    });
  }

  bool _hasNextChapter() {
    if (_stages.isEmpty) return false;

    try {
      final chapters = _stages.map((stage) => stage.chapter).toSet();
      if (chapters.isEmpty) return false;

      final maxChapter = chapters.reduce((a, b) => a > b ? a : b);
      return _currentChapter < maxChapter;
    } catch (e) {
      print('Error in _hasNextChapter: $e');
      return false;
    }
  }
}
