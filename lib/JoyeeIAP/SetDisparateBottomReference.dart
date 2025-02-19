import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'StopPrismaticAnimationBase.dart';
import 'GetMainQueueFilter.dart';
import 'dart:ui';
import 'package:in_app_purchase/in_app_purchase.dart';

class ContinueSimilarMultiplicationList extends StatefulWidget {
  const ContinueSimilarMultiplicationList({Key? key}) : super(key: key);

  @override
  RestartMediocreTempleDecorator createState() =>
      RestartMediocreTempleDecorator();
}

class RestartMediocreTempleDecorator
    extends State<ContinueSimilarMultiplicationList>
    with SingleTickerProviderStateMixin {
  int _coinBalance = 6000;
  final GetOtherInitiatorsList _shopManager = GetOtherInitiatorsList.instance;
  late List<InitializeAdvancedAnalogyManager> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = false;

  // New modern color scheme
  static const primaryColor = Color(0xFF7C4DFF); // Deep purple
  static const secondaryColor = Color(0xFFFF6B6B); // Coral pink
  static const accentColor = Color(0xFF00BFA5); // Teal
  static const backgroundColor = Color(0xFF0A0F1E); // Dark navy
  static const surfaceColor = Color(0xFF1A1F2E); // Lighter navy
  static const cardGradientStart = Color(0xFF2A2D3E);
  static const cardGradientEnd = Color(0xFF1F2233);

  late AnimationController _animController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _slideAnimation;

  bool _isRestoringPurchases = false;

  @override
  void initState() {
    super.initState();
    StartAccordionGridProtocol();
    _shopManager.onPurchaseComplete = SyncCrucialColorCreator;
    _shopManager.onPurchaseError = PrepareAsynchronousValueObserver;
    _shopItems = shopInventory;
    _loadProducts();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
  }

  Future<void> _loadProducts() async {
    try {
      await _shopManager.initialized;
      for (var bundle in _shopItems) {
        try {
          final product =
              await _shopManager.GenerateElasticParamAdapter(bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      GetDiversifiedCapsuleManager('Failed to load store: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> StartAccordionGridProtocol() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 6000;
    });
  }

  Future<void> ResizeCriticalGroupCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  Future<void> DecoupleCrudeOptionStack(int amount) async {
    setState(() {
      _coinBalance = (_coinBalance - amount).clamp(0, double.infinity).toInt();
    });
    await ResizeCriticalGroupCache();
  }

  void SyncCrucialColorCreator(int purchasedAmount) {
    setState(() {
      _coinBalance += purchasedAmount;
      ResizeCriticalGroupCache();
    });
    GetDiversifiedCapsuleManager('Successfully added $purchasedAmount gems!');
  }

  void PrepareAsynchronousValueObserver(String errorMessage) {
    GetDiversifiedCapsuleManager('Transaction failed: $errorMessage');
  }

  void GetDiversifiedCapsuleManager(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> QuitGeometricSubpixelList() async {
    setState(() {
      _isRestoringPurchases = true;
    });

    try {
      await _shopManager.GetTensorMetadataCollection();
      GetDiversifiedCapsuleManager('Purchases restored successfully');
    } catch (e) {
      GetDiversifiedCapsuleManager(
          'Failed to restore purchases: ${e.toString()}');
    } finally {
      setState(() {
        _isRestoringPurchases = false;
      });
    }
  }

  Future<void> _handlePurchase(InitializeAdvancedAnalogyManager bundle) async {
    if (_shopManager.DetachLastDistinctionReference) {
      GetDiversifiedCapsuleManager(
          'Please wait for the current transaction to complete.');
      return;
    }

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        GetDiversifiedCapsuleManager(
            'Product not available yet. Please try again later.');
        return;
      }
      await _shopManager.GetDenseChapterManager(product);
    } catch (e) {
      GetDiversifiedCapsuleManager(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  backgroundColor,
                  backgroundColor.withOpacity(0.8),
                  backgroundColor.withOpacity(0.6),
                ],
              ),
            ),
          ),
          // Main content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildGlassHeader(),
              SliverToBoxAdapter(child: _buildPremiumBalance()),
              _buildSubscriptionSection(),
              _buildBasicSection(),
              _buildBundleSection(),
              _buildCollectionSection(),
              _buildAudioSection(),
              const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGlassHeader() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FlexibleSpaceBar(
            title: const Text(
              'Premium Store',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor.withOpacity(0.1),
                    secondaryColor.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.restore, color: Colors.white),
          onPressed: QuitGeometricSubpixelList,
        ),
      ],
    );
  }

  Widget _buildPremiumBalance() {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cardGradientStart.withOpacity(0.9),
                    cardGradientEnd.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Balance',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildShiningCoinIcon(),
                              const SizedBox(width: 12),
                              Text(
                                '$_coinBalance',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: accentColor,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.smart_toy_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'AI Assistant Usage',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Use your coins to chat with AI Assistant. Each conversation costs 1 coin.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShiningCoinIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD700),
            Color(0xFFFFA500),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.stars_rounded,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    final subscriptionItems =
        _shopItems.where((item) => item.category == 'subscription').toList();
    if (subscriptionItems.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                const Icon(
                  Icons.workspace_premium,
                  color: secondaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Subscription Plans',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'BEST VALUE',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 380, // Increased from 320 to 380 for more space
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: subscriptionItems.length,
              itemBuilder: (context, index) {
                return _buildSubscriptionCard(subscriptionItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(InitializeAdvancedAnalogyManager bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.DetachLastDistinctionReference;

    return Container(
      width: 300,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            secondaryColor.withOpacity(0.8),
            primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: (isAvailable && !isProcessing)
              ? () => _handlePurchase(bundle)
              : null,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        bundle.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                        maxHeight: 200), // Increased from 160 to 200
                    child: SingleChildScrollView(
                      child: Text(
                        bundle.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 16), // Increased from 12 to 16 for better spacing
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.diamond_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${bundle.coinAmount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _buildPremiumPriceTag(product?.price ?? bundle.price),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicSection() {
    final basicItems =
        _shopItems.where((item) => item.category == 'basic').toList();
    if (basicItems.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Icon(
                  Icons.diamond_outlined,
                  color: secondaryColor,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Basic Packs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220, // Increased from 180 to 220
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: basicItems.length,
              itemBuilder: (context, index) {
                return _buildBasicPackCard(basicItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicPackCard(InitializeAdvancedAnalogyManager bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.DetachLastDistinctionReference;

    return Container(
      width: 160,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cardGradientStart,
            cardGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: (isAvailable && !isProcessing)
              ? () => _handlePurchase(bundle)
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Add this
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.diamond_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  bundle.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${bundle.coinAmount} Coins',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                _buildPremiumPriceTag(product?.price ?? bundle.price),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBundleSection() {
    final bundleItems =
        _shopItems.where((item) => item.category == 'bundle').toList();
    if (bundleItems.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Icon(
                  Icons.card_giftcard,
                  color: secondaryColor,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Special Bundles',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220, // Updated height
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: bundleItems.length,
              itemBuilder: (context, index) {
                return _buildBasicPackCard(bundleItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionSection() {
    final collectionItems =
        _shopItems.where((item) => item.category == 'collection').toList();
    if (collectionItems.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Icon(
                  Icons.collections_bookmark,
                  color: secondaryColor,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Collections',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220, // Updated height
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: collectionItems.length,
              itemBuilder: (context, index) {
                return _buildBasicPackCard(collectionItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSection() {
    final audioItems =
        _shopItems.where((item) => item.category == 'audio').toList();
    if (audioItems.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Icon(
                  Icons.music_note,
                  color: secondaryColor,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Audio Packs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220, // Updated height
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: audioItems.length,
              itemBuilder: (context, index) {
                return _buildBasicPackCard(audioItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPriceTag(String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            secondaryColor,
            primaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        price,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
