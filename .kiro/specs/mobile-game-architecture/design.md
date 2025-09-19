# Game Architecture Design Document

## Overview

This document outlines a simplified Flutter-based mobile game architecture focused on ease of implementation and maintenance. The design uses Flutter's built-in state management (setState) and minimal external dependencies to create a clean, straightforward game structure. The architecture emphasizes simplicity while maintaining good organization and performance for mobile gameplay.

The design uses shared_preferences for data persistence, avoids complex state management libraries, and focuses on core game functionality without external integrations like user accounts or image caching.

## Architecture

### High-Level Architecture

The game follows a simplified architecture pattern with the following main components:

```
┌─────────────────────────────────────────┐
│           UI Layer                      │
│  (Screens, Widgets, Game Canvas)       │
├─────────────────────────────────────────┤
│          Game Logic Layer               │
│    (Game State, Controllers)           │
├─────────────────────────────────────────┤
│         Services Layer                  │
│  (Storage, Audio, Preferences)         │
└─────────────────────────────────────────┘
```

### Core Architectural Patterns

1. **StatefulWidget with setState**: Simple state management for game components
2. **Service Pattern**: Separate services for storage, audio, and game utilities
3. **Model Classes**: Simple data classes without complex serialization
4. **Controller Pattern**: Game logic controllers that manage game state

### Game Core Systems

The game consists of several simplified core systems:

- **Game Controller**: Manages game state and logic using setState
- **Screen Management**: Handles navigation between different game screens
- **Input Handling**: Processes user taps and gestures
- **Audio Service**: Manages sound effects using Flutter's built-in audio
- **Storage Service**: Handles data persistence with shared_preferences
- **Game Models**: Simple data classes for game entities and state

## Components and Interfaces

### 1. Game Controller

```dart
class GameController extends ChangeNotifier {
  GameState _gameState = GameState();
  
  GameState get gameState => _gameState;
  
  void updateGameState(GameState newState) {
    _gameState = newState;
    notifyListeners();
  }
  
  void startGame() {
    // Game start logic
    notifyListeners();
  }
  
  void pauseGame() {
    // Game pause logic
    notifyListeners();
  }
  
  void resetGame() {
    // Game reset logic
    notifyListeners();
  }
}
```

### 2. State Management with StatefulWidget

```dart
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameController gameController = GameController();
  
  @override
  void initState() {
    super.initState();
    gameController.addListener(_onGameStateChanged);
  }
  
  void _onGameStateChanged() {
    setState(() {
      // UI will rebuild when game state changes
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameCanvas(gameState: gameController.gameState),
    );
  }
}
```

### 3. Storage Service

```dart
class StorageService {
  static const String _gameDataKey = 'game_data';
  static const String _settingsKey = 'game_settings';
  
  Future<void> saveGameData(Map<String, dynamic> gameData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(gameData);
    await prefs.setString(_gameDataKey, jsonString);
  }
  
  Future<Map<String, dynamic>?> loadGameData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_gameDataKey);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }
  
  Future<void> saveSettings(GameSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('master_volume', settings.masterVolume);
    await prefs.setBool('sound_enabled', settings.soundEnabled);
  }
  
  Future<GameSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return GameSettings(
      masterVolume: prefs.getDouble('master_volume') ?? 1.0,
      soundEnabled: prefs.getBool('sound_enabled') ?? true,
    );
  }
}
```

### 4. Input Handling

```dart
class GameCanvas extends StatefulWidget {
  final GameState gameState;
  
  const GameCanvas({Key? key, required this.gameState}) : super(key: key);
  
  @override
  _GameCanvasState createState() => _GameCanvasState();
}

class _GameCanvasState extends State<GameCanvas> {
  void _onTapDown(TapDownDetails details) {
    final position = details.localPosition;
    // Handle tap input
    widget.gameController.handleTap(position);
  }
  
  void _onPanUpdate(DragUpdateDetails details) {
    final position = details.localPosition;
    // Handle drag input
    widget.gameController.handleDrag(position);
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onPanUpdate: _onPanUpdate,
      child: CustomPaint(
        painter: GamePainter(gameState: widget.gameState),
        size: Size.infinite,
      ),
    );
  }
}
```

### 5. Game Objects

