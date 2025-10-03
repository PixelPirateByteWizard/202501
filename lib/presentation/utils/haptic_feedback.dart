import 'dart:async';
import 'package:flutter/services.dart';

class HapticFeedbackService {
  static bool _isEnabled = false;
  static int _lastFeedbackTime = 0;
  static const int _minTimeBetweenFeedbacks = 80; // Milliseconds

  // Initialize the service
  static Future<void> initialize() async {
    // Default to enabled, will be updated based on settings
    _isEnabled = true;
  }

  // Enable or disable haptic feedback
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  // Check if haptic feedback is enabled
  static bool isEnabled() {
    return _isEnabled;
  }

  // Check if enough time has passed since the last feedback
  static bool _canProvideFeedback() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastFeedbackTime < _minTimeBetweenFeedbacks) {
      return false;
    }
    _lastFeedbackTime = now;
    return true;
  }

  // Trigger light impact feedback (for tile movements)
  static void lightImpact() {
    if (!_isEnabled || !_canProvideFeedback()) return;

    try {
      HapticFeedback.lightImpact();
    } catch (e) {
      // Ignore errors
    }
  }

  // Trigger medium impact feedback (for tile merges)
  static void mediumImpact() {
    if (!_isEnabled || !_canProvideFeedback()) return;

    try {
      HapticFeedback.mediumImpact();
    } catch (e) {
      // Ignore errors
    }
  }

  // Trigger heavy impact feedback (for game over)
  static void heavyImpact() {
    if (!_isEnabled || !_canProvideFeedback()) return;

    try {
      HapticFeedback.heavyImpact();

      // For game over, add a sequence of haptic feedback for emphasis
      Timer(const Duration(milliseconds: 150), () {
        if (_isEnabled) HapticFeedback.mediumImpact();
      });
      Timer(const Duration(milliseconds: 300), () {
        if (_isEnabled) HapticFeedback.heavyImpact();
      });
    } catch (e) {
      // Ignore errors
    }
  }

  // Trigger vibration feedback (for button presses)
  static void vibrate() {
    if (!_isEnabled || !_canProvideFeedback()) return;

    try {
      HapticFeedback.selectionClick();
    } catch (e) {
      // Ignore errors
    }
  }

  // Provide feedback based on the tile value (higher values get stronger feedback)
  static void tileValueFeedback(int value) {
    if (!_isEnabled || !_canProvideFeedback()) return;

    try {
      if (value >= 48) {
        HapticFeedback.heavyImpact();
      } else if (value >= 12) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      // Ignore errors
    }
  }
}
