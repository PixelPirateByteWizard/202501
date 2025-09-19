import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int _selectedCategory = 0;

  final List<String> _categories = [
    '新手指南',
    '游戏玩法',
    '武将系统',
    '战斗系统',
    '常见问题',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildCategoryTabs(),
              Expanded(
                child: _buildContent(),
              ),
            ],
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
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            '使用帮助',
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

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryGold
                    : AppTheme.cardBackgroundDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryGold
                      : AppTheme.textSecondary.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: isSelected
                        ? AppTheme.backgroundDark
                        : AppTheme.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration,
        child: _getContentForCategory(_selectedCategory),
      ),
    );
  }

  Widget _getContentForCategory(int category) {
    switch (category) {
      case 0:
        return _buildBeginnerGuide();
      case 1:
        return _buildGameplayGuide();
      case 2:
        return _buildGeneralGuide();
      case 3:
        return _buildBattleGuide();
      case 4:
        return _buildFAQ();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBeginnerGuide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🎮 新手指南'),
        _buildHelpItem(
          '游戏目标',
          '体验完整的三国历史，从桃园结义到三国归晋。收集武将，组建阵容，征战天下！',
        ),
        _buildHelpItem(
          '开始游戏',
          '1. 进入征程模式\n2. 选择第一个关卡"桃园结义"\n3. 选择武将组成队伍\n4. 开始你的三国之旅',
        ),
        _buildHelpItem(
          '基础操作',
          '• 点击关卡进入战斗\n• 拖拽武将调整阵容\n• 查看武将详情了解属性\n• 完成关卡获得奖励',
        ),
        _buildHelpItem(
          '重要提示',
          '• 游戏数据自动保存\n• 建议先熟悉战斗系统\n• 合理搭配武将阵容\n• 关注武将的职业特点',
        ),
      ],
    );
  }

  Widget _buildGameplayGuide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('⚔️ 游戏玩法'),
        _buildHelpItem(
          '征程模式',
          '主要的游戏模式，包含5个章节25个关卡：\n• 第一章：群雄并起\n• 第二章：三足鼎立\n• 第三章：鼎足之势\n• 第四章：北伐中原\n• 第五章：三国归晋',
        ),
        _buildHelpItem(
          '武将收集',
          '通过以下方式获得武将：\n• 完成关卡奖励\n• 商店购买\n• 成就奖励\n• 特殊活动',
        ),
        _buildHelpItem(
          '装备系统',
          '为武将装备武器和防具：\n• 武器：提升攻击力\n• 防具：提升防御力\n• 饰品：提供特殊效果\n• 强化装备提升属性',
        ),
        _buildHelpItem(
          '成就系统',
          '完成各种挑战获得成就：\n• 战斗成就\n• 收集成就\n• 进度成就\n• 特殊成就',
        ),
      ],
    );
  }

  Widget _buildGeneralGuide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('👥 武将系统'),
        _buildHelpItem(
          '武将属性',
          '每个武将都有四项基础属性：\n• 攻击：影响造成的伤害\n• 防御：减少受到的伤害\n• 智力：影响技能效果\n• 速度：决定行动顺序',
        ),
        _buildHelpItem(
          '武将职业',
          '不同职业有不同特点：\n• 武将：攻击力强，适合前排\n• 谋士：智力高，擅长策略\n• 弓手：速度快，远程攻击\n• 骑兵：机动性强，突击能力强',
        ),
        _buildHelpItem(
          '武将技能',
          '每个武将都有独特技能：\n• 主动技能：战斗中手动释放\n• 被动技能：自动触发\n• 合击技能：多人配合释放\n• 觉醒技能：达到条件后解锁',
        ),
        _buildHelpItem(
          '武将培养',
          '提升武将实力的方法：\n• 升级：消耗经验提升等级\n• 装备：穿戴装备提升属性\n• 突破：突破等级上限\n• 觉醒：解锁新技能',
        ),
      ],
    );
  }

  Widget _buildBattleGuide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('⚔️ 战斗系统'),
        _buildHelpItem(
          '战斗流程',
          '1. 选择出战武将（最多6人）\n2. 选择阵型获得加成\n3. 进入回合制战斗\n4. 轮流行动直到分出胜负',
        ),
        _buildHelpItem(
          '回合制规则',
          '• 每回合每个武将只能行动一次\n• 可以选择普通攻击或释放技能\n• 行动后武将进入冷却状态\n• 点击"结束回合"进入敌军回合',
        ),
        _buildHelpItem(
          '阵型系统',
          '不同阵型提供不同加成：\n• 锋矢阵：攻击+15%，承伤+20%\n• 雁行阵：攻防各+5%，平衡型\n• 鱼鳞阵：防御+20%，攻击-5%',
        ),
        _buildHelpItem(
          '战斗技巧',
          '• 合理搭配武将职业\n• 根据敌人特点选择阵型\n• 优先攻击威胁最大的敌人\n• 保护血量较低的武将\n• 善用技能的特殊效果',
        ),
      ],
    );
  }

  Widget _buildFAQ() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('❓ 常见问题'),
        _buildHelpItem(
          'Q: 游戏数据会丢失吗？',
          'A: 游戏数据自动保存在本地，不会轻易丢失。建议定期备份重要数据。',
        ),
        _buildHelpItem(
          'Q: 如何获得更多武将？',
          'A: 完成关卡、购买商店物品、达成成就都可以获得武将。',
        ),
        _buildHelpItem(
          'Q: 战斗失败了怎么办？',
          'A: 可以调整阵容、升级武将、更换装备后重新挑战。',
        ),
        _buildHelpItem(
          'Q: 关卡太难无法通过？',
          'A: 建议先完成其他关卡提升实力，或者尝试不同的阵型搭配。',
        ),
        _buildHelpItem(
          'Q: 如何重置游戏？',
          'A: 在设置页面选择"重置游戏"，注意此操作不可恢复。',
        ),
        _buildHelpItem(
          'Q: 游戏卡顿怎么办？',
          'A: 尝试关闭其他应用、重启游戏，或在设置中清除缓存。',
        ),
        _buildHelpItem(
          'Q: 发现bug如何反馈？',
          'A: 可以通过设置页面的"反馈建议"功能联系我们。',
        ),
        _buildHelpItem(
          'Q: 游戏有内购吗？',
          'A: 本游戏完全免费，无任何内购项目。',
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.primaryGold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHelpItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}