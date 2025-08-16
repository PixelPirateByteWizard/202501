import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';
import '../../core/models/coin_model.dart';
import '../shell/main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _selectedCoins = [];

  final List<Coin> _availableCoins = [
    Coin(
      id: 'bitcoin',
      name: 'Bitcoin',
      symbol: 'BTC',
      imageUrl: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1.png',
      price: 67890.12,
      priceChange24h: 1.56,
      sparklineData: [],
    ),
    Coin(
      id: 'ethereum',
      name: 'Ethereum',
      symbol: 'ETH',
      imageUrl: 'https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png',
      price: 3450.12,
      priceChange24h: 5.12,
      sparklineData: [],
    ),
    Coin(
      id: 'solana',
      name: 'Solana',
      symbol: 'SOL',
      imageUrl: 'https://s2.coinmarketcap.com/static/img/coins/64x64/5426.png',
      price: 168.45,
      priceChange24h: -1.89,
      sparklineData: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCoins.addAll(['ethereum', 'solana']); // Pre-select some coins
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildSplashPage(),
          _buildIntroPage1(),
          _buildIntroPage2(),
          _buildSetupPage(),
        ],
      ),
    );
  }

  Widget _buildSplashPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.scatter_plot,
            size: 80,
            color: Color(0xFF4A90E2),
          ),
          const SizedBox(height: 20),
          const Text(
            'CoinVerse',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Color(0xFFE6EDF3),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '你的专属AI加密策略师',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8B949E),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 60),
          GestureDetector(
            onTap: () => _nextPage(),
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  '开始体验',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPage1() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _skipToSetup(),
                child: const Text(
                  '跳过',
                  style: TextStyle(
                    color: Color(0xFF8B949E),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1641843993248-34a072b68345?q=80&w=800&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            '厌倦了在信息噪音中迷失？',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE6EDF3),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            '每日海量资讯，真假难辨，机会与风险擦肩而过。',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8B949E),
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildIntroPage2() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _skipToSetup(),
                child: const Text(
                  '跳过',
                  style: TextStyle(
                    color: Color(0xFF8B949E),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1694421132752-63b657e11c1e?q=80&w=800&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            '让 VerseAI 为你提炼决策信号',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE6EDF3),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'AI驱动的情报引擎，将数据转化为可行动的洞察。',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8B949E),
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildSetupPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 80),
          const Text(
            '开启你的智能投资之旅',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE6EDF3),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            '选择你感兴趣的币种，构建你的专属仪表盘。',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8B949E),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: _availableCoins.length,
              itemBuilder: (context, index) {
                final coin = _availableCoins[index];
                final isSelected = _selectedCoins.contains(coin.id);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D3447).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF4A90E2)
                          : Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      coin.imageUrl,
                      width: 40,
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.currency_bitcoin, size: 40);
                      },
                    ),
                    title: Text(
                      coin.name,
                      style: const TextStyle(
                        color: Color(0xFFE6EDF3),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      coin.symbol,
                      style: const TextStyle(
                        color: Color(0xFF8B949E),
                        fontSize: 14,
                      ),
                    ),
                    trailing: Icon(
                      isSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: isSelected
                          ? const Color(0xFF4A90E2)
                          : const Color(0xFF8B949E),
                      size: 28,
                    ),
                    onTap: () => _toggleCoin(coin.id),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _selectedCoins.isNotEmpty ? _completeOnboarding : null,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: _selectedCoins.isNotEmpty
                    ? const Color(0xFF50E3C2)
                    : const Color(0xFF8B949E),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Text(
                  '完成 (${_selectedCoins.length})',
                  style: TextStyle(
                    color: _selectedCoins.isNotEmpty
                        ? const Color(0xFF1A1E2D)
                        : const Color(0xFF2D3447),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: () => _nextPage(),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF4A90E2),
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Center(
          child: Text(
            '继续',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToSetup() {
    _pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _toggleCoin(String coinId) {
    setState(() {
      if (_selectedCoins.contains(coinId)) {
        _selectedCoins.remove(coinId);
      } else {
        _selectedCoins.add(coinId);
      }
    });
  }

  void _completeOnboarding() async {
    await StorageService.saveWatchlist(_selectedCoins);
    await StorageService.setOnboardingComplete();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainShell()),
      );
    }
  }
}
