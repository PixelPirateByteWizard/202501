import 'package:shared_preferences/shared_preferences.dart';

class VibrationService {
  static final VibrationService _instance = VibrationService._internal();
  factory VibrationService() => _instance;

  VibrationService._internal();

  // 振動狀態
  bool _vibrationEnabled = true;
  bool _hasVibrator = false;

  // 振動模式持續時間（毫秒）
  static const int _shortVibration = 20;
  static const int _mediumVibration = 50;
  static const int _longVibration = 100;
  static const int _patternVibration = 200;
  static const int _strongVibration = 80;

  // 初始化
  Future<void> init() async {
    try {
      // 检查是否支持振动的逻辑被移除，默认不支持振动
      _hasVibrator = false;

      // 讀取用戶設置
      final prefs = await SharedPreferences.getInstance();
      _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    } catch (e) {
      print('振動服務初始化錯誤: $e');
      _hasVibrator = false;
      _vibrationEnabled = false;
    }
  }

  // 設置振動狀態
  Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibrationEnabled', enabled);
  }

  // 獲取振動狀態
  bool get isVibrationEnabled => _vibrationEnabled && _hasVibrator;

  // 短振動（按鈕點擊）
  Future<void> shortVibrate() async {
    // 不执行任何振动
    if (!isVibrationEnabled) return;
    // 移除振动逻辑，只保留空方法
  }

  // 中等振動（敵人擊中）
  Future<void> mediumVibrate() async {
    // 不执行任何振动
    if (!isVibrationEnabled) return;
    // 移除振动逻辑，只保留空方法
  }

  // 強烈振動（暴擊和範圍攻擊）
  Future<void> strongVibrate() async {
    // 不执行任何振动
    if (!isVibrationEnabled) return;
    // 移除振动逻辑，只保留空方法
  }

  // 長振動（遊戲結束）
  Future<void> longVibrate() async {
    // 不执行任何振动
    if (!isVibrationEnabled) return;
    // 移除振动逻辑，只保留空方法
  }

  // 震動模式（玩家受到傷害）
  Future<void> patternVibrate() async {
    // 不执行任何振动
    if (!isVibrationEnabled) return;
    // 移除振动逻辑，只保留空方法
  }

  // 升級振動模式
  Future<void> upgradeVibrate() async {
    // 不执行任何振动
    if (!isVibrationEnabled) return;
    // 移除振动逻辑，只保留空方法
  }
}
