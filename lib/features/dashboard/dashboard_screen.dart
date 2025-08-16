import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/models/coin_model.dart';
import '../../core/models/news_article_model.dart';
import '../../core/models/exchange_model.dart';
import '../../shared/widgets/themed_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Coin> _watchlistCoins = [];
  List<NewsArticle> _newsArticles = [];
  List<ExchangeAnnouncement> _exchangeAnnouncements = [];
  List<ExchangeInfo> _exchangeInfos = [];
  String _dailyInsight =
      'BTC突破95K创历史新高，市场进入超级牛市阶段。AI分析显示Layer2和AI概念币种将迎来新一轮爆发，建议关注技术面突破信号。';

  @override
  void initState() {
    super.initState();
    _initializeDefaultData();
    _loadData();
  }

  void _initializeDefaultData() {
    // 设置默认的关注币种
    _watchlistCoins = [
      Coin(
        id: 'bitcoin',
        name: 'Bitcoin',
        symbol: 'BTC',
        imageUrl: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
        price: 95420.50,
        priceChange24h: 2.34,
        sparklineData: [92000, 93500, 94800, 93200, 95000, 96200, 95420],
      ),
      Coin(
        id: 'ethereum',
        name: 'Ethereum',
        symbol: 'ETH',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png',
        price: 4850.75,
        priceChange24h: 3.67,
        sparklineData: [4600, 4720, 4800, 4650, 4820, 4900, 4850],
      ),
      Coin(
        id: 'solana',
        name: 'Solana',
        symbol: 'SOL',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/5426.png',
        price: 245.80,
        priceChange24h: 5.23,
        sparklineData: [230, 235, 240, 238, 245, 250, 245],
      ),
    ];

    // 设置默认新闻
    _newsArticles = [
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
    ];

    // 设置默认交易所公告
    _exchangeAnnouncements = [
      ExchangeAnnouncement(
        id: '1',
        title: 'Binance新用户注册送100 USDT体验金',
        content: '新用户完成身份认证即可获得100 USDT体验金，用于合约交易体验',
        exchangeName: 'Binance',
        exchangeIcon: '🟡',
        type: ExchangeAnnouncementType.activity,
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        isImportant: true,
        actionUrl: 'https://binance.com/register',
      ),
      ExchangeAnnouncement(
        id: '2',
        title: 'OKX上线PEPE永续合约',
        content: 'PEPE-USDT永续合约现已上线，支持最高20倍杠杆交易',
        exchangeName: 'OKX',
        exchangeIcon: '⚫',
        type: ExchangeAnnouncementType.listing,
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        isImportant: true,
      ),
      ExchangeAnnouncement(
        id: '6',
        title: 'Gate.io启动Web3钱包空投活动',
        content: '使用Gate.io Web3钱包完成指定任务，瓜分10万USDT奖池',
        exchangeName: 'Gate.io',
        exchangeIcon: '🟢',
        type: ExchangeAnnouncementType.activity,
        publishedAt: DateTime.now().subtract(const Duration(hours: 16)),
        isImportant: true,
      ),
    ];

    // 设置默认交易所信息
    _exchangeInfos = [
      ExchangeInfo(
        name: 'Binance',
        icon: '🟡',
        status: 'online',
        volume24h: 28500000000, // 285亿美元
        tradingPairs: 2000,
      ),
      ExchangeInfo(
        name: 'OKX',
        icon: '⚫',
        status: 'online',
        volume24h: 15200000000, // 152亿美元
        tradingPairs: 1500,
      ),
      ExchangeInfo(
        name: 'Coinbase',
        icon: '🔵',
        status: 'online',
        volume24h: 8900000000, // 89亿美元
        tradingPairs: 800,
      ),
      ExchangeInfo(
        name: 'Huobi',
        icon: '🔴',
        status: 'online',
        volume24h: 6700000000, // 67亿美元
        tradingPairs: 1200,
      ),
      ExchangeInfo(
        name: 'Kraken',
        icon: '🟣',
        status: 'online',
        volume24h: 3400000000, // 34亿美元
        tradingPairs: 600,
      ),
    ];
  }

  Future<void> _loadData() async {
    try {
      final watchlist = await StorageService.getWatchlist();
      final allCoins = await ApiService.getMarketData();
      final news = await ApiService.getNewsData();
      final insight = await ApiService.getDailyInsight();
      final exchangeAnnouncements = await ApiService.getExchangeAnnouncements();
      final exchangeInfos = await ApiService.getExchangeInfo();

      setState(() {
        _watchlistCoins =
            allCoins.where((coin) => watchlist.contains(coin.id)).toList();
        // 显示前5条新闻，包含不同类型
        _newsArticles = news.take(5).toList();
        _exchangeAnnouncements =
            exchangeAnnouncements.take(3).toList(); // 显示前3条公告
        _exchangeInfos = exchangeInfos;
        _dailyInsight = insight;
      });
    } catch (e) {
      // 即使加载失败也显示页面内容
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E2D),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: Text(
                '仪表盘',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE6EDF3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWatchlistSection(),
                  const SizedBox(height: 24),
                  _buildExchangeInfoSection(),
                  const SizedBox(height: 24),
                  _buildExchangeAnnouncementsSection(),
                  const SizedBox(height: 24),
                  _buildDailyInsightSection(),
                  const SizedBox(height: 24),
                  _buildNewsSection(),
                  const SizedBox(height: 100), // Bottom padding for tab bar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchlistSection() {
    return ThemedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的关注',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE6EDF3),
            ),
          ),
          const SizedBox(height: 16),
          if (_watchlistCoins.isEmpty)
            const Text(
              '暂无关注的币种',
              style: TextStyle(
                color: Color(0xFF8B949E),
                fontSize: 16,
              ),
            )
          else
            Column(
              children:
                  _watchlistCoins.map((coin) => _buildCoinItem(coin)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildCoinItem(Coin coin) {
    final isPositive = coin.priceChange24h >= 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Image.network(
            coin.imageUrl,
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.currency_bitcoin,
                  size: 40, color: Color(0xFF8B949E));
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coin.symbol,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE6EDF3),
                  ),
                ),
                Text(
                  coin.name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8B949E),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatPrice(coin.price),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE6EDF3),
                ),
              ),
              Text(
                '${isPositive ? '+' : ''}${coin.priceChange24h.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 14,
                  color: isPositive
                      ? const Color(0xFF4ADE80)
                      : const Color(0xFFF87171),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyInsightSection() {
    return ThemedCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4A90E2), Color(0xFF50E3C2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.psychology, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'VerseAI 每日洞察',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _dailyInsight,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // Navigate to AI assistant
            },
            child: const Text(
              '查看详情 →',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            '关键新闻流',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE6EDF3),
            ),
          ),
        ),
        if (_newsArticles.isNotEmpty)
          ..._newsArticles.map((article) => _buildNewsItem(article))
        else
          const ThemedCard(
            child: Text(
              '暂无新闻',
              style: TextStyle(
                color: Color(0xFF8B949E),
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNewsItem(NewsArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: _buildNewsItemByType(article),
    );
  }

  Widget _buildNewsItemByType(NewsArticle article) {
    switch (article.type) {
      case ArticleType.featured:
        return _buildFeaturedNewsItem(article);
      case ArticleType.flash:
        return _buildFlashNewsItem(article);
      case ArticleType.announcement:
        return _buildAnnouncementNewsItem(article);
    }
  }

  Widget _buildFeaturedNewsItem(NewsArticle article) {
    return ThemedCard(
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
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '精选',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A90E2),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${article.source} · ${_getTimeAgo(article.publishedAt)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8B949E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlashNewsItem(NewsArticle article) {
    return ThemedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFFE6EDF3),
                height: 1.3,
              ),
              children: [
                const TextSpan(
                  text: '[快讯] ',
                  style: TextStyle(
                    color: Color(0xFFF87171),
                    fontWeight: FontWeight.bold,
                  ),
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
    );
  }

  Widget _buildAnnouncementNewsItem(NewsArticle article) {
    return ThemedCard(
      backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.1),
      border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF3B82F6),
            ),
            child: const Icon(
              Icons.announcement,
              color: Colors.white,
              size: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 15,
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
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return '\$${price.toStringAsFixed(2)}';
    } else if (price >= 1) {
      return '\$${price.toStringAsFixed(2)}';
    } else if (price >= 0.01) {
      return '\$${price.toStringAsFixed(4)}';
    } else {
      return '\$${price.toStringAsFixed(8)}';
    }
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

  Widget _buildExchangeInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            '交易所状态',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE6EDF3),
            ),
          ),
        ),
        if (_exchangeInfos.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _exchangeInfos.length,
              itemBuilder: (context, index) {
                final exchange = _exchangeInfos[index];
                return Container(
                  width: 160,
                  margin: EdgeInsets.only(
                      right: index == _exchangeInfos.length - 1 ? 0 : 12),
                  child: _buildExchangeInfoCard(exchange),
                );
              },
            ),
          )
        else
          const ThemedCard(
            child: Text(
              '暂无交易所信息',
              style: TextStyle(
                color: Color(0xFF8B949E),
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExchangeInfoCard(ExchangeInfo exchange) {
    return GestureDetector(
      onTap: () => _showExchangeInfoModal(exchange),
      child: ThemedCard(
        child: SizedBox(
          height: 88, // 固定高度防止溢出
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    exchange.icon,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      exchange.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE6EDF3),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF4ADE80), // 全部改为正常状态
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '正常',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4ADE80),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '24h: \$${_formatVolume(exchange.volume24h)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8B949E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${exchange.tradingPairs} 交易对',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8B949E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExchangeAnnouncementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            '交易所公告',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE6EDF3),
            ),
          ),
        ),
        if (_exchangeAnnouncements.isNotEmpty)
          ..._exchangeAnnouncements
              .map((announcement) => _buildAnnouncementItem(announcement))
        else
          const ThemedCard(
            child: Text(
              '暂无公告',
              style: TextStyle(
                color: Color(0xFF8B949E),
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAnnouncementItem(ExchangeAnnouncement announcement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ThemedCard(
        backgroundColor: announcement.isImportant
            ? const Color(0xFF4A90E2).withOpacity(0.1)
            : null,
        border: announcement.isImportant
            ? Border.all(color: const Color(0xFF4A90E2).withOpacity(0.3))
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  announcement.exchangeIcon,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  announcement.exchangeName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A90E2),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getAnnouncementTypeColor(announcement.type)
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getAnnouncementTypeText(announcement.type),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _getAnnouncementTypeColor(announcement.type),
                    ),
                  ),
                ),
                if (announcement.isImportant) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.priority_high,
                    color: Color(0xFFF87171),
                    size: 16,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              announcement.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE6EDF3),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              announcement.content,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF8B949E),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              _getTimeAgo(announcement.publishedAt),
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

  Color _getAnnouncementTypeColor(ExchangeAnnouncementType type) {
    switch (type) {
      case ExchangeAnnouncementType.announcement:
        return const Color(0xFF4A90E2);
      case ExchangeAnnouncementType.activity:
        return const Color(0xFF4ADE80);
      case ExchangeAnnouncementType.maintenance:
        return const Color(0xFFFBBF24);
      case ExchangeAnnouncementType.listing:
        return const Color(0xFF8B5CF6);
    }
  }

  String _getAnnouncementTypeText(ExchangeAnnouncementType type) {
    switch (type) {
      case ExchangeAnnouncementType.announcement:
        return '公告';
      case ExchangeAnnouncementType.activity:
        return '活动';
      case ExchangeAnnouncementType.maintenance:
        return '维护';
      case ExchangeAnnouncementType.listing:
        return '上币';
    }
  }

  String _formatVolume(double volume) {
    if (volume >= 1000000000) {
      return '${(volume / 1000000000).toStringAsFixed(1)}B';
    } else if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(1)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}K';
    } else {
      return volume.toStringAsFixed(0);
    }
  }

  void _showExchangeInfoModal(ExchangeInfo exchange) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1E2D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      exchange.icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exchange.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE6EDF3),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF4ADE80),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                '服务正常',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4ADE80),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF8B949E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildInfoRow(
                    '24小时交易量', '\$${_formatVolume(exchange.volume24h)}'),
                const SizedBox(height: 16),
                _buildInfoRow('交易对数量', '${exchange.tradingPairs}'),
                const SizedBox(height: 16),
                _buildInfoRow('服务状态', '正常运行'),
                const SizedBox(height: 16),
                _buildInfoRow('成立时间', _getExchangeFoundedYear(exchange.name)),
                const SizedBox(height: 16),
                _buildInfoRow('总部位置', _getExchangeLocation(exchange.name)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4A90E2).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '官方信息',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getExchangeDescription(exchange.name),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFE6EDF3),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '关闭',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF8B949E),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE6EDF3),
          ),
        ),
      ],
    );
  }

  String _getExchangeFoundedYear(String exchangeName) {
    switch (exchangeName) {
      case 'Binance':
        return '2017年';
      case 'OKX':
        return '2017年';
      case 'Coinbase':
        return '2012年';
      case 'Huobi':
        return '2013年';
      case 'Kraken':
        return '2011年';
      default:
        return '未知';
    }
  }

  String _getExchangeLocation(String exchangeName) {
    switch (exchangeName) {
      case 'Binance':
        return '马耳他';
      case 'OKX':
        return '塞舌尔';
      case 'Coinbase':
        return '美国';
      case 'Huobi':
        return '新加坡';
      case 'Kraken':
        return '美国';
      default:
        return '未知';
    }
  }

  String _getExchangeDescription(String exchangeName) {
    switch (exchangeName) {
      case 'Binance':
        return '全球最大的加密货币交易平台之一，提供现货、合约、期权等多种交易服务。支持超过350种加密货币交易，日交易量常居全球第一。';
      case 'OKX':
        return '全球领先的数字资产交易平台，提供现货、衍生品、DeFi等全方位服务。以技术创新和用户体验著称，支持多种交易模式。';
      case 'Coinbase':
        return '美国最大的合规加密货币交易所，纳斯达克上市公司。专注于为机构和零售用户提供安全、合规的数字资产服务。';
      case 'Huobi':
        return '老牌数字资产交易平台，在全球多个国家和地区提供服务。以安全稳定和丰富的产品线闻名，支持多种数字资产交易。';
      case 'Kraken':
        return '成立最早的加密货币交易所之一，以安全性和合规性著称。提供现货、期货、保证金交易等服务，深受专业交易者信赖。';
      default:
        return '优质的数字资产交易平台，为用户提供安全、便捷的交易服务。';
    }
  }
}

class MiniSparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  MiniSparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;

    if (range == 0) return;

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - ((data[i] - minValue) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
