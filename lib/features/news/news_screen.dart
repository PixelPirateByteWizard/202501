import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/models/news_article_model.dart';
import '../../shared/widgets/themed_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<NewsArticle> _articles = [];
  List<NewsArticle> _filteredArticles = [];
  String _selectedCategory = '精选';

  final List<String> _categories = ['精选', '快讯', '公告'];

  @override
  void initState() {
    super.initState();
    _initializeDefaultData();
    _loadData();
  }

  void _initializeDefaultData() {
    _articles = [
      // 精选新闻
      NewsArticle(
        id: '1',
        title: 'Bitcoin突破95,000美元创历史新高，机构持续增持',
        source: 'CoinDesk',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '2',
        title: 'AI代币板块集体爆发，FET领涨超15%',
        source: 'The Block',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '3',
        title: '美国通胀数据好于预期，加密市场迎来资金流入',
        source: 'Bloomberg',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '4',
        title: 'Layer2生态大爆发：Arbitrum和Optimism TVL双双创新高',
        source: 'DeFi Pulse',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '5',
        title: 'RWA赛道迎来政策利好，传统金融巨头纷纷入场',
        source: 'CoinTelegraph',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '6',
        title: 'Meme币市场成熟化，DOGE和SHIB获得更多实用场景',
        source: 'Decrypt',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 18)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '7',
        title: '以太坊上海升级一周年：Staking生态蓬勃发展',
        source: 'Ethereum Foundation',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '8',
        title: 'Solana生态DeFi协议总锁仓量突破150亿美元',
        source: 'DeFi Llama',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '9',
        title: '加密货币ETF资金流入创单月新高，机构FOMO情绪升温',
        source: 'Financial Times',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '10',
        title: 'Web3游戏市场规模预计2025年底达到500亿美元',
        source: 'GameFi Report',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 2, hours: 12)),
        type: ArticleType.featured,
      ),

      // 快讯
      NewsArticle(
        id: '11',
        title: '以太坊Layer2总锁仓量突破1000亿美元里程碑',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(minutes: 25)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '12',
        title: 'Solana生态TVL创新高，超越以太坊Layer2',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(minutes: 45)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '13',
        title: 'BTC期货持仓量创历史新高，达到450亿美元',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '14',
        title: 'Chainlink预言机网络处理交易量突破10万亿美元',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '15',
        title: 'Polygon zkEVM主网交易量单日突破100万笔',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '16',
        title: 'Uniswap V4测试网上线，引入Hook功能',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '17',
        title: 'Avalanche子网数量突破1000个，生态持续扩张',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '18',
        title: 'Cardano智能合约平台活跃地址数创年内新高',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '19',
        title: 'Cosmos生态IBC转账量单日突破500万笔',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 7)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '20',
        title: 'Polkadot平行链拍卖第三轮即将启动',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        type: ArticleType.flash,
      ),

      // 公告
      NewsArticle(
        id: '41',
        title: 'Coinbase宣布支持更多RWA代币交易对',
        source: 'Coinbase公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '42',
        title: 'Binance将上线新一批AI概念代币',
        source: 'Binance公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '43',
        title: 'OKX交易所推出Layer2代币专区',
        source: 'OKX公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '44',
        title: 'Kraken宣布支持以太坊质押提取功能',
        source: 'Kraken公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 16)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '45',
        title: 'Huobi Global更名为HTX，品牌全面升级',
        source: 'HTX公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 20)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '46',
        title: 'Gate.io推出Web3钱包一键交易功能',
        source: 'Gate.io公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '47',
        title: 'KuCoin交易所新增支持20种DeFi代币',
        source: 'KuCoin公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '48',
        title: 'Bybit推出合约交易手续费减免活动',
        source: 'Bybit公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '49',
        title: 'Bitget交易所上线跟单交易2.0版本',
        source: 'Bitget公告',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 1, hours: 12)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '50',
        title: 'MEXC Global新增支持Solana生态代币',
        source: 'MEXC公告',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 1, hours: 16)),
        type: ArticleType.announcement,
      ),
    ];
    // 默认显示精选新闻
    _filteredArticles =
        _articles.where((a) => a.type == ArticleType.featured).toList();
  }

  Future<void> _loadData() async {
    try {
      final articles = await ApiService.getNewsData();
      setState(() {
        _articles = articles;
        _filteredArticles = articles;
      });
    } catch (e) {
      // 即使加载失败也显示页面内容
    }
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == '精选') {
        _filteredArticles =
            _articles.where((a) => a.type == ArticleType.featured).toList();
      } else if (category == '快讯') {
        _filteredArticles =
            _articles.where((a) => a.type == ArticleType.flash).toList();
      } else if (category == '公告') {
        _filteredArticles =
            _articles.where((a) => a.type == ArticleType.announcement).toList();
      } else {
        _filteredArticles = _articles;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 12, 24, 20),
            child: Text(
              '资讯',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: Color(0xFFE6EDF3),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildCategoryTabs(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildArticleList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return GestureDetector(
            onTap: () => _filterByCategory(category),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF4A90E2) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFFE6EDF3)
                        : const Color(0xFF8B949E),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticleList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _filteredArticles.length,
      itemBuilder: (context, index) {
        final article = _filteredArticles[index];
        return _buildArticleItem(article);
      },
    );
  }

  Widget _buildArticleItem(NewsArticle article) {
    switch (article.type) {
      case ArticleType.featured:
        return _buildFeaturedArticle(article);
      case ArticleType.flash:
        return _buildFlashArticle(article);
      case ArticleType.announcement:
        return _buildAnnouncementArticle(article);
    }
  }

  Widget _buildFeaturedArticle(NewsArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: ThemedCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  article.imageUrl!,
                  width: double.infinity,
                  height: 192,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 192,
                      color: const Color(0xFF8B949E),
                      child: const Icon(Icons.image,
                          color: Colors.white, size: 48),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE6EDF3),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '来源: ${article.source} · ${_getTimeAgo(article.publishedAt)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8B949E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashArticle(NewsArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ThemedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE6EDF3),
                ),
                children: [
                  const TextSpan(
                    text: '[快讯] ',
                    style: TextStyle(color: Color(0xFFF87171)),
                  ),
                  TextSpan(text: article.title),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getTimeAgo(article.publishedAt),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF8B949E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementArticle(NewsArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ThemedCard(
        backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.1),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3B82F6),
              ),
              child: const Icon(
                Icons.announcement,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE6EDF3),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${article.source} · ${_getTimeAgo(article.publishedAt)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8B949E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}
