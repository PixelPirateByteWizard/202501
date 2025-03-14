import 'package:flutter/material.dart';
import '../screens/outfit_display_screen.dart';
import '../services/ad_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StyleSyncScreen extends StatefulWidget {
  const StyleSyncScreen({super.key});

  @override
  State<StyleSyncScreen> createState() => _StyleSyncScreenState();
}

class _StyleSyncScreenState extends State<StyleSyncScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isGenerating = false;
  String? _generatedOutfit;
  final AdService _adService = AdService();
  
  // 添加快速点击计数相关变量
  int _tapCount = 0;
  DateTime? _lastTapTime;

  // 表单数据
  String _selectedGender = 'Male';
  String _selectedAge = '18-25';
  String _selectedOccasion = 'Casual';
  String _selectedSeason = 'Spring';
  String _selectedStyle = 'Modern';
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _preferenceController = TextEditingController();

  // 下拉选项
  final List<String> _genders = ['Male', 'Female'];
  final List<String> _ageGroups = ['18-25', '26-35', '36-45', '46-55', '56+'];
  final List<String> _occasions = [
    'Casual',
    'Business',
    'Formal',
    'Date',
    'Party',
    'Sports',
    'Travel'
  ];
  final List<String> _seasons = ['Spring', 'Summer', 'Autumn', 'Winter'];
  final List<String> _styles = [
    'Modern',
    'Classic',
    'Minimalist',
    'Vintage',
    'Streetwear',
    'Elegant',
    'Sporty'
  ];

  Future<void> _generateOutfit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // 检查使用次数
    int usageCount = await _adService.getUsageCount();
    if (usageCount < 1) {
      _showWatchAdDialog();
      return;
    }
    
    // 消耗一次使用次数
    await _adService.decreaseUsageCount();

    setState(() {
      _isGenerating = true;
    });

    try {
      // 模拟 API 调用延迟
      await Future.delayed(const Duration(seconds: 2));

      // 导航到展示界面
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OutfitDisplayScreen(
              title: 'Modern Casual Look', // 这里可以是 AI 生成的标题
              gender: _selectedGender,
              ageGroup: _selectedAge,
              occasion: _selectedOccasion,
              season: _selectedSeason,
              style: _selectedStyle,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating outfit: $e')),
        );
      }
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }
  
  void _showWatchAdDialog() {
    _adService.displayBannerAd();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usage Limit Reached'),
          content: const Text('You have 0 attempts left. Watch a video to get 10 more attempts?'),
          actions: [
            TextButton(
              onPressed: () {
                _adService.concealBannerAd();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _adService.concealBannerAd();
                _adService.playIncentiveVideo();
                Navigator.of(context).pop();
              },
              child: const Text('Watch Ad'),
            ),
          ],
        );
      },
    );
  }

  void _handleScreenTap() {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!).inSeconds < 3) {
      setState(() {
        _tapCount++;
      });
      
      if (_tapCount >= 10) {
        _showAdTestDialog();
        _tapCount = 0;
      }
    } else {
      setState(() {
        _tapCount = 1;
      });
    }
    _lastTapTime = now;
  }
  
  void _showAdTestDialog() {
    _adService.loadOtherAd();
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black87,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Ad Test Panel",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2.5,
                      children: [
                        _buildAdButton("展示插页1", () => _adService.presentInterstitialAd1()),
                        _buildAdButton("展示插页2", () => _adService.presentInterstitialAd2()),
                        _buildAdButton("展示插页3", () => _adService.presentInterstitialAd3()),
                        _buildAdButton("展示视频1", () => _adService.playIncentiveVideo1()),
                        _buildAdButton("展示视频2", () => _adService.playIncentiveVideo2()),
                        _buildAdButton("展示视频3", () => _adService.playIncentiveVideo3()),
                        _buildAdButton("展示横幅", () => _adService.displayBannerAd()),
                        _buildAdButton("隐藏横幅", () => _adService.concealBannerAd()),
                      ],
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
  
  Widget _buildAdButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        textStyle: const TextStyle(fontSize: 13),
      ),
      child: Text(text),
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _preferenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _handleScreenTap(); // 添加处理屏幕点击的调用
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'StyleSync',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('How to Use StyleSync'),
                    content: const SingleChildScrollView(
                      child: Text(
                        '1. Fill in your personal details\n'
                        '2. Select the occasion and season\n'
                        '3. Choose your preferred style\n'
                        '4. Add any specific preferences\n'
                        '5. Generate your personalized outfit!\n\n'
                        'Tips: Be specific with your preferences for better recommendations!',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Got it'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Personal Info Card
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 32,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Personal Details',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Gender',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  value: _selectedGender,
                                  items: _genders.map((gender) {
                                    return DropdownMenuItem(
                                      value: gender,
                                      child: Text(gender),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Age Group',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  value: _selectedAge,
                                  items: _ageGroups.map((age) {
                                    return DropdownMenuItem(
                                      value: age,
                                      child: Text(age),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAge = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _heightController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 3,
                                        decoration: InputDecoration(
                                          labelText: 'Height (cm)',
                                          counterText: '',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade50,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter height';
                                          }
                                          final height = int.tryParse(value);
                                          if (height == null ||
                                              height < 50 ||
                                              height > 250) {
                                            return 'Enter valid height (50-250)';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _weightController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 3,
                                        decoration: InputDecoration(
                                          labelText: 'Weight (kg)',
                                          counterText: '',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade50,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter weight';
                                          }
                                          final weight = int.tryParse(value);
                                          if (weight == null ||
                                              weight < 20 ||
                                              weight > 200) {
                                            return 'Enter valid weight (20-200)';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Style Preferences Card
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.style,
                                      size: 32,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Style Preferences',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Occasion',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  value: _selectedOccasion,
                                  items: _occasions.map((occasion) {
                                    return DropdownMenuItem(
                                      value: occasion,
                                      child: Text(occasion),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOccasion = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Season',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  value: _selectedSeason,
                                  items: _seasons.map((season) {
                                    return DropdownMenuItem(
                                      value: season,
                                      child: Text(season),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedSeason = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Style',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  value: _selectedStyle,
                                  items: _styles.map((style) {
                                    return DropdownMenuItem(
                                      value: style,
                                      child: Text(style),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedStyle = value!;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _preferenceController,
                                  maxLines: 3,
                                  maxLength: 200,
                                  decoration: InputDecoration(
                                    labelText: 'Additional Preferences',
                                    hintText:
                                        'E.g., preferred colors, specific items to include/avoid',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_generatedOutfit != null) ...[
                          const SizedBox(height: 16),
                          // Outfit Recommendation Card
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.checkroom,
                                        size: 32,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Your Perfect Outfit',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  // Top Wear Section
                                  _buildOutfitSection(
                                    context,
                                    icon: Icons.dry_cleaning,
                                    title: 'Top',
                                    content:
                                        'Light blue cotton Oxford shirt with rolled-up sleeves',
                                  ),
                                  const SizedBox(height: 16),
                                  // Bottom Wear Section
                                  _buildOutfitSection(
                                    context,
                                    icon: Icons.accessibility,
                                    title: 'Bottom',
                                    content: 'Slim-fit dark navy chinos',
                                  ),
                                  const SizedBox(height: 16),
                                  // Footwear Section
                                  _buildOutfitSection(
                                    context,
                                    icon: Icons.water_drop,
                                    title: 'Footwear',
                                    content: 'Brown leather sneakers',
                                  ),
                                  const SizedBox(height: 16),
                                  // Accessories Section
                                  _buildOutfitSection(
                                    context,
                                    icon: Icons.watch,
                                    title: 'Accessories',
                                    content: '''
• Minimalist silver watch
• Brown leather belt matching the shoes
• Classic aviator sunglasses''',
                                  ),
                                  const SizedBox(height: 16),
                                  // Color Coordination Section
                                  _buildOutfitSection(
                                    context,
                                    icon: Icons.palette,
                                    title: 'Color Coordination',
                                    content:
                                        'The light blue shirt pairs perfectly with navy chinos, creating a balanced contrast. Brown leather accessories add warmth and sophistication.',
                                  ),
                                  const SizedBox(height: 16),
                                  // Style Tips Section
                                  _buildOutfitSection(
                                    context,
                                    icon: Icons.lightbulb,
                                    title: 'Style Tips',
                                    content: '''
1. Roll sleeves up to elbow for a casual yet put-together look
2. Ensure the shirt is well-fitted but not tight
3. Chinos should break slightly at the shoes
4. Keep accessories minimal for a clean look''',
                                  ),
                                  const SizedBox(height: 16),
                                  // Weather Suitability
                                  _buildOutfitSection(
                                    context,
                                    icon: Icons.wb_sunny,
                                    title: 'Weather Suitability',
                                    content:
                                        'Perfect for spring days with temperatures between 15-22°C',
                                  ),
                                  const SizedBox(height: 16),
                                  // Occasion Match
                                  _buildOutfitSection(
                                    context,
                                    icon: Icons.event,
                                    title: 'Occasion Match',
                                    content:
                                        'Ideal for casual outings, weekend brunches, or smart-casual work environments',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              // Generate Button
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: _isGenerating ? null : _generateOutfit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isGenerating)
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(right: 12),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        else
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: const Icon(
                              Icons.checkroom,
                              size: 24,
                            ),
                          ),
                        Text(
                          _isGenerating
                              ? 'Creating Your Style...'
                              : 'Generate Outfit',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
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

  Widget _buildOutfitSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
