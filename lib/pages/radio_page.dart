import 'package:flutter/material.dart';
import '../models/radio_model.dart';
import '../utils/navigation.dart';
import 'radio_chat_page.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage>
    with AutomaticKeepAliveClientMixin {
  // 白色主题的颜色定义
  final Color primaryColor = const Color(0xFF6B2C9E);
  final Color secondaryColor = const Color(0xFFFF2A6D);
  final Color backgroundColor = Colors.white;
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF333333);
  final Color subtitleColor = const Color(0xFF666666);
  final Color borderColor = const Color(0xFFEEEEEE);

  // 类别颜色映射 - 使用更柔和的颜色
  final Map<String, Color> _categoryColorMap = {
    '全部': const Color(0xFF5E35B1), // 更深的紫色，确保与白色背景对比度高
    '音乐': const Color(0xFF66BB6A), // 柔和绿色
    '文化': const Color(0xFFAB47BC), // 柔和紫色
    '娱乐': const Color(0xFFFFA726), // 柔和橙色
    '资讯': const Color(0xFF42A5F5), // 柔和蓝色
    '体育': const Color(0xFFEF5350), // 柔和红色
    '教育': const Color(0xFF26A69A), // 柔和青色
    '国际': const Color(0xFF5C6BC0), // 柔和靛蓝色
    '特色': const Color(0xFFFF7043), // 柔和深橙色
  };

  // 获取类别对应的颜色
  Color _getCategoryColor(String category) {
    return _categoryColorMap[category] ?? primaryColor;
  }

  // 获取类别对应的渐变色
  List<Color> _getCategoryGradient(String category) {
    final baseColor = _getCategoryColor(category);
    return [
      baseColor,
      baseColor.withOpacity(0.7),
    ];
  }

  // 使用静态方法获取电台数据
  late List<RadioStation> _allStations;
  late RadioStation _featuredStation;
  late List<RadioStation> _stations;

  // 分类列表
  final List<String> _categories = [
    '全部',
    '音乐',
    '文化',
    '娱乐',
    '资讯',
    '体育',
    '教育',
    '国际',
    '特色'
  ];
  String _selectedCategory = '全部';

  // 搜索控制
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // 用于控制焦点的FocusNode
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initStations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _initStations() {
    // 获取所有电台
    _allStations = RadioStation.getDefaultStations();

    // 设置特色电台（第一个电台）
    _featuredStation = _allStations[0];

    // 其余电台列表
    _stations = _allStations.sublist(1);
  }

  // 根据分类筛选电台
  void _filterStationsByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == '全部') {
        _stations = _allStations.sublist(1);
      } else {
        _stations = _allStations
            .where((station) => station.category == category)
            .toList();
      }

      // 如果有搜索查询，同时应用搜索过滤
      if (_searchQuery.isNotEmpty) {
        _applySearch(_searchQuery);
      }
    });
  }

  // 应用搜索过滤
  void _applySearch(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filterStationsByCategory(_selectedCategory);
      return;
    }

    setState(() {
      List<RadioStation> baseList;
      if (_selectedCategory == '全部') {
        baseList = _allStations;
      } else {
        baseList = _allStations
            .where((station) => station.category == _selectedCategory)
            .toList();
      }

      _stations = baseList
          .where((station) =>
              station.name.toLowerCase().contains(_searchQuery) ||
              station.description.toLowerCase().contains(_searchQuery))
          .toList();

      // 如果特色电台也符合搜索条件，则更新特色电台
      if (_featuredStation.name.toLowerCase().contains(_searchQuery) ||
          _featuredStation.description.toLowerCase().contains(_searchQuery)) {
        // 保持原有特色电台
      } else if (_stations.isNotEmpty) {
        // 如果特色电台不符合但有其他符合的电台，将第一个符合的设为特色
        _featuredStation = _stations[0];
        _stations = _stations.sublist(1);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  // 显示举报和屏蔽选项
  void _showReportBlockOptions(RadioStation station) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  '操作选项',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.report_outlined, color: Colors.red),
                ),
                title: const Text(
                  '举报',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A0B47),
                  ),
                ),
                subtitle: const Text(
                  '举报不良内容或违规行为',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(station);
                },
              ),
              const Divider(height: 1, indent: 70, endIndent: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.block, color: Color(0xFF6B2C9E)),
                ),
                title: const Text(
                  '屏蔽',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A0B47),
                  ),
                ),
                subtitle: const Text(
                  '不再显示此电台',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showBlockDialog(station);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // 显示举报对话框
  void _showReportDialog(RadioStation station) {
    final TextEditingController _reportController = TextEditingController();
    String _selectedReportReason = '内容不当';
    final List<String> _reportReasons = [
      '内容不当',
      '侵犯隐私',
      '虚假信息',
      '仇恨言论',
      '其他原因'
    ];

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            '举报电台',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2A0B47),
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.report_outlined,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '你正在举报: ${station.name}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2A0B47),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '请选择举报原因:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: _reportReasons.map((reason) {
                          return RadioListTile<String>(
                            title: Text(
                              reason,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF2A0B47),
                              ),
                            ),
                            value: reason,
                            groupValue: _selectedReportReason,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _selectedReportReason = value!;
                              });
                            },
                            dense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  '补充说明 (选填，最多200字):',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _reportController,
                  maxLines: 3,
                  maxLength: 200,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2A0B47),
                  ),
                  decoration: InputDecoration(
                    hintText: '请详细描述您遇到的问题...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEC).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '提示: 举报成功后，该电台将从您的列表中永久删除。',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                _removeStation(station, '举报');
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                '提交举报',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      ),
    );
  }

  // 显示屏蔽对话框
  void _showBlockDialog(RadioStation station) {
    final TextEditingController _blockController = TextEditingController();
    String _selectedBlockReason = '不感兴趣';
    final List<String> _blockReasons = ['不感兴趣', '内容重复', '不喜欢风格', '其他原因'];

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            '屏蔽电台',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2A0B47),
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.block,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '你正在屏蔽: ${station.name}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2A0B47),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '请选择屏蔽原因:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: _blockReasons.map((reason) {
                          return RadioListTile<String>(
                            title: Text(
                              reason,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF2A0B47),
                              ),
                            ),
                            value: reason,
                            groupValue: _selectedBlockReason,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _selectedBlockReason = value!;
                              });
                            },
                            dense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  '补充说明 (选填，最多100字):',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _blockController,
                  maxLines: 2,
                  maxLength: 100,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2A0B47),
                  ),
                  decoration: InputDecoration(
                    hintText: '请说明您屏蔽的具体原因...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey[700],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '提示: 屏蔽后，该电台将从您的列表中永久删除。',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                _removeStation(station, '屏蔽');
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                '确认屏蔽',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      ),
    );
  }

  // 从列表中移除电台
  void _removeStation(RadioStation station, String action) {
    setState(() {
      // 如果是特色电台，需要重新设置特色电台
      if (_featuredStation.id == station.id) {
        if (_stations.isNotEmpty) {
          _featuredStation = _stations[0];
          _stations = _stations.sublist(1);
        }
      }

      // 从所有电台列表中移除
      _allStations.removeWhere((item) => item.id == station.id);

      // 从当前显示的电台列表中移除
      _stations.removeWhere((item) => item.id == station.id);
    });

    // 显示成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已${action}该电台'),
        backgroundColor: action == '举报' ? Colors.red : Colors.grey[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: '知道了',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // 显示功能介绍对话框
  void _showFeaturesDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  const Color(0xFFF5F0FA),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 图标
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.radio,
                    color: primaryColor,
                    size: 30,
                  ),
                ),
                Text(
                  '时空之声使用指南',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '欢迎使用时空之声！在这里，您可以与来自不同时空的电台主持人进行对话交流。',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // 内容管理功能说明
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '内容管理功能',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2A0B47),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 举报功能
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECEC),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.report_outlined,
                              color: Colors.red,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '举报功能',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2A0B47),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '长按电台卡片可举报不良内容。举报后，该电台将从您的列表中永久删除，我们会对内容进行审核。',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Divider(color: Colors.grey[200]),
                      const SizedBox(height: 12),

                      // 屏蔽功能
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.block,
                              color: primaryColor,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '屏蔽功能',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2A0B47),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '长按电台卡片可屏蔽不感兴趣的内容。屏蔽后，该电台将从您的列表中永久删除，不会再次显示。',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Divider(color: Colors.grey[200]),
                      const SizedBox(height: 12),

                      // 操作提示
                      Row(
                        children: [
                          Icon(
                            Icons.touch_app,
                            color: primaryColor,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '长按任意电台卡片即可使用举报或屏蔽功能',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2A0B47),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, const Color(0xFF4A1A6B)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      '开始探索',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用super.build
    return GestureDetector(
      // 点击页面任意区域收起键盘
      onTap: () => _searchFocusNode.unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildCategoryFilter(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // 刷新电台列表
                    setState(() {
                      _initStations();
                      _searchController.clear();
                      _searchQuery = '';
                      _selectedCategory = '全部';
                    });
                    // 确保键盘收起
                    _searchFocusNode.unfocus();
                  },
                  color: primaryColor,
                  backgroundColor: Colors.white,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFeaturedSection(),
                        const SizedBox(height: 24),
                        _buildExploreSection(),
                        // 添加底部间距
                        const SizedBox(height: 30),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧标题部分
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '时空之声',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '与电台主持人对话',
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // 右上角信息按钮
          InkWell(
            onTap: _showFeaturesDialog,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withAlpha(40),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 光晕效果
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withOpacity(0.1),
                          Colors.transparent,
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                  // 信息图标
                  Icon(
                    Icons.info_outline,
                    color: primaryColor,
                    size: 24,
                  ),
                  // 小光点装饰
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          // 限制输入长度
          maxLength: 20,
          // 隐藏计数器
          buildCounter: (context,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          // 设置键盘类型和操作按钮
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          // 点击搜索按钮时收起键盘
          onSubmitted: (value) {
            _searchFocusNode.unfocus();
            _applySearch(value);
          },
          decoration: InputDecoration(
            hintText: '搜索聊天频道...',
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
                      _applySearch('');
                      _searchFocusNode.unfocus();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
            // 不显示错误文本
            errorStyle: const TextStyle(height: 0),
            // 添加内部填充
            isDense: true,
            fillColor: Colors.white,
            filled: true,
          ),
          onChanged: _applySearch,
          cursorColor: primaryColor,
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          final chipColor = _getCategoryColor(category);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _searchFocusNode.unfocus();
                  _filterStationsByCategory(category);
                },
                borderRadius: BorderRadius.circular(20),
                child: Ink(
                  decoration: BoxDecoration(
                    color: isSelected ? chipColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isSelected ? Colors.transparent : Colors.grey[300]!,
                      width: 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: chipColor.withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected) ...[
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : textColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection() {
    // 如果没有电台数据，显示空状态
    if (_allStations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            '没有可用的聊天频道',
            style: TextStyle(color: subtitleColor),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '为你推荐',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            // 播放按钮
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            // 点击卡片时收起键盘
            _searchFocusNode.unfocus();
            NavigationUtil.navigateWithAnimation(
              context,
              RadioChatPage(station: _featuredStation),
            );
          },
          onLongPress: () {
            _showReportBlockOptions(_featuredStation);
          },
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                // 背景图片
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    _featuredStation.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey[100],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey[100],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image,
                                color: subtitleColor,
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '无法加载图片',
                                style: TextStyle(color: subtitleColor),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // 渐变遮罩
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                // 播放按钮
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                ),
                // 电台信息
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 电台类别标签
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                secondaryColor,
                                primaryColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: secondaryColor.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            '推荐',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 电台名称
                        Text(
                          _featuredStation.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // 电台描述
                        Text(
                          _featuredStation.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        // 直播标签
                        if (_featuredStation.isLive) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                '直播',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExploreSection() {
    if (_stations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                _searchQuery.isNotEmpty ? '没有找到匹配的频道' : '该分类下没有聊天频道',
                style: TextStyle(
                  fontSize: 16,
                  color: subtitleColor,
                ),
                textAlign: TextAlign.center,
              ),
              if (_searchQuery.isNotEmpty || _selectedCategory != '全部') ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // 点击按钮时收起键盘
                    _searchFocusNode.unfocus();
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                      _selectedCategory = '全部';
                      _initStations();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                  child: const Text('显示全部频道'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '探索聊天',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            Text(
              '${_stations.length} 个频道',
              style: TextStyle(
                fontSize: 14,
                color: subtitleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85, // 调整卡片比例
          ),
          itemCount: _stations.length,
          itemBuilder: (context, index) {
            final station = _stations[index];
            return _buildStationCard(station);
          },
        ),
      ],
    );
  }

  Widget _buildStationCard(RadioStation station) {
    return GestureDetector(
      onTap: () {
        // 点击电台卡片时收起键盘
        _searchFocusNode.unfocus();
        NavigationUtil.navigateWithAnimation(
          context,
          RadioChatPage(station: station),
        );
      },
      onLongPress: () {
        _showReportBlockOptions(station);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 背景图片
              Image.network(
                station.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[100],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          primaryColor,
                        ),
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[100],
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        color: subtitleColor,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
              // 渐变遮罩
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              // 播放按钮
              Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
              ),
              // 电台信息
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 电台类别
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _getCategoryGradient(station.category),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: _getCategoryColor(station.category)
                                  .withOpacity(0.3),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          station.category,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // 电台名称
                      Text(
                        station.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      // 电台描述
                      Text(
                        station.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
