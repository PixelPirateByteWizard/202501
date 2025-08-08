import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/trading_pair.dart';

/// Repository for fetching trading pair data
class MarketRepository {
  // 使用真实接口获取行情（USD优先）
  Future<List<TradingPair>> getTradingPairs() async {
    try {
      final uri = Uri.parse(
          'https://ticker-api.cointelegraph.com/rates/index?fiatSymbol=USD&page=1&rowCount=50');
      final resp = await http.get(uri, headers: {
        'user-agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36',
      });
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final List<dynamic> rates = data['rates'] as List<dynamic>;
        final random = Random();
        final List<TradingPair> result = rates.map((e) {
          final m = e as Map<String, dynamic>;
          final symbol = (m['cryptoSymbol'] ?? '').toString();
          final name = (m['name'] ?? '').toString();
          final price = double.tryParse((m['price'] ?? '0').toString()) ?? 0.0;
          final change24h = (m['change24h'] as num?)?.toDouble() ?? 0.0;
          final vol = double.tryParse((m['volume24h'] ?? '0').toString()) ?? 0.0;

          // 构造UI需要的字段
          final buy = price * (1 + 0.0005);
          final sell = price * (1 - 0.0005);
          final trend = change24h >= 0 ? 'up' : 'down';
          final chart = List<double>.generate(20, (i) {
            final noise = (random.nextDouble() - 0.5) * price * 0.01;
            return price + noise + i * (change24h / 100.0) * price * 0.01;
          });
          final volumeB = vol / 1e9; // 以十亿美元显示
          final categories = ['Major', 'Altcoin', 'DeFi', 'Meme'];
          final category = symbol == 'BTC' || symbol == 'ETH'
              ? 'Major'
              : categories[random.nextInt(categories.length)];

          return TradingPair(
            id: '${symbol.isNotEmpty ? symbol : name}/USD',
            buyRate: buy,
            sellRate: sell,
            changePercent: change24h,
            trend: trend,
            summary: '$name 实时价格更新',
            chartData: chart,
            category: category,
            volume: volumeB.isFinite ? volumeB : 0,
            volatility: (random.nextDouble() * 100).clamp(10, 95),
            technicalIndicators: const {},
            marketSentiment: change24h >= 2
                ? 'Bullish'
                : (change24h <= -2 ? 'Bearish' : 'Neutral'),
          );
        }).toList();
        return result;
      }
      throw Exception('status ${resp.statusCode}');
    } catch (_) {
      // 失败时退回到mock
      return _mockPairs();
    }
  }

  Future<List<TradingPair>> getTopTradingPairs() async {
    try {
      final all = await getTradingPairs();
      all.sort((a, b) => b.volume.compareTo(a.volume));
      return all.take(10).toList();
    } catch (_) {
      return _mockPairs().take(3).toList();
    }
  }

  // Added method to get pairs by category
  Future<Map<String, List<TradingPair>>> getTradingPairsByCategory() async {
    final allPairs = await getTradingPairs();
    final Map<String, List<TradingPair>> categorizedPairs = {};

    for (final pair in allPairs) {
      if (!categorizedPairs.containsKey(pair.category)) {
        categorizedPairs[pair.category] = [];
      }
      categorizedPairs[pair.category]!.add(pair);
    }

    return categorizedPairs;
  }

  List<TradingPair> _mockPairs() {
    return [
      TradingPair(
        id: 'BTC/USD',
        buyRate: 67432.25,
        sellRate: 67420.80,
        changePercent: 2.34,
        trend: 'up',
        summary: '比特币突破67000美元，机构投资者持续流入',
        chartData: [40, 50, 45, 60, 55, 65, 70],
        category: 'Major',
        volume: 32.8,
        volatility: 58,
      ),
      TradingPair(
        id: 'ETH/USD',
        buyRate: 3425.75,
        sellRate: 3424.50,
        changePercent: -0.88,
        trend: 'down',
        summary: '以太坊网络拥堵，Gas费用创近期新高',
        chartData: [50, 30, 45, 35, 60, 40, 50],
        category: 'Major',
        volume: 18.4,
        volatility: 45,
      ),
      TradingPair(
        id: 'SOL/USD',
        buyRate: 142.05,
        sellRate: 141.92,
        changePercent: 3.32,
        trend: 'up',
        summary: 'Solana生态系统DApp数量突破新高',
        chartData: [42, 45, 48, 52, 55, 58, 62],
        category: 'Altcoin',
        volume: 5.3,
        volatility: 65,
      ),
    ];
  }
}
