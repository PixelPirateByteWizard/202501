import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

class UsageHelpScreen extends StatelessWidget {
  const UsageHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('使用帮助'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        backgroundIndex: 10,
        overlayOpacity: 0.7,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            _HelpItem(
              icon: Icons.games_outlined,
              title: '游戏目标',
              content: '通过收集刀锋来增强你的角色，击败不断涌来的敌人，尽可能生存更长时间。',
              color: Colors.greenAccent,
            ),
            _HelpItem(
              icon: Icons.control_camera_outlined,
              title: '如何移动',
              content: '使用屏幕左下方的虚拟摇杆来控制你的角色移动。',
              color: Colors.lightBlueAccent,
            ),
            _HelpItem(
              icon: Icons.double_arrow_outlined,
              title: '冲刺',
              content: '点击屏幕右下方的冲刺按钮可以进行快速位移，用于躲避敌人或快速接近刀锋。冲刺有冷却时间。',
              color: Colors.cyanAccent,
            ),
            _HelpItem(
              icon: Icons.shield_outlined,
              title: '刀锋与敌人',
              content: '收集地图上的刀锋可以增加你的刀锋数量和攻击范围。与敌人碰撞会消耗刀锋，刀锋数量为零时游戏结束。',
              color: Colors.orangeAccent,
            ),
            _HelpItem(
              icon: Icons.trending_up_outlined,
              title: '难度与分数',
              content: '游戏难度会随着时间增加，敌人会变得更强。你的最终分数取决于你被击败时拥有的刀锋数量。',
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;

  const _HelpItem({
    required this.icon,
    required this.title,
    required this.content,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.3),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
