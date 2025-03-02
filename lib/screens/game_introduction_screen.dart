import 'package:flutter/material.dart';

class GameIntroductionScreen extends StatelessWidget {
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
                        '游戏介绍',
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
                  '欢迎来到"西游幻途"的世界！在这款游戏中，您将踏上一段史诗般的旅程，穿越一个充满挑战、冒险和难忘角色的神秘领域。',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '游戏特点：',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• 引人入胜的故事情节和丰富的背景\n'
                  '• 多样化的角色和独特的能力\n'
                  '• 具有挑战性的任务和冒险\n'
                  '• 精美的图形和沉浸式的音效\n'
                  '• 多人模式，与朋友组队\n',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '游戏玩法：',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1. 创建您的角色并选择您的职业。\n'
                  '2. 探索广阔的世界并完成任务。\n'
                  '3. 升级您的角色并解锁新技能。\n'
                  '4. 与其他玩家联手击败强大的敌人。\n'
                  '5. 享受旅程，沉浸在故事中！\n',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '现在就加入我们，开始您的"西游幻途"冒险吧！愿您的旅程充满兴奋与荣耀！',
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
