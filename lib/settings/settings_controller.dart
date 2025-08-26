import 'preferences_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsController {
  // Current preferences
  Preferences _preferences = Preferences.defaults();

  // Get current preferences
  Preferences get preferences => _preferences;

  // Load preferences from SharedPreferences
  Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsJson = prefs.getString('preferences');

      if (prefsJson != null) {
        final Map<String, dynamic> prefsMap = json.decode(prefsJson);
        _preferences = Preferences.fromJson(prefsMap);
      }
    } catch (e) {
      // If there's an error, use defaults
      _preferences = Preferences.defaults();
    }
  }

  // Save preferences to SharedPreferences
  Future<void> savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsJson = json.encode(_preferences.toJson());
      await prefs.setString('preferences', prefsJson);
    } catch (e) {
      // Handle error (could log or show a notification)
    }
  }

  // Toggle dark mode
  Future<Preferences> toggleDarkMode() async {
    _preferences = _preferences.toggleDarkMode();
    await savePreferences();
    return _preferences;
  }

  // Toggle haptic feedback
  Future<Preferences> toggleHaptic() async {
    _preferences = _preferences.toggleHaptic();
    await savePreferences();
    return _preferences;
  }

  // Toggle sound effects
  Future<Preferences> toggleSound() async {
    _preferences = _preferences.toggleSound();
    await savePreferences();
    return _preferences;
  }

  // Toggle auto-save
  Future<Preferences> toggleAutoSave() async {
    _preferences = _preferences.toggleAutoSave();
    await savePreferences();
    return _preferences;
  }
}
