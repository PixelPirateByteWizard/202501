import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart'; // 引入以使用 GameStats

class GameSettingsService with ChangeNotifier {
  late SharedPreferences _prefs;

  // 私有状态
  bool _particlesEnabled = true;

  // 公共 Getters
  bool get particlesEnabled => _particlesEnabled;

  // 用于 SharedPreferences 的键
  static const String _particlesEnabledKey = 'settings_particlesEnabled';

  // 异步初始化方法，用于加载设置
  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _particlesEnabled = _prefs.getBool(_particlesEnabledKey) ?? true;
    notifyListeners();
  }

  // 更新粒子效果开关
  void updateParticlesEnabled(bool enabled) {
    if (_particlesEnabled == enabled) return;
    _particlesEnabled = enabled;
    _prefs.setBool(_particlesEnabledKey, enabled);
    notifyListeners();
  }

  // 重置为默认设置
  Future<void> resetToDefaults() async {
    updateParticlesEnabled(true);
  }

  // 重置所有游戏数据和设置
  Future<void> resetAllGameData() async {
    // 重置游戏统计数据
    await StorageService.saveGameStats(GameStats());
    // 重置本服务的设置
    await resetToDefaults();
  }
}
