import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        title: const Text('使用帮助'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 帮助标题
              Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.help_center,
                          size: 48,
                          color: AppTheme.accentColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '《烽尘绘谱》使用指南',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '让我们一起踏上三国征程',
                          style: TextStyle(
                            color: AppTheme.lightColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 快速开始
              _buildHelpSection(
                context,
                icon: Icons.play_circle_outline,
                title: '快速开始',
                content: '1. 首次进入游戏会有新手引导\n2. 选择您的初始武将\n3. 开始您的三国征程\n4. 通过征程模式推进剧情\n5. 收集更多武将和装备',
              ),
              
              // 游戏模式
              _buildHelpSection(
                context,
                icon: Icons.gamepad,
                title: '游戏模式',
                content: '征程模式：\n• 主要的剧情推进模式\n• 通过选择不同选项影响故事发展\n• AI会根据您的选择生成独特的剧情\n\n战斗模式：\n• 回合制策略战斗\n• 九宫格阵型布局\n• 武将技能和装备搭配\n• 实时战斗描述生成',
              ),
              
              // 武将系统
              _buildHelpSection(
                context,
                icon: Icons.people,
                title: '武将系统',
                content: '武将获取：\n• 通过征程剧情招募\n• 完成特定任务奖励\n• 商店购买武将卡包\n\n武将培养：\n• 使用经验道具提升等级\n• 装备武器和防具\n• 学习和升级技能\n• 突破等级上限',
              ),
              
              // 阵型战斗
              _buildHelpSection(
                context,
                icon: Icons.grid_view,
                title: '阵型战斗',
                content: '阵型布置：\n• 3x3九宫格战场\n• 前排承受更多伤害\n• 后排输出更安全\n• 中排平衡攻防\n\n战斗策略：\n• 合理搭配武将职业\n• 利用武将技能组合\n• 观察敌方阵型弱点\n• 适时调整战术',
              ),
              
              // 装备系统
              _buildHelpSection(
                context,
                icon: Icons.shield,
                title: '装备系统',
                content: '装备类型：\n• 武器：提升攻击力\n• 防具：提升防御力\n• 饰品：提供特殊效果\n\n装备获取：\n• 战斗胜利奖励\n• 商店购买\n• 任务完成奖励\n• 装备合成制作',
              ),
              
              // 商店系统
              _buildHelpSection(
                context,
                icon: Icons.store,
                title: '商店系统',
                content: '商店功能：\n• 购买武将卡包\n• 购买装备道具\n• 购买经验材料\n• 购买特殊物品\n\n货币系统：\n• 金币：基础货币\n• 元宝：高级货币\n• 声望：特殊货币\n• 材料：合成道具',
              ),
              
              // 成就系统
              _buildHelpSection(
                context,
                icon: Icons.emoji_events,
                title: '成就系统',
                content: '成就类型：\n• 剧情成就：完成特定剧情\n• 战斗成就：达成战斗目标\n• 收集成就：收集武将装备\n• 特殊成就：隐藏条件达成\n\n成就奖励：\n• 经验值和金币\n• 稀有道具\n• 专属称号\n• 特殊武将',
              ),
              
              // 设置优化
              _buildHelpSection(
                context,
                icon: Icons.settings,
                title: '设置优化',
                content: '推荐设置：\n• 根据喜好调整音量\n• 设置合适的文本速度\n• 选择喜欢的叙事风格\n• 开启战斗动画效果\n\n性能优化：\n• 关闭不必要的动画\n• 降低音效音量\n• 定期清理游戏缓存',
              ),
              
              // 常见问题
              _buildHelpSection(
                context,
                icon: Icons.quiz,
                title: '常见问题',
                content: 'Q: 游戏数据会丢失吗？\nA: 游戏数据保存在本地，卸载应用会丢失数据。\n\nQ: 如何获得更多武将？\nA: 通过征程剧情、完成任务、商店购买等方式。\n\nQ: 战斗失败怎么办？\nA: 可以调整阵型、升级武将、更换装备后重试。\n\nQ: AI生成的内容不满意？\nA: 可以在设置中调整AI偏好，或重新开始剧情。',
              ),
              
              const SizedBox(height: 24),
              
              // 联系支持
              Center(
                child: Column(
                  children: [
                    const Text(
                      '还有其他问题？',
                      style: TextStyle(
                        color: AppTheme.lightColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/feedback'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        foregroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      icon: const Icon(Icons.support_agent),
                      label: const Text('联系客服'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(
                height: 1.6,
                color: AppTheme.lightColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}