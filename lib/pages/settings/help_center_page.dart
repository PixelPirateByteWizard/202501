import 'package:flutter/material.dart';

// 白色主题的颜色定义
const Color primaryColor = Color(0xFF6B2C9E);
const Color secondaryColor = Color(0xFFFF2A6D);
const Color backgroundColor = Colors.white;
const Color cardColor = Colors.white;
const Color textColor = Color(0xFF333333);
const Color subtitleColor = Color(0xFF666666);
const Color borderColor = Color(0xFFEEEEEE);

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  List<FAQItem> _filteredFAQs = [];

  final List<FAQItem> _allFAQs = [
    FAQItem(
      question: '如何连接平行现实？',
      answer: '要连接平行现实，请导航到"平行时空"标签并选择一个角色卡片。这将建立与该现实的连接，让您可以与平行宇宙中的自己聊天。',
      category: '平行时空',
    ),
    FAQItem(
      question: '塔罗牌阅读是什么，它们如何工作？',
      answer:
          '塔罗牌阅读使用象征性的卡片，为您的人生道路和潜在的未来提供见解。在"遇见"标签中，您可以选择卡片，并根据古老的塔罗智慧接收AI驱动的解读。',
      category: '遇见',
    ),
    FAQItem(
      question: '星象解读有多准确？',
      answer: '我们的星象解读结合了传统的占星学原理和先进的AI分析。虽然它们提供了有价值的见解，但应该将其视为指导而非绝对的预测。',
      category: '遇见',
    ),
    FAQItem(
      question: '我可以离线收听电台吗？',
      answer: '目前，时空之声电台功能需要互联网连接来流式传输内容。我们正在探索未来更新中的离线收听选项。',
      category: '电台',
    ),
    FAQItem(
      question: '我与平行现实的对话是私密的吗？',
      answer: '是的，您的所有对话都是私密且加密的。我们不会与第三方共享您的对话数据。您可以查看我们的隐私政策了解更多详情。',
      category: '隐私',
    ),
    FAQItem(
      question: '如何更改我的用户名？',
      answer: '目前，应用程序不支持更改用户名。我们正在努力在未来的更新中添加此功能。',
      category: '账户',
    ),
    FAQItem(
      question: '如果应用程序崩溃，我该怎么办？',
      answer: '如果应用程序崩溃，请重新启动它。如果问题仍然存在，请尝试清除应用程序缓存或重新安装。您也可以通过反馈部分报告崩溃情况。',
      category: '技术',
    ),
    FAQItem(
      question: '如何建议新功能？',
      answer: '我们欢迎功能建议！请使用设置菜单中的反馈表单提交您的想法。我们的团队会定期审核所有建议。',
      category: '通用',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredFAQs = List.from(_allFAQs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterFAQs(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredFAQs = List.from(_allFAQs);
      } else {
        _filteredFAQs = _allFAQs
            .where((faq) =>
                faq.question.toLowerCase().contains(_searchQuery) ||
                faq.answer.toLowerCase().contains(_searchQuery) ||
                faq.category.toLowerCase().contains(_searchQuery))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _searchFocusNode.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildSearchBar(),
              Expanded(
                child: _filteredFAQs.isEmpty
                    ? _buildNoResultsFound()
                    : _buildFAQList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          ),
          const SizedBox(width: 16),
          Text(
            '帮助中心',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
          maxLength: 50,
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onChanged: _filterFAQs,
          decoration: InputDecoration(
            hintText: '搜索帮助主题...',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: primaryColor.withOpacity(0.7),
              size: 22,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: primaryColor.withOpacity(0.7),
                      size: 20,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _filterFAQs('');
                      _searchFocusNode.unfocus();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            isDense: true,
            fillColor: Colors.white,
            filled: true,
          ),
          cursorColor: primaryColor,
        ),
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              '未找到结果',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '尝试不同的关键词或浏览我们的常见问题分类',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: subtitleColor,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                _filterFAQs('');
                _searchFocusNode.unfocus();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 2,
              ),
              child: const Text('清除搜索'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQList() {
    // Group FAQs by category
    Map<String, List<FAQItem>> groupedFAQs = {};

    for (var faq in _filteredFAQs) {
      if (!groupedFAQs.containsKey(faq.category)) {
        groupedFAQs[faq.category] = [];
      }
      groupedFAQs[faq.category]!.add(faq);
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        if (_searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              '找到 ${_filteredFAQs.length} 个结果',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: subtitleColor,
              ),
            ),
          ),
        ...groupedFAQs.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      _getCategoryIcon(entry.key),
                      size: 20,
                      color: _getCategoryColor(entry.key),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getCategoryColor(entry.key),
                      ),
                    ),
                  ],
                ),
              ),
              ...entry.value.map((faq) => _buildFAQItem(faq)),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case '平行时空':
        return Icons.public;
      case '遇见':
        return Icons.auto_awesome;
      case '电台':
        return Icons.radio;
      case '隐私':
        return Icons.security;
      case '账户':
        return Icons.person;
      case '技术':
        return Icons.settings;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildFAQItem(FAQItem faq) {
    final categoryColor = _getCategoryColor(faq.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.help_outline,
                    size: 14,
                    color: categoryColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  faq.question,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          iconColor: categoryColor,
          collapsedIconColor: subtitleColor,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                faq.answer,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '平行时空':
        return const Color(0xFF5C6BC0); // 靛蓝色
      case '遇见':
        return const Color(0xFFAB47BC); // 柔和紫色
      case '电台':
        return const Color(0xFFFF7043); // 柔和深橙色
      case '隐私':
        return const Color(0xFFEF5350); // 柔和红色
      case '账户':
        return const Color(0xFF66BB6A); // 柔和绿色
      case '技术':
        return const Color(0xFFFFA726); // 柔和橙色
      default:
        return const Color(0xFF26A69A); // 柔和青色
    }
  }
}

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
