import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        title: const Text('关于我们'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 游戏Logo和名称
              Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.auto_stories,
                            size: 40,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '烽尘绘谱',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'v1.0.0',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.lightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 游戏介绍
              _buildSectionCard(
                context,
                title: '游戏介绍',
                content: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '《烽尘绘谱》是一款基于AI驱动的三国题材文字RPG游戏。在这里，您将体验到纯文字带来的无限想象空间，每一个选择都将影响您的三国征程。',
                      style: TextStyle(height: 1.6),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '字里行间，自有千军万马。',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 核心特色
              _buildSectionCard(
                context,
                title: '核心特色',
                content: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FeatureItem(
                      icon: Icons.psychology,
                      title: 'AI动态生成',
                      description: '基于DeepSeek AI，动态生成剧情和战斗描述',
                    ),
                    SizedBox(height: 12),
                    _FeatureItem(
                      icon: Icons.menu_book,
                      title: '纯文字体验',
                      description: '回归文字游戏本质，激发无限想象力',
                    ),
                    SizedBox(height: 12),
                    _FeatureItem(
                      icon: Icons.grid_view,
                      title: '策略阵型',
                      description: '九宫格阵型布局，策略性回合制战斗',
                    ),
                    SizedBox(height: 12),
                    _FeatureItem(
                      icon: Icons.people,
                      title: '武将收集',
                      description: '收集培养三国名将，体验不同的战斗风格',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 开发团队
              _buildSectionCard(
                context,
                title: '开发团队',
                content: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '开发者：独立开发者',
                      style: TextStyle(height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '技术栈：Flutter + DeepSeek AI',
                      style: TextStyle(height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '设计理念：用现代技术重新诠释经典文字游戏',
                      style: TextStyle(height: 1.6),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 版权信息
              _buildSectionCard(
                context,
                title: '版权信息',
                content: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '© 2024 烽尘绘谱开发团队',
                      style: TextStyle(height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '本游戏为原创作品，所有权利保留。',
                      style: TextStyle(height: 1.6),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '三国历史人物及相关内容属于公共领域。',
                      style: TextStyle(height: 1.6),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 联系我们按钮
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/feedback'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: const Icon(Icons.email),
                  label: const Text('联系我们'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required Widget content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppTheme.accentColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: AppTheme.lightColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}