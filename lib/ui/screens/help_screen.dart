import 'package:flutter/material.dart';
import 'base_info_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseInfoScreen(
      title: '使用帮助',
      children: [
        InfoSection(
          title: '游戏规则',
          children: [
            InfoParagraph(
              '群英谜阵是一款经典的益智游戏，玩家需要通过移动方块，将打乱的数字按照顺序重新排列。',
            ),
            InfoParagraph(
              '游戏开始时，数字方块会被随机打乱。您需要通过点击方块，将它们移动到空白位置，最终将所有数字按照从小到大的顺序排列。',
            ),
          ],
        ),
        InfoSection(
          title: '操作方法',
          children: [
            InfoParagraph(
              '1. 点击与空白格相邻的方块即可移动',
            ),
            InfoParagraph(
              '2. 方块只能向上、下、左、右四个方向移动',
            ),
            InfoParagraph(
              '3. 每次只能移动一个方块',
            ),
          ],
        ),
        InfoSection(
          title: '游戏难度',
          children: [
            InfoParagraph(
              '游戏提供三种难度级别：',
            ),
            InfoParagraph(
              '• 初级（3x3）：适合新手入门',
            ),
            InfoParagraph(
              '• 中级（4x4）：需要一定的思考能力',
            ),
            InfoParagraph(
              '• 高级（5x5）：考验您的智慧极限',
            ),
          ],
        ),
        InfoSection(
          title: '获得成就',
          children: [
            InfoParagraph(
              '完成特定的游戏目标可以解锁成就，例如：',
            ),
            InfoParagraph(
              '• 完成第一局游戏',
            ),
            InfoParagraph(
              '• 在特定时间内完成游戏',
            ),
            InfoParagraph(
              '• 使用最少步数完成游戏',
            ),
          ],
        ),
        InfoSection(
          title: '游戏技巧',
          children: [
            InfoParagraph(
              '1. 先确定数字的大致位置，制定移动策略',
            ),
            InfoParagraph(
              '2. 注意观察空白格的位置，合理规划移动路线',
            ),
            InfoParagraph(
              '3. 尽量避免重复移动同一方块',
            ),
            InfoParagraph(
              '4. 建议从最小的数字开始排列',
            ),
          ],
        ),
      ],
    );
  }
}
