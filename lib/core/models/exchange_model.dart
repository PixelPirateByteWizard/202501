enum ExchangeAnnouncementType { announcement, activity, maintenance, listing }

class ExchangeAnnouncement {
  final String id;
  final String title;
  final String content;
  final String exchangeName;
  final String exchangeIcon;
  final ExchangeAnnouncementType type;
  final DateTime publishedAt;
  final bool isImportant;
  final String? actionUrl;

  ExchangeAnnouncement({
    required this.id,
    required this.title,
    required this.content,
    required this.exchangeName,
    required this.exchangeIcon,
    required this.type,
    required this.publishedAt,
    this.isImportant = false,
    this.actionUrl,
  });

  factory ExchangeAnnouncement.fromJson(Map<String, dynamic> json) {
    return ExchangeAnnouncement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      exchangeName: json['exchangeName'] ?? '',
      exchangeIcon: json['exchangeIcon'] ?? '',
      type: ExchangeAnnouncementType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ExchangeAnnouncementType.announcement,
      ),
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toIso8601String()),
      isImportant: json['isImportant'] ?? false,
      actionUrl: json['actionUrl'],
    );
  }
}

class ExchangeInfo {
  final String name;
  final String icon;
  final String status; // online, maintenance, limited
  final double volume24h;
  final int tradingPairs;
  final String? statusMessage;

  ExchangeInfo({
    required this.name,
    required this.icon,
    required this.status,
    required this.volume24h,
    required this.tradingPairs,
    this.statusMessage,
  });

  factory ExchangeInfo.fromJson(Map<String, dynamic> json) {
    return ExchangeInfo(
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      status: json['status'] ?? 'online',
      volume24h: (json['volume24h'] ?? 0).toDouble(),
      tradingPairs: json['tradingPairs'] ?? 0,
      statusMessage: json['statusMessage'],
    );
  }
}