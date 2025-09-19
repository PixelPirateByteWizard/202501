class Formation {
  final String id;
  final String name;
  final String description;
  final Map<String, int> bonuses; // 属性加成
  final List<String?> positions; // 9个位置，null表示空位

  Formation({
    required this.id,
    required this.name,
    required this.description,
    required this.bonuses,
    required this.positions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'bonuses': bonuses,
      'positions': positions,
    };
  }

  factory Formation.fromJson(Map<String, dynamic> json) {
    return Formation(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      bonuses: Map<String, int>.from(json['bonuses']),
      positions: List<String?>.from(json['positions']),
    );
  }

  Formation copyWith({
    String? id,
    String? name,
    String? description,
    Map<String, int>? bonuses,
    List<String?>? positions,
  }) {
    return Formation(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      bonuses: bonuses ?? this.bonuses,
      positions: positions ?? this.positions,
    );
  }
}

class FormationType {
  final String id;
  final String name;
  final String description;
  final Map<String, int> bonuses;

  FormationType({
    required this.id,
    required this.name,
    required this.description,
    required this.bonuses,
  });

  static List<FormationType> get defaultTypes {
    return [
      FormationType(
        id: 'feng_shi',
        name: '锋矢阵',
        description: '攻击型阵型，前锋伤害+15%，中军伤害+10%，但承伤增加20%',
        bonuses: {'attack': 15, 'damage_taken': 20},
      ),
      FormationType(
        id: 'yan_xing',
        name: '雁行阵',
        description: '平衡型阵型，全军攻防均衡，适合持久战',
        bonuses: {'attack': 5, 'defense': 5},
      ),
      FormationType(
        id: 'yu_lin',
        name: '鱼鳞阵',
        description: '防御型阵型，大幅提升防御力，但攻击力略有下降',
        bonuses: {'defense': 20, 'attack': -5},
      ),
    ];
  }
}