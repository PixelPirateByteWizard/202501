class Preferences {
  final bool isDarkMode;
  final bool isHapticEnabled;
  final bool isSoundEnabled;
  final bool isAutoSaveEnabled;

  const Preferences({
    required this.isDarkMode,
    required this.isHapticEnabled,
    required this.isSoundEnabled,
    required this.isAutoSaveEnabled,
  });

  // Default preferences
  factory Preferences.defaults() {
    return const Preferences(
      isDarkMode: true, // Default to dark mode as per design
      isHapticEnabled: true,
      isSoundEnabled: false,
      isAutoSaveEnabled: true,
    );
  }

  // Toggle dark mode
  Preferences toggleDarkMode() {
    return Preferences(
      isDarkMode: !isDarkMode,
      isHapticEnabled: isHapticEnabled,
      isSoundEnabled: isSoundEnabled,
      isAutoSaveEnabled: isAutoSaveEnabled,
    );
  }

  // Toggle haptic feedback
  Preferences toggleHaptic() {
    return Preferences(
      isDarkMode: isDarkMode,
      isHapticEnabled: !isHapticEnabled,
      isSoundEnabled: isSoundEnabled,
      isAutoSaveEnabled: isAutoSaveEnabled,
    );
  }

  // Toggle sound effects
  Preferences toggleSound() {
    return Preferences(
      isDarkMode: isDarkMode,
      isHapticEnabled: isHapticEnabled,
      isSoundEnabled: !isSoundEnabled,
      isAutoSaveEnabled: isAutoSaveEnabled,
    );
  }

  // Toggle auto-save
  Preferences toggleAutoSave() {
    return Preferences(
      isDarkMode: isDarkMode,
      isHapticEnabled: isHapticEnabled,
      isSoundEnabled: isSoundEnabled,
      isAutoSaveEnabled: !isAutoSaveEnabled,
    );
  }

  // For JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'isHapticEnabled': isHapticEnabled,
      'isSoundEnabled': isSoundEnabled,
      'isAutoSaveEnabled': isAutoSaveEnabled,
    };
  }

  // From JSON deserialization
  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      isDarkMode: json['isDarkMode'] as bool? ?? true,
      isHapticEnabled: json['isHapticEnabled'] as bool? ?? true,
      isSoundEnabled: json['isSoundEnabled'] as bool? ?? false,
      isAutoSaveEnabled: json['isAutoSaveEnabled'] as bool? ?? true,
    );
  }
}
