import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PrepareDeclarativeSliderCollection.dart';
import 'QuantizerNewestHeroHandler.dart';
import 'dart:ui';
import 'package:in_app_purchase/in_app_purchase.dart';

class GetNextDescriptionHandler extends StatefulWidget {
  const GetNextDescriptionHandler({Key? key}) : super(key: key);

  @override
  SetLastValueBase createState() => SetLastValueBase();
}

class SetLastValueBase extends State<GetNextDescriptionHandler>
    with SingleTickerProviderStateMixin {
  int _coinBalance = 6000;
  final InitializeResilientSchemaInstance _shopManager =
      InitializeResilientSchemaInstance.instance;
  late List<GetSustainableVolumePool> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;

  // Define game-style theme colors
  static const primaryColor = Color(0xFFFFD700); // Gold
  static const secondaryColor = Color(0xFFFFA500); // Orange
  static const backgroundColor = Color(0xFF1A1A2F); // Dark blue background
  static const surfaceColor = Color(0xFF2A2A40); // Lighter blue
  static const accentColor = Color(0xFFE6B800); // Dark gold

  late AnimationController _animController;
  late Animation<double> _opacityAnimation;

  bool _isRestoringPurchases = false;

  @override
  void initState() {
    super.initState();
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    GetNormalHeadFactory();
    _shopManager.onPurchaseComplete = EqualSymmetricCycleFilter;
    _shopManager.onPurchaseError = DropoutOldMissionDecorator;
    _shopItems = _shopManager.SetElasticTailList();
    _loadProducts();

    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    // Restore screen orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _shopManager.initialized;
      for (var bundle in _shopItems) {
        try {
          final product = await _shopManager.ScheduleSubstantialNumberHandler(
              bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('Failed to load product ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('Failed to initialize shop: $e');
      DecouplePermissiveNumberContainer(
          'Failed to load store: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> GetNormalHeadFactory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 6000;
    });
  }

  Future<void> SetAsynchronousBoundAdapter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  Future<void> GetElasticTimeGroup(int amount) async {
    setState(() {
      _coinBalance = (_coinBalance - amount).clamp(0, double.infinity).toInt();
    });
    await SetAsynchronousBoundAdapter();
  }

  void EqualSymmetricCycleFilter(int purchasedAmount) {
    setState(() {
      _coinBalance += purchasedAmount;
      SetAsynchronousBoundAdapter();
    });
    DecouplePermissiveNumberContainer(
        'Successfully added $purchasedAmount gems!');
  }

  void DropoutOldMissionDecorator(String errorMessage) {
    DecouplePermissiveNumberContainer('Transaction failed: $errorMessage');
  }

  void DecouplePermissiveNumberContainer(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> EmbraceUsedNameBase() async {
    setState(() {
      _isRestoringPurchases = true;
    });

    try {
      await _shopManager.StopUniqueBufferCreator();
      DecouplePermissiveNumberContainer('Purchases restored successfully');
    } catch (e) {
      DecouplePermissiveNumberContainer(
          'Failed to restore purchases: ${e.toString()}');
    } finally {
      setState(() {
        _isRestoringPurchases = false;
      });
    }
  }

  Future<void> _handlePurchase(GetSustainableVolumePool bundle) async {
    if (_shopManager.TrainSimilarLeftPool) {
      DecouplePermissiveNumberContainer(
          'Please wait for the current transaction to complete.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        DecouplePermissiveNumberContainer(
            'Product not available yet. Please try again later.');
        return;
      }
      await _shopManager.PrepareSubstantialCoordManager(product);
    } catch (e) {
      DecouplePermissiveNumberContainer(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/store_background.jpg'), // 需要添加背景图
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              backgroundColor.withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    _buildGameStoreHeader(),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildStoreContent(),
                          ),
                          _buildRightPanel(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildGameStoreHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: primaryColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 16),
              const Text(
                'Spirit Gem Store',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NotoSansTC', // Use Traditional Chinese font
                ),
              ),
            ],
          ),
          _buildBalanceDisplay(),
        ],
      ),
    );
  }

  Widget _buildBalanceDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/coin_icon.png', // Need to add spirit gem icon
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Text(
            '$_coinBalance',
            style: const TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSansTC',
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Spirit Gems',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'NotoSansTC',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hot Items',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSansTC',
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _shopItems.length,
              itemBuilder: (context, index) =>
                  _buildGameItemCard(_shopItems[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameItemCard(GetSustainableVolumePool bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.TrainSimilarLeftPool;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: (isAvailable && !isProcessing)
              ? () => _handlePurchase(bundle)
              : null,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildItemIcon(bundle),
                    const SizedBox(height: 12),
                    Text(
                      bundle.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSansTC',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/coin_icon.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${bundle.coinAmount}',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product?.price ?? bundle.price}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    _buildPurchaseButton(),
                  ],
                ),
              ),
              if (isProcessing)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemIcon(GetSustainableVolumePool bundle) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: primaryColor.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Icon(
        bundle.category == 'subscription'
            ? Icons.workspace_premium_rounded
            : Icons.diamond_rounded,
        color: primaryColor,
        size: 32,
      ),
    );
  }

  Widget _buildPurchaseButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            accentColor,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'Purchase',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSansTC',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.8),
        border: Border(
          left: BorderSide(
            color: primaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     const Text(
      //       '特別優惠',
      //       style: TextStyle(
      //         color: Colors.white,
      //         fontSize: 18,
      //         fontWeight: FontWeight.bold,
      //         fontFamily: 'NotoSansTC',
      //       ),
      //     ),
      //     const SizedBox(height: 16),
      //     _buildPromotionCard(),
      //     const Spacer(),
      //     // _buildRestorePurchasesButton(),
      //   ],
      // ),
    );
  }

  Widget _buildPromotionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.2),
            accentColor.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: const Column(
        children: [
          Text(
            'First Purchase Double',
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSansTC',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'First purchase of any item gets double Spirit Gem rewards',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontFamily: 'NotoSansTC',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget _buildRestorePurchasesButton() {
  //   return TextButton(
  //     onPressed: _isRestoringPurchases ? null : EmbraceUsedNameBase,
  //     style: TextButton.styleFrom(
  //       padding: const EdgeInsets.symmetric(vertical: 12),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         if (_isRestoringPurchases)
  //           const SizedBox(
  //             width: 16,
  //             height: 16,
  //             child: CircularProgressIndicator(
  //               strokeWidth: 2,
  //               valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
  //             ),
  //           )
  //         else
  //           const Icon(Icons.restore, color: primaryColor),
  //         const SizedBox(width: 8),
  //         const Text(
  //           'Restore Purchases',
  //           style: TextStyle(
  //             color: primaryColor,
  //             fontSize: 14,
  //             fontFamily: 'NotoSansTC',
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
