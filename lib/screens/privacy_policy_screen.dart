import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('隐私政策'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        backgroundIndex: 8,
        overlayOpacity: 0.7,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            color: Colors.black.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('1. 我们收集的信息'),
                  _buildSectionContent(
                      '本游戏在您使用过程中会通过 SharedPreferences 在您的设备本地存储匿名游戏数据，例如最高分、游戏时长、设置偏好等，用于优化游戏体验和统计分析。我们不会收集或上传您的任何个人身份信息。'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('2. 信息的使用'),
                  _buildSectionContent(
                      '我们收集的数据仅用于改进游戏性能和提供更好的用户体验。我们不会将您的数据分享或出售给任何第三方。'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('3. 数据安全'),
                  _buildSectionContent(
                      '我们采取合理的本地存储机制来保护我们收集的信息，所有数据均存储在您的设备上，不会上传至服务器。'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('4. 政策变更'),
                  _buildSectionContent('我们可能会不时更新本隐私政策。任何更新都将在此页面发布。'),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      '如果您有任何疑问，请通过反馈渠道联系我们。',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        content,
        style:
            const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
      ),
    );
  }
}
