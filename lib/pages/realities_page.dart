import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:math' as math;
import '../models/reality_model.dart';
import '../utils/navigation.dart';
import '../utils/enhanced_cartoon_ui.dart';
import 'reality_detail_page.dart';

// 透明图片的字节数据 - 用作头像FadeInImage的占位符
final Uint8List kTransparentImage = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
]);

class RealitiesPage extends StatefulWidget {
  const RealitiesPage({super.key});

  @override
  State<RealitiesPage> createState() => _RealitiesPageState();
}

class _RealitiesPageState extends State<RealitiesPage> {
  // 搜索和筛选状态
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = '全部';
  
  // 分类列表
  final List<String> _categories = [
    '全部', '艺术家', '工程师', '探索者', '思想家', '创造者'
  ];

  // 科幻风格头像URL列表
  final List<String> _scifiAvatars = [
    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200',
    'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?q=80&w=200',
    'https://images.unsplash.com/photo-1546961329-78bef0414d7c?q=80&w=200',
    'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200',
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=200',
    'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?q=80&w=200',
    'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?q=80&w=200',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200',
    'https://images.unsplash.com/photo-1614283233556-f35b0c801ef1?q=80&w=200',
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=200',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
    'https://images.unsplash.com/photo-1521119989659-a83eee488004?q=80&w=200',
    'https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?q=80&w=200',
    'https://images.unsplash.com/photo-1522556189639-b150ed9c4330?q=80&w=200',
    'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?q=80&w=200',
    'https://images.unsplash.com/photo-1499996860823-5214fcc65f8f?q=80&w=200',
    'https://images.unsplash.com/photo-1548142813-c348350df52b?q=80&w=200',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200',
    'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?q=80&w=200',
    'https://images.unsplash.com/photo-1528892952291-009c663ce843?q=80&w=200',
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=200',
    'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=200',
    'https://images.unsplash.com/photo-1502323777036-f29e3972f5ea?q=80&w=200',
    'https://images.unsplash.com/photo-1504257432389-52343af06ae3?q=80&w=200',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=200',
    'https://images.unsplash.com/photo-1541647376583-8934aaf3448a?q=80&w=200',
    'https://images.unsplash.com/photo-1554151228-14d9def656e4?q=80&w=200',
    'https://images.unsplash.com/photo-1504593811423-6dd665756598?q=80&w=200',
    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=200',
    'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=200',
  ];

  // 模拟平行时空数据
  late List<Reality> _realities;
  late List<Reality> _filteredRealities;
  bool _imagesPreloaded = false;
  
  // 为每个角色生成随机渐变色
  late List<List<Color>> _gradientColors;

