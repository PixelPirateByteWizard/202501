class Clue {
  final String id;
  final String title;
  final String description;
  final String icon;
  final DateTime acquiredDate;
  final bool isNew;
  final String category;

  const Clue({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.acquiredDate,
    this.isNew = false,
    this.category = 'general',
  });

  Clue copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    DateTime? acquiredDate,
    bool? isNew,
    String? category,
  }) {
    return Clue(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      acquiredDate: acquiredDate ?? this.acquiredDate,
      isNew: isNew ?? this.isNew,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'acquiredDate': acquiredDate.millisecondsSinceEpoch,
      'isNew': isNew,
      'category': category,
    };
  }

  factory Clue.fromJson(Map<String, dynamic> json) {
    return Clue(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      acquiredDate: DateTime.fromMillisecondsSinceEpoch(json['acquiredDate']),
      isNew: json['isNew'] ?? false,
      category: json['category'] ?? 'general',
    );
  }
}
