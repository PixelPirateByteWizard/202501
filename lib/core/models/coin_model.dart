class Coin {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final double price;
  final double priceChange24h;
  final List<double> sparklineData;

  Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.priceChange24h,
    required this.sparklineData,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      priceChange24h: (json['priceChange24h'] ?? 0).toDouble(),
      sparklineData: List<double>.from(json['sparklineData'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'imageUrl': imageUrl,
      'price': price,
      'priceChange24h': priceChange24h,
      'sparklineData': sparklineData,
    };
  }
}