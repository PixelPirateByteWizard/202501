enum MessageType {
  user,
  ai,
  system,
}

class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final List<String>? quickActions;

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.quickActions,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    List<String>? quickActions,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      quickActions: quickActions ?? this.quickActions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'quickActions': quickActions,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      type: MessageType.values.firstWhere((e) => e.name == json['type']),
      timestamp: DateTime.parse(json['timestamp']),
      quickActions: json['quickActions']?.cast<String>(),
    );
  }
}