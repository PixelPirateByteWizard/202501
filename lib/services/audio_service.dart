import 'package:flutter/services.dart';

class AudioService {
  static bool _soundEnabled = true;
  static bool _musicEnabled = true;
  static double _soundVolume = 0.85;
  static double _musicVolume = 0.7;

  // 初始化音频服务
  static Future<void> initialize() async {
    // 这里可以初始化音频播放器
    // 由于没有添加音频依赖，这里只是占位
  }

  // 播放音效
  static Future<void> playSound(SoundEffect effect) async {
    if (!_soundEnabled) return;
    
    // 使用系统震动作为音效的替代
    switch (effect) {
      case SoundEffect.buttonClick:
        HapticFeedback.lightImpact();
        break;
      case SoundEffect.battleHit:
        HapticFeedback.mediumImpact();
        break;
      case SoundEffect.victory:
        HapticFeedback.heavyImpact();
        break;
      case SoundEffect.levelUp:
        HapticFeedback.heavyImpact();
        break;
      case SoundEffect.equipItem:
        HapticFeedback.lightImpact();
        break;
      case SoundEffect.error:
        HapticFeedback.vibrate();
        break;
    }
  }

  // 播放背景音乐
  static Future<void> playBackgroundMusic(BackgroundMusic music) async {
    if (!_musicEnabled) return;
    
    // 这里应该播放背景音乐
    // 由于没有音频依赖，暂时不实现
  }

  // 停止背景音乐
  static Future<void> stopBackgroundMusic() async {
    // 停止背景音乐
  }

  // 设置音效开关
  static void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  // 设置音乐开关
  static void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    }
  }

  // 设置音效音量
  static void setSoundVolume(double volume) {
    _soundVolume = volume.clamp(0.0, 1.0);
  }

  // 设置音乐音量
  static void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
  }

  // 获取设置
  static bool get soundEnabled => _soundEnabled;
  static bool get musicEnabled => _musicEnabled;
  static double get soundVolume => _soundVolume;
  static double get musicVolume => _musicVolume;
}

enum SoundEffect {
  buttonClick,
  battleHit,
  victory,
  levelUp,
  equipItem,
  error,
}

enum BackgroundMusic {
  menu,
  battle,
  story,
}