import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/enemy.dart';
import '../models/player.dart';
import '../models/upgrade.dart';
import '../utils/game_utils.dart';
import 'storage_service.dart';
import 'vibration_service.dart';

class GameService {
  // Game state
  GameState? _gameState;
  GameState? get gameState => _gameState;

  // Timers
  Timer? _gameLoopTimer;
  Timer? _enemySpawnTimer;
  Timer? _bulletFireTimer;

  // Screen size
  Size _screenSize = Size.zero;

  // Bullet list
  final List<Map<String, dynamic>> _bullets = [];
  List<Map<String, dynamic>> get bullets => _bullets;

  // Vibration service
  final VibrationService _vibrationService = VibrationService();

  // Stream controller for notifying subscribers to update
  final _gameStateController = StreamController<GameState>.broadcast();
  Stream<GameState> get gameStateStream => _gameStateController.stream;

  // Screen center position (character position)
  Position get characterPosition => Position(
        x: _screenSize.width / 2,
        y: _screenSize.height / 2,
      );

  // Initialize game
  Future<void> initGame(Size screenSize, [Player? initialPlayer]) async {
    _screenSize = screenSize;

    // Initialize vibration service
    await _vibrationService.init();

    // Try to load saved game state
    final savedGameState = await StorageService.loadGameState();

    if (savedGameState != null && !savedGameState.isGameOver) {
      _gameState = savedGameState;
    } else {
      // Create new game, can optionally use initial character
      _gameState = GameState.newGame(initialPlayer);
    }

    _gameStateController.add(_gameState!);
  }

  // Start game loop
  void startGame() {
    if (_gameState == null) return;

    _gameState!.isPaused = false;
    _gameState!.isGameOver = false;

    // Start game loop
    _startGameLoop();

    // Periodically spawn enemies
    _startEnemySpawner();

    // Periodically fire bullets
    _startBulletFiring();

    _gameStateController.add(_gameState!);
  }

  // Pause game
  void pauseGame() {
    if (_gameState == null) return;

    _gameState!.isPaused = true;
    _stopTimers();

    // Save game state
    StorageService.saveGameState(_gameState!);

    _gameStateController.add(_gameState!);
  }

  // Resume game
  void resumeGame() {
    if (_gameState == null) return;

    _gameState!.isPaused = false;

    // Start game loop
    _startGameLoop();

    // Periodically spawn enemies
    _startEnemySpawner();

    // Periodically fire bullets
    _startBulletFiring();

    _gameStateController.add(_gameState!);
  }

  // End game
  void endGame() {
    if (_gameState == null) return;

    _gameState!.isGameOver = true;
    _stopTimers();

    // Game over vibration
    _vibrationService.longVibrate();

    // Save player record
    StorageService.savePlayerRecord(_gameState!.player);

    // Clear saved game state
    StorageService.clearGameState();

    _gameStateController.add(_gameState!);
  }

  // Restart game
  void restartGame() {
    _stopTimers();
    _bullets.clear();

    // Create new game
    _gameState = GameState.newGame();

    // Button vibration
    _vibrationService.shortVibrate();

    startGame();
  }

  // Return to main menu
  void returnToMainMenu() {
    _stopTimers();
    _bullets.clear();

    // Button vibration
    _vibrationService.shortVibrate();

    // Clear saved game state
    StorageService.clearGameState();

    // Create new game
    _gameState = GameState.newGame();
    _gameState!.isPaused = true;

    _gameStateController.add(_gameState!);
  }

  // Output upgrade status information (for debugging)
  void printUpgradeStatus() {
    if (_gameState != null) {
      print(_gameState!.verifyUpgrade());
    }
  }

  // Select upgrade and apply
  void selectUpgrade(Upgrade upgrade) {
    // Output pre-upgrade status
    print("Pre-upgrade:");
    printUpgradeStatus();

    _gameState?.applyUpgrade(upgrade);
    _gameState?.player.resetEnlightenmentProgress();
    _gameStateController.add(_gameState!);
    resumeGame();

    // Output post-upgrade status
    print("Post-upgrade (selected ${upgrade.name}):");
    printUpgradeStatus();
  }

