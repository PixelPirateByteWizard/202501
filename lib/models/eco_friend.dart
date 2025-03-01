class EcoFriend {
  final String id;
  final String name;
  final String avatar;
  final String bio;
  final List<String> interests;
  final List<String> presetMessages;

  // 新增的基本信息字段
  final String title; // 环保领域头衔/职称
  final List<String> badges; // 获得的荣誉徽章
  final List<String> projects; // 参与的主要项目
  final Map<String, String> stats; // 环保贡献数据

  const EcoFriend({
    required this.id,
    required this.name,
    required this.avatar,
    required this.bio,
    required this.interests,
    required this.presetMessages,
    required this.title,
    required this.badges,
    required this.projects,
    required this.stats,
  });

  // Simple manual JSON serialization
  factory EcoFriend.fromJson(Map<String, dynamic> json) {
    return EcoFriend(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      bio: json['bio'] as String,
      interests: List<String>.from(json['interests'] as List),
      presetMessages: List<String>.from(json['preset_messages'] as List),
      title: json['title'] as String,
      badges: List<String>.from(json['badges'] as List),
      projects: List<String>.from(json['projects'] as List),
      stats: Map<String, String>.from(json['stats'] as Map),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'bio': bio,
        'interests': interests,
        'preset_messages': presetMessages,
        'title': title,
        'badges': badges,
        'projects': projects,
        'stats': stats,
      };
}
