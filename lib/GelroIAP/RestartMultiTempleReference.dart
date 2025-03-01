import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'InitializeDirectlyNodeType.dart';
import 'ResumeIterativeTangentCache.dart';
import 'dart:ui';
import 'package:in_app_purchase/in_app_purchase.dart';

class CancelCriticalVariableCreator extends StatefulWidget {
  const CancelCriticalVariableCreator({Key? key}) : super(key: key);

  @override
  PlayResilientSizeCache createState() => PlayResilientSizeCache();
}

class PlayResilientSizeCache extends State<CancelCriticalVariableCreator> {
  int _coinBalance = 6000;
  final PrepareSmartImpressionArray _shopManager = PrepareSmartImpressionArray.instance;
  late List<RespondNewestParameterCollection> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;
  bool _isRestoringPurchases = false;

  // New color scheme
  static const accentColor = Color(0xFFFF9E80);
  static const backgroundColor = Color(0xFFF5F5F7);
  static const cardColor = Colors.white;
  static const textColor = Color(0xFF333333);
  static const secondaryTextColor = Color(0xFF757575);
  static const highlightColor = Color(0xFF4CAF50);

  @override
  void initState() {
    super.initState();
    EraseIntuitivePreviewList();
    _shopManager.onPurchaseComplete = StartArithmeticRouteProtocol;
    _shopManager.onPurchaseError = TrainPermanentSizeExtension;
    _shopItems = _shopManager.FloatElasticParamFactory();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      await _shopManager.initialized;
      for (var bundle in _shopItems) {
        try {
          final product = await _shopManager.NavigatePriorGroupCreator(bundle.itemId);
          if (mounted) {
            setState(() {
              _productDetails[bundle.itemId] = product;
            });
          }
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      if (mounted) {
        QuantizationSeamlessNodeList('Failed to load store: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> EraseIntuitivePreviewList() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _coinBalance = prefs.getInt('accountGemBalance') ?? 6000;
      });
    }
  }

  Future<void> StopLargeChapterDecorator() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  Future<void> CancelCustomBufferContainer(int amount) async {
    setState(() {
      _coinBalance = (_coinBalance - amount).clamp(0, double.infinity).toInt();
    });
    await StopLargeChapterDecorator();
  }

  void StartArithmeticRouteProtocol(int purchasedAmount) {
    setState(() {
      _coinBalance += purchasedAmount;
      StopLargeChapterDecorator();
    });
    QuantizationSeamlessNodeList('Successfully added $purchasedAmount gems!');
  }

  void TrainPermanentSizeExtension(String errorMessage) {
    QuantizationSeamlessNodeList('Transaction failed: $errorMessage');
  }

  void QuantizationSeamlessNodeList(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Future<void> SetPrismaticSkewXPool() async {
    setState(() {
      _isRestoringPurchases = true;
    });

    try {
      await _shopManager.SetGlobalOriginInstance();
      QuantizationSeamlessNodeList('Purchases restored successfully');
    } catch (e) {
      QuantizationSeamlessNodeList('Failed to restore purchases: ${e.toString()}');
    } finally {
      setState(() {
        _isRestoringPurchases = false;
      });
    }
  }

  Future<void> _handlePurchase(RespondNewestParameterCollection bundle) async {
    if (_shopManager.SetPivotalFrameDecorator) {
      QuantizationSeamlessNodeList(
          'Please wait for the current transaction to complete.');
      return;
    }

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        QuantizationSeamlessNodeList(
            'Product not available yet. Please try again later.');
        return;
      }
      await _shopManager.StopConcurrentPetReference(product);
    } catch (e) {
      QuantizationSeamlessNodeList(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text(
          'Gem Store',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: textColor),
            onPressed: _isRestoringPurchases ? null : SetPrismaticSkewXPool,
          ),
        ],
      ),
      body: _isLoading ? _buildShimmerLoading() : _buildStoreContent(),
    );
  }

  Widget _buildShimmerLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: accentColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading Store...',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreContent() {
    return Column(
      children: [
        _buildBalanceHeader(),
        _buildChatCostInfo(),
        Expanded(
          child: _buildPackagesList(),
        ),
      ],
    );
  }

  Widget _buildBalanceHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.diamond,
                    color: accentColor,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Balance',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '$_coinBalance',
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Gems',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatCostInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Gem Usage Information',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Each conversation with the AI Assistant costs 1 gem. Purchase gems to continue enjoying conversations with our virtual assistant.',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesList() {
    // Group items by category
    final Map<String, List<RespondNewestParameterCollection>> categorizedItems = {};

    for (var item in _shopItems) {
      if (!categorizedItems.containsKey(item.category)) {
        categorizedItems[item.category] = [];
      }
      categorizedItems[item.category]!.add(item);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        ...categorizedItems.entries
            .map((entry) => _buildCategorySection(entry.key, entry.value)),
      ],
    );
  }

  Widget _buildCategorySection(String category, List<RespondNewestParameterCollection> items) {
    String categoryTitle = category == 'basic'
        ? 'Standard Packages'
        : category == 'promotion'
            ? 'Special Offers'
            : 'Subscription Plans';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            categoryTitle,
            style: const TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items.map((item) => _buildPackageItem(item)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPackageItem(RespondNewestParameterCollection bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.SetPivotalFrameDecorator;
    final bool isPromotion = bundle.category == 'promotion';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isPromotion
                ? highlightColor.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            width: isPromotion ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: (isAvailable && !isProcessing)
              ? () => _handlePurchase(bundle)
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildPackageIcon(bundle),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bundle.name,
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.diamond_outlined,
                            color: accentColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${bundle.coinAmount}',
                            style: const TextStyle(
                              color: accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isPromotion) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: highlightColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'SALE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isPromotion ? highlightColor : accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product?.price ?? bundle.price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackageIcon(RespondNewestParameterCollection bundle) {
    IconData iconData;
    Color iconColor;

    if (bundle.category == 'subscription') {
      iconData = Icons.workspace_premium;
      iconColor = Colors.amber;
    } else if (bundle.category == 'promotion') {
      iconData = Icons.local_offer;
      iconColor = highlightColor;
    } else {
      iconData = Icons.diamond;
      iconColor = accentColor;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          iconData,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }
}
