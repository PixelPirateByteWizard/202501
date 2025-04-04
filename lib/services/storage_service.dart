import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  // Storage keys
  static const String qrHistoryKey = 'qr_history';
  static const String encryptionHistoryKey = 'encryption_history';
  static const String wordCountHistoryKey = 'word_count_history';

  // Initialize the SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save a string to SharedPreferences
  static Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // Get a string from SharedPreferences
  static String? getString(String key) {
    return _prefs.getString(key);
  }

  // Save a string list to SharedPreferences
  static Future<bool> saveStringList(String key, List<String> values) async {
    return await _prefs.setStringList(key, values);
  }

  // Get a string list from SharedPreferences
  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // Save an object to SharedPreferences (converted to JSON)
  static Future<bool> saveObject(String key, Map<String, dynamic> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  // Get an object from SharedPreferences (converted from JSON)
  static Map<String, dynamic>? getObject(String key) {
    final String? jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  // Save a list of objects to SharedPreferences (converted to JSON)
  static Future<bool> saveObjectList(
      String key, List<Map<String, dynamic>> values) async {
    final List<String> jsonList =
        values.map((item) => jsonEncode(item)).toList();
    return await _prefs.setStringList(key, jsonList);
  }

  // Get a list of objects from SharedPreferences (converted from JSON)
  static List<Map<String, dynamic>>? getObjectList(String key) {
    final List<String>? jsonList = _prefs.getStringList(key);
    if (jsonList == null) return null;
    return jsonList
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }

  // Add an item to a history list (QR Code, Encryption, Word Count)
  static Future<bool> addToHistory(
      String historyKey, Map<String, dynamic> item) async {
    List<Map<String, dynamic>> history = getObjectList(historyKey) ?? [];
    // Add the new item at the beginning of the list
    history.insert(0, item);
    // Limit history to 50 items
    if (history.length > 50) {
      history = history.sublist(0, 50);
    }
    return await saveObjectList(historyKey, history);
  }

  // Get history list (QR Code, Encryption, Word Count)
  static List<Map<String, dynamic>> getHistory(String historyKey) {
    return getObjectList(historyKey) ?? [];
  }

  // Clear history list (QR Code, Encryption, Word Count)
  static Future<bool> clearHistory(String historyKey) async {
    return await saveObjectList(historyKey, []);
  }

  // Clear all data in SharedPreferences
  static Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
