import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coin_model.dart';
import '../models/news_article_model.dart';
import '../models/ai_report_model.dart';
import '../models/exchange_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.coinverse.com'; // Placeholder URL
  static const String deepSeekApiUrl =
      'https://api.deepseek.com/chat/completions';
  static const String deepSeekApiKey = 'sk-e7da5e7ebea04b10b6aec9dcf0232333';

  // Mock data for development
  static Future<List<Coin>> getMarketData() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      // 主流币 - 2025年8月价格
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
      // Layer 2 - 2025年Layer2生态蓬勃发展
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
      // AI 概念 - 2025年AI热潮持续
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
      // RWA 概念 - 2025年现实世界资产代币化兴起
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
      // 稳定币
      Coin(
        id: 'tether',
        name: 'Tether',
        symbol: 'USDT',
        imageUrl: 'https://s2.coinmarketcap.com/static/img/coins/64x64/825.png',
        price: 1.00,
        priceChange24h: 0.01,
        sparklineData: [1.0, 1.0, 0.999, 1.0, 1.001, 1.0, 1.0],
      ),
      Coin(
        id: 'usd-coin',
        name: 'USD Coin',
        symbol: 'USDC',
        imageUrl:
            'https://s2.coinmarketcap.com/static/img/coins/64x64/3408.png',
        price: 1.00,
        priceChange24h: -0.01,
        sparklineData: [1.0, 1.0, 1.001, 1.0, 0.999, 1.0, 1.0],
      ),
      // Meme 币 - 2025年Meme币市场成熟化
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
  }

  static Future<List<NewsArticle>> getNewsData() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      // 精选新闻 (Featured)
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

      // 快讯 (Flash)
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
      NewsArticle(
        id: '21',
        title: 'Near Protocol分片技术升级完成，TPS提升至10万',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 9)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '22',
        title: 'Aptos生态DeFi协议总数突破200个',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 10)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '23',
        title: 'Sui网络日活跃用户数突破100万',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 11)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '24',
        title: 'Ethereum Name Service域名注册量突破300万',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '25',
        title: 'OpenSea NFT交易量环比增长150%',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 13)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '26',
        title: 'Blur NFT市场份额超越OpenSea',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 14)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '27',
        title: 'Magic Eden推出以太坊NFT交易功能',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 15)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '28',
        title: 'Lido质押ETH数量突破1000万枚',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 16)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '29',
        title: 'Rocket Pool去中心化质押协议TVL创新高',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 17)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '30',
        title: 'Frax Finance推出新一代稳定币FRAX v3',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 18)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '31',
        title: 'Curve Finance治理代币CRV锁仓量创历史新高',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 19)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '32',
        title: 'Convex Finance协议收入突破5亿美元',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 20)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '33',
        title: 'Yearn Finance推出新版本v3策略',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 21)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '34',
        title: 'Compound协议新增支持10种代币抵押',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 22)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '35',
        title: 'Aave协议V4版本开发进度过半',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(hours: 23)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '36',
        title: 'MakerDAO治理投票通过新抵押品提案',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '37',
        title: 'Synthetix协议推出永续合约交易功能',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '38',
        title: 'dYdX V4主网正式上线，支持完全去中心化交易',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '39',
        title: 'GMX协议交易量突破2000亿美元里程碑',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '40',
        title: 'PancakeSwap推出跨链桥接功能',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
        type: ArticleType.flash,
      ),

      // 公告 (Announcement)
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

      // 更多精选新闻
      NewsArticle(
        id: '51',
        title: '摩根大通推出机构级加密货币托管服务',
        source: 'Reuters',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '52',
        title: '高盛计划推出比特币ETF产品',
        source: 'Wall Street Journal',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '53',
        title: '花旗银行开始为机构客户提供加密货币交易服务',
        source: 'Financial News',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 2, hours: 12)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '54',
        title: '富达投资管理公司增持比特币ETF份额',
        source: 'Investment News',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '55',
        title: '贝莱德比特币ETF资产管理规模突破500亿美元',
        source: 'Asset Management',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '56',
        title: '灰度以太坊信托转换为ETF获得SEC批准',
        source: 'SEC Filing',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 3, hours: 12)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '57',
        title: 'Visa推出基于区块链的跨境支付解决方案',
        source: 'Visa Press',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 4)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '58',
        title: 'Mastercard与多家加密货币公司达成合作协议',
        source: 'Mastercard News',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 4, hours: 6)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '59',
        title: 'PayPal扩大加密货币服务至欧洲市场',
        source: 'PayPal Official',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 4, hours: 12)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '60',
        title: 'Square更名为Block，全面拥抱Web3生态',
        source: 'Block Inc',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        type: ArticleType.featured,
      ),

      // 更多快讯
      NewsArticle(
        id: '61',
        title: 'Tesla持有的比特币价值突破20亿美元',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '62',
        title: 'MicroStrategy再次购买1000枚比特币',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '63',
        title: 'El Salvador比特币储备增至5000枚',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 6)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '64',
        title: '中非共和国宣布比特币为法定货币',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '65',
        title: '日本央行开始数字日元试点项目',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 2, hours: 10)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '66',
        title: '欧洲央行CBDC项目进入第二阶段测试',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 2, hours: 12)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '67',
        title: '中国数字人民币试点城市扩展至50个',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 2, hours: 14)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '68',
        title: '英国金融监管局发布加密货币新规草案',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 2, hours: 16)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '69',
        title: '新加坡金管局批准首批数字银行牌照',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 2, hours: 18)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '70',
        title: '香港证监会推出虚拟资产交易平台监管框架',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 2, hours: 20)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '71',
        title: '韩国国会通过数字资产基本法',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 2, hours: 22)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '72',
        title: '澳大利亚储备银行启动CBDC研究项目',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '73',
        title: '加拿大央行发布数字货币研究报告',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '74',
        title: '巴西央行数字货币试点项目正式启动',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '75',
        title: '印度政府考虑推出数字卢比',
        source: '快讯',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 3, hours: 8)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '76',
        title: '俄罗斯央行完成数字卢布首次交易测试',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 3, hours: 10)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '77',
        title: '土耳其里拉数字化项目获得政府支持',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 3, hours: 12)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '78',
        title: '阿联酋推出全球首个国家级NFT战略',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 3, hours: 14)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '79',
        title: '沙特阿拉伯宣布建设区块链经济特区',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 3, hours: 16)),
        type: ArticleType.flash,
      ),
      NewsArticle(
        id: '80',
        title: '以色列央行启动数字谢克尔研究项目',
        source: '快讯',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 3, hours: 18)),
        type: ArticleType.flash,
      ),

      // 更多公告
      NewsArticle(
        id: '81',
        title: 'Uniswap Labs推出移动端钱包应用',
        source: 'Uniswap公告',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 1, hours: 20)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '82',
        title: 'Metamask集成Layer2网络一键切换功能',
        source: 'Metamask公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '83',
        title: 'Trust Wallet支持100+区块链网络',
        source: 'Trust Wallet公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '84',
        title: 'Phantom钱包推出多链支持功能',
        source: 'Phantom公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '85',
        title: 'Rainbow钱包集成NFT展示功能',
        source: 'Rainbow公告',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 2, hours: 12)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '86',
        title: 'Coinbase Wallet推出DeFi收益聚合器',
        source: 'Coinbase Wallet公告',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 2, hours: 16)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '87',
        title: 'Ledger硬件钱包支持新增20种代币',
        source: 'Ledger公告',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 2, hours: 20)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '88',
        title: 'Trezor推出新一代硬件钱包Model T Pro',
        source: 'Trezor公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '89',
        title: 'SafePal钱包推出Web3浏览器功能',
        source: 'SafePal公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 3, hours: 4)),
        type: ArticleType.announcement,
      ),
      NewsArticle(
        id: '90',
        title: 'Exodus钱包集成去中心化交易功能',
        source: 'Exodus公告',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 3, hours: 8)),
        type: ArticleType.announcement,
      ),

      // 最后10条精选新闻
      NewsArticle(
        id: '91',
        title: 'Web3社交平台用户数突破1亿，去中心化社交成为新趋势',
        source: 'Web3 Times',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 4)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '92',
        title: '元宇宙房地产交易量创历史新高，虚拟土地价格飙升',
        source: 'Metaverse News',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 4, hours: 6)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '93',
        title: 'DAO治理代币总市值突破1000亿美元，去中心化治理成主流',
        source: 'DAO Report',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 4, hours: 12)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '94',
        title: '跨链桥协议安全性大幅提升，多链生态互操作性增强',
        source: 'Cross Chain Daily',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '95',
        title: '零知识证明技术在DeFi中的应用案例突破100个',
        source: 'ZK Research',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 5, hours: 6)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '96',
        title: '去中心化存储网络总容量突破100PB，Web3基础设施日趋完善',
        source: 'Storage Weekly',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 5, hours: 12)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '97',
        title: '链上身份验证系统用户突破5000万，数字身份主权时代来临',
        source: 'Identity Tech',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 6)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '98',
        title: '预测市场平台交易量创新高，去中心化预测成为投资新工具',
        source: 'Prediction Markets',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 6, hours: 6)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '99',
        title: '合成资产协议TVL突破500亿美元，传统金融资产上链加速',
        source: 'Synthetic Assets',
        imageUrl: null,
        publishedAt:
            DateTime.now().subtract(const Duration(days: 6, hours: 12)),
        type: ArticleType.featured,
      ),
      NewsArticle(
        id: '100',
        title: '全球首个完全去中心化的保险协议正式上线，DeFi保险进入新纪元',
        source: 'DeFi Insurance',
        imageUrl: null,
        publishedAt: DateTime.now().subtract(const Duration(days: 7)),
        type: ArticleType.featured,
      ),
    ];
  }

  static Future<AIReport> getAIReport(String query) async {
    try {
      // 添加伦理道德检查
      if (_containsInvestmentAdviceRequest(query)) {
        return AIReport(
          summary: '抱歉，我不能提供具体的投资建议。投资有风险，请根据自己的风险承受能力做出决策。',
          riskLevel: RiskLevel.medium,
          pros: '建议您：1. 做好充分的研究 2. 分散投资风险 3. 只投资您能承受损失的资金',
          cons: '投资加密货币存在高风险，价格波动剧烈，可能面临全部损失的风险。',
        );
      }

      final systemPrompt = '''你是CoinVerse的专业Web3.0和加密货币分析师VerseAI。请遵循以下原则：

1. 伦理道德限制：
   - 绝不提供具体的投资建议或推荐买卖特定币种
   - 不预测具体价格目标
   - 强调投资风险和DYOR（Do Your Own Research）
   - 提醒用户理性投资，不要投入超过承受能力的资金

2. 分析框架：
   - 提供客观的技术分析和市场趋势
   - 分析项目的技术特点和生态发展
   - 评估风险等级（低、中、高）
   - 给出优势和风险点分析

3. 回答格式：

   - 综合风险评级：低风险/中风险/高风险
   - 优势分析：列出积极因素
   - 风险分析：列出需要注意的风险点

请用中文回答，保持专业和客观。''';

      final response = await http.post(
        Uri.parse(deepSeekApiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $deepSeekApiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': query},
          ],
          'stream': false,
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final aiResponse = data['choices'][0]['message']['content'] as String;

        return _parseAIResponse(aiResponse);
      } else {
        throw Exception('API调用失败: ${response.statusCode}');
      }
    } catch (e) {
      // 如果API调用失败，返回默认响应
      return AIReport(
        summary: '抱歉，AI分析服务暂时不可用，请稍后再试。',
        riskLevel: RiskLevel.medium,
        pros: '建议您通过多个渠道获取信息，进行综合分析',
        cons: '请注意投资风险，理性决策',
      );
    }
  }

  static bool _containsInvestmentAdviceRequest(String query) {
    final investmentKeywords = [
      '买入',
      '卖出',
      '购买',
      '抛售',
      '投资建议',
      '推荐',
      '什么时候买',
      '什么时候卖',
      '价格预测',
      '涨到多少',
      '跌到多少',
      '目标价',
      '止损',
      '止盈'
    ];

    return investmentKeywords
        .any((keyword) => query.toLowerCase().contains(keyword.toLowerCase()));
  }

  static AIReport _parseAIResponse(String response) {
    // 简单的响应解析，实际项目中可以使用更复杂的解析逻辑
    final lines = response.split('\n');
    String summary = '';
    String pros = '';
    String cons = '';
    RiskLevel riskLevel = RiskLevel.medium;

    for (String line in lines) {
      if (line.contains('总结') || line.contains('概括')) {
        summary = line.replaceAll(RegExp(r'^[^：:]*[：:]'), '').trim();
      } else if (line.contains('优势') || line.contains('积极')) {
        pros = line.replaceAll(RegExp(r'^[^：:]*[：:]'), '').trim();
      } else if (line.contains('风险') || line.contains('注意')) {
        cons = line.replaceAll(RegExp(r'^[^：:]*[：:]'), '').trim();
      } else if (line.contains('高风险')) {
        riskLevel = RiskLevel.high;
      } else if (line.contains('低风险')) {
        riskLevel = RiskLevel.low;
      }
    }

    // 如果解析失败，使用整个响应作为总结
    if (summary.isEmpty) {
      summary =
          response.length > 200 ? '${response.substring(0, 200)}...' : response;
    }
    if (pros.isEmpty) {
      pros = '请进行深入研究，了解项目的技术特点和发展前景';
    }
    if (cons.isEmpty) {
      cons = '加密货币投资存在高风险，价格波动剧烈，请谨慎投资';
    }

    return AIReport(
      summary: summary,
      riskLevel: riskLevel,
      pros: pros,
      cons: cons,
    );
  }

  // 获取预设问题
  static List<String> getPresetQuestions() {
    return [
      '什么是Web3.0？它与Web2.0有什么区别？',
      '解释一下DeFi（去中心化金融）的基本概念',
      '什么是Layer2扩容方案？主要有哪些类型？',
      'NFT的价值来源是什么？',
      '什么是DAO（去中心化自治组织）？',
      '解释区块链的共识机制有哪些？',
      '什么是跨链技术？为什么重要？',
      '智能合约的安全风险有哪些？',
      '什么是流动性挖矿？',
      '解释一下零知识证明技术',
      '什么是元宇宙？与区块链有什么关系？',
      '加密货币钱包的类型和安全性如何？',
    ];
  }

  // 获取交易所公告
  static Future<List<ExchangeAnnouncement>> getExchangeAnnouncements() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      // 重要公告
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
        id: '3',
        title: 'Coinbase Pro系统维护通知',
        content: '将于北京时间8月6日02:00-04:00进行系统维护，期间暂停交易',
        exchangeName: 'Coinbase',
        exchangeIcon: '🔵',
        type: ExchangeAnnouncementType.maintenance,
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        isImportant: false,
      ),
      ExchangeAnnouncement(
        id: '4',
        title: 'Huobi Global手续费优惠活动',
        content: '现货交易手续费8折优惠，活动期间至8月31日',
        exchangeName: 'Huobi',
        exchangeIcon: '🔴',
        type: ExchangeAnnouncementType.activity,
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        isImportant: false,
      ),
      ExchangeAnnouncement(
        id: '5',
        title: 'Kraken新增支持MATIC质押',
        content: 'Polygon (MATIC) 质押服务现已上线，年化收益率约8%',
        exchangeName: 'Kraken',
        exchangeIcon: '🟣',
        type: ExchangeAnnouncementType.announcement,
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        isImportant: false,
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
  }

  // 获取交易所信息
  static Future<List<ExchangeInfo>> getExchangeInfo() async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
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

  static Future<String> getDailyInsight() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return 'BTC突破95K创历史新高，市场进入超级牛市阶段。AI分析显示Layer2和AI概念币种将迎来新一轮爆发，建议关注技术面突破信号。';
  }
}