  // Start game loop
  void _startGameLoop() {
    _gameLoopTimer?.cancel();

    _gameLoopTimer = Timer.periodic(GameConstants.gameTickInterval, (timer) {
      if (_gameState == null) return;

      final deltaTime = GameConstants.gameTickInterval.inMilliseconds / 1000;

      // Update game state
      _gameState!.update(deltaTime, _screenSize);

      // Update bullet positions
      _updateBullets(deltaTime);

      // Check if game is over
      if (_gameState!.checkGameOver()) {
        endGame();
        return;
      }

      _gameStateController.add(_gameState!);
    });
  }

  // Start enemy spawner
  void _startEnemySpawner() {
    _enemySpawnTimer?.cancel();

    _enemySpawnTimer = Timer.periodic(_gameState!.enemySpawnInterval, (timer) {
      if (_gameState == null || _gameState!.isPaused || _gameState!.isGameOver)
        return;

      // Spawn new enemy
      _gameState!.spawnEnemy(_screenSize);

      _gameStateController.add(_gameState!);
    });
  }

  // Start bullet firing
  void _startBulletFiring() {
    _bulletFireTimer?.cancel();

    final fireInterval = GameConstants.bulletFireInterval.inMilliseconds /
        _gameState!.fireRateMultiplier;

    _bulletFireTimer =
        Timer.periodic(Duration(milliseconds: fireInterval.round()), (timer) {
      if (_gameState == null || _gameState!.isPaused || _gameState!.isGameOver)
        return;

      // Fire bullets
      _fireBullets();

      _gameStateController.add(_gameState!);
    });
  }

  // Fire bullets
  void _fireBullets() {
    if (_gameState == null || _gameState!.enemies.isEmpty) return;

    // Get all active enemies
    final activeEnemies = _gameState!.enemies.where((e) => e.isActive).toList();
    if (activeEnemies.isEmpty) return;

    // Fire bullets for each active bullet type
    for (final bulletType in _gameState!.activeBullets) {
      for (var i = 0; i < _gameState!.multiShotCount; i++) {
        // Choose a different target enemy for each bullet, not all bullets share one target
        final random = Random();
        final targetEnemy = activeEnemies[random.nextInt(activeEnemies.length)];

        // Random angle offset (for multi-shot)
        final angleOffset = (i - (_gameState!.multiShotCount - 1) / 2) * 0.2;

        final targetDirection = Position(
          x: targetEnemy.position.x - characterPosition.x,
          y: targetEnemy.position.y - characterPosition.y,
        );

        // Calculate direction vector length
        final distance = targetDirection.distanceTo(Position(x: 0, y: 0));

        // Normalize direction vector
        final normalizedDirection = Position(
          x: targetDirection.x / distance,
          y: targetDirection.y / distance,
        );

        // Apply angle offset
        final angle =
            atan2(normalizedDirection.y, normalizedDirection.x) + angleOffset;
        final offsetDirection = Position(
          x: cos(angle),
          y: sin(angle),
        );

        // Create bullet
        _createBullet(bulletType, offsetDirection);
      }
    }
  }

  // Create bullet
  void _createBullet(String bulletType, Position direction) {
    final damage = (GameConstants.baseBulletDamage *
            (_gameState!.bulletDamageMultipliers[bulletType] ?? 1.0))
        .round();

    _bullets.add({
      'type': bulletType,
      'position': Position(
        x: characterPosition.x,
        y: characterPosition.y,
      ),
      'direction': direction,
      'damage': damage,
      'speed': GameConstants.bulletSpeed,
      'isActive': true,
    });
  }

