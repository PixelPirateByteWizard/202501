import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/models/coin_model.dart';
import '../../shared/widgets/themed_card.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List<Coin> _coins = [];
  List<Coin> _filteredCoins = [];
  String _selectedCategory = '全部';
  bool _isCardLayout = true; // 默认卡片布局
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    '全部',
    '主流币',
    'Layer2',
    'AI概念',
    'RWA',
    'Meme'
  ];

  @override
  void initState() {
    super.initState();
    _initializeDefaultData();
    _loadData();
    _searchController.addListener(_filterCoins);
  }

  void _initializeDefaultData() {
    _coins = [
      // 主流币
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
        id: 'binancecoin',
        name: 'BNB',
        symbol: 'BNB',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/1839.png',
        price: 785.30,
        priceChange24h: 1.89,
        sparklineData: [760, 770, 780, 775, 785, 790, 785],
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
      Coin(
        id: 'cardano',
        name: 'Cardano',
        symbol: 'ADA',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/2010.png',
        price: 1.45,
        priceChange24h: 4.12,
        sparklineData: [1.35, 1.38, 1.42, 1.40, 1.44, 1.47, 1.45],
      ),
      Coin(
        id: 'avalanche',
        name: 'Avalanche',
        symbol: 'AVAX',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/5805.png',
        price: 68.90,
        priceChange24h: 2.78,
        sparklineData: [65, 66, 68, 67, 69, 70, 68.9],
      ),
      // Layer 2
      Coin(
        id: 'polygon',
        name: 'Polygon',
        symbol: 'MATIC',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/3890.png',
        price: 2.85,
        priceChange24h: 6.45,
        sparklineData: [2.6, 2.7, 2.8, 2.75, 2.85, 2.9, 2.85],
      ),
      Coin(
        id: 'arbitrum',
        name: 'Arbitrum',
        symbol: 'ARB',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/11841.png',
        price: 4.67,
        priceChange24h: 8.23,
        sparklineData: [4.2, 4.3, 4.5, 4.4, 4.6, 4.7, 4.67],
      ),
      Coin(
        id: 'optimism',
        name: 'Optimism',
        symbol: 'OP',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/11840.png',
        price: 5.89,
        priceChange24h: 7.12,
        sparklineData: [5.4, 5.5, 5.7, 5.6, 5.8, 5.9, 5.89],
      ),
      // AI 概念
      Coin(
        id: 'fetch-ai',
        name: 'Fetch.ai',
        symbol: 'FET',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/3773.png',
        price: 8.45,
        priceChange24h: 15.67,
        sparklineData: [7.2, 7.8, 8.1, 7.9, 8.3, 8.6, 8.45],
      ),
      Coin(
        id: 'singularitynet',
        name: 'SingularityNET',
        symbol: 'AGIX',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/2424.png',
        price: 2.34,
        priceChange24h: 18.92,
        sparklineData: [1.9, 2.0, 2.2, 2.1, 2.3, 2.4, 2.34],
      ),
      Coin(
        id: 'ocean-protocol',
        name: 'Ocean Protocol',
        symbol: 'OCEAN',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/3911.png',
        price: 3.78,
        priceChange24h: 12.45,
        sparklineData: [3.2, 3.4, 3.6, 3.5, 3.7, 3.8, 3.78],
      ),
      // RWA 概念
      Coin(
        id: 'chainlink',
        name: 'Chainlink',
        symbol: 'LINK',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/1975.png',
        price: 35.89,
        priceChange24h: 9.45,
        sparklineData: [32, 33, 35, 34, 36, 37, 35.89],
      ),
      Coin(
        id: 'maker',
        name: 'Maker',
        symbol: 'MKR',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/1518.png',
        price: 4250.60,
        priceChange24h: 5.67,
        sparklineData: [4000, 4100, 4200, 4150, 4250, 4300, 4250],
      ),
      // Meme 币
      Coin(
        id: 'dogecoin',
        name: 'Dogecoin',
        symbol: 'DOGE',
        imageUrl: 'https://s2.coinmarketcap.com/static/img/coins/64x64/74.png',
        price: 0.45,
        priceChange24h: 12.34,
        sparklineData: [0.38, 0.41, 0.43, 0.42, 0.44, 0.46, 0.45],
      ),
      Coin(
        id: 'shiba-inu',
        name: 'Shiba Inu',
        symbol: 'SHIB',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/5994.png',
        price: 0.000089,
        priceChange24h: 25.67,
        sparklineData: [
          0.000065,
          0.000072,
          0.000081,
          0.000078,
          0.000086,
          0.000091,
          0.000089
        ],
      ),
      Coin(
        id: 'pepe',
        name: 'Pepe',
        symbol: 'PEPE',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/24478.png',
        price: 0.0000156,
        priceChange24h: 34.78,
        sparklineData: [
          0.0000098,
          0.000011,
          0.000013,
          0.000012,
          0.000015,
          0.000016,
          0.0000156
        ],
      ),
    ];
    _filteredCoins = _coins;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final coins = await ApiService.getMarketData();
      setState(() {
        _coins = coins;
        _filteredCoins = coins;
      });
    } catch (e) {
      // 即使加载失败也显示页面内容
    }
  }

  void _filterCoins() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCoins = _coins.where((coin) {
        final matchesSearch = coin.name.toLowerCase().contains(query) ||
            coin.symbol.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == '全部' ||
            _getCoinCategory(coin) == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  String _getCoinCategory(Coin coin) {
    // 根据币种ID分类
    if (['bitcoin', 'ethereum', 'binancecoin', 'solana', 'cardano', 'avalanche']
        .contains(coin.id)) {
      return '主流币';
    } else if (['polygon', 'arbitrum', 'optimism'].contains(coin.id)) {
      return 'Layer2';
    } else if (['fetch-ai', 'singularitynet', 'ocean-protocol']
        .contains(coin.id)) {
      return 'AI概念';
    } else if (['chainlink', 'maker'].contains(coin.id)) {
      return 'RWA';
    } else if (['dogecoin', 'shiba-inu', 'pepe'].contains(coin.id)) {
      return 'Meme';
    }
    return '全部';
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterCoins();
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
              '市场',
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
              children: [
                _buildSearchAndLayoutToggle(),
                const SizedBox(height: 16),
                _buildCategoryTabs(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isCardLayout ? _buildCardLayout() : _buildListLayout(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndLayoutToggle() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2D3447),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Color(0xFFE6EDF3)),
              decoration: const InputDecoration(
                hintText: '搜索币种',
                hintStyle: TextStyle(color: Color(0xFF8B949E)),
                prefixIcon: Icon(Icons.search, color: Color(0xFF8B949E)),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2D3447),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isCardLayout = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isCardLayout
                        ? const Color(0xFF4A90E2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.grid_view,
                    color:
                        _isCardLayout ? Colors.white : const Color(0xFF8B949E),
                    size: 20,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isCardLayout = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: !_isCardLayout
                        ? const Color(0xFF4A90E2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.list,
                    color:
                        !_isCardLayout ? Colors.white : const Color(0xFF8B949E),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
            onTap: () => _onCategoryChanged(category),
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

  Widget _buildCardLayout() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: _filteredCoins.length,
      itemBuilder: (context, index) {
        final coin = _filteredCoins[index];
        return _buildCoinCard(coin);
      },
    );
  }

  Widget _buildListLayout() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _filteredCoins.length,
      itemBuilder: (context, index) {
        final coin = _filteredCoins[index];
        return _buildCoinListItem(coin);
      },
    );
  }

  Widget _buildCoinCard(Coin coin) {
    final isPositive = coin.priceChange24h >= 0;
    return ThemedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.network(
                coin.imageUrl,
                width: 32,
                height: 32,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.currency_bitcoin,
                      size: 32, color: Color(0xFF8B949E));
                },
              ),
              const SizedBox(width: 8),
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
                        fontSize: 12,
                        color: Color(0xFF8B949E),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: _buildSparkline(coin.sparklineData, isPositive),
          ),
          const SizedBox(height: 12),
          Text(
            _formatPrice(coin.price),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE6EDF3),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isPositive
                  ? const Color(0xFF4ADE80).withOpacity(0.2)
                  : const Color(0xFFF87171).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${isPositive ? '+' : ''}${coin.priceChange24h.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isPositive
                    ? const Color(0xFF4ADE80)
                    : const Color(0xFFF87171),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinListItem(Coin coin) {
    final isPositive = coin.priceChange24h >= 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3447).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
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
                  coin.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE6EDF3),
                  ),
                ),
                Text(
                  coin.symbol,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8B949E),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            height: 30,
            child: _buildSparkline(coin.sparklineData, isPositive),
          ),
          const SizedBox(width: 16),
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

  Widget _buildSparkline(List<double> data, bool isPositive) {
    if (data.isEmpty) return const SizedBox();

    return CustomPaint(
      size: const Size(80, 30),
      painter: SparklinePainter(
        data: data,
        color: isPositive ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
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
