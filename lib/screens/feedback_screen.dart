import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackController = TextEditingController();
  
  String _feedbackType = '建议';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        title: const Text('反馈和建议'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 反馈标题
              Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.feedback,
                          size: 48,
                          color: AppTheme.accentColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '您的意见对我们很重要',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '请告诉我们您的想法和建议',
                          style: TextStyle(
                            color: AppTheme.lightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 反馈表单
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '反馈表单',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // 反馈类型
                        Text(
                          '反馈类型',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.lightColor.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _feedbackType,
                              onChanged: (value) {
                                setState(() {
                                  _feedbackType = value!;
                                });
                              },
                              dropdownColor: AppTheme.cardColor,
                              style: Theme.of(context).textTheme.bodyMedium,
                              items: const [
                                DropdownMenuItem(value: '建议', child: Text('功能建议')),
                                DropdownMenuItem(value: '问题', child: Text('问题反馈')),
                                DropdownMenuItem(value: '体验', child: Text('体验反馈')),
                                DropdownMenuItem(value: '其他', child: Text('其他')),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // 联系方式（可选）
                        Text(
                          '联系方式（可选）',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: '您的昵称',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: '您的邮箱（用于回复）',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return '请输入有效的邮箱地址';
                              }
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // 反馈内容
                        Text(
                          '反馈内容 *',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _feedbackController,
                          decoration: const InputDecoration(
                            hintText: '请详细描述您的意见或建议...',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 6,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '请输入反馈内容';
                            }
                            if (value.trim().length < 10) {
                              return '反馈内容至少需要10个字符';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // 提交按钮
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitFeedback,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentColor,
                              foregroundColor: AppTheme.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isSubmitting
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text('提交中...'),
                                    ],
                                  )
                                : const Text(
                                    '提交反馈',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 其他联系方式
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '其他联系方式',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildContactItem(
                        icon: Icons.email,
                        title: '邮箱反馈',
                        subtitle: 'feedback@sanguohuiquan.com',
                        onTap: () {
                          // 这里可以添加打开邮箱应用的逻辑
                          _showContactDialog('邮箱', 'feedback@sanguohuiquan.com');
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildContactItem(
                        icon: Icons.chat,
                        title: 'QQ群',
                        subtitle: '123456789',
                        onTap: () {
                          _showContactDialog('QQ群', '123456789');
                        },
                      ),
                      
                      const SizedBox(height: 12),
                      
                      _buildContactItem(
                        icon: Icons.schedule,
                        title: '客服时间',
                        subtitle: '工作日 9:00-18:00',
                        onTap: null,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 温馨提示
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: AppTheme.accentColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '温馨提示',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• 我们会认真阅读每一条反馈\n'
                        '• 有价值的建议将在后续版本中采纳\n'
                        '• 如留下联系方式，我们会及时回复\n'
                        '• 感谢您对《烽尘绘谱》的支持！',
                        style: TextStyle(
                          height: 1.6,
                          color: AppTheme.lightColor,
                        ),
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

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.accentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.accentColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.lightColor,
              ),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(String type, String contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text('联系方式'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$type：$contact'),
            const SizedBox(height: 8),
            const Text(
              '请复制联系方式到对应应用中联系我们',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.lightColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // 模拟提交过程
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      // 显示成功提示
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.cardColor,
          title: const Text('提交成功'),
          content: const Text('感谢您的反馈！我们会认真考虑您的建议。'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 关闭对话框
                Navigator.pop(context); // 返回上一页
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.primaryColor,
              ),
              child: const Text('确定'),
            ),
          ],
        ),
      );
    }
  }
}