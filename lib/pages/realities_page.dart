import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../models/reality_model.dart';
import '../utils/navigation.dart';
import 'reality_detail_page.dart';

// 透明图片的字节数据 - 用作FadeInImage的占位符
final Uint8List kTransparentImage = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82
]);

class RealitiesPage extends StatefulWidget {
  const RealitiesPage({super.key});

  @override
  State<RealitiesPage> createState() => _RealitiesPageState();
}

class _RealitiesPageState extends State<RealitiesPage> {
  // 科幻风格背景图片URL列表 - 主要来源
  final List<String> _scifiBackgrounds = [
    'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=800', // 星空
    'https://images.unsplash.com/photo-1534796636912-3b95b3ab5986?q=80&w=800', // 霓虹城市
    'https://images.unsplash.com/photo-1520034475321-cbe63696469a?q=80&w=800', // 银河
    'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?q=80&w=800', // 星系
    'https://images.unsplash.com/photo-1614732414444-096e5f1122d5?q=80&w=800', // 未来城市
    'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=800', // 光效
    'https://images.unsplash.com/photo-1536440136628-849c177e76a1?q=80&w=800', // 极光
    'https://images.unsplash.com/photo-1484589065579-248aad0d8b13?q=80&w=800', // 光隧道
    'https://images.unsplash.com/photo-1465101162946-4377e57745c3?q=80&w=800', // 星轨
    'https://images.unsplash.com/photo-1510906594845-bc082582c8cc?q=80&w=800', // 宇宙飞船
    'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?q=80&w=800', // 地球视图
    'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?q=80&w=800', // 星云
    'https://images.unsplash.com/photo-1607499699372-8caefc5952b5?q=80&w=800', // 霓虹灯
    'https://images.unsplash.com/photo-1518365050014-70fe7232897f?q=80&w=800', // 光线
    'https://images.unsplash.com/photo-1506318137071-a8e063b4bec0?q=80&w=800', // 星空2
    'https://images.unsplash.com/photo-1537420327992-d6e192287183?q=80&w=800', // 霓虹灯2
    'https://images.unsplash.com/photo-1504333638930-c8787321eee0?q=80&w=800', // 紫色光效
    'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?q=80&w=800', // 渐变
    'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?q=80&w=800', // 星空3
    'https://images.unsplash.com/photo-1516339901601-2e1b62dc0c45?q=80&w=800', // 霓虹城市2
    'https://images.unsplash.com/photo-1558486012-817176f84c6d?q=80&w=800', // 未来感
    'https://images.unsplash.com/photo-1504192010706-dd7f569ee2be?q=80&w=800', // 星空4
    'https://images.unsplash.com/photo-1507608616759-54f48f0af0ee?q=80&w=800', // 极光2
    'https://images.unsplash.com/photo-1534330207526-d4ac467e2ede?q=80&w=800', // 紫色光效2
    'https://images.unsplash.com/photo-1531306728370-e2ebd9d7bb99?q=80&w=800', // 梦幻
    'https://images.unsplash.com/photo-1528818955841-a7f1425131b5?q=80&w=800', // 未来城市2
    'https://images.unsplash.com/photo-1502481851512-e9e2529bfbf9?q=80&w=800', // 星空5
    'https://images.unsplash.com/photo-1510784722466-f2aa9c52fff6?q=80&w=800', // 星云2
    'https://images.unsplash.com/photo-1566438480900-0609be27a4be?q=80&w=800', // 极光3
    'https://images.unsplash.com/photo-1535223289827-42f1e9919769?q=80&w=800', // 未来感2
  ];

  // 备用背景图片URL列表 - 使用更可靠的CDN源
  final List<String> _fallbackBackgrounds = [
    'https://source.unsplash.com/random/800x600/?space', // 随机太空图
    'https://source.unsplash.com/random/800x600/?galaxy', // 随机银河图
    'https://source.unsplash.com/random/800x600/?nebula', // 随机星云图
    'https://source.unsplash.com/random/800x600/?stars', // 随机星空图
    'https://source.unsplash.com/random/800x600/?cosmos', // 随机宇宙图
    'https://source.unsplash.com/random/800x600/?night', // 随机夜空图
    'https://images.pexels.com/photos/1169754/pexels-photo-1169754.jpeg?auto=compress&cs=tinysrgb&w=800', // 银河
    'https://images.pexels.com/photos/1252890/pexels-photo-1252890.jpeg?auto=compress&cs=tinysrgb&w=800', // 星空
    'https://images.pexels.com/photos/956999/milky-way-starry-sky-night-sky-star-956999.jpeg?auto=compress&cs=tinysrgb&w=800', // 银河2
    'https://images.pexels.com/photos/1694000/pexels-photo-1694000.jpeg?auto=compress&cs=tinysrgb&w=800', // 星空2
  ];

