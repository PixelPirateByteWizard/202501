import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

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
            '使用幫助',
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
      child: Column(
        children: [
          _buildHelpSection(
            '基礎操作指南',
            [
              {
                'title': '遊戲控制',
                'content':
                    '• 點擊螢幕左側區域進行移動\n• 右側區域用於視角控制\n• 上滑可以跳躍\n• 雙指縮放可調整視角距離',
              },
              {
                'title': '戰鬥系統',
                'content': '• 點擊技能按鈕釋放法術\n• 長按可蓄力施法\n• 滑動可進行連招\n• 防禦需要及時按下防禦鍵',
              },
              {
                'title': '修煉系統',
                'content': '• 通過修煉提升境界\n• 收集靈石增加修為\n• 學習功法提升實力\n• 突破需要特定條件',
              },
            ],
          ),
          const SizedBox(height: 16),
          _buildHelpSection(
            '新手指引',
            [
              {
                'title': '開始遊戲',
                'content': '1. 創建角色選擇門派\n2. 完成新手教學任務\n3. 領取新手獎勵\n4. 加入修真聯盟',
              },
              {
                'title': '快速升級',
                'content': '1. 完成主線任務\n2. 參與日常活動\n3. 加入幫派歷練\n4. 完成成就任務',
              },
            ],
          ),
          const SizedBox(height: 16),
          _buildHelpSection(
            '常見問題',
            [
              {
                'title': '無法登入遊戲',
                'content': '• 檢查網絡連接\n• 確認帳號密碼正確\n• 清理遊戲緩存\n• 重新安裝遊戲',
              },
              {
                'title': '遊戲卡頓',
                'content': '• 降低畫質設置\n• 關閉特效\n• 清理後台程序\n• 重啟設備',
              },
              {
                'title': '無法購買',
                'content': '• 確認支付方式\n• 檢查賬戶餘額\n• 更新支付信息\n• 聯繫客服處理',
              },
            ],
          ),
          const SizedBox(height: 16),
          _buildHelpSection(
            '遊戲技巧',
            [
              {
                'title': '戰鬥技巧',
                'content': '• 合理搭配功法\n• 注意靈力消耗\n• 善用連招系統\n• 掌握走位要領',
              },
              {
                'title': '資源獲取',
                'content': '• 完成每日任務\n• 參與世界活動\n• 交易市場交易\n• 組隊副本掉落',
              },
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, List<Map<String, String>> items) {
    return Container(
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
          ...items.map((item) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['content']!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              )),
        ],
      ),
    );
  }
}
