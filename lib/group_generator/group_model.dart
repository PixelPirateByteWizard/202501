class Player {
  final String id;
  final String name;
  final String? skill; // 可选的技能等级，如"初级"，"中级"，"高级"

  const Player({required this.id, required this.name, this.skill});

  // 从名称创建玩家
  factory Player.fromName(String name, {String? skill}) {
    return Player(
      id:
          DateTime.now().millisecondsSinceEpoch.toString() +
          name.hashCode.toString(),
      name: name,
      skill: skill,
    );
  }

  // 创建带有技能的玩家副本
  Player copyWithSkill(String? newSkill) {
    return Player(id: id, name: name, skill: newSkill);
  }

  // JSON序列化
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'skill': skill};
  }

  // JSON反序列化
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      skill: json['skill'] as String?,
    );
  }
}

class Group {
  final String id;
  final String name;
  final List<Player> players;
  final String? description; // 可选的组描述

  const Group({
    required this.id,
    required this.name,
    required this.players,
    this.description,
  });

  // 创建带有名称的空组
  factory Group.create(String name, {String? description}) {
    return Group(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      players: [],
      description: description,
    );
  }

  // 添加玩家到组
  Group addPlayer(Player player) {
    final updatedPlayers = List<Player>.from(players)..add(player);
    return Group(
      id: id,
      name: name,
      players: updatedPlayers,
      description: description,
    );
  }

  // 从组中移除玩家
  Group removePlayer(String playerId) {
    final updatedPlayers = List<Player>.from(players)
      ..removeWhere((player) => player.id == playerId);
    return Group(
      id: id,
      name: name,
      players: updatedPlayers,
      description: description,
    );
  }

  // 更新组名
  Group updateName(String newName) {
    return Group(
      id: id,
      name: newName,
      players: players,
      description: description,
    );
  }

  // 更新组描述
  Group updateDescription(String? newDescription) {
    return Group(
      id: id,
      name: name,
      players: players,
      description: newDescription,
    );
  }

  // 获取组平均技能水平（如果有）
  String? get averageSkill {
    if (players.isEmpty || players.every((player) => player.skill == null)) {
      return null;
    }

    final skillPlayers = players
        .where((player) => player.skill != null)
        .toList();
    if (skillPlayers.isEmpty) return null;

    // 简单实现，可以根据需要扩展为数值计算
    final Map<String, int> skillCount = {};
    for (final player in skillPlayers) {
      skillCount[player.skill!] = (skillCount[player.skill!] ?? 0) + 1;
    }

    // 返回最常见的技能等级
    String? mostCommonSkill;
    int maxCount = 0;
    skillCount.forEach((skill, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonSkill = skill;
      }
    });

    return mostCommonSkill;
  }

  // JSON序列化
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'players': players.map((player) => player.toJson()).toList(),
      'description': description,
    };
  }

  // JSON反序列化
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      players: (json['players'] as List)
          .map(
            (playerJson) => Player.fromJson(playerJson as Map<String, dynamic>),
          )
          .toList(),
      description: json['description'] as String?,
    );
  }
}
