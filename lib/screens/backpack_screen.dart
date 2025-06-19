import 'package:flutter/material.dart';
import '../widgets/app_background.dart';

// 为皮肤和圣物创建简单的数据模型
class Skin {
  final String name;
  final String imagePath;
  final bool isEquipped;
  const Skin(
      {required this.name, required this.imagePath, this.isEquipped = false});
}

class Relic {
  final String name;
  final String imagePath;
  final String description;
  const Relic(
      {required this.name, required this.imagePath, required this.description});
}

class BackpackScreen extends StatelessWidget {
  const BackpackScreen({super.key});

  // 模拟的皮肤和圣物数据
  static const List<Skin> _skins = [
    Skin(name: '默认外观', imagePath: 'assets/item/Item1.png', isEquipped: true),
    Skin(name: '武士之魂', imagePath: 'assets/item/Item2.png'),
    Skin(name: '圣殿骑士', imagePath: 'assets/item/Item3.png'),
    Skin(name: '暗影刺客', imagePath: 'assets/item/Item4.png'),
    Skin(name: '光明使者', imagePath: 'assets/item/Item5.png'),
    Skin(name: '风暴战士', imagePath: 'assets/item/Item6.png'),
    Skin(name: '火焰法师', imagePath: 'assets/item/Item7.png'),
    Skin(name: '冰霜巫师', imagePath: 'assets/item/Item8.png'),
    Skin(name: '雷电战神', imagePath: 'assets/item/Item15.png'),
    Skin(name: '自然守护者', imagePath: 'assets/item/Item16.png'),
    Skin(name: '深海猎手', imagePath: 'assets/item/Item17.png'),
    Skin(name: '机械战士', imagePath: 'assets/item/Item18.png'),
    Skin(name: '星空游侠', imagePath: 'assets/item/Item19.png'),
    Skin(name: '幽灵刺客', imagePath: 'assets/item/Item20.png'),
    Skin(name: '龙骑士', imagePath: 'assets/item/Item21.png'),
    Skin(name: '死亡使者', imagePath: 'assets/item/Item22.png'),
  ];

  static const List<Relic> _relics = [
    Relic(
        name: '磁力护符',
        imagePath: 'assets/item/Item9.png',
        description: '自动吸取刀锋的范围扩大50%。'),
    Relic(
        name: '急速之刃',
        imagePath: 'assets/item/Item10.png',
        description: '冲刺冷却时间减少0.5秒。'),
    Relic(
        name: '守护核心',
        imagePath: 'assets/item/Item11.png',
        description: '初始刀锋数量增加5。'),
    Relic(
        name: '幸运符咒',
        imagePath: 'assets/item/Item12.png',
        description: '增加10%几率在击败敌人时获得双倍刀锋。'),
    Relic(
        name: '时间扭曲器',
        imagePath: 'assets/item/Item13.png',
        description: '每60秒自动减少冲刺冷却时间5秒。'),
    Relic(
        name: '能量护盾',
        imagePath: 'assets/item/Item14.png',
        description: '每局游戏可以抵挡一次致命伤害。'),
    Relic(
        name: '刀锋增幅器',
        imagePath: 'assets/item/Item23.png',
        description: '所有刀锋伤害增加15%。'),
    Relic(
        name: '闪避护符',
        imagePath: 'assets/item/Item24.png',
        description: '10%几率自动闪避敌人攻击。'),
    Relic(
        name: '生命汲取',
        imagePath: 'assets/item/Item25.png',
        description: '击败敌人时有20%几率恢复1把刀锋。'),
    Relic(
        name: '狂暴之心',
        imagePath: 'assets/item/Item26.png',
        description: '生命值低于30%时，移动速度提升25%。'),
    Relic(
        name: '猎人之眼',
        imagePath: 'assets/item/Item27.png',
        description: '显示附近隐形敌人的位置。'),
    Relic(
        name: '虚空之石',
        imagePath: 'assets/item/Item28.png',
        description: '每60秒传送至随机安全位置，可手动激活。'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('背包'),
          backgroundColor: Colors.transparent,
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
        body: AppBackground(
          backgroundIndex: 4,
          overlayOpacity: 0.7,
          child: TabBarView(
            children: [
              _buildGridView(_buildSkinCard),
              _buildGridView(_buildRelicCard),
            ],
          ),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              skin.imagePath,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                relic.imagePath,
                width: 64,
                height: 64,
                fit: BoxFit.contain,
              ),
            ),
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
