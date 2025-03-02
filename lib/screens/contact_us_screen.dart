import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.yellow),
                      onPressed: () {
                        Navigator.pop(context); // 返回上一个界面
                      },
                    ),
                    const Text(
                      '联系我们',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                    ),
                    const SizedBox(width: 48), // 占位符以保持对齐
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '我们重视您的反馈',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '您的想法和建议对我们至关重要。如果您有任何问题、建议或疑虑，请随时与我们联系。我们致力于根据您的反馈改进我们的服务。',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '联系信息：',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '电子邮件：support@example.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  '电话：+1 (234) 567-890',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '营业时间：',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '周一至周五：上午 9 点 - 下午 5 点\n'
                  '周六：上午 10 点 - 下午 4 点\n'
                  '周日：休息',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '关注我们：',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.facebook, color: Colors.white),
                      onPressed: () {
                        // 添加 Facebook 链接功能
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share,
                          color: Colors.white), // 占位符用于 Twitter
                      onPressed: () {
                        // 添加 Twitter 链接功能
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt,
                          color: Colors.white), // 占位符用于 Instagram
                      onPressed: () {
                        // 添加 Instagram 链接功能
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
