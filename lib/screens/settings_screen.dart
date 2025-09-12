import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/game_data_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic> _settings = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await GameDataService.loadSettings();
    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    await GameDataService.saveSettings(_settings);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('设置已保存'),
          backgroundColor: AppTheme.accentColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.secondaryColor,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.accentColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 版本信息
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '烽尘绘谱',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'v1.0.0',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 音画设置
              _buildSectionCard(
                title: '音画设置',
                children: [
                  _buildSliderSetting(
                    label: '背景音乐',
                    value: _settings['backgroundMusic']?.toDouble() ?? 0.7,
                    onChanged: (value) {
                      setState(() {
                        _settings['backgroundMusic'] = value;
                      });
                    },
                  ),
                  _buildSliderSetting(
                    label: '音效音量',
                    value: _settings['soundEffects']?.toDouble() ?? 0.85,
                    onChanged: (value) {
                      setState(() {
                        _settings['soundEffects'] = value;
                      });
                    },
                  ),
                  _buildSliderSetting(
                    label: '文本速度',
                    value: _settings['textSpeed']?.toDouble() ?? 0.6,
                    onChanged: (value) {
                      setState(() {
                        _settings['textSpeed'] = value;
                      });
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 其他选项
              _buildSectionCard(
                title: '其他',
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: AppTheme.accentColor,
                    ),
                    title: const Text('关于我们'),
                    subtitle: const Text('查看游戏信息和制作团队'),
                    onTap: () => Navigator.pushNamed(context, '/about'),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.description_outlined,
                      color: AppTheme.accentColor,
                    ),
                    title: const Text('用户协议'),
                    subtitle: const Text('查看用户服务协议'),
                    onTap: () => Navigator.pushNamed(context, '/user-agreement'),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.privacy_tip_outlined,
                      color: AppTheme.accentColor,
                    ),
                    title: const Text('隐私协议'),
                    subtitle: const Text('查看隐私保护政策'),
                    onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.help_outline,
                      color: AppTheme.accentColor,
                    ),
                    title: const Text('使用帮助'),
                    subtitle: const Text('查看游戏玩法说明'),
                    onTap: () => Navigator.pushNamed(context, '/help'),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.feedback_outlined,
                      color: AppTheme.accentColor,
                    ),
                    title: const Text('反馈和建议'),
                    subtitle: const Text('向我们提供宝贵建议'),
                    onTap: () => Navigator.pushNamed(context, '/feedback'),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const Text(
                      '重置游戏数据',
                      style: TextStyle(color: Colors.red),
                    ),
                    subtitle: const Text('清除所有游戏进度（不可恢复）'),
                    onTap: _showResetDialog,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSetting({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${(value * 100).round()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.accentColor,
              inactiveTrackColor: AppTheme.lightColor.withValues(alpha: 0.3),
              thumbColor: AppTheme.accentColor,
              overlayColor: AppTheme.accentColor.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
              min: 0.0,
              max: 1.0,
            ),
          ),
        ],
      ),
    );
  }





  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('重置游戏数据'),
        content: const Text(
          '此操作将清除所有游戏进度，包括武将、装备、剧情进度等。\n\n此操作不可恢复，确定要继续吗？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightColor,
            ),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGameData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('确定重置'),
          ),
        ],
      ),
    );
  }

  void _resetGameData() {
    // 这里应该清除游戏数据
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('游戏数据已重置，请重启应用'),
        backgroundColor: Colors.red,
      ),
    );
  }
}