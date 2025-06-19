import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户协议'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        backgroundIndex: 9,
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
                  _buildSectionTitle('1. 服务条款'),
                  _buildSectionContent(
                      '本协议是您与《神将GO》之间就您使用本游戏服务所达成的法律协议。在使用本游戏服务前，请您务必仔细阅读本协议。'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('2. 用户权利与义务'),
                  _buildSectionContent(
                      '您有权在遵守本协议及相关法律法规的前提下使用本游戏服务。您应确保您的行为符合所有适用的法律法规，不得利用本游戏从事任何违法活动。'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('3. 隐私保护'),
                  _buildSectionContent(
                      '我们尊重并保护您的隐私。关于我们如何收集、使用和保护您的信息，请参阅我们的《隐私政策》。'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('4. 免责声明'),
                  _buildSectionContent(
                      '本游戏在法律允许的最大范围内"按原样"提供，不作任何明示或暗示的保证。对于因使用或无法使用本游戏而造成的任何损失，我们不承担任何责任。'),
                  const SizedBox(height: 20),
                  _buildSectionTitle('5. 协议变更'),
                  _buildSectionContent(
                      '我们保留随时修改本协议的权利，并将在本游戏内发布最新版本。您继续使用本游戏即表示您接受修订后的协议。'),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      '感谢您对《神将GO》的支持！',
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
