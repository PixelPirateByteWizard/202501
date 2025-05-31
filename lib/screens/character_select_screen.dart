import 'package:flutter/material.dart';
import '../models/player.dart';
import '../utils/constants.dart';
import 'game_screen.dart';

class CharacterSelectScreen extends StatefulWidget {
  const CharacterSelectScreen({Key? key}) : super(key: key);

  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCharacterIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> _characters = [
    {
      'name': '劍修',
      'description': '精通劍術的修士，有更高的攻擊力及速度。',
      'asset': 'assets/images/characters/characters_1.png',
      'specialties': ['高攻擊力', '快速攻擊', '靈氣穿透'],
      'startingSkills': ['靈力回復'],
      'startingBullets': ['bolt', 'spirit'],
    },
    {
      'name': '煉丹師',
      'description': '煉丹術高超的修士，有更多的生命值及恢復能力。',
      'asset': 'assets/images/characters/characters_2.png',
      'specialties': ['高生命值', '生命回復', '灼燒傷害'],
      'startingSkills': ['靈氣護盾'],
      'startingBullets': ['bolt', 'flame'],
    },
    {
      'name': '符修',
      'description': '擅長符咒的修士，能同時發射多種不同的法術。',
      'asset': 'assets/images/characters/characters_3.png',
      'specialties': ['多重法術', '範圍攻擊', '元素掌控'],
      'startingSkills': ['靈子感應'],
      'startingBullets': ['bolt', 'frost'],
    },
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCharacter(int index) {
    setState(() {
      _selectedCharacterIndex = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _startGame() {
    final character = _characters[_selectedCharacterIndex];

    final player = Player(
      characterAsset: character['asset'],
      bullets: List<String>.from(character['startingBullets']),
      passiveSkills: List<String>.from(character['startingSkills']),
    );

    switch (_selectedCharacterIndex) {
      case 0: // 劍修
        player.skillLevels['attack_power'] = 2;
        player.skillLevels['attack_speed'] = 1;
        break;
      case 1: // 煉丹師
        player.health = 120;
        player.maxHealth = 120;
        player.skillLevels['health_regen'] = 1;
        break;
      case 2: // 符修
        player.skillLevels['multi_cast'] = 1;
        player.skillLevels['area_effect'] = 1;
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(initialPlayer: player),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/backgrounds_2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    // 頂部标题区域 (10%)
                    SizedBox(
                      height: constraints.maxHeight * 0.1,
                      child: Center(
                        child: Text(
                          '選擇你的修士',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            color: Colors.amber.shade100,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.7),
                                blurRadius: 5,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 角色选择区域 (20%)
                    SizedBox(
                      height: constraints.maxHeight * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _characters.length,
                          (index) => _buildCharacterOption(index),
                        ),
                      ),
                    ),

                    // 角色详情区域 (60%)
                    SizedBox(
                      height: constraints.maxHeight * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: _buildCompactCharacterDetails(),
                      ),
                    ),

                    // 底部按钮区域 (10%)
                    SizedBox(
                      height: constraints.maxHeight * 0.1,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: _startGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade800,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.play_arrow, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '開始修仙之旅',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterOption(int index) {
    final isSelected = index == _selectedCharacterIndex;
    final character = _characters[index];
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    return GestureDetector(
      onTap: () => _selectCharacter(index),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          final scale = isSelected
              ? _animationController.status == AnimationStatus.completed
                  ? _scaleAnimation.value
                  : 1.0
              : 1.0;

          return Transform.scale(
            scale: scale,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 4 : 8),
              width: isSmallScreen ? 70 : 80,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.amber.withOpacity(0.3)
                    : Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.amber : Colors.grey.shade700,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Container(
                      width: isSmallScreen ? 40 : 45,
                      height: isSmallScreen ? 40 : 45,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        border: Border.all(
                          color:
                              isSelected ? Colors.amber : Colors.grey.shade600,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          character['asset'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 2 : 4),
                  Text(
                    character['name'],
                    style: TextStyle(
                      color: isSelected ? Colors.amber : Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: isSmallScreen ? 12 : 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompactCharacterDetails() {
    final character = _characters[_selectedCharacterIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.shade800.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头像和角色名称/描述
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: isSmallScreen ? 40 : 45,
                  height: isSmallScreen ? 40 : 45,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    border: Border.all(
                      color: Colors.amber,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      character['asset'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character['name'],
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      character['description'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Divider(
              color: Colors.amber,
              height: isSmallScreen ? 16 : 20,
              thickness: 0.5),

          // 三栏布局
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 专长
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber.shade200,
                            size: isSmallScreen ? 14 : 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '專長',
                            style: TextStyle(
                              color: Colors.amber.shade200,
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 6 : 8),
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: List.generate(
                            (character['specialties'] as List<String>).length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                  bottom: isSmallScreen ? 4 : 6),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.purple.shade300,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      character['specialties'][index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isSmallScreen ? 11 : 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 垂直分割线
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: isSmallScreen ? 6 : 8),
                  width: 1,
                  color: Colors.amber.withOpacity(0.3),
                ),

                // 技能
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.amber.shade200,
                            size: isSmallScreen ? 14 : 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '技能',
                            style: TextStyle(
                              color: Colors.amber.shade200,
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 6 : 8),
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: List.generate(
                            (character['startingSkills'] as List<String>)
                                .length,
                            (index) => Container(
                              margin: EdgeInsets.only(
                                  bottom: isSmallScreen ? 4 : 6),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: isSmallScreen ? 2 : 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.blue.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                character['startingSkills'][index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 11 : 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 垂直分割线
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: isSmallScreen ? 6 : 8),
                  width: 1,
                  color: Colors.amber.withOpacity(0.3),
                ),

                // 法术
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.bolt,
                            color: Colors.amber.shade200,
                            size: isSmallScreen ? 14 : 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '法術',
                            style: TextStyle(
                              color: Colors.amber.shade200,
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 6 : 8),
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: List.generate(
                            (character['startingBullets'] as List<String>)
                                .length,
                            (index) {
                              final bullet =
                                  character['startingBullets'][index];
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: isSmallScreen ? 4 : 6),
                                child: Row(
                                  children: [
                                    Container(
                                      width: isSmallScreen ? 20 : 22,
                                      height: isSmallScreen ? 20 : 22,
                                      decoration: BoxDecoration(
                                        color: _getBulletColor(bullet)
                                            .withOpacity(0.2),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _getBulletColor(bullet),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        _getBulletIcon(bullet),
                                        color: _getBulletColor(bullet),
                                        size: isSmallScreen ? 10 : 12,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _getBulletName(bullet),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isSmallScreen ? 11 : 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // // 角色特性展示区（用图标和短文本）
          // Container(
          //   margin: EdgeInsets.only(top: isSmallScreen ? 6 : 8),
          //   padding: EdgeInsets.symmetric(
          //       vertical: isSmallScreen ? 6 : 8,
          //       horizontal: isSmallScreen ? 10 : 12),
          //   decoration: BoxDecoration(
          //     color: Colors.amber.withOpacity(0.1),
          //     borderRadius: BorderRadius.circular(8),
          //     border: Border.all(color: Colors.amber.withOpacity(0.3)),
          //   ),
          //   child: _buildCharacterTraits(),
          // ),
        ],
      ),
    );
  }

  Widget _buildCharacterTraits() {
    // Initialize with default values or make them nullable
    late IconData traitIcon;
    late String traitTitle;
    late String traitDescription;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    switch (_selectedCharacterIndex) {
      case 0:
        traitIcon = Icons.sports_martial_arts;
        traitTitle = '劍氣縱橫';
        traitDescription = '劍修出手迅捷，攻擊力提升20%，攻速提升15%';
        break;
      case 1:
        traitIcon = Icons.healing;
        traitTitle = '丹藥精通';
        traitDescription = '煉丹師生命值提升20%，每3秒恢復1點生命';
        break;
      case 2:
        traitIcon = Icons.auto_awesome;
        traitTitle = '符道通玄';
        traitDescription = '符修可同時釋放多種法術，範圍效果提升30%';
        break;
      default:
        traitIcon = Icons.stars;
        traitTitle = '修仙者';
        traitDescription = '擁有特殊能力的修仙者';
        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(traitIcon, color: Colors.amber, size: isSmallScreen ? 16 : 18),
        SizedBox(width: isSmallScreen ? 6 : 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                traitTitle,
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: isSmallScreen ? 12 : 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                traitDescription,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isSmallScreen ? 10 : 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getBulletName(String bulletType) {
    switch (bulletType) {
      case 'bolt':
        return '雷電';
      case 'flame':
        return '火焰';
      case 'frost':
        return '冰霜';
      case 'spirit':
        return '靈氣';
      case 'tornado':
        return '風暴';
      default:
        return bulletType;
    }
  }

  Color _getBulletColor(String bulletType) {
    switch (bulletType) {
      case 'bolt':
        return Colors.amber;
      case 'flame':
        return Colors.deepOrange;
      case 'frost':
        return Colors.lightBlue;
      case 'spirit':
        return Colors.purple;
      case 'tornado':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getBulletIcon(String bulletType) {
    switch (bulletType) {
      case 'bolt':
        return Icons.flash_on;
      case 'flame':
        return Icons.local_fire_department;
      case 'frost':
        return Icons.ac_unit;
      case 'spirit':
        return Icons.hub;
      case 'tornado':
        return Icons.air;
      default:
        return Icons.circle;
    }
  }
}