```dart
class GameObject {
  final String id;
  Offset position;
  double rotation;
  double scale;
  bool isActive;
  Color color;
  
  GameObject({
    required this.id,
    this.position = Offset.zero,
    this.rotation = 0.0,
    this.scale = 1.0,
    this.isActive = true,
    this.color = Colors.blue,
  });
  
  void update() {
    // Update object logic
  }
  
  void render(Canvas canvas, Size size) {
    if (!isActive) return;
    
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(position, 20 * scale, paint);
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'x': position.dx,
      'y': position.dy,
      'rotation': rotation,
      'scale': scale,
      'isActive': isActive,
      'color': color.value,
    };
  }
  
  factory GameObject.fromJson(Map<String, dynamic> json) {
    return GameObject(
      id: json['id'],
      position: Offset(json['x'], json['y']),
      rotation: json['rotation'],
      scale: json['scale'],
      isActive: json['isActive'],
      color: Color(json['color']),
    );
  }
}
```

### 6. Navigation and UI

```dart
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  static void navigateTo(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }
  
  static void navigateBack() {
    navigatorKey.currentState?.pop();
  }
  
  static void navigateAndReplace(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }
}

class GamePainter extends CustomPainter {
  final GameState gameState;
  
  GamePainter({required this.gameState});
  
  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    final backgroundPaint = Paint()..color = Colors.black;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    
    // Draw game objects
    for (final gameObject in gameState.gameObjects) {
      gameObject.render(canvas, size);
    }
    
    // Draw UI elements
    _drawScore(canvas, size);
    _drawLives(canvas, size);
  }
  
  void _drawScore(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Score: ${gameState.score}',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(20, 50));
  }
  
  void _drawLives(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Lives: ${gameState.lives}',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - 120, 50));
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
```

## Data Models

### Core Game Models

```dart
class GameState {
  int score;
  int lives;
  int level;
  bool isGameOver;
  bool isPaused;
  List<GameObject> gameObjects;
  DateTime lastUpdated;
  
  GameState({
    this.score = 0,
    this.lives = 3,
    this.level = 1,
    this.isGameOver = false,
    this.isPaused = false,
    this.gameObjects = const [],
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();
  
  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'lives': lives,
      'level': level,
      'isGameOver': isGameOver,
      'isPaused': isPaused,
      'gameObjects': gameObjects.map((obj) => obj.toJson()).toList(),
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
    };
  }
  
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      score: json['score'] ?? 0,
      lives: json['lives'] ?? 3,
      level: json['level'] ?? 1,
      isGameOver: json['isGameOver'] ?? false,
      isPaused: json['isPaused'] ?? false,
      gameObjects: (json['gameObjects'] as List?)
          ?.map((obj) => GameObject.fromJson(obj))
          .toList() ?? [],
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(json['lastUpdated'] ?? 0),
    );
  }
}

class GameSettings {
  double masterVolume;
  bool soundEnabled;
  bool vibrationEnabled;
  
  GameSettings({
    this.masterVolume = 1.0,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'masterVolume': masterVolume,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
    };
  }
  
  factory GameSettings.fromJson(Map<String, dynamic> json) {
    return GameSettings(
      masterVolume: json['masterVolume'] ?? 1.0,
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
    );
  }
}
```

### Game-Specific Models

```dart
class Player extends GameObject {
  double health;
  double maxHealth;
  
  Player({
    required String id,
    Offset position = Offset.zero,
    this.health = 100.0,
    this.maxHealth = 100.0,
  }) : super(
    id: id,
    position: position,
    color: Colors.green,
  );
  
  void takeDamage(double damage) {
    health = (health - damage).clamp(0.0, maxHealth);
    if (health <= 0) {
      isActive = false;
    }
  }
  
  void heal(double amount) {
    health = (health + amount).clamp(0.0, maxHealth);
  }
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['health'] = health;
    json['maxHealth'] = maxHealth;
    return json;
  }
  
  factory Player.fromJson(Map<String, dynamic> json) {
    final player = Player(
      id: json['id'],
      position: Offset(json['x'], json['y']),
      health: json['health'] ?? 100.0,
      maxHealth: json['maxHealth'] ?? 100.0,
    );
    player.rotation = json['rotation'] ?? 0.0;
    player.scale = json['scale'] ?? 1.0;
    player.isActive = json['isActive'] ?? true;
    return player;
  }
}

class Enemy extends GameObject {
  double speed;
  
  Enemy({
    required String id,
    Offset position = Offset.zero,
    this.speed = 50.0,
  }) : super(
    id: id,
    position: position,
    color: Colors.red,
  );
  
  void moveTowards(Offset target) {
    final direction = target - position;
    final distance = direction.distance;
    if (distance > 0) {
      final normalizedDirection = direction / distance;
      position += normalizedDirection * speed * (1/60); // Assuming 60 FPS
    }
  }
  
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['speed'] = speed;
    return json;
  }
  
  factory Enemy.fromJson(Map<String, dynamic> json) {
    final enemy = Enemy(
      id: json['id'],
      position: Offset(json['x'], json['y']),
      speed: json['speed'] ?? 50.0,
    );
    enemy.rotation = json['rotation'] ?? 0.0;
    enemy.scale = json['scale'] ?? 1.0;
    enemy.isActive = json['isActive'] ?? true;
    return enemy;
  }
}
```

