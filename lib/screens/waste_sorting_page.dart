import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/ai_chat_service.dart';

class WasteSortingPage extends StatefulWidget {
  const WasteSortingPage({super.key});

  @override
  State<WasteSortingPage> createState() => _WasteSortingPageState();
}

class _WasteSortingPageState extends State<WasteSortingPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String? _searchResult;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 添加监听器以实时更新UI
    _searchController.addListener(() {
      setState(() {
        // 触发UI更新，使清除按钮能够正确显示
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _searchWaste() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchResult = null;
    });

    FocusScope.of(context).unfocus();

    final aiResponse = await AIChatService.getAIResponse(
      "As a waste sorting expert, please analyze this item: $query. "
          "Please provide a response in the following format:\n\n"
          "1. Classification: [Must be one of these four categories ONLY: Recyclable Waste, Hazardous Waste, Kitchen Waste, or Other Waste]\n"
          "2. Disposal Method: [How to properly dispose of this item]\n"
          "3. Environmental Impact: [Brief explanation of environmental impact]\n"
          "4. Special Instructions: [Any special handling requirements]\n\n"
          "Remember: All waste MUST be classified into one of these four categories:\n"
          "- Recyclable Waste: paper, plastic, metal, glass, etc.\n"
          "- Hazardous Waste: batteries, paint, medicines, fluorescent tubes, etc.\n"
          "- Kitchen Waste: food scraps, fruit peels, tea leaves, etc.\n"
          "- Other Waste: tissues, dust, ceramics, etc.",
      "You are a waste classification expert. Always categorize items into one of the four main categories: Recyclable Waste, Hazardous Waste, Kitchen Waste, or Other Waste. Be precise and consistent.",
    );

    if (mounted) {
      setState(() {
        _isSearching = false;
        _searchResult = aiResponse;
      });
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFF2A2D5F),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Help Guide',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '• Enter any item name to get sorting advice\n'
                  '• Items will be classified into 4 categories:\n'
                  '  - Recyclable Waste\n'
                  '  - Hazardous Waste\n'
                  '  - Kitchen Waste\n'
                  '  - Other Waste\n'
                  '• View detailed disposal methods and environmental impact\n'
                  '• Check common waste types in the guide below',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF8B6BF3),
                          Color(0xFF6B4DE3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Got it',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0B2E),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 160),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_searchResult != null)
                        _buildInfoCard(
                          title: 'Sorting Result',
                          content: _searchResult!,
                          icon: Icons.info_outline,
                        ),
                      if (_searchResult != null) const SizedBox(height: 16),
                      _buildCommonWasteTypes(),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0B2E),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Smart Waste Sorting',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Professional sorting advice',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => _showHelpDialog(context),
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF8B6BF3),
                                    Color(0xFF6B4DE3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF8B6BF3)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.help_outline_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF2A2D5F).withOpacity(0.8),
                                    const Color(0xFF1A1B3F).withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                focusNode: _focusNode,
                                maxLength: 50,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Enter item to search...',
                                  hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _searchResult = null;
                                            });
                                          },
                                        )
                                      : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  counterText: '', // 隐藏字数计数器
                                ),
                                onSubmitted: (_) => _searchWaste(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _searchWaste,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF8B6BF3),
                                    Color(0xFF6B4DE3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF8B6BF3)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isSearching)
                Container(
                  color: const Color(0xFF0A0B2E).withOpacity(0.8),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF8B6BF3)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2D5F),
              Color(0xFF1A1B3F),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8B6BF3),
                      Color(0xFF6B4DE3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B6BF3).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWasteTypeCard({
    required String title,
    required Color color,
    required IconData icon,
    required String examples,
    required String description,
  }) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A2D5F),
              Color(0xFF1A1B3F),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.8),
                      color.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Common items: $examples',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        height: 1.3,
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
  }

  Widget _buildCommonWasteTypes() {
    return Column(
      children: [
        _buildWasteTypeCard(
          title: 'Recyclable Waste',
          color: Colors.blue,
          icon: Icons.recycling,
          examples: 'Paper, plastic, metal, glass',
          description:
              'Items that can be recycled. Clean and dry before recycling.',
        ),
        const SizedBox(height: 12),
        _buildWasteTypeCard(
          title: 'Hazardous Waste',
          color: Colors.red,
          icon: Icons.warning,
          examples: 'Batteries, paint, medicines',
          description: 'Harmful substances requiring special handling.',
        ),
        const SizedBox(height: 12),
        _buildWasteTypeCard(
          title: 'Kitchen Waste',
          color: Colors.green,
          icon: Icons.restaurant,
          examples: 'Food scraps, fruit peels, tea leaves',
          description: 'Food waste that can be composted into fertilizer.',
        ),
        const SizedBox(height: 12),
        _buildWasteTypeCard(
          title: 'Other Waste',
          color: Colors.grey,
          icon: Icons.delete,
          examples: 'Tissues, dust, ceramics',
          description: 'Non-recyclable items that require landfill disposal.',
        ),
      ],
    );
  }
}
