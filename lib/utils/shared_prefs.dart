import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _prefs;

  // 初始化SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 保存最近聊天的角色ID
  static Future<bool> saveLastChatCharacterId(String characterId) async {
    return await _prefs.setString('last_chat_character_id', characterId);
  }

  // 获取最近聊天的角色ID
  static String? getLastChatCharacterId() {
    return _prefs.getString('last_chat_character_id');
  }

  // 保存主题模式
  static Future<bool> saveDarkMode(bool isDark) async {
    return await _prefs.setBool('is_dark_mode', isDark);
  }

  // 获取主题模式
  static bool getDarkMode() {
    return _prefs.getBool('is_dark_mode') ?? true; // 默认为深色模式
  }

  // 保存用户名
  static Future<bool> saveUsername(String username) async {
    return await _prefs.setString('username', username);
  }

  // 获取用户名
  static String getUsername() {
    return _prefs.getString('username') ?? '时空旅人_01';
  }

  // 保存通知设置
  static Future<bool> saveNotificationEnabled(bool enabled) async {
    return await _prefs.setBool('notification_enabled', enabled);
  }

  // 获取通知设置
  static bool getNotificationEnabled() {
    return _prefs.getBool('notification_enabled') ?? true;
  }
}
