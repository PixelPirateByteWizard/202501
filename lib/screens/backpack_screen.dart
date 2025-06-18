import 'package:flutter/material.dart';

// 为皮肤和圣物创建简单的数据模型
class Skin {
  final String name;
  final IconData icon;
  final bool isEquipped;
  const Skin({required this.name, required this.icon, this.isEquipped = false});
}

class Relic {
  final String name;
  final IconData icon;
  final String description;
  const Relic(
      {required this.name, required this.icon, required this.description});
}

class BackpackScreen extends StatelessWidget {
  const BackpackScreen({super.key});

  // 模拟的皮肤和圣物数据
  static const List<Skin> _skins = [
    Skin(name: '默认外观', icon: Icons.person, isEquipped: true),
    Skin(name: '武士之魂', icon: Icons.sports_kabaddi),
    Skin(name: '圣殿骑士', icon: Icons.shield),
    Skin(name: '暗影刺客', icon: Icons.visibility_off),
  ];

  static const List<Relic> _relics = [
    Relic(
        name: '磁力护符',
        icon: Icons.compare_arrows,
        description: '自动吸取刀锋的范围扩大50%。'),
    Relic(name: '急速之刃', icon: Icons.flash_on, description: '冲刺冷却时间减少0.5秒。'),
    Relic(
        name: '守护核心', icon: Icons.health_and_safety, description: '初始刀锋数量增加5。'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF000010),
        appBar: AppBar(
          title: const Text('背包'),
          backgroundColor: const Color(0xFF000010),
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            indicatorWeight: 3.0,
            tabs: [
              Tab(icon: Icon(Icons.style), text: '皮肤'),
              Tab(icon: Icon(Icons.auto_awesome), text: '圣物'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGridView(_buildSkinCard),
            _buildGridView(_buildRelicCard),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(Function(BuildContext, int) cardBuilder) {
    final itemCount =
        cardBuilder == _buildSkinCard ? _skins.length : _relics.length;
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => cardBuilder(context, index),
    );
  }

  Widget _buildSkinCard(BuildContext context, int index) {
    final skin = _skins[index];
    return Card(
      color: skin.isEquipped
          ? Colors.blue.withOpacity(0.2)
          : Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: skin.isEquipped ? Colors.blue : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(skin.icon, size: 64, color: Colors.white),
          const SizedBox(height: 16),
          Text(skin.name,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          if (skin.isEquipped)
            const Text('已装备',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRelicCard(BuildContext context, int index) {
    final relic = _relics[index];
    return Card(
      color: Colors.purple.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.purple.withOpacity(0.5), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(relic.icon, size: 56, color: Colors.purple.shade200),
            Text(relic.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text(
              relic.description,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
