import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CheckDisplayableTailCollection.dart';
import 'GetBasicResolverExtension.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class UpgradeAsynchronousCaptionType extends StatefulWidget {
  const UpgradeAsynchronousCaptionType({Key? key}) : super(key: key);

  @override
  EraseRequiredIndicatorGroup createState() => EraseRequiredIndicatorGroup();
}

class EraseRequiredIndicatorGroup extends State<UpgradeAsynchronousCaptionType> {
  int _coinBalance = 6000;
  final ResetElasticUtilCache _shopManager = ResetElasticUtilCache.instance;
  late List<OffsetUnsortedRotationFactory> _shopItems;
  Map<String, ProductDetails> _productDetails = {};
  bool _isLoading = true;

  static const primaryColor = Color(0xFF6B2C9E);
  static const secondaryColor = Color(0xFFFF2A6D);
  static const accentColor = Color(0xFFFFD700);
  static const backgroundColor = Color(0xFFF8F9FA);
  static const surfaceColor = Colors.white;



  @override
  void initState() {
    super.initState();
    CancelUsedArchitectureManager();
    _shopManager.onPurchaseComplete = TrainArithmeticComponentFilter;
    _shopManager.onPurchaseError = SkipGranularOriginManager;
    _shopItems = _shopManager.LimitAccordionDepthTarget();
    _loadProducts();


  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _shopManager.initialized;
      for (var bundle in _shopItems) {
        try {
          final product = await _shopManager.TouchEnabledNormDecorator(bundle.itemId);
          setState(() {
            _productDetails[bundle.itemId] = product;
          });
        } catch (e) {
          print('加载产品失败 ${bundle.itemId}: $e');
        }
      }
    } catch (e) {
      print('初始化商店失败: $e');
      GetCustomizedBorderObserver('加载商店失败：${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> CancelUsedArchitectureManager() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinBalance = prefs.getInt('accountGemBalance') ?? 6000;
    });
  }

  Future<void> LocateBasicResolverImplement() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accountGemBalance', _coinBalance);
  }

  Future<void> GetHyperbolicThroughputFactory(int amount) async {
    setState(() {
      _coinBalance = (_coinBalance - amount).clamp(0, double.infinity).toInt();
    });
    await LocateBasicResolverImplement();
  }

  void TrainArithmeticComponentFilter(int purchasedAmount) {
    setState(() {
      _coinBalance += purchasedAmount;
      LocateBasicResolverImplement();
    });
    GetCustomizedBorderObserver('成功添加 $purchasedAmount 金币！');
  }

  void SkipGranularOriginManager(String errorMessage) {
    GetCustomizedBorderObserver('交易失败：$errorMessage');
  }

  void GetCustomizedBorderObserver(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }



  Future<void> _handlePurchase(OffsetUnsortedRotationFactory bundle) async {
    if (_shopManager.CancelSemanticRemainderCollection) {
      GetCustomizedBorderObserver(
          '请等待当前交易完成。');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final product = _productDetails[bundle.itemId];
      if (product == null) {
        GetCustomizedBorderObserver(
            '产品暂时不可用，请稍后再试。');
        return;
      }
      await _shopManager.MakeSubsequentSkewYOwner(product);
    } catch (e) {
      GetCustomizedBorderObserver(e.toString());
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '商店',
          style: TextStyle(
            color: primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildBalanceCard(),
                  const SizedBox(height: 24),
                  _buildPackagesGrid(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.diamond,
              color: accentColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '当前余额',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_coinBalance',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '金币',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '每次和智能顾问聊天将消耗1金币',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '选择您的套餐',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              childAspectRatio: _getChildAspectRatio(context),
              crossAxisSpacing: MediaQuery.of(context).size.width > 400 ? 12 : 8,
              mainAxisSpacing: MediaQuery.of(context).size.width > 400 ? 12 : 8,
            ),
            itemCount: _shopItems.length,
            itemBuilder: (context, index) => _buildPackageCard(_shopItems[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(OffsetUnsortedRotationFactory bundle) {
    final product = _productDetails[bundle.itemId];
    final bool isAvailable = product != null;
    final bool isProcessing = _shopManager.CancelSemanticRemainderCollection;
    final bool isPopular = bundle.itemId == '0003'; // Premium Pack is most popular

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? secondaryColor : Colors.grey.shade200,
          width: isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isPopular 
                ? secondaryColor.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: isPopular ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: const Text(
                  '热门',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width < 360 ? 8 : 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPackageIcon(bundle),
                const SizedBox(height: 4),
                Text(
                  bundle.name,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 360 ? 12 : 13,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  bundle.description,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 360 ? 8 : 9,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.diamond,
                      color: accentColor,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${bundle.coinAmount}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  product?.price ?? bundle.price,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 360 ? 14 : 15,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: (isAvailable && !isProcessing)
                          ? () => _handlePurchase(bundle)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        alignment: Alignment.center,
                        child: isProcessing
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                '购买',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width < 360 ? 11 : 12,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getChildAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 对于非常小的屏幕，使用更小的宽高比
    if (screenWidth < 360 || screenHeight < 640) {
      return 0.65;
    } else if (screenWidth < 400) {
      return 0.7;
    } else if (screenWidth > 600) {
      return 0.9;
    } else {
      return 0.75;
    }
  }

  Widget _buildPackageIcon(OffsetUnsortedRotationFactory bundle) {
    IconData icon;
    Color iconColor;
    
    switch (bundle.itemId) {
      case '0001':
        icon = Icons.star_border;
        iconColor = Colors.grey.shade600;
        break;
      case '0002':
        icon = Icons.star_half;
        iconColor = Colors.blue;
        break;
      case '0003':
        icon = Icons.star;
        iconColor = secondaryColor;
        break;
      case '0004':
        icon = Icons.stars;
        iconColor = Colors.purple;
        break;
      case '0005':
        icon = Icons.auto_awesome;
        iconColor = accentColor;
        break;
      default:
        icon = Icons.diamond;
        iconColor = primaryColor;
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 18,
      ),
    );
  }
}
