import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  static bool _soundEnabled = true;
  static bool _vibrationEnabled = true;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('sound_enabled') ?? true;
    _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', enabled);
  }

  static Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration_enabled', enabled);
  }

  static bool get soundEnabled => _soundEnabled;
  static bool get vibrationEnabled => _vibrationEnabled;

  static Future<void> playPourSound() async {
    if (!_soundEnabled) return;
    // In a real app, you'd load actual sound files
    // For now, we'll use system sounds or generate tones
    await _playTone(440, 200); // A4 note for 200ms
  }

  static Future<void> playSuccessSound() async {
    if (!_soundEnabled) return;
    await _playTone(523, 300); // C5 note for 300ms
  }

  static Future<void> playErrorSound() async {
    if (!_soundEnabled) return;
    await _playTone(220, 150); // A3 note for 150ms
  }

  static Future<void> playWinSound() async {
    if (!_soundEnabled) return;
    // Play a sequence of notes for win
    await _playTone(523, 200); // C5
    await Future.delayed(const Duration(milliseconds: 100));
    await _playTone(659, 200); // E5
    await Future.delayed(const Duration(milliseconds: 100));
    await _playTone(784, 300); // G5
  }

  static Future<void> _playTone(double frequency, int durationMs) async {
    // This is a simplified implementation
    // In a real app, you'd use actual audio files
    try {
      // For now, we'll just use vibration as audio feedback
      if (_vibrationEnabled) {
        await Vibration.vibrate(duration: durationMs ~/ 4);
      }
    } catch (e) {
      // Handle audio playback errors
    }
  }

  static Future<void> vibrateLight() async {
    if (!_vibrationEnabled) return;
    try {
      await Vibration.vibrate(duration: 50);
    } catch (e) {
      // Handle vibration errors
    }
  }

  static Future<void> vibrateMedium() async {
    if (!_vibrationEnabled) return;
    try {
      await Vibration.vibrate(duration: 100);
    } catch (e) {
      // Handle vibration errors
    }
  }

  static Future<void> vibrateSuccess() async {
    if (!_vibrationEnabled) return;
    try {
      await Vibration.vibrate(duration: 200);
    } catch (e) {
      // Handle vibration errors
    }
  }
}