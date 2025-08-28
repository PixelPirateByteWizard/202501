class Reality {
  final String id;
  final String name;
  final String description;
  final String avatarUrl;
  final String backgroundUrl;
  final String? fallbackBackgroundUrl; // 备用背景图URL
  bool _backgroundLoadFailed = false;

  Reality({
    required this.id,
    required this.name,
    required this.description,
    required this.avatarUrl,
    required this.backgroundUrl,
    this.fallbackBackgroundUrl,
  });

  // 获取实际使用的背景URL
  String get effectiveBackgroundUrl {
    if (_backgroundLoadFailed && fallbackBackgroundUrl != null) {
      return fallbackBackgroundUrl!;
    }
    return backgroundUrl;
  }

  // 标记背景加载失败
  void markBackgroundLoadFailed() {
    _backgroundLoadFailed = true;
  }

  // 重置背景加载状态
  void resetBackgroundLoadState() {
    _backgroundLoadFailed = false;
  }

  // 检查是否使用备用背景
  bool get isUsingFallbackBackground =>
      _backgroundLoadFailed && fallbackBackgroundUrl != null;

  @override
  String toString() {
    return 'Reality{id: $id, name: $name, description: $description}';
  }
}