  // 科幻风格头像URL列表 - 确保有32个元素
  final List<String> _scifiAvatars = [
    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200', // 默认用户
    'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?q=80&w=200', // 男性头像
    'https://images.unsplash.com/photo-1546961329-78bef0414d7c?q=80&w=200', // 女性头像
    'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200', // 男性头像2
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200', // 女性头像2
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=200', // 男性头像3
    'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e?q=80&w=200', // 女性头像3
    'https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?q=80&w=200', // 男性头像4
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200', // 女性头像4
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200', // 男性头像5
    'https://images.unsplash.com/photo-1614283233556-f35b0c801ef1?q=80&w=200', // 女性头像5
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=200', // 男性头像6
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200', // 女性头像6
    'https://images.unsplash.com/photo-1521119989659-a83eee488004?q=80&w=200', // 男性头像7
    'https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?q=80&w=200', // 女性头像7
    'https://images.unsplash.com/photo-1522556189639-b150ed9c4330?q=80&w=200', // 男性头像8
    'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?q=80&w=200', // 女性头像8
    'https://images.unsplash.com/photo-1499996860823-5214fcc65f8f?q=80&w=200', // 男性头像9
    'https://images.unsplash.com/photo-1548142813-c348350df52b?q=80&w=200', // 女性头像9
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200', // 男性头像10
    'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?q=80&w=200', // 女性头像10
    'https://images.unsplash.com/photo-1528892952291-009c663ce843?q=80&w=200', // 男性头像11
    'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?q=80&w=200', // 女性头像11
    'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=200', // 男性头像12
    'https://images.unsplash.com/photo-1502323777036-f29e3972f5ea?q=80&w=200', // 女性头像12
    'https://images.unsplash.com/photo-1504257432389-52343af06ae3?q=80&w=200', // 男性头像13
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=200', // 女性头像13
    'https://images.unsplash.com/photo-1541647376583-8934aaf3448a?q=80&w=200', // 男性头像14
    'https://images.unsplash.com/photo-1554151228-14d9def656e4?q=80&w=200', // 女性头像14
    'https://images.unsplash.com/photo-1504593811423-6dd665756598?q=80&w=200', // 男性头像15
    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=200', // 女性头像15
    'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=200', // 男性头像16
    'https://images.unsplash.com/photo-1580489944761-15a19d654956?q=80&w=200', // 女性头像16
  ];

  // 模拟平行时空数据 - 32个
  late List<Reality> _realities;
  bool _imagesPreloaded = false;

  @override
  void initState() {
    super.initState();
    _initializeRealities();
  }

