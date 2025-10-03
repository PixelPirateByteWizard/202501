import 'dart:convert';

class SettingsModel {
  final bool soundEnabled;
  final bool hapticFeedbackEnabled;
  final bool isFirstTime;

  SettingsModel({
    required this.soundEnabled,
    required this.hapticFeedbackEnabled,
    this.isFirstTime = true,
  });

  // Default settings
  factory SettingsModel.defaultSettings() {
    return SettingsModel(soundEnabled: true, hapticFeedbackEnabled: false);
  }

  // Create a copy with updated values
  SettingsModel copyWith({
    bool? soundEnabled,
    bool? hapticFeedbackEnabled,
    bool? isFirstTime,
  }) {
    return SettingsModel(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'soundEnabled': soundEnabled,
      'hapticFeedbackEnabled': hapticFeedbackEnabled,
      'isFirstTime': isFirstTime,
    };
  }

  // Create from JSON
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      soundEnabled: json['soundEnabled'] as bool,
      hapticFeedbackEnabled: json['hapticFeedbackEnabled'] as bool,
      isFirstTime: json.containsKey('isFirstTime')
          ? json['isFirstTime'] as bool
          : true,
    );
  }

  // Serialize to string
  String serialize() {
    return jsonEncode(toJson());
  }

  // Deserialize from string
  factory SettingsModel.deserialize(String data) {
    return SettingsModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }
}
