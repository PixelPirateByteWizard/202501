enum WorkstationStatus { optimal, warning, error, offline }

class Workstation {
  final String id;
  final String name;
  final String icon;
  final WorkstationStatus status;
  final String inputResource;
  final String outputResource;
  final double efficiency;
  final int level;
  final bool isBuilt;

  const Workstation({
    required this.id,
    required this.name,
    required this.icon,
    required this.status,
    required this.inputResource,
    required this.outputResource,
    required this.efficiency,
    this.level = 1,
    this.isBuilt = true,
  });

  Workstation copyWith({
    String? id,
    String? name,
    String? icon,
    WorkstationStatus? status,
    String? inputResource,
    String? outputResource,
    double? efficiency,
    int? level,
    bool? isBuilt,
  }) {
    return Workstation(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      inputResource: inputResource ?? this.inputResource,
      outputResource: outputResource ?? this.outputResource,
      efficiency: efficiency ?? this.efficiency,
      level: level ?? this.level,
      isBuilt: isBuilt ?? this.isBuilt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'status': status.index,
      'inputResource': inputResource,
      'outputResource': outputResource,
      'efficiency': efficiency,
      'level': level,
      'isBuilt': isBuilt,
    };
  }

  factory Workstation.fromJson(Map<String, dynamic> json) {
    return Workstation(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      status: WorkstationStatus.values[json['status']],
      inputResource: json['inputResource'],
      outputResource: json['outputResource'],
      efficiency: json['efficiency'].toDouble(),
      level: json['level'] ?? 1,
      isBuilt: json['isBuilt'] ?? true,
    );
  }
}
