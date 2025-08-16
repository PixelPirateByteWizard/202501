enum ArticleType { featured, flash, announcement }

class NewsArticle {
  final String id;
  final String title;
  final String source;
  final String? imageUrl;
  final DateTime publishedAt;
  final ArticleType type;

  NewsArticle({
    required this.id,
    required this.title,
    required this.source,
    this.imageUrl,
    required this.publishedAt,
    required this.type,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      source: json['source'] ?? '',
      imageUrl: json['imageUrl'],
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toIso8601String()),
      type: ArticleType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ArticleType.featured,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'source': source,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt.toIso8601String(),
      'type': type.toString().split('.').last,
    };
  }
}