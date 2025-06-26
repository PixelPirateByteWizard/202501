import 'package:shared_preferences/shared_preferences.dart';

/// A service class to handle persistent storage using SharedPreferences.
/// 一个使用 SharedPreferences 处理持久化存储的服务类
class StorageService {
  static const String _highestLevelKey = 'highestLevel';

  /// Saves the highest level number the player has reached.
  /// 保存玩家达到的最高关卡编号
  Future<void> saveHighestLevel(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_highestLevelKey, level);
    } catch (e) {
      // In a real app, you might want to log this error.
      // 在实际应用中，你可能需要记录这个错误
      print('Error saving level: $e');
    }
  }

  /// Loads the highest level number reached by the player.
  /// Defaults to 1 if no level has been saved yet.
  /// 加载玩家达到的最高关卡编号。如果还没有保存过，则默认为1
  Future<int> loadHighestLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_highestLevelKey) ?? 1;
    } catch (e) {
      print('Error loading level: $e');
      return 1;
    }
  }
}
