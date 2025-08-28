class Assistant {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final String iconData;
  final String backgroundColor;

  Assistant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.iconData,
    required this.backgroundColor,
  });

  @override
  String toString() {
    return 'Assistant{id: $id, name: $name, category: $category}';
  }
}

// Keep these for backward compatibility
class TarotCard {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  TarotCard({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  @override
  String toString() {
    return 'TarotCard{id: $id, name: $name}';
  }
}

class AstrologyReading {
  final String sign;
  final String date;
  final String description;

  AstrologyReading({
    required this.sign,
    required this.date,
    required this.description,
  });

  @override
  String toString() {
    return 'AstrologyReading{sign: $sign, date: $date}';
  }
}