  void _initializeRealities() {
    // 角色名称列表
    final List<String> names = [
      '意识漫游者',
      '赛博歌姬',
      '量子工程师',
      '星际诗人',
      '梦境建筑师',
      '时间编织者',
      '虚拟考古学家',
      '情感炼金术士',
      '星系守望者',
      '记忆收藏家',
      '概率操控者',
      '维度旅行家',
      '思想雕塑家',
      '未来回忆师',
      '光影魔术师',
      '元素和声者',
      '神经网络诗人',
      '反物质艺术家',
      '生物机械工程师',
      '全息记录者',
      '引力编舞者',
      '虚空聆听者',
      '分形梦想家',
      '量子占卜师',
      '超弦理论家',
      '意识黑客',
      '时空建筑师',
      '平行历史学家',
      '奇点探索者',
      '混沌数学家',
      '宇宙生态学家',
      '意识进化论者'
    ];

    // 角色描述列表
    final List<String> descriptions = [
      '"万物皆有裂痕，那是光照进来的地方。"',
      '"我的歌声，是霓虹下的唯一真实。"',
      '"时间只是一个可被编程的变量。"',
      '"宇宙的韵律，藏在每颗恒星的脉搏里。"',
      '"我们在梦中创造的世界，比现实更加真实。"',
      '"每一秒都是一根线，我在编织命运的锦缎。"',
      '"我在数据海洋中挖掘被遗忘的文明。"',
      '"我能将悲伤转化为希望，恐惧变为勇气。"',
      '"我的瞳孔里映照着千万个文明的兴衰。"',
      '"每一段回忆都是我收藏的珍宝。"',
      '"在我的世界里，偶然只是未被发现的必然。"',
      '"我穿梭于无数平行宇宙，寻找最美的可能性。"',
      '"我用想象力雕刻出思想的形状。"',
      '"我记得那些尚未发生的美好瞬间。"',
      '"我能让光与影讲述永恒的故事。"',
      '"风、火、水、土在我的指挥下奏响宇宙交响曲。"',
      '"我的思维是由量子比特编织的诗篇。"',
      '"我用不存在的材料创造永恒的艺术。"',
      '"在我的世界，生命与机械早已融为一体。"',
      '"我的每一次心跳都记录着宇宙的脉动。"',
      '"我让星球与星系随着引力的韵律起舞。"',
      '"我能听见宇宙深处的低语和呢喃。"',
      '"我的梦境是无限递归的分形模式。"',
      '"我通过量子纠缠预见无数可能的未来。"',
      '"我在十一维空间中弹奏宇宙的弦乐。"',
      '"我能入侵现实的源代码，重写存在的规则。"',
      '"我用时间和空间作为建材，构筑不可能的建筑。"',
      '"我记录着那些从未发生过的历史。"',
      '"我站在现实的边缘，凝视着无限的可能性。"',
      '"在混沌中，我发现了最完美的秩序。"',
      '"我研究星系间的共生关系和能量循环。"',
      '"我见证了思想从单一到复杂的进化历程。"',
    ];

    // 初始化角色列表，确保每个角色都有不同的背景图片和头像以及备用背景
    _realities = List.generate(32, (index) {
      // 使用模运算确保不会超出数组范围
      int bgIndex = index % _scifiBackgrounds.length;
      int avatarIndex = index % _scifiAvatars.length;
      int fallbackIndex = index % _fallbackBackgrounds.length;

      return Reality(
        id: (index + 1).toString(),
        name: names[index],
        description: descriptions[index],
        avatarUrl: _scifiAvatars[avatarIndex],
        backgroundUrl: _scifiBackgrounds[bgIndex],
        fallbackBackgroundUrl: _fallbackBackgrounds[fallbackIndex],
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在这里预加载图片
    if (!_imagesPreloaded) {
      _preloadImages();
      _imagesPreloaded = true;
    }
  }

  // 预加载图片
  void _preloadImages() {
    for (var reality in _realities) {
      precacheImage(NetworkImage(reality.avatarUrl), context);
      precacheImage(NetworkImage(reality.backgroundUrl), context);
    }
  }

  // 显示理念介绍的对话框
  void _showConceptDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  const Color(0xFFF5F0FA),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B2C9E).withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 宇宙图标
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6B2C9E).withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 轨道1
                      Transform.rotate(
                        angle: 0.3,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF6B2C9E).withOpacity(0.7),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      // 轨道2
                      Transform.rotate(
                        angle: 2.0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF4A1A6B).withOpacity(0.7),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      // 中心星球
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF2A0B47),
                        ),
                      ),
                      // 行星1
                      Positioned(
                        top: 10,
                        right: 12,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF6B2C9E),
                          ),
                        ),
                      ),
                      // 行星2
                      Positioned(
                        bottom: 15,
                        left: 10,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4A1A6B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '平行时空理念',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '在无限的宇宙中，存在着无数个平行时空，每一个都有着不同版本的你。'
                  '\n\n这些角色代表了你在不同现实中可能成为的样子 - 诗人、工程师、艺术家、探险家...'
                  '\n\n通过与这些"平行的自己"对话，你可以探索未知的可能性，发现自己潜在的天赋和视角。'
                  '\n\n选择一个角色，开始一段跨越维度的对话吧。',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // 新增：举报和屏蔽功能说明
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: const Color(0xFF6B2C9E),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '内容管理功能',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2A0B47),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 举报功能
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECEC),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.report_outlined,
                              color: Colors.red,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '举报功能',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2A0B47),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '长按角色卡片可举报不良内容。举报后，该角色将从您的列表中永久删除，我们会对内容进行审核。',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Divider(color: Colors.grey[200]),
                      const SizedBox(height: 12),

                      // 屏蔽功能
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.block,
                              color: const Color(0xFF6B2C9E),
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '屏蔽功能',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2A0B47),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '长按角色卡片可屏蔽不感兴趣的内容。屏蔽后，该角色将从您的列表中永久删除，不会再次显示。',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Divider(color: Colors.grey[200]),
                      const SizedBox(height: 12),

                      // 操作提示
                      Row(
                        children: [
                          Icon(
                            Icons.touch_app,
                            color: const Color(0xFF6B2C9E),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '长按任意角色卡片即可使用举报或屏蔽功能',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2A0B47),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6B2C9E), Color(0xFF4A1A6B)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6B2C9E).withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      '开始探索',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 点击空白区域收起键盘
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // 背景装饰
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        const Color(0xFFF5F0FA).withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: _buildRealitiesList(),
                  ),
                ],
              ),
              // 左上角装饰性图标
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6B2C9E).withAlpha(40),
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 外环
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF6B2C9E).withOpacity(0.7),
                            width: 1.5,
                          ),
                        ),
                      ),
                      // 内环
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF4A1A6B).withOpacity(0.7),
                            width: 1.5,
                          ),
                        ),
                      ),
                      // 中心点
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF2A0B47),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 右上角信息按钮
              Positioned(
                top: 16,
                right: 16,
                child: InkWell(
                  onTap: _showConceptDialog,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6B2C9E).withAlpha(40),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 光晕效果
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFF6B2C9E).withOpacity(0.1),
                                Colors.transparent,
                              ],
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),
                        // 信息图标
                        Icon(
                          Icons.info_outline,
                          color: const Color(0xFF4A1A6B),
                          size: 24,
                        ),
                        // 小光点装饰
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF6B2C9E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Column(
        children: [
          Text(
            '平行时空',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: const Color(0xFF4A1A6B),
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '在无数个宇宙中，遇见不同的自己',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B2C9E),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealitiesList() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 每行显示2个卡片
        childAspectRatio: 0.75, // 卡片宽高比
        crossAxisSpacing: 12, // 水平间距
        mainAxisSpacing: 12, // 垂直间距
      ),
      itemCount: _realities.length,
      itemBuilder: (context, index) {
        final reality = _realities[index];
        return _buildRealityCard(reality);
      },
    );
  }

  // 构建加载中的背景
  Widget _buildLoadingBackground() {
    return Container(
      color: Colors.white.withOpacity(0.9),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor:
                    AlwaysStoppedAnimation<Color>(const Color(0xFF6B2C9E)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '加载中...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建渐变备用背景 - 当所有图片加载失败时使用
  Widget _buildFallbackGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFF0F0F0),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.blur_on,
          size: 40,
          color: const Color(0xFF6B2C9E).withOpacity(0.5),
        ),
      ),
    );
  }

  // 显示举报和屏蔽选项
  void _showReportBlockOptions(Reality reality) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(
                  '操作选项',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.report_outlined, color: Colors.red),
                ),
                title: const Text(
                  '举报',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A0B47),
                  ),
                ),
                subtitle: const Text(
                  '举报不良内容或违规行为',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(reality);
                },
              ),
              const Divider(height: 1, indent: 70, endIndent: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.block, color: Color(0xFF6B2C9E)),
                ),
                title: const Text(
                  '屏蔽',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2A0B47),
                  ),
                ),
                subtitle: const Text(
                  '不再显示此平行时空',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showBlockDialog(reality);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // 显示举报对话框
  void _showReportDialog(Reality reality) {
    final TextEditingController _reportController = TextEditingController();
    String _selectedReportReason = '内容不当';
    final List<String> _reportReasons = [
      '内容不当',
      '侵犯隐私',
      '虚假信息',
      '仇恨言论',
      '其他原因'
    ];

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            '举报平行时空',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2A0B47),
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.report_outlined,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '你正在举报: ${reality.name}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2A0B47),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '请选择举报原因:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: _reportReasons.map((reason) {
                          return RadioListTile<String>(
                            title: Text(
                              reason,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF2A0B47),
                              ),
                            ),
                            value: reason,
                            groupValue: _selectedReportReason,
                            activeColor: const Color(0xFF6B2C9E),
                            onChanged: (value) {
                              setState(() {
                                _selectedReportReason = value!;
                              });
                            },
                            dense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  '补充说明 (选填，最多200字):',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _reportController,
                  maxLines: 3,
                  maxLength: 200,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2A0B47),
                  ),
                  decoration: InputDecoration(
                    hintText: '请详细描述您遇到的问题...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: const Color(0xFF6B2C9E)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEC).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '提示: 举报成功后，该平行时空将从您的列表中永久删除。',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                _removeReality(reality, '举报');
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6B2C9E),
                backgroundColor: const Color(0xFFF5F0FA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                '提交举报',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      ),
    );
  }

  // 显示屏蔽对话框
  void _showBlockDialog(Reality reality) {
    final TextEditingController _blockController = TextEditingController();
    String _selectedBlockReason = '不感兴趣';
    final List<String> _blockReasons = ['不感兴趣', '内容重复', '不喜欢风格', '其他原因'];

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            '屏蔽平行时空',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2A0B47),
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.block,
                          color: const Color(0xFF6B2C9E),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '你正在屏蔽: ${reality.name}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2A0B47),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '请选择屏蔽原因:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: _blockReasons.map((reason) {
                          return RadioListTile<String>(
                            title: Text(
                              reason,
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF2A0B47),
                              ),
                            ),
                            value: reason,
                            groupValue: _selectedBlockReason,
                            activeColor: const Color(0xFF6B2C9E),
                            onChanged: (value) {
                              setState(() {
                                _selectedBlockReason = value!;
                              });
                            },
                            dense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  '补充说明 (选填，最多100字):',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A0B47),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _blockController,
                  maxLines: 2,
                  maxLength: 100,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2A0B47),
                  ),
                  decoration: InputDecoration(
                    hintText: '请说明您屏蔽的具体原因...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: const Color(0xFF6B2C9E)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey[700],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '提示: 屏蔽后，该平行时空将从您的列表中永久删除。',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                _removeReality(reality, '屏蔽');
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF6B2C9E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                '确认屏蔽',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        ),
      ),
    );
  }

  // 从列表中移除平行时空
  void _removeReality(Reality reality, String action) {
    // 从列表中移除
    setState(() {
      _realities.removeWhere((item) => item.id == reality.id);
    });

    // 显示成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已${action}该平行时空'),
        backgroundColor: action == '举报' ? Colors.red : Colors.grey[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: '知道了',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    // 这里可以添加实际的举报/屏蔽逻辑，如发送到服务器等
    // 例如: ApiService.reportReality(reality.id, reason, description);
  }

  Widget _buildRealityCard(Reality reality) {
    return GestureDetector(
      onTap: () {
        NavigationUtil.navigateWithAnimation(
          context,
          RealityDetailPage(reality: reality),
        );
      },
      onLongPress: () {
        _showReportBlockOptions(reality);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 背景图片 - 使用FadeInImage实现平滑过渡和加载状态
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage, // 透明占位符
                image: reality.effectiveBackgroundUrl,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 300),
                imageErrorBuilder: (context, error, stackTrace) {
                  // 如果当前未使用备用URL，则尝试使用备用URL
                  if (!reality.isUsingFallbackBackground &&
                      reality.fallbackBackgroundUrl != null) {
                    // 标记主图片加载失败，下次将使用备用图片
                    reality.markBackgroundLoadFailed();
                    // 强制重建组件
                    if (mounted) {
                      Future.microtask(() => setState(() {}));
                    }
                    // 显示加载中占位符
                    return _buildLoadingBackground();
                  }

                  // 如果备用图片也加载失败，显示渐变背景
                  return _buildFallbackGradientBackground();
                },
              ),
              // 渐变遮罩 - 只在底部添加轻微渐变以确保文字可读
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
              // 内容
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 头像和名称
                    Row(
                      children: [
                        // 头像 - 使用Hero动画和更可靠的图片加载
                        Hero(
                          tag: 'avatar-${reality.id}',
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF6B2C9E).withAlpha(128),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(20),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: reality.avatarUrl,
                                fit: BoxFit.cover,
                                fadeInDuration:
                                    const Duration(milliseconds: 300),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  // 头像加载失败时显示默认头像
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey[500],
                                      size: 24,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 名称
                        Expanded(
                          child: Hero(
                            tag: 'name-${reality.id}',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                reality.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // 描述
                    Hero(
                      tag: 'desc-${reality.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          reality.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
