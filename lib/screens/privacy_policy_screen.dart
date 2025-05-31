import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgrounds/backgrounds_5.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '隱私政策',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.amber.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '引言',
              '我們非常重視您的隱私保護。本隱私政策旨在說明我們如何收集、使用、存儲和保護您的個人信息。請您仔細閱讀並理解本政策的全部內容。',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '信息收集',
              '''我們可能收集以下類型的信息：

1. 基本信息
• 賬號信息（用戶名、密碼）
• 設備信息（設備型號、操作系統）
• 網絡信息（IP地址、網絡狀態）

2. 遊戲信息
• 遊戲進度和成就
• 遊戲偏好設置
• 遊戲內社交互動記錄

3. 支付信息
• 交易記錄
• 支付方式信息（經過加密處理）''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '信息使用',
              '''我們使用收集的信息用於：

1. 提供服務
• 維護遊戲運營
• 改進遊戲體驗
• 提供客戶支持

2. 安全保障
• 防止作弊和濫用
• 保護賬號安全
• 處理違規行為

3. 遊戲優化
• 分析遊戲數據
• 改進遊戲功能
• 開發新的功能''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '信息保護',
              '''我們採取以下措施保護您的信息：

1. 技術保護
• 數據加密存儲
• 安全傳輸協議
• 訪問權限控制

2. 管理保護
• 員工保密協議
• 內部安全培訓
• 定期安全審計''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '信息共享',
              '''在以下情況下，我們可能會共享您的信息：

1. 經您同意的共享
2. 法律法規要求的共享
3. 為維護遊戲安全的必要共享
4. 與合作夥伴的受限共享（經過脫敏處理）''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '兒童隱私',
              '''我們特別重視兒童的隱私保護：

1. 未滿16歲的用戶需要監護人同意
2. 限制未成年人的遊戲時間和支付額度
3. 提供專門的未成年人保護措施
4. 定期審查未成年人賬號使用情況''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '您的權利',
              '''您擁有以下權利：

1. 訪問您的個人信息
2. 更正不準確的信息
3. 刪除個人信息
4. 撤回同意
5. 導出個人信息
6. 注銷賬號''',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '政策更新',
              '我們可能會不時更新本隱私政策。更新後，我們會在遊戲內和官方網站公布新的隱私政策。建議您定期查看本政策以了解任何變更。',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '聯繫我們',
              '''如果您對本隱私政策有任何疑問，請聯繫我們：

• 隱私保護郵箱：privacy@xianxiataifang.com
• 客服電話：+886-XX-XXXXXXXX
• 辦公地址：台北市XX區XX路XX號''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          content,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