  // Update bullet positions
  void _updateBullets(double deltaTime) {
    final activeBullets = <Map<String, dynamic>>[];

    for (final bullet in _bullets) {
      if (!bullet['isActive']) continue;

      // Update bullet position
      final position = bullet['position'] as Position;
      final direction = bullet['direction'] as Position;
      final speed = bullet['speed'] as double;
      final bulletType = bullet['type'] as String;

      // Check if it's a homing bullet
      final bool isHoming = _gameState!.isBulletHoming;

      if ((isHoming || bulletType == 'bolt') &&
          _gameState!.enemies.isNotEmpty) {
        // Find nearest enemy
        Enemy? closestEnemy;
        double minDistance = double.infinity;

        for (final enemy in _gameState!.enemies) {
          if (!enemy.isActive) continue;

          final distance = position.distanceTo(enemy.position);
          if (distance < minDistance) {
            minDistance = distance;
            closestEnemy = enemy;
          }
        }

        // If there's an enemy, slightly adjust direction towards enemy
        if (closestEnemy != null) {
          final targetDirection = Position(
            x: closestEnemy.position.x - position.x,
            y: closestEnemy.position.y - position.y,
          );

          // Calculate distance
          final dist = sqrt(targetDirection.x * targetDirection.x +
              targetDirection.y * targetDirection.y);
          if (dist > 0) {
            // Normalize target direction
            targetDirection.x /= dist;
            targetDirection.y /= dist;

            // Use linear interpolation to smoothly adjust direction (bullet tracking strength)
            // Set different tracking strengths for different bullet types
            double trackingStrength = 0.0;

            // Basic homing bullets
            if (isHoming) {
              trackingStrength = 0.3; // Enhanced to 0.3 (originally 0.1)

              // Add specific tracking strength for different bullet types
              switch (bulletType) {
                case 'bolt': // Lightning bullets have good tracking ability
                  trackingStrength = 0.4;
                  break;
                case 'spirit': // Spirit bullets have excellent tracking ability
                  trackingStrength = 0.5;
                  break;
              }
            }
            // Even without tracking skill, lightning bullets have basic tracking ability
            else if (bulletType == 'bolt') {
              trackingStrength = 0.15;
            }

            // Adjust tracking strength based on distance to enemy, stronger tracking when closer
            if (minDistance < 100) {
              trackingStrength *= 1.5;
            }

            direction.x = direction.x * (1 - trackingStrength) +
                targetDirection.x * trackingStrength;
            direction.y = direction.y * (1 - trackingStrength) +
                targetDirection.y * trackingStrength;

            // Re-normalize direction
            final newDist =
                sqrt(direction.x * direction.x + direction.y * direction.y);
            if (newDist > 0) {
              direction.x /= newDist;
              direction.y /= newDist;
            }
          }
        }
      }

      position.x += direction.x * speed * deltaTime * 100;
      position.y += direction.y * speed * deltaTime * 100;

      // Check if bullet is out of screen bounds
      if (position.x < 0 ||
          position.x > _screenSize.width ||
          position.y < 0 ||
          position.y > _screenSize.height) {
        continue;
      }

      // Check if bullet hits enemy
      var hitEnemy = false;
      var hitCount = 0; // For spirit bullet penetration count

      // Check if area attack is triggered
      final bool isAreaAttack = bulletType == 'area' ||
          (Random().nextDouble() < _gameState!.areaAttackChance &&
              bulletType != 'area');

      // If it's an area attack, target all enemies
      if (isAreaAttack) {
        _performAreaAttack(position, bullet['damage'] as int);
        hitEnemy = true;
      } else {
        // Normal attack logic
        for (final enemy in _gameState!.enemies) {
          if (!enemy.isActive) continue;

          final distance = position.distanceTo(enemy.position);
          if (distance < GameConstants.enemySize / 2) {
            // Check critical hit
            int actualDamage = bullet['damage'] as int;
            bool isCritical =
                Random().nextDouble() < _gameState!.criticalStrikeChance;

            if (isCritical) {
              actualDamage =
                  (actualDamage * 2).round(); // Critical hit double damage

              // Strong vibration
              _vibrationService.strongVibrate();
            }

            // Bullet hits enemy
            enemy.takeDamage(actualDamage);

            // Check bullet special effects
            _applyBulletEffects(bulletType, enemy);

            // Medium intensity vibration
            _vibrationService.mediumVibrate();

            // If enemy is defeated
            if (!enemy.isActive) {
              _handleEnemyDefeated(enemy);
            }

            // If bullet is piercing type (spirit bullet), count and check if penetration limit is reached
            if (bulletType == 'spirit') {
              hitCount++;

              // Get maximum pierce count, default is 1 (pierce one enemy only)
              final maxPierceCount = _gameState!.spiritBulletPierceCount;

              // If penetration limit is reached, mark as hit
              if (hitCount >= maxPierceCount) {
                hitEnemy = true;
                break;
              }
            } else {
              hitEnemy = true;
              break;
            }
          }
        }
      }

      if (!hitEnemy) {
        activeBullets.add(bullet);
      }
    }

    _bullets.clear();
    _bullets.addAll(activeBullets);
  }