  @override
  void initState() {
    super.initState();
    _initializeRealities();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterRealities();
    });
  }

  void _filterRealities() {
    _filteredRealities = _realities.where((reality) {
      final matchesSearch = reality.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          reality.description.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == '全部' || 
          _getCategoryForReality(reality.name) == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  String _getCategoryForReality(String name) {
    if (name.contains('艺术') || name.contains('诗人') || name.contains('魔术师') || name.contains('雕塑')) {
      return '艺术家';
    } else if (name.contains('工程师') || name.contains('编织') || name.contains('建筑师') || name.contains('数学')) {
      return '工程师';
    } else if (name.contains('旅行') || name.contains('探索') || name.contains('守望') || name.contains('漫游')) {
      return '探索者';
    } else if (name.contains('哲学') || name.contains('思想') || name.contains('理论') || name.contains('占卜')) {
      return '思想家';
    } else if (name.contains('梦想') || name.contains('创造') || name.contains('炼金') || name.contains('收藏')) {
      return '创造者';
    }
    return '探索者';
  }

  void _initializeRealities() {
    // 角色名称列表
    final List<String> names = [
      '夜猫子小雨', '咖啡店老板娘', '深夜电台DJ', '街头摄影师', '独立书店店主', '城市探索者',
      '二次元画师', '温暖陪伴师', '旅行博主', '复古唱片收藏家', '手工艺达人', '星空观测员',
      '文艺青年阿墨', '温柔学姐', '阳光运动男孩', '甜品师小糖', '民谣歌手', '植物系女孩',
      '程序员小哥哥', '古风汉服娘', '健身教练', '萌宠训练师', '奶茶师夜未央', '花艺师',
      '瑜伽老师', '游戏主播', '烘焙达人', '文学少女', '户外领队', '插画师',
      '茶艺师', '生活导师'
    ];

    // 角色描述列表
    final List<String> descriptions = [
      '"万物皆有裂痕，那是光照进来的地方。"',
      '"我的歌声，是霓虹下的唯一真实。"',
      '"时间只是一个可被编程的变量。"',
      '"宇宙的韵律，藏在每颗恒星的脉搏里。"',
      '"我们在梦中创造的世界，比现实更加真实。"',
      '"每一秒都是一根线，我在编织命运的锦缎。"',
      '"我在数据海洋中挖掘被遗忘的文明。"',
      '"我能将悲伤转化为希望，恐惧变为勇气。"',
      '"我的瞳孔里映照着千万个文明的兴衰。"',
      '"每一段回忆都是我收藏的珍宝。"',
      '"在我的世界里，偶然只是未被发现的必然。"',
      '"我穿梭于无数平行宇宙，寻找最美的可能性。"',
      '"我用想象力雕刻出思想的形状。"',
      '"我记得那些尚未发生的美好瞬间。"',
      '"我能让光与影讲述永恒的故事。"',
      '"风、火、水、土在我的指挥下奏响宇宙交响曲。"',
      '"我的思维是由量子比特编织的诗篇。"',
      '"我用不存在的材料创造永恒的艺术。"',
      '"在我的世界，生命与机械早已融为一体。"',
      '"我的每一次心跳都记录着宇宙的脉动。"',
      '"我让星球与星系随着引力的韵律起舞。"',
      '"我能听见宇宙深处的低语和呢喃。"',
      '"我的梦境是无限递归的分形模式。"',
      '"我通过量子纠缠预见无数可能的未来。"',
      '"我在十一维空间中弹奏宇宙的弦乐。"',
      '"我能入侵现实的源代码，重写存在的规则。"',
      '"我用时间和空间作为建材，构筑不可能的建筑。"',
      '"我记录着那些从未发生过的历史。"',
      '"我站在现实的边缘，凝视着无限的可能性。"',
      '"在混沌中，我发现了最完美的秩序。"',
      '"我研究星系间的共生关系和能量循环。"',
      '"我见证了思想从单一到复杂的进化历程。"',
    ];

    // 初始化角色列表
    _realities = List.generate(32, (index) {
      int avatarIndex = index % _scifiAvatars.length;
      return Reality(
        id: (index + 1).toString(),
        name: names[index],
        description: descriptions[index],
        avatarUrl: _scifiAvatars[avatarIndex],
        backgroundUrl: '',
        fallbackBackgroundUrl: null,
      );
    });

    // 为每个角色生成随机渐变色
    _gradientColors = List.generate(32, (index) => EnhancedCartoonUI.generateRandomGradient());
    
    // 初始化筛选列表
    _filteredRealities = List.from(_realities);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPreloaded) {
      _preloadImages();
      _imagesPreloaded = true;
    }
  }

  void _preloadImages() {
    for (var reality in _realities) {
      precacheImage(NetworkImage(reality.avatarUrl), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // 背景装饰
            _buildBackgroundDecorations(),
            // 主要内容
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildSearchAndFilter(),
                  _buildCategoryTabs(),
                  _buildStatsRow(),
                  Expanded(
                    child: _buildRealitiesList(),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: EnhancedCartoonUI.floatingActionButton(
          icon: Icons.shuffle,
          onPressed: _shuffleRealities,
          tooltip: '随机排序',
        ),
      ),
    );
  }

  // 构建背景装饰
  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        // 渐变背景
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFFFAF9FF), // 非常淡的紫色背景
                Colors.white,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // 浮动的装饰元素
        Positioned(
          top: 120,
          left: 30,
          child: Icon(
            Icons.star,
            color: const Color(0xFFE1BEE7).withValues(alpha: 0.3),
            size: 24,
          ),
        ),
        Positioned(
          top: 250,
          right: 40,
          child: Icon(
            Icons.auto_awesome,
            color: const Color(0xFFf093fb).withValues(alpha: 0.25),
            size: 20,
          ),
        ),
        Positioned(
          top: 400,
          left: 50,
          child: Icon(
            Icons.music_note,
            color: const Color(0xFF4facfe).withValues(alpha: 0.2),
            size: 22,
          ),
        ),
        Positioned(
          bottom: 300,
          right: 30,
          child: Icon(
            Icons.star,
            color: const Color(0xFFfed6e3).withValues(alpha: 0.3),
            size: 18,
          ),
        ),
        Positioned(
          bottom: 200,
          left: 40,
          child: Icon(
            Icons.auto_awesome,
            color: const Color(0xFFa8edea).withValues(alpha: 0.25),
            size: 16,
          ),
        ),
        Positioned(
          top: 180,
          right: 80,
          child: Icon(
            Icons.music_note,
            color: const Color(0xFFfcb69f).withValues(alpha: 0.2),
            size: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFFAF9FF),
          ],
        ),
      ),
      child: Row(
        children: [
          // 左侧装饰图标
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFf093fb).withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.blur_circular_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                // 装饰星星
                Positioned(
                  top: 8,
                  right: 10,
                  child: Icon(
                    Icons.star,
                    color: Colors.white.withValues(alpha: 0.4),
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 18),
          
          // 标题区域
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '平行时空',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: const Color(0xFF2A0B47),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFa8edea), Color(0xFF4facfe)],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    '遇见无数个可能的自己',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 2,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 右侧信息按钮
          GestureDetector(
            onTap: _showConceptDialog,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFffecd2), Color(0xFFfcb69f)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFfcb69f).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return EnhancedCartoonUI.searchBar(
      controller: _searchController,
      hintText: '搜索平行时空角色...',
      onFilterTap: _showFilterDialog,
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return EnhancedCartoonUI.categoryChip(
            label: category,
            isSelected: _selectedCategory == category,
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _filterRealities();
              });
            },
            icon: _getCategoryIcon(category),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '艺术家':
        return Icons.palette;
      case '工程师':
        return Icons.engineering;
      case '探索者':
        return Icons.explore;
      case '思想家':
        return Icons.psychology;
      case '创造者':
        return Icons.auto_awesome;
      default:
        return Icons.apps;
    }
  }

  Widget _buildStatsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 400;
        
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16, 
            vertical: 8
          ),
          child: Row(
            children: [
              Expanded(
                child: EnhancedCartoonUI.statsCard(
                  title: '总角色数',
                  value: '${_realities.length}',
                  icon: Icons.people,
                  color: const Color(0xFF6B2C9E),
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: EnhancedCartoonUI.statsCard(
                  title: '在线角色',
                  value: '${_getOnlineCount()}',
                  icon: Icons.online_prediction,
                  color: const Color(0xFF4CAF50),
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: EnhancedCartoonUI.statsCard(
                  title: '当前显示',
                  value: '${_filteredRealities.length}',
                  icon: Icons.visibility,
                  color: const Color(0xFFFF6B35),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _getOnlineCount() {
    return math.Random().nextInt(_realities.length ~/ 2) + _realities.length ~/ 2;
  }

  Widget _buildRealitiesList() {
    if (_filteredRealities.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // 根据屏幕宽度调整网格配置
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 400;
        final isVerySmallScreen = screenWidth < 350;
        
        // 动态调整childAspectRatio以适应不同屏幕
        double aspectRatio;
        if (isVerySmallScreen) {
          aspectRatio = 0.85; // 更高的卡片以容纳内容
        } else if (isSmallScreen) {
          aspectRatio = 0.75;
        } else {
          aspectRatio = 0.7;
        }
        
        return GridView.builder(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: isSmallScreen ? 8 : 12,
            mainAxisSpacing: isSmallScreen ? 8 : 12,
          ),
          itemCount: _filteredRealities.length,
          itemBuilder: (context, index) {
            final reality = _filteredRealities[index];
            final originalIndex = _realities.indexOf(reality);
            return _buildEnhancedRealityCard(reality, originalIndex);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6B2C9E).withValues(alpha: 0.1),
                  const Color(0xFFFF2A6D).withValues(alpha: 0.05),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off,
              size: 48,
              color: Color(0xFF6B2C9E),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '没有找到匹配的角色',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '尝试调整搜索条件或选择其他分类',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          EnhancedCartoonUI.enhancedCard(
            onTap: () {
              setState(() {
                _searchController.clear();
                _selectedCategory = '全部';
                _filterRealities();
              });
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                '重置筛选条件',
                style: TextStyle(
                  color: Color(0xFF6B2C9E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedRealityCard(Reality reality, int originalIndex) {
    final isOnline = math.Random(originalIndex).nextBool();
    
    return EnhancedCartoonUI.characterCard(
      name: reality.name,
      description: reality.description,
      avatarUrl: reality.avatarUrl,
      gradientColors: _gradientColors[originalIndex],
      isOnline: isOnline,
      onTap: () => _navigateToRealityDetail(reality),
      onLongPress: () => _showCharacterOptions(reality),
    );
  }

  // 导航到角色详情页
  void _navigateToRealityDetail(Reality reality) {
    NavigationUtil.navigateWithAnimation(
      context,
      RealityDetailPage(reality: reality),
    );
  }

  // 显示角色选项菜单
  void _showCharacterOptions(Reality reality) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部指示器
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 角色信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      reality.avatarUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF6B2C9E),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reality.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2A0B47),
                          ),
                        ),
                        Text(
                          '长按操作菜单',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 操作选项
            _buildOptionItem(
              icon: Icons.chat_bubble_outline,
              title: '开始对话',
              subtitle: '与这个角色进行深度交流',
              color: const Color(0xFF6B2C9E),
              onTap: () {
                Navigator.pop(context);
                _navigateToRealityDetail(reality);
              },
            ),
            
            _buildOptionItem(
              icon: Icons.favorite_outline,
              title: '添加收藏',
              subtitle: '收藏这个有趣的角色',
              color: const Color(0xFFFF2A6D),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('已收藏 ${reality.name}');
              },
            ),
            
            _buildOptionItem(
              icon: Icons.share_outlined,
              title: '分享角色',
              subtitle: '分享给朋友一起探索',
              color: const Color(0xFF4ECDC4),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('分享功能开发中...');
              },
            ),
            
            const Divider(height: 1),
            
            _buildOptionItem(
              icon: Icons.report_outlined,
              title: '举报内容',
              subtitle: '举报不当内容',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _showReportDialog(reality);
              },
            ),
            
            _buildOptionItem(
              icon: Icons.block,
              title: '屏蔽角色',
              subtitle: '不再显示此角色',
              color: Colors.grey[600]!,
              onTap: () {
                Navigator.pop(context);
                _showBlockDialog(reality);
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2A0B47),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 显示筛选对话框
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('筛选选项'),
        content: const Text('筛选功能开发中...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // 显示概念介绍对话框
  void _showConceptDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xFFF5F0FA),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 宇宙图标
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6B2C9E).withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.blur_circular_rounded,
                    color: Color(0xFF6B2C9E),
                    size: 32,
                  ),
                ),
                const Text(
                  '平行时空理念',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '在无限的宇宙中，存在着无数个平行时空，每一个都有着不同版本的你。'
                  '\n\n这些角色代表了你在不同现实中可能成为的样子 - 诗人、工程师、艺术家、探险家...'
                  '\n\n通过与这些"平行的自己"对话，你可以探索未知的可能性，发现自己潜在的天赋和视角。'
                  '\n\n选择一个角色，开始一段跨越维度的对话吧。',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6B2C9E), Color(0xFF4A1A6B)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6B2C9E).withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      '开始探索',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  // 显示举报对话框
  void _showReportDialog(Reality reality) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('举报 ${reality.name}'),
        content: const Text('确定要举报这个角色吗？举报后该角色将从您的列表中移除。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeReality(reality);
              _showSnackBar('已举报并移除 ${reality.name}');
            },
            child: const Text('举报', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 显示屏蔽对话框
  void _showBlockDialog(Reality reality) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('屏蔽 ${reality.name}'),
        content: const Text('确定要屏蔽这个角色吗？屏蔽后该角色将从您的列表中永久移除。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeReality(reality);
              _showSnackBar('已屏蔽 ${reality.name}');
            },
            child: const Text('屏蔽', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  // 移除角色
  void _removeReality(Reality reality) {
    setState(() {
      _realities.remove(reality);
      _filterRealities();
    });
  }

  // 随机排序
  void _shuffleRealities() {
    setState(() {
      _realities.shuffle();
      _filterRealities();
    });
    _showSnackBar('已随机排序');
  }

  // 显示提示消息
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFf093fb).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}