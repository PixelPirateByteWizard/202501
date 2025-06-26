import 'package:flutter/services.dart';

/// A simple audio service for game sound effects using system sounds and haptic feedback.
/// 一个使用系统声音和触觉反馈的简单游戏音效服务
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  bool _soundEnabled = true;
  bool _hapticEnabled = true;

  bool get soundEnabled => _soundEnabled;
  bool get hapticEnabled => _hapticEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  void setHapticEnabled(bool enabled) {
    _hapticEnabled = enabled;
  }

  /// Play sound for piece selection
  /// 播放棋子选择音效
  Future<void> playSelectSound() async {
    if (!_soundEnabled) return;
    try {
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      // Ignore errors on platforms that don't support system sounds
    }
  }

  /// Play sound for successful synthesis
  /// 播放成功合成音效
  Future<void> playSynthesisSound() async {
    if (!_soundEnabled) return;
    try {
      await SystemSound.play(SystemSoundType.click);
      if (_hapticEnabled) {
        await HapticFeedback.lightImpact();
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Play sound for successful match
  /// 播放成功匹配音效
  Future<void> playMatchSound() async {
    if (!_soundEnabled) return;
    try {
      await SystemSound.play(SystemSoundType.click);
      if (_hapticEnabled) {
        await HapticFeedback.mediumImpact();
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Play sound for level completion
  /// 播放关卡完成音效
  Future<void> playLevelCompleteSound() async {
    if (!_soundEnabled) return;
    try {
      await SystemSound.play(SystemSoundType.click);
      if (_hapticEnabled) {
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Play sound for invalid move
  /// 播放无效移动音效
  Future<void> playInvalidMoveSound() async {
    if (!_soundEnabled) return;
    try {
      if (_hapticEnabled) {
        await HapticFeedback.selectionClick();
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Provide haptic feedback for piece tap
  /// 为棋子点击提供触觉反馈
  Future<void> tapFeedback() async {
    if (!_hapticEnabled) return;
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Ignore errors
    }
  }
}
