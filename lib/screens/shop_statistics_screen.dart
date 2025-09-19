import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/shop_service.dart';

class ShopStatisticsScreen extends StatefulWidget {
  const ShopStatisticsScreen({super.key});

  @override
  State<ShopStatisticsScreen> createState() => _ShopStatisticsScreenState();
}

class _ShopStatisticsScreenState extends State<ShopStatisticsScreen> {
  PurchaseStatistics? _statistics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);
    
    final statistics = await ShopService.getPurchaseStatistics();
    
    setState(() {
      _statistics = statistics;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isLoading ? _buildLoadingWidget() : _buildStatisticsContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: AppTheme.primaryGold),
          ),
          const SizedBox(width: 8),
          const Text(
            '购买统计',
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

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(color: AppTheme.primaryGold),
    );
  }

  Widget _buildStatisticsContent() {
    if (_statistics == null) {
      return const Center(
        child: Text(
          '暂无统计数据',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCard(),
          const SizedBox(height: 20),
          _buildCategoryBreakdown(),
          const SizedBox(height: 20),
          _buildMostPurchasedItems(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics, color: AppTheme.primaryGold, size: 20),
              SizedBox(width: 8),
              Text(
                '总体统计',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '总消费',
                  '${_statistics!.totalSpent}',
                  Icons.monetization_on,
                  AppTheme.primaryGold,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '购买物品',
                  '${_statistics!.totalItems}',
                  Icons.shopping_bag,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '交易次数',
                  '${_statistics!.totalTransactions}',
                  Icons.receipt,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  '平均单价',
                  '${_statistics!.totalTransactions > 0 ? (_statistics!.totalSpent / _statistics!.totalTransactions).round() : 0}',
                  Icons.trending_up,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    if (_statistics!.categoryBreakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.pie_chart, color: AppTheme.primaryGold, size: 20),
              SizedBox(width: 8),
              Text(
                '分类统计',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._statistics!.categoryBreakdown.entries.map((entry) {
            final percentage = (_statistics!.totalItems > 0 
              ? (entry.value / _statistics!.totalItems * 100) 
              : 0).round();
            return _buildCategoryItem(entry.key, entry.value, percentage);
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category, int count, int percentage) {
    final color = _getCategoryColor(category);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '$count ($percentage%)',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '武器':
        return Colors.red;
      case '防具':
        return Colors.blue;
      case '饰品':
        return Colors.purple;
      case '消耗品':
        return Colors.green;
      default:
        return AppTheme.primaryGold;
    }
  }

  Widget _buildMostPurchasedItems() {
    if (_statistics!.mostPurchasedItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star, color: AppTheme.primaryGold, size: 20),
              SizedBox(width: 8),
              Text(
                '热门商品',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._statistics!.mostPurchasedItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return _buildPopularItem(index + 1, item.key, item.value);
          }),
        ],
      ),
    );
  }

  Widget _buildPopularItem(int rank, String itemName, int count) {
    final rankColor = rank <= 3 ? AppTheme.primaryGold : AppTheme.textSecondary;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rankColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              itemName,
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '$count 件',
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