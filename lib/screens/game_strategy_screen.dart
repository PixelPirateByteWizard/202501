import 'package:flutter/material.dart';

class GameStrategyScreen extends StatelessWidget {
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
                        '游戏攻略',
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
                  '欢迎来到游戏攻略指南！',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '在本节中，您将找到帮助您在"西游幻途"旅程中取得成功的基本策略和提示。无论您是初学者还是经验丰富的玩家，这些策略都将增强您的游戏体验，提高您的胜利机会。',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '关键策略：',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• 了解您角色的优势和劣势。\n'
                  '• 专注于提升您的技能和能力。\n'
                  '• 探索世界以寻找隐藏的宝藏和资源。\n'
                  '• 与其他玩家组队进行挑战任务。\n'
                  '• 注意您的法力值并明智地使用它们。\n',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '成功提示：',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1. 始终准备好战斗，装备最佳装备。\n'
                  '2. 参加活动以获得独家奖励。\n'
                  '3. 加入公会以获取额外资源和支持。\n'
                  '4. 随时关注游戏补丁和社区新闻。\n'
                  '5. 定期练习以提高您的技能和策略。\n',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '通过这些策略和提示，您将朝着成为"西游幻途"大师的目标迈进。祝您好运，愿您的冒险充满兴奋与荣耀！',
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
