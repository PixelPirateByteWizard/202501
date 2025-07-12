import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrelexis/models/journal_entry.dart';
import 'package:astrelexis/models/todo_item.dart';

class StorageService {
  static const String _journalEntriesKey = 'journal_entries';
  static const String _todoItemsKey = 'todo_items';

  Future<void> saveJournalEntries(List<JournalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      entries.map((entry) => entry.toMap()).toList(),
    );
    await prefs.setString(_journalEntriesKey, encodedData);
  }

  Future<List<JournalEntry>> loadJournalEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_journalEntriesKey);
    if (encodedData != null) {
      final List<dynamic> decodedData = json.decode(encodedData);
      return decodedData.map((item) => JournalEntry.fromMap(item)).toList();
    }
    return [];
  }

  Future<void> updateJournalEntry(JournalEntry updatedEntry) async {
    final entries = await loadJournalEntries();
    final index = entries.indexWhere((entry) => entry.id == updatedEntry.id);
    if (index != -1) {
      entries[index] = updatedEntry;
      await saveJournalEntries(entries);
    }
  }

  Future<void> deleteJournalEntry(String entryId) async {
    final entries = await loadJournalEntries();
    entries.removeWhere((entry) => entry.id == entryId);
    await saveJournalEntries(entries);
  }

  Future<void> saveTodoItems(List<TodoItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      items.map((item) => item.toMap()).toList(),
    );
    await prefs.setString(_todoItemsKey, encodedData);
  }

  Future<List<TodoItem>> loadTodoItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_todoItemsKey);
    if (encodedData != null) {
      final List<dynamic> decodedData = json.decode(encodedData);
      return decodedData.map((item) => TodoItem.fromMap(item)).toList();
    }
    return [];
  }

  Future<void> updateTodoItem(TodoItem updatedTodo) async {
    final todos = await loadTodoItems();
    final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      todos[index] = updatedTodo;
      await saveTodoItems(todos);
    }
  }

  Future<void> deleteTodoItem(String todoId) async {
    final todos = await loadTodoItems();
    todos.removeWhere((todo) => todo.id == todoId);
    await saveTodoItems(todos);
  }

  Future<void> initializeSampleData() async {
    final existingEntries = await loadJournalEntries();
    final existingTodos = await loadTodoItems();

    // Add sample todos if none exist
    if (existingTodos.isEmpty) {
      final now = DateTime.now();
      final sampleTodos = [
        TodoItem(
          task: 'Finalize Q3 presentation',
          notes: 'Review slides and practice timing',
          dueDate: now,
          isCompleted: true,
        ),
        TodoItem(
          task: 'Review project proposals',
          notes: 'Check technical feasibility and budget',
          dueDate: now.add(const Duration(days: 1)),
          isCompleted: false,
        ),
        TodoItem(
          task: 'Team meeting preparation',
          notes: 'Prepare agenda and gather feedback',
          dueDate: now.add(const Duration(days: 2)),
          isCompleted: false,
        ),
      ];
      await saveTodoItems(sampleTodos);
    }
  }
}
