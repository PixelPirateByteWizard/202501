class RadioStation {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String audioUrl;
  final String category;
  final bool isLive; // 是否为直播电台

  RadioStation({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.audioUrl,
    required this.category,
    this.isLive = true, // 默认为直播电台
  });

  // 创建一个可靠的备用音频流URL
  static const String fallbackAudioUrl =
      'https://stream.0nlineradio.com/classical';

  // 创建一个包含默认电台列表的静态方法
  static List<RadioStation> getDefaultStations() {
    return [
      // 特色电台
      RadioStation(
        id: '1',
        name: '经典音乐',
        description: '聆听永恒的经典旋律',
        imageUrl:
            'https://images.unsplash.com/photo-1511379938547-c1f69419868d?q=80&w=800&auto=format&fit=crop',
        audioUrl: 'https://lhttp.qingting.fm/live/267/64k.mp3',
        category: '音乐',
      ),

      // 其他电台
      RadioStation(
        id: '2',
        name: '生活娱乐台',
        description: '丰富多彩的生活资讯',
        imageUrl:
            'https://images.unsplash.com/photo-1557672172-298e090bd0f1?q=80&w=800&auto=format&fit=crop',
        audioUrl: 'https://lhttp.qingting.fm/live/20715/64k.mp3',
        category: '娱乐',
      ),
      RadioStation(
        id: '3',
        name: '乡村',
        description: '乡村故事与民俗文化',
        imageUrl:
            'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=800&auto=format&fit=crop',
        audioUrl: 'https://lhttp.qingting.fm/live/3977/64k.mp3',
        category: '文化',
      ),
      RadioStation(
        id: '4',
        name: '国风',
        description: '传统戏曲艺术的魅力',
        imageUrl:
            'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?q=80&w=800&auto=format&fit=crop',
        audioUrl: 'https://lhttp.qingting.fm/live/4595/64k.mp3',
        category: '文化',
      ),
      RadioStation(
        id: '6',
        name: 'Capital Yorkshire',
        description: '英国流行音乐电台',
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=800&auto=format&fit=crop',
        audioUrl:
            'https://media-ice.musicradio.com/CapitalYorkshireSouthWestMP3',
        category: '国际',
      ),
      RadioStation(
        id: '7',
        name: '金曲音乐',
        description: '经典金曲不间断',
        imageUrl:
            'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=800&auto=format&fit=crop',
        audioUrl: 'https://lhttp.qingting.fm/live/20192/64k.mp3',
        category: '音乐',
      ),
      RadioStation(
        id: '8',
        name: '华语民谣',
        description: '青春活力的声音',
        imageUrl:
            'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?q=80&w=800&auto=format&fit=crop',
        audioUrl: 'https://lhttp.qingting.fm/live/20192/64k.mp3',
        category: '教育',
      ),
      RadioStation(
        id: '9',
        name: '交通之声',
        description: '实时路况与交通资讯',
        imageUrl:
            'https://images.unsplash.com/photo-1519003722824-194d4455a60c?q=80&w=800&auto=format&fit=crop',
        audioUrl: 'https://lhttp.qingting.fm/live/20212386/64k.mp3',
        category: '资讯',
      ),
      RadioStation(
        id: '11',
        name: '音乐故事',
        description: '音乐背后的故事',
        imageUrl:
            'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?q=80&w=800&auto=format&fit=crop',
        audioUrl: 'https://lhttp.qingting.fm/live/15318146/64k.mp3',
        category: '音乐',
      ),
    ];
  }

  @override
  String toString() {
    return 'RadioStation{id: $id, name: $name, category: $category}';
  }
}
