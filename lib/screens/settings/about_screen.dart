import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildGameInfo(),
                      const SizedBox(height: 20),
                      _buildDeveloperInfo(),
                      const SizedBox(height: 20),
                      _buildGameFeatures(),
                      const SizedBox(height: 20),
                      _buildContact(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            '关于我们',
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

  Widget _buildGameInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          // 游戏图标
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryGold,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.castle,
              color: AppTheme.backgroundDark,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '烽尘会谱',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'v1.0.0',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '一款以三国历史为背景的策略卡牌游戏，体验从桃园结义到三国归晋的完整历程。收集名将，组建阵容，征战天下！',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.code,
                color: AppTheme.primaryGold,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                '开发团队',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('开发者', '烽尘工作室'),
          _buildInfoRow('引擎', 'Flutter'),
          _buildInfoRow('开发语言', 'Dart'),
          _buildInfoRow('发布日期', '2024年12月'),
          _buildInfoRow('更新频率', '定期更新'),
        ],
      ),
    );
  }

  Widget _buildGameFeatures() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star,
                color: AppTheme.primaryGold,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                '游戏特色',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeatureItem('🏛️', '历史还原', '忠实还原三国历史，体验经典战役'),
          _buildFeatureItem('⚔️', '策略战斗', '回合制战斗，考验策略与智慧'),
          _buildFeatureItem('👥', '武将收集', '收集三国名将，打造最强阵容'),
          _buildFeatureItem('🎯', '阵型搭配', '多种阵型组合，克敌制胜'),
          _buildFeatureItem('🏆', '成就系统', '丰富成就挑战，展示实力'),
          _buildFeatureItem('🛍️', '装备强化', '收集装备，提升武将实力'),
        ],
      ),
    );
  }

  Widget _buildContact() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.contact_mail,
                color: AppTheme.primaryGold,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                '联系我们',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '如果您在游戏中遇到问题或有任何建议，欢迎通过以下方式联系我们：',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          _buildContactItem(Icons.email, '邮箱', 'support@fengchen.game'),
          _buildContactItem(Icons.web, '官网', 'www.fengchen.game'),
          _buildContactItem(Icons.forum, '论坛', 'forum.fengchen.game'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryGold,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}