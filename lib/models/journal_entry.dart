import 'dart:convert';
import 'package:uuid/uuid.dart';

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final String? imageUrl; // Used for "Memory" entries
  final List<String> tags; // Tags for categorization
  final DateTime createdAt;

  JournalEntry({
    String? id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.tags = const [],
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['imageUrl'] as String?,
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory JournalEntry.fromJson(String source) =>
      JournalEntry.fromMap(json.decode(source) as Map<String, dynamic>);
}