  // Handle area attack
  void _performAreaAttack(Position center, int baseDamage) {
    // Area attack effect radius
    const areaRadius = 100.0;

    // Strong vibration
    _vibrationService.strongVibrate();

    // Deal damage to all enemies in range
    for (final enemy in _gameState!.enemies) {
      if (!enemy.isActive) continue;

      final distance = center.distanceTo(enemy.position);

      // If enemy is in range
      if (distance <= areaRadius) {
        // Calculate damage reduction based on distance (center has highest damage)
        final damageFactor =
            1.0 - (distance / areaRadius) * 0.5; // At least 50% damage at edge
        final actualDamage = (baseDamage * damageFactor).round();

        // Deal damage to enemy
        enemy.takeDamage(actualDamage);

        // Apply knockback effect
        enemy.applyKnockback(center, GameConstants.knockbackForce);

        // If enemy is defeated
        if (!enemy.isActive) {
          _handleEnemyDefeated(enemy);
        }
      }
    }
  }

  // Apply bullet special effects
  void _applyBulletEffects(String bulletType, Enemy enemy) {
    switch (bulletType) {
      case 'bolt': // Lightning - stun effect
        if (Random().nextDouble() < 0.3) {
          // 30% chance to trigger stun
          enemy.setStunned(1000); // 1 second stun
        }
        break;

      case 'flame': // Fire - burn effect
        if (Random().nextDouble() < 0.5) {
          // 50% chance to trigger burn
          // Calculate burn damage (base 3 points)
          final burnDamage = 3 + (_gameState!.flameBulletBurnDamage).round();
          enemy.setBurning(3000, burnDamage); // 3 second burn
        }
        break;

      case 'frost': // Frost - slow effect
        if (Random().nextDouble() < 0.7) {
          // 70% chance to trigger slow
          // Calculate slow factor (base 0.5, i.e. half speed)
          final slowFactor = 0.5 -
              (_gameState!.frostBulletSlowFactor *
                  0.1); // 10% additional slow per level
          enemy.setSlowed(2000, slowFactor); // 2 second slow
        }
        break;

      case 'tornado': // Storm - knockback effect
        if (Random().nextDouble() < 0.8) {
          // 80% chance to trigger knockback
          // Calculate knockback force (base force plus additional factor)
          final knockbackForce = GameConstants.knockbackForce *
              (1.0 + _gameState!.tornadoBulletKnockbackFactor);

          // Knockback from bullet to enemy direction
          final center = characterPosition;
          enemy.applyKnockback(center, knockbackForce);
        }
        break;
    }
  }

  // Handle enemy defeated logic
  void _handleEnemyDefeated(Enemy enemy) {
    // Add score
    _gameState!.score += enemy.reward;

    // Add cultivation
    final cultivationReward =
        (enemy.reward * _gameState!.cultivationGainMultiplier).round();
    _gameState!.player.increaseCultivation(cultivationReward);

    // Add enlightenment progress
    _gameState!.player.increaseEnlightenment(
        GameConstants.baseEnlightenmentGain *
            _gameState!.enlightenmentGainMultiplier);

    // Add defeated enemy count
    _gameState!.player.addEnemyDefeat(enemy.type == 'bossFiend');

    // Add combo
    _gameState!.player.increaseCombo();

    // Life steal effect
    if (_gameState!.lifeStealAmount > 0) {
      _gameState!.player.heal(_gameState!.lifeStealAmount);
    }

    // If boss is defeated, enter next wave
    if (enemy.type == 'bossFiend') {
      _gameState!.player.nextWave();
      _gameState!.updateDifficulty();
    }
  }

  // Stop all timers
  void _stopTimers() {
    _gameLoopTimer?.cancel();
    _enemySpawnTimer?.cancel();
    _bulletFireTimer?.cancel();
  }

  // Release resources
  void dispose() {
    _stopTimers();
    _gameStateController.close();
  }

  // Set vibration state
  Future<void> setVibrationEnabled(bool enabled) async {
    await _vibrationService.setVibrationEnabled(enabled);
  }

  // Get vibration state
  bool get isVibrationEnabled => _vibrationService.isVibrationEnabled;
}
