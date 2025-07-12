import 'dart:convert';
import 'package:uuid/uuid.dart';

class TodoItem {
  final String id;
  final String task;
  final String? notes;
  final DateTime dueDate;
  bool isCompleted;

  TodoItem({
    String? id,
    required this.task,
    this.notes,
    required this.dueDate,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'] as String,
      task: map['task'] as String,
      notes: map['notes'] as String?,
      dueDate: DateTime.parse(map['dueDate'] as String),
      isCompleted: map['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'notes': notes,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  String toJson() => json.encode(toMap());

  factory TodoItem.fromJson(String source) =>
      TodoItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
