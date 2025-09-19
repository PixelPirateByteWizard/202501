import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _contactController = TextEditingController();
  
  String _selectedType = '建议';
  final List<String> _feedbackTypes = ['建议', 'Bug反馈', '功能请求', '其他'];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildFeedbackForm(),
                      const SizedBox(height: 20),
                      _buildContactInfo(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.primaryGold,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            '反馈建议',
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.feedback,
                  color: AppTheme.primaryGold,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text(
                  '提交反馈',
                  style: TextStyle(
                    color: AppTheme.primaryGold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // 反馈类型选择
            const Text(
              '反馈类型',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppTheme.cardBackgroundDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.textSecondary.withValues(alpha: 0.3),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedType,
                  isExpanded: true,
                  dropdownColor: AppTheme.cardBackgroundDark,
                  style: const TextStyle(color: AppTheme.textLight),
                  items: _feedbackTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 标题输入
            const Text(
              '标题',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              style: const TextStyle(color: AppTheme.textLight),
              decoration: InputDecoration(
                hintText: '请简要描述问题或建议',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
                filled: true,
                fillColor: AppTheme.cardBackgroundDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.primaryGold),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入标题';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // 详细内容输入
            const Text(
              '详细描述',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _contentController,
              style: const TextStyle(color: AppTheme.textLight),
              maxLines: 6,
              decoration: InputDecoration(
                hintText: '请详细描述您遇到的问题或建议...\n\n如果是Bug反馈，请包含：\n• 出现问题的具体步骤\n• 预期结果和实际结果\n• 设备型号和系统版本',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
                filled: true,
                fillColor: AppTheme.cardBackgroundDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.primaryGold),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入详细描述';
                }
                if (value.trim().length < 10) {
                  return '描述内容至少需要10个字符';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // 联系方式输入（可选）
            const Text(
              '联系方式（可选）',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _contactController,
              style: const TextStyle(color: AppTheme.textLight),
              decoration: InputDecoration(
                hintText: '邮箱或其他联系方式，方便我们回复您',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
                filled: true,
                fillColor: AppTheme.cardBackgroundDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.primaryGold),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 提交按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGold,
                  foregroundColor: AppTheme.backgroundDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '提交反馈',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.contact_support,
                color: AppTheme.primaryGold,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text(
                '其他联系方式',
                style: TextStyle(
                  color: AppTheme.primaryGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '除了通过此表单反馈，您也可以通过以下方式联系我们：',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          _buildContactItem(Icons.email, '邮箱', 'feedback@fengchen.game'),
          _buildContactItem(Icons.web, '官网', 'www.fengchen.game'),
          _buildContactItem(Icons.forum, '论坛', 'forum.fengchen.game'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.primaryGold.withValues(alpha: 0.3),
              ),
            ),
            child: const Text(
              '💡 提示：我们会认真对待每一条反馈，并尽快回复。您的建议是我们改进游戏的重要动力！',
              style: TextStyle(
                color: AppTheme.primaryGold,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryGold,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              color: AppTheme.textLight,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // 模拟提交反馈
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.cardBackground,
          title: const Text(
            '反馈提交成功',
            style: TextStyle(color: AppTheme.primaryGold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '感谢您的反馈！我们已收到您的意见：',
                style: TextStyle(color: AppTheme.textLight),
              ),
              const SizedBox(height: 12),
              Text(
                '类型：$_selectedType',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              Text(
                '标题：${_titleController.text}',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              const Text(
                '我们会尽快处理您的反馈，如有需要会通过您提供的联系方式回复。',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // 返回设置页面
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
      
      // 清空表单
      _titleController.clear();
      _contentController.clear();
      _contactController.clear();
      setState(() {
        _selectedType = '建议';
      });
    }
  }
}