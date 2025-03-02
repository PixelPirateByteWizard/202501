import 'package:flutter/material.dart';

class PrivacyProtectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景图片
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bj/xybj7.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black54,
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // 内容
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16.0, // 添加状态栏高度和额外边距
              left: 16.0,
              right: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.yellow),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Expanded(
                      child: Text(
                        '隐私保护',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // 占位符以保持对齐
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '我们重视您的隐私',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '在《西游幻途》中，我们承诺保护您的个人信息和隐私。请阅读以下隐私政策，以了解我们如何收集、使用和保护您的信息。',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '信息收集：',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• 我们可能会收集您的姓名、电子邮件地址和其他联系信息。\n'
                  '• 我们可能会收集您在游戏中的活动数据，以改善用户体验。\n',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '信息使用：',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• 我们将您的信息用于提供和改进我们的服务。\n'
                  '• 我们可能会使用您的信息与您沟通，发送更新和促销信息。\n',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '信息保护：',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• 我们采取适当的安全措施来保护您的个人信息。\n'
                  '• 我们不会将您的信息出售给第三方。\n',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '如有任何疑问或担忧，请随时与我们联系。感谢您对《西游幻途》的支持与信任！',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
