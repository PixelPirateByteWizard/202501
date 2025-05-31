import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math.dart' as vector;

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  final ScrollController _scrollController = ScrollController();

  // Animation controllers
  late AnimationController _animationController;
  bool _isShowingDetails = false;
  int _selectedAchievementIndex = -1;

  // For parallax effect
  double _scrollOffset = 0;

  // 成就分类
  final List<String> _categories = [
    'All',
    'Combat',
    'Cultivation',
    'Exploration',
    'Social',
    'Collection'
  ];

  // Category icons to make it more visual
  final Map<String, IconData> _categoryIcons = {
    'All': Icons.apps,
    'Combat': Icons.sports_martial_arts,
    'Cultivation': Icons.whatshot,
    'Exploration': Icons.explore,
    'Social': Icons.groups,
    'Collection': Icons.diamond,
  };

  // 所有成就列表
  final List<Map<String, dynamic>> _allAchievements = [
    // 战斗类成就
    {
      'title': 'First Cultivation Experience',
      'description': 'Started the game for the first time',
      'icon': Icons.play_circle,
      'color': Colors.blue.shade400,
      'isUnlocked': true,
      'progress': 1.0,
      'category': 'Combat',
      'reward': 'Spirit Stones x100',
    },
    {
      'title': 'Minor Accomplishment',
      'description': 'Defeated 100 enemies with sword techniques',
      'icon': Icons.sports_kabaddi,
      'color': Colors.amber.shade600,
      'isUnlocked': true,
      'progress': 0.75,
      'category': 'Combat',
      'reward': 'Sword Qi Pills x3',
    },
    {
      'title': 'Tempered Through Trials',
      'description': 'Upgraded any skill to the highest level',
      'icon': Icons.workspace_premium,
      'color': Colors.orange.shade600,
      'isUnlocked': false,
      'progress': 0.3,
      'category': 'Combat',
      'reward': 'Foundation Establishment Pill x1',
    },
    {
      'title': 'Sword Riding the Wind',
      'description': 'Cast spells 100 times in a row',
      'icon': Icons.flash_on,
      'color': Colors.purple.shade500,
      'isUnlocked': false,
      'progress': 0.5,
      'category': 'Combat',
      'reward': 'Spirit Stones x500',
    },
    {
      'title': 'Invincible Sword Cultivator',
      'description': 'Defeated 5 or more enemies simultaneously',
      'icon': Icons.sports_martial_arts,
      'color': Colors.red.shade600,
      'isUnlocked': false,
      'progress': 0.25,
      'category': 'Combat',
      'reward': 'Sword Qi Talismans x5',
    },
    {
      'title': 'Sword Qi Unleashed',
      'description': 'Completed a game as a Sword Cultivator',
      'icon': Icons.gavel,
      'color': Colors.blue.shade800,
      'isUnlocked': false,
      'progress': 0.0,
      'category': 'Combat',
      'reward': 'Sword Riding Technique x1',
    },

    // 修炼类成就
    {
      'title': 'Pill Master',
      'description': 'Completed 10 alchemy sessions',
      'icon': Icons.local_fire_department,
      'color': Colors.red.shade500,
      'isUnlocked': false,
      'progress': 0.1,
      'category': 'Cultivation',
      'reward': 'Alchemy Furnace x1',
    },
    {
      'title': 'Pill Flame Mastery',
      'description': 'Completed a game as an Alchemist',
      'icon': Icons.science,
      'color': Colors.green.shade600,
      'isUnlocked': false,
      'progress': 0.0,
      'category': 'Cultivation',
      'reward': 'Alchemy Technique x1',
    },
    {
      'title': 'Talisman Mastery',
      'description': 'Completed a game as a Talisman Cultivator',
      'icon': Icons.auto_awesome,
      'color': Colors.deepPurple.shade500,
      'isUnlocked': false,
      'progress': 0.0,
      'category': 'Cultivation',
      'reward': 'Five Elements Talismans x5',
    },
    {
      'title': 'Foundation Establishment',
      'description': 'Successfully established your foundation',
      'icon': Icons.accessibility_new,
      'color': Colors.teal.shade500,
      'isUnlocked': true,
      'progress': 1.0,
      'category': 'Cultivation',
      'reward': 'Spirit Stones x1000',
    },
    {
      'title': 'Core Formation',
      'description': 'Successfully formed your core',
      'icon': Icons.cyclone,
      'color': Colors.amber.shade800,
      'isUnlocked': false,
      'progress': 0.2,
      'category': 'Cultivation',
      'reward': 'Foundation Establishment Manual x1',
    },

    // 探索类成就
    {
      'title': 'First Exploration',
      'description': 'Explored 5 different regions',
      'icon': Icons.travel_explore,
      'color': Colors.green.shade400,
      'isUnlocked': true,
      'progress': 0.6,
      'category': 'Exploration',
      'reward': 'Spirit Stones x300',
    },
    {
      'title': 'Void Traveler',
      'description': 'Teleported over 1000 times',
      'icon': Icons.transform,
      'color': Colors.indigo.shade400,
      'isUnlocked': false,
      'progress': 0.15,
      'category': 'Exploration',
      'reward': 'Teleportation Talismans x3',
    },
    {
      'title': '寻宝达人',
      'description': '发现10件隐藏宝物',
      'icon': Icons.search,
      'color': Colors.amber.shade500,
      'isUnlocked': false,
      'progress': 0.4,
      'category': 'Exploration',
      'reward': '藏宝图 x1',
    },
    {
      'title': '秘境探险',
      'description': '发现并探索一处秘境',
      'icon': Icons.visibility,
      'color': Colors.deepPurple.shade300,
      'isUnlocked': false,
      'progress': 0.0,
      'category': 'Exploration',
      'reward': '传送符 x5',
    },

    // 社交类成就
    {
      'title': '结交道友',
      'description': '加入一个门派',
      'icon': Icons.group_add,
      'color': Colors.blue.shade300,
      'isUnlocked': true,
      'progress': 1.0,
      'category': 'Social',
      'reward': '门派贡献值 x100',
    },
    {
      'title': '声名远播',
      'description': '获得100点声望',
      'icon': Icons.public,
      'color': Colors.orange.shade300,
      'isUnlocked': false,
      'progress': 0.35,
      'category': 'Social',
      'reward': '修为丹 x2',
    },
    {
      'title': '门派精英',
      'description': '在门派中达到长老级别',
      'icon': Icons.stars,
      'color': Colors.amber.shade700,
      'isUnlocked': false,
      'progress': 0.0,
      'category': 'Social',
      'reward': 'Spirit Stones x2000',
    },

    // 收集类成就
    {
      'title': '药草收集者',
      'description': '收集30种不同的药草',
      'icon': Icons.eco,
      'color': Colors.green.shade500,
      'isUnlocked': false,
      'progress': 0.25,
      'category': 'Collection',
      'reward': '百草丹方 x1',
    },
    {
      'title': '武器专家',
      'description': '收集10种不同的武器',
      'icon': Icons.shield,
      'color': Colors.blueGrey.shade600,
      'isUnlocked': false,
      'progress': 0.5,
      'category': 'Collection',
      'reward': '神兵图谱 x1',
    },
    {
      'title': '灵宝收藏家',
      'description': '收集5件灵宝',
      'icon': Icons.diamond,
      'color': Colors.pink.shade400,
      'isUnlocked': false,
      'progress': 0.2,
      'category': 'Collection',
      'reward': '洗髓丹 x1',
    },

    // 终极成就
    {
      'title': '开天辟地',
      'description': '达到第50波',
      'icon': Icons.landscape,
      'color': Colors.cyan.shade600,
      'isUnlocked': false,
      'progress': 0.0,
      'category': 'Combat',
      'reward': '天地玄黄符 x1',
    },
    {
      'title': '逆天成仙',
      'description': '完成所有成就',
      'icon': Icons.celebration,
      'color': Colors.amber.shade900,
      'isUnlocked': false,
      'progress': 0.0,
      'category': 'Cultivation',
      'reward': '羽化登仙丹 x1',
    },
    {
      'title': '道法自然',
      'description': '领悟所有天赋技能',
      'icon': Icons.light_mode,
      'color': Colors.yellow.shade700,
      'isUnlocked': false,
      'progress': 0.05,
      'category': 'Cultivation',
      'reward': '悟道茶 x3',
    },
  ];

  // 当前显示的成就列表
  List<Map<String, dynamic>> _filteredAchievements = [];
  Map<String, dynamic>? _selectedAchievement;

  // Track completion stats per category
  Map<String, int> _categoryCompletionCount = {};
  Map<String, double> _categoryProgress = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _pageController = PageController(viewportFraction: 0.85);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    _filteredAchievements = _allAchievements;
    _calculateCategoryStats();

    // Add haptic feedback on page transition
    _pageController.addListener(() {
      if (_pageController.page?.round() != _pageController.page) {
        HapticFeedback.lightImpact();
      }
    });

    // Play entrance animation
    Future.delayed(const Duration(milliseconds: 100), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculateCategoryStats() {
    // Initialize counts and progress for all categories
    for (final category in _categories) {
      if (category == 'All') continue;

      final categoryAchievements =
          _allAchievements.where((a) => a['category'] == category).toList();

      final unlockedCount =
          categoryAchievements.where((a) => a['isUnlocked'] == true).length;

      _categoryCompletionCount[category] = unlockedCount;
      _categoryProgress[category] = categoryAchievements.isEmpty
          ? 0.0
          : unlockedCount / categoryAchievements.length;
    }
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        if (_tabController.index == 0) {
          _filteredAchievements = _allAchievements;
        } else {
          final category = _categories[_tabController.index];
          _filteredAchievements = _allAchievements
              .where((achievement) => achievement['category'] == category)
              .toList();
        }

        // Reset selected achievement when changing tabs
        _selectedAchievementIndex = -1;
        _isShowingDetails = false;
      });
    }
  }

  int get _unlockedCount =>
      _allAchievements.where((a) => a['isUnlocked']).length;
  double get _overallProgress => _unlockedCount / _allAchievements.length;

  void _selectAchievement(int index) {
    setState(() {
      if (_selectedAchievementIndex == index && _isShowingDetails) {
        // Deselect if tapping the same one again
        _selectedAchievementIndex = -1;
        _isShowingDetails = false;
        _selectedAchievement = null;
      } else {
        _selectedAchievementIndex = index;
        _isShowingDetails = true;
        _selectedAchievement = _filteredAchievements[index];

        // Ensure the selected item is visible
        if (_scrollController.hasClients) {
          final itemPosition = index * 160.0; // Approximate height
          final screenHeight = MediaQuery.of(context).size.height;
          final scrollOffset = _scrollController.offset;

          if (itemPosition < scrollOffset ||
              itemPosition > scrollOffset + screenHeight - 300) {
            _scrollController.animateTo(math.max(0, itemPosition - 50),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Animated background with parallax effect
          _buildAnimatedBackground(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildProgressIndicator(),
                _buildCategoryTabs(),
                Expanded(
                  child: _buildAchievementsList(),
                ),
              ],
            ),
          ),

          // Details overlay with hero animation
          if (_isShowingDetails && _selectedAchievement != null)
            _buildDetailsOverlay(_selectedAchievement!),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Base background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/backgrounds/backgrounds_7.png',
            fit: BoxFit.cover,
          ),
        ),

        // Animated overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.purple.withOpacity(0.1),
                  Colors.indigo.withOpacity(0.2),
                ],
              ),
            ),
          ),
        ),

        // Animated particles
        Positioned.fill(
          child: AnimatedParticles(
            scrollOffset: _scrollOffset,
          ),
        ),

        // Vignette effect
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                stops: const [0.7, 1.0],
                radius: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final Animation<double> fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
    ));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Custom back button with ripple effect
                  _buildCustomBackButton(),
                  const SizedBox(width: 12),
                  const Text(
                    'Hall of Achievements',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _buildAchievementCounter(),
                ],
              ),

              const SizedBox(height: 8),

              // Inspirational quote that changes randomly
              Text(
                '"The path is found through perseverance, and the body is refined through cultivation."',
                style: TextStyle(
                  color: Colors.amber.shade100,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(30),
        splashColor: Colors.white.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.7),
            Colors.orange.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '$_unlockedCount/${_allAchievements.length}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final Animation<double> fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    );

    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
    ));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.black.withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.insights,
                        color: Colors.amber.shade300,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Cultivation Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          _getProgressColor(_overallProgress).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _getProgressColor(_overallProgress),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${(_overallProgress * 100).toInt()}%',
                      style: TextStyle(
                        color: _getProgressColor(_overallProgress),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Customized progress bar
              Stack(
                children: [
                  // Background
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  // Progress fill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutQuart,
                    height: 12,
                    width: MediaQuery.of(context).size.width *
                        _overallProgress *
                        0.8, // Account for padding
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getProgressColor(_overallProgress),
                          _getProgressColor(_overallProgress).withOpacity(0.7),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: _getProgressColor(_overallProgress)
                              .withOpacity(0.5),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),

                  // Glow effect
                  if (_overallProgress > 0)
                    Positioned(
                      left: MediaQuery.of(context).size.width *
                              _overallProgress *
                              0.8 -
                          10,
                      top: 0,
                      child: Container(
                        height: 12,
                        width: 20,
                        decoration: BoxDecoration(
                          color: _getProgressColor(_overallProgress)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: _getProgressColor(_overallProgress)
                                  .withOpacity(0.8),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Category progress indicators
              SizedBox(
                height: 64,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length - 1, // Skip "All"
                  itemBuilder: (context, index) {
                    final category = _categories[index + 1]; // Skip "All"
                    final progress = _categoryProgress[category] ?? 0.0;
                    final completedCount =
                        _categoryCompletionCount[category] ?? 0;
                    final totalCount = _allAchievements
                        .where((a) => a['category'] == category)
                        .length;

                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _getProgressColor(progress).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _categoryIcons[category] ?? Icons.circle,
                                color: _getProgressColor(progress),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                category,
                                style: TextStyle(
                                  color: _getProgressColor(progress),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor:
                                  Colors.grey.shade800.withOpacity(0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getProgressColor(progress),
                              ),
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '$completedCount/$totalCount',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress <= 0.25) {
      return Colors.red.shade400;
    } else if (progress <= 0.5) {
      return Colors.orange.shade400;
    } else if (progress <= 0.75) {
      return Colors.amber.shade400;
    } else {
      return Colors.green.shade400;
    }
  }

  Widget _buildCategoryTabs() {
    final Animation<double> fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
    );

    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.9, curve: Curves.easeOutCubic),
    ));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          height: 70,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Colors.amber,
            indicatorWeight: 0, // Custom indicator below
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            indicator: BoxDecoration(
              // Custom indicator
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade700,
                  Colors.amber.shade500,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            tabs: List.generate(_categories.length, (index) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    if (_tabController.index == index)
                      BoxShadow(
                        color: Colors.amber.shade700.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _categoryIcons[_categories[index]] ?? Icons.circle,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _categories[index],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementsList() {
    if (_filteredAchievements.isEmpty) {
      return const Center(
        child: Text(
          '此分类暂无成就',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    final Animation<double> fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 16, bottom: 100),
          itemCount: _filteredAchievements.length,
          itemBuilder: (context, index) {
            // Staggered animation for items
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final itemAnimation = Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      0.6 + (index / _filteredAchievements.length) * 0.4,
                      1.0,
                      curve: Curves.easeOutQuart,
                    ),
                  ),
                );

                return Transform.translate(
                  offset: Offset(
                    100 * (1.0 - itemAnimation.value),
                    0,
                  ),
                  child: Opacity(
                    opacity: itemAnimation.value,
                    child: child,
                  ),
                );
              },
              child: _buildEnhancedAchievementCard(
                _filteredAchievements[index],
                index,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEnhancedAchievementCard(
      Map<String, dynamic> achievement, int index) {
    final isUnlocked = achievement['isUnlocked'] as bool;
    final progress = achievement['progress'] as double;
    final Color color = achievement['color'] as Color;
    final bool isSelected = index == _selectedAchievementIndex;

    return GestureDetector(
      onTap: () => _selectAchievement(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 130, // Increased from 124 to accommodate content
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              isUnlocked
                  ? color.withOpacity(0.3)
                  : Colors.grey.shade900.withOpacity(0.8),
              Colors.black.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: isUnlocked
                  ? color.withOpacity(0.4)
                  : Colors.black.withOpacity(0.3),
              blurRadius: isSelected ? 15 : 8,
              offset: const Offset(0, 5),
              spreadRadius: isSelected ? 1 : 0,
            ),
          ],
          border: Border.all(
            color: isSelected
                ? color
                : isUnlocked
                    ? color.withOpacity(0.5)
                    : Colors.grey.shade800.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: isUnlocked ? 0 : 2,
              sigmaY: isUnlocked ? 0 : 2,
            ),
            child: Stack(
              children: [
                // Background particle effect for unlocked achievements
                if (isUnlocked)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ParticlePainter(
                        color: color.withOpacity(0.2),
                        particleCount: 10,
                      ),
                    ),
                  ),

                // Main content
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12), // Reduced vertical padding
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Achievement icon with glow
                      _buildAchievementIcon(achievement, isUnlocked, color),
                      const SizedBox(width: 12), // Reduced from 16

                      // Achievement details
                      Expanded(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title and category
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      achievement['title'] as String,
                                      style: TextStyle(
                                        color: isUnlocked
                                            ? Colors.white
                                            : Colors.grey.shade400,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16, // Reduced from 17
                                        letterSpacing: 0.5,
                                        shadows: [
                                          if (isUnlocked)
                                            Shadow(
                                              color: color.withOpacity(0.7),
                                              blurRadius: 5,
                                              offset: const Offset(0, 1),
                                            ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),

                                  // Achievement status icon
                                  Container(
                                    padding: const EdgeInsets.all(
                                        3), // Reduced from 4
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black45,
                                    ),
                                    child: Icon(
                                      !isUnlocked
                                          ? Icons.lock
                                          : progress >= 1.0
                                              ? Icons.check_circle
                                              : Icons.pending,
                                      color: !isUnlocked
                                          ? Colors.grey.shade500
                                          : progress >= 1.0
                                              ? Colors.green
                                              : Colors.amber,
                                      size: 14, // Reduced from 16
                                    ),
                                  ),
                                ],
                              ),

                              // Badge for category
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 1, bottom: 3), // Reduced from 2, 4
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 1, // Reduced from 2
                                ),
                                decoration: BoxDecoration(
                                  color: isUnlocked
                                      ? color.withOpacity(0.2)
                                      : Colors.grey.shade800.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isUnlocked
                                        ? color.withOpacity(0.4)
                                        : Colors.grey.shade700.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _categoryIcons[achievement['category']] ??
                                          Icons.circle,
                                      color: isUnlocked
                                          ? color
                                          : Colors.grey.shade600,
                                      size: 10, // Reduced from 12
                                    ),
                                    const SizedBox(width: 3), // Reduced from 4
                                    Text(
                                      achievement['category'] as String,
                                      style: TextStyle(
                                        color: isUnlocked
                                            ? color
                                            : Colors.grey.shade600,
                                        fontSize: 10, // Reduced from 11
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Description
                              SizedBox(
                                height: 28, // Reduced from 30
                                child: Text(
                                  achievement['description'] as String,
                                  style: TextStyle(
                                    color: isUnlocked
                                        ? Colors.white.withOpacity(0.8)
                                        : Colors.grey.shade600,
                                    fontSize: 11, // Reduced from 12
                                    height: 1.1, // Reduced from 1.2
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              const SizedBox(height: 4), // Reduced from 5

                              // Progress bar
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        // Background
                                        Container(
                                          height: 6, // Reduced from 8
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade900
                                                .withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(
                                                3), // Reduced from 4
                                          ),
                                        ),

                                        // Fill
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 800),
                                          height: 6, // Reduced from 8
                                          width:
                                              constraints.maxWidth * progress,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                isUnlocked
                                                    ? color.withOpacity(0.7)
                                                    : Colors.grey.shade600,
                                                isUnlocked
                                                    ? color
                                                    : Colors.grey.shade700,
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                3), // Reduced from 4
                                            boxShadow: [
                                              if (isUnlocked)
                                                BoxShadow(
                                                  color: color.withOpacity(0.4),
                                                  blurRadius:
                                                      3, // Reduced from 4
                                                  offset: const Offset(0,
                                                      1), // Reduced from (0, 2)
                                                ),
                                            ],
                                          ),
                                        ),

                                        // Shimmer effect on progress bar
                                        if (isUnlocked && progress > 0)
                                          Positioned(
                                            top: 0,
                                            child: ShimmerEffect(
                                              width: constraints.maxWidth *
                                                  progress,
                                              height: 6, // Reduced from 8
                                              color: color,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 6), // Reduced from 8

                                  // Progress percentage
                                  Text(
                                    '${(progress * 100).toInt()}%',
                                    style: TextStyle(
                                      color: isUnlocked
                                          ? color
                                          : Colors.grey.shade600,
                                      fontSize: 10, // Reduced from 12
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // Reward preview overlay
                if (isUnlocked)
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.amber.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.card_giftcard,
                            color: Colors.amber,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            achievement['reward'] as String,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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

  Widget _buildAchievementIcon(
      Map<String, dynamic> achievement, bool isUnlocked, Color color) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            isUnlocked
                ? color.withOpacity(0.7)
                : Colors.grey.shade800.withOpacity(0.7),
            isUnlocked
                ? color.withOpacity(0.3)
                : Colors.grey.shade900.withOpacity(0.3),
          ],
          stops: const [0.2, 1.0],
        ),
        boxShadow: [
          if (isUnlocked)
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 15,
              spreadRadius: 1,
            ),
        ],
        border: Border.all(
          color: isUnlocked
              ? color.withOpacity(0.7)
              : Colors.grey.shade700.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(
          achievement['icon'] as IconData,
          color: isUnlocked ? Colors.white : Colors.grey.shade500,
          size: 26,
        ),
      ),
    );
  }

  Widget _buildDetailsOverlay(Map<String, dynamic> achievement) {
    final isUnlocked = achievement['isUnlocked'] as bool;
    final progress = achievement['progress'] as double;
    final color = achievement['color'] as Color;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isShowingDetails = false;
          _selectedAchievementIndex = -1;
          _selectedAchievement = null;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            child: Center(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                tween: Tween<double>(begin: 0.8, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                    maxWidth: MediaQuery.of(context).size.width - 48,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: isUnlocked
                            ? color.withOpacity(0.5)
                            : Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(
                      color: isUnlocked ? color : Colors.grey.shade800,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with curved design
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                isUnlocked
                                    ? color.withOpacity(0.8)
                                    : Colors.grey.shade900.withOpacity(0.8),
                                isUnlocked
                                    ? color.withOpacity(0.2)
                                    : Colors.grey.shade900.withOpacity(0.2),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Particle effect background for unlocked achievements
                              if (isUnlocked)
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: ParticlePainter(
                                      color: Colors.white.withOpacity(0.2),
                                      particleCount: 30,
                                      speed: 0.5,
                                    ),
                                  ),
                                ),

                              // Achievement icon
                              Center(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        isUnlocked
                                            ? Colors.white.withOpacity(0.9)
                                            : Colors.grey.shade200
                                                .withOpacity(0.1),
                                        isUnlocked
                                            ? color.withOpacity(0.7)
                                            : Colors.grey.shade700
                                                .withOpacity(0.3),
                                      ],
                                      stops: const [0.3, 1.0],
                                    ),
                                    boxShadow: [
                                      if (isUnlocked)
                                        BoxShadow(
                                          color: color.withOpacity(0.8),
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        ),
                                    ],
                                    border: Border.all(
                                      color: isUnlocked
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.grey.shade700
                                              .withOpacity(0.5),
                                      width: 3,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      achievement['icon'] as IconData,
                                      color: isUnlocked
                                          ? Colors.white
                                          : Colors.grey.shade500,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),

                              // Close button
                              Positioned(
                                top: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isShowingDetails = false;
                                      _selectedAchievementIndex = -1;
                                      _selectedAchievement = null;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.5),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),

                              // Lock icon for locked achievements
                              if (!isUnlocked)
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.5),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Content
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title
                              Text(
                                achievement['title'] as String,
                                style: TextStyle(
                                  color: isUnlocked
                                      ? Colors.white
                                      : Colors.grey.shade400,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    if (isUnlocked)
                                      Shadow(
                                        color: color.withOpacity(0.7),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 6),

                              // Category badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: isUnlocked
                                      ? color.withOpacity(0.2)
                                      : Colors.grey.shade800.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isUnlocked
                                        ? color.withOpacity(0.4)
                                        : Colors.grey.shade700.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _categoryIcons[achievement['category']] ??
                                          Icons.circle,
                                      color: isUnlocked
                                          ? color
                                          : Colors.grey.shade600,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      achievement['category'] as String,
                                      style: TextStyle(
                                        color: isUnlocked
                                            ? color
                                            : Colors.grey.shade600,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Description with scroll effect
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color:
                                        Colors.grey.shade800.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  achievement['description'] as String,
                                  style: TextStyle(
                                    color: isUnlocked
                                        ? Colors.white.withOpacity(0.9)
                                        : Colors.grey.shade500,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Reward section
                              if (achievement['reward'] != null) ...[
                                Text(
                                  'Achievement Reward',
                                  style: TextStyle(
                                    color: Colors.amber.shade300,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.amber.withOpacity(0.3),
                                        Colors.amber.withOpacity(0.1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.amber.withOpacity(0.5),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amber.withOpacity(0.2),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.card_giftcard,
                                        color: isUnlocked
                                            ? Colors.amber
                                            : Colors.grey.shade600,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        achievement['reward'] as String,
                                        style: TextStyle(
                                          color: isUnlocked
                                              ? Colors.amber
                                              : Colors.grey.shade600,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Progress section
                              Text(
                                'Completion Progress',
                                style: TextStyle(
                                  color: isUnlocked
                                      ? Colors.white70
                                      : Colors.grey.shade600,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  // Progress bar background
                                  Container(
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade900,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),

                                  // Progress bar fill
                                  AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    curve: Curves.easeOutQuart,
                                    height: 16,
                                    width: MediaQuery.of(context).size.width *
                                        progress *
                                        0.7,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          isUnlocked
                                              ? color.withOpacity(0.7)
                                              : Colors.grey.shade700,
                                          isUnlocked
                                              ? color
                                              : Colors.grey.shade600,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        if (isUnlocked)
                                          BoxShadow(
                                            color: color.withOpacity(0.4),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Glow effect
                                  if (isUnlocked && progress > 0)
                                    Positioned(
                                      left: MediaQuery.of(context).size.width *
                                              progress *
                                              0.7 -
                                          10,
                                      top: 0,
                                      child: Container(
                                        height: 16,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: color.withOpacity(0.8),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Progress: ${(progress * 100).toInt()}%',
                                style: TextStyle(
                                  color: isUnlocked
                                      ? Colors.white70
                                      : Colors.grey.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isShowingDetails = false;
                                    _selectedAchievementIndex = -1;
                                    _selectedAchievement = null;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isUnlocked ? color : Colors.grey.shade800,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 10,
                                  ),
                                  elevation: 8,
                                  shadowColor: isUnlocked
                                      ? color.withOpacity(0.5)
                                      : Colors.transparent,
                                ),
                                child: const Text(
                                  'Close',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(Map<String, dynamic> achievement) {
    setState(() {
      _selectedAchievement = achievement;
      _isShowingDetails = true;
      _selectedAchievementIndex = _filteredAchievements.indexOf(achievement);
    });
  }
}

// Custom animation components
class AnimatedParticles extends StatefulWidget {
  final double scrollOffset;

  const AnimatedParticles({
    Key? key,
    required this.scrollOffset,
  }) : super(key: key);

  @override
  State<AnimatedParticles> createState() => _AnimatedParticlesState();
}

class _AnimatedParticlesState extends State<AnimatedParticles>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: BackgroundParticlePainter(
            animation: _controller,
            scrollOffset: widget.scrollOffset,
          ),
        );
      },
    );
  }
}

class BackgroundParticlePainter extends CustomPainter {
  final Animation<double> animation;
  final double scrollOffset;
  final List<ParticleModel> particles = [];

  BackgroundParticlePainter({
    required this.animation,
    required this.scrollOffset,
  }) {
    if (particles.isEmpty) {
      _initParticles();
    }
  }

  void _initParticles() {
    for (int i = 0; i < 40; i++) {
      particles.add(ParticleModel(
        x: math.Random().nextDouble() * 1.2 - 0.1,
        y: math.Random().nextDouble() * 1.2 - 0.1,
        size: math.Random().nextDouble() * 4 + 1,
        color: [
          Colors.white.withOpacity(0.1 + math.Random().nextDouble() * 0.1),
          Colors.amber.withOpacity(0.1 + math.Random().nextDouble() * 0.1),
          Colors.purple.withOpacity(0.1 + math.Random().nextDouble() * 0.1),
        ][math.Random().nextInt(3)],
        speed: math.Random().nextDouble() * 0.02 + 0.01,
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final parallaxOffset = scrollOffset * 0.05;

    for (int i = 0; i < particles.length; i++) {
      final particle = particles[i];

      // Update position with animation
      final x = (particle.x + animation.value * particle.speed) % 1.0;
      final y = (particle.y + animation.value * particle.speed / 2) % 1.0 -
          parallaxOffset * particle.speed * 10;

      // Draw particle
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        particle.size,
        Paint()..color = particle.color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundParticlePainter oldDelegate) {
    return true;
  }
}

class ParticleModel {
  double x;
  double y;
  double size;
  Color color;
  double speed;

  ParticleModel({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
  });
}

class ParticlePainter extends CustomPainter {
  final Color color;
  final int particleCount;
  final double speed;

  ParticlePainter({
    required this.color,
    this.particleCount = 20,
    this.speed = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent pattern

    for (int i = 0; i < particleCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 + 1;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = color.withOpacity(random.nextDouble() * 0.5 + 0.1),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ShimmerEffect extends StatefulWidget {
  final double width;
  final double height;
  final Color color;

  const ShimmerEffect({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
  }) : super(key: key);

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: ShimmerPainter(
            animation: _controller,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class ShimmerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  ShimmerPainter({
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double shimmerWidth = size.width * 0.3;
    final double startX =
        -shimmerWidth + animation.value * (size.width + shimmerWidth * 2);

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color.withOpacity(0.5),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(
        Rect.fromLTWH(startX, 0, shimmerWidth, size.height),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ShimmerPainter oldDelegate) {
    return true;
  }
}