## Error Handling

### Error Management Strategy

1. **Simple Error Handling**: Use try-catch blocks for critical operations
2. **User Feedback**: Show simple error messages using SnackBar or AlertDialog
3. **Graceful Degradation**: Continue game operation when possible
4. **Debug Logging**: Use print statements for development debugging

### Error Handling Implementation

```dart
class ErrorHandler {
  static void handleError(String message, {Object? error}) {
    print('Game Error: $message');
    if (error != null) {
      print('Details: $error');
    }
  }
  
  static void showUserError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
  
  static Future<T?> safeExecute<T>(Future<T> Function() operation, {
    String? errorMessage,
    BuildContext? context,
  }) async {
    try {
      return await operation();
    } catch (e) {
      handleError(errorMessage ?? 'Operation failed', error: e);
      if (context != null && errorMessage != null) {
        showUserError(context, errorMessage);
      }
      return null;
    }
  }
}
```

### Recovery Mechanisms

- **Auto-save Recovery**: Restore from SharedPreferences on app restart
- **State Validation**: Basic validation of loaded game state
- **Default Values**: Use sensible defaults when data is missing or corrupted
- **Memory Management**: Rely on Flutter's automatic garbage collection

## Testing Strategy

### Testing Pyramid

1. **Unit Tests**: Test individual components and business logic
2. **Integration Tests**: Test component interactions and data flow
3. **Widget Tests**: Test UI components and user interactions
4. **End-to-End Tests**: Test complete user workflows
5. **Performance Tests**: Test game performance under various conditions

### Test Categories

#### Unit Testing
- Game logic validation
- State management operations
- Data model serialization/deserialization
- Utility functions and calculations
- Error handling scenarios

#### Integration Testing
- Asset loading and caching
- Audio system integration
- Input processing pipeline
- Save/load functionality
- Network communication

#### UI Testing
- Screen navigation flows
- User interaction responses
- Animation and transition testing
- Responsive layout validation
- Accessibility compliance

#### Performance Testing
- Frame rate consistency
- Memory usage optimization
- Battery consumption
- Loading time benchmarks
- Stress testing with multiple concurrent operations

### Testing Tools and Frameworks

- **flutter_test**: Core Flutter testing framework for unit and widget tests
- **test**: Dart testing framework for pure Dart logic
- **integration_test**: Basic end-to-end testing

### Testing Approach

- Focus on unit tests for game logic and data models
- Widget tests for UI components
- Simple integration tests for critical user flows
- Manual testing for gameplay experience

## Performance Optimization

### Rendering Optimization
- Use CustomPainter for efficient 2D rendering
- Minimize widget rebuilds by using setState strategically
- Cache paint objects to avoid recreation
- Use RepaintBoundary for complex widgets that don't change often

### Memory Management
- Rely on Flutter's automatic garbage collection
- Avoid creating unnecessary objects in paint methods
- Use object pooling for frequently created game objects
- Clear unused game objects from lists

### CPU Optimization
- Use Timer.periodic for game loop instead of continuous rebuilding
- Implement simple collision detection using distance calculations
- Cache expensive calculations when possible
- Use efficient data structures (List, Map) appropriately

### Battery and Performance
- Limit frame rate to 60 FPS using Timer
- Pause game loop when app is in background
- Reduce calculations when game is paused
- Use simple animations and avoid complex effects