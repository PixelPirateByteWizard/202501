import 'package:flutter/material.dart';
import '../models/bottle.dart';
import '../models/game_state.dart';
import '../models/game_level.dart';
import '../utils/constants.dart';
import 'level_service.dart';
import 'storage_service.dart';
import 'sound_service.dart';
import 'achievement_service.dart';

class GameService {
  final List<GameState> _undoStack = [];
  
  GameState initializeLevel(int levelNumber, Size screenSize) {
    final level = GameLevel.getLevel(levelNumber);
    if (level == null) {
      throw Exception('Level $levelNumber not found');
    }
    
    final bottles = LevelService.generateLevel(level, screenSize);
    final gameState = GameState(
      bottles: bottles,
      currentLevel: levelNumber,
      moveCount: 0,
      undoCount: GameConstants.initialUndoCount,
      startTime: DateTime.now(),
    );
    
    _undoStack.clear();
    _saveState(gameState);
    
    return gameState;
  }
  
  GameState? handleBottleClick(GameState currentState, Bottle clickedBottle) {
    if (currentState.isAnimating) return null;
    
    // Handle eliminate mode
    if (currentState.isRemovingColor) {
      if (!clickedBottle.isEmpty) {
        // Create new bottles list with the modification
        final newBottles = currentState.bottles.map((b) => b.copy()).toList();
        final targetBottle = newBottles.firstWhere((b) => b.id == clickedBottle.id);
        targetBottle.removeTopLiquid();
        
        final newState = currentState.copyWith(
          bottles: newBottles,
          moveCount: currentState.moveCount + 1,
          isRemovingColor: false,
        );
        _saveState(newState);
        return newState;
      }
      return null;
    }
    
    // Handle normal selection and pouring
    if (currentState.selectedBottle == null) {
      // Select bottle if it's not empty and not sorted
      if (!clickedBottle.isEmpty && !clickedBottle.isSorted) {
        return currentState.copyWith(selectedBottle: clickedBottle);
      }
    } else {
      final selectedBottle = currentState.selectedBottle!;
      
      // Deselect if clicking the same bottle
      if (selectedBottle == clickedBottle) {
        return currentState.copyWith(clearSelectedBottle: true);
      }
      
      // Try to pour liquid
      if (LevelService.canPourLiquid(selectedBottle, clickedBottle)) {
        // Create copies of all bottles to avoid modifying original state
        final newBottles = currentState.bottles.map((b) => b.copy()).toList();
        final newSelectedBottle = newBottles.firstWhere((b) => b.id == selectedBottle.id);
        final newClickedBottle = newBottles.firstWhere((b) => b.id == clickedBottle.id);

        // 计算实际可以移动的液体数量
        final actualMoveAmount = LevelService.calculateMoveAmount(newSelectedBottle, newClickedBottle);
        
        // Move liquids one by one to ensure proper order
        for (int i = 0; i < actualMoveAmount; i++) {
          final liquid = newSelectedBottle.removeTopLiquid();
          if (liquid != null) {
            newClickedBottle.addLiquid(liquid);
          }
        }
        
        final newState = currentState.copyWith(
          bottles: newBottles,
          moveCount: currentState.moveCount + 1,
          clearSelectedBottle: true,
        );
        
        // Play pour sound
        SoundService.playPourSound();
        SoundService.vibrateLight();
        
        _saveState(newState);
        return newState;
      } else {
        // Invalid move - shake the bottle
        selectedBottle.triggerShake();
        
        // Play error sound and vibration
        SoundService.playErrorSound();
        SoundService.vibrateMedium();
        
        // Select new bottle if it's valid
        if (!clickedBottle.isEmpty && !clickedBottle.isSorted) {
          return currentState.copyWith(selectedBottle: clickedBottle);
        } else {
          return currentState.copyWith(clearSelectedBottle: true);
        }
      }
    }
    
    return null;
  }
  
  GameState? undoMove(GameState currentState) {
    if (_undoStack.length <= 1 || currentState.undoCount <= 0) {
      return null;
    }
    
    _undoStack.removeLast(); // Remove current state
    final previousState = _undoStack.last;
    
    return previousState.copyWith(
      undoCount: currentState.undoCount - 1,
      clearSelectedBottle: true,
      usedUndo: true,
    );
  }
  
  GameState addEmptyBottle(GameState currentState) {
    if (currentState.bottles.length >= GameConstants.maxBottles) {
      return currentState;
    }
    
    final newBottles = List<Bottle>.from(currentState.bottles);
    newBottles.add(Bottle(x: 0, y: 0));
    
    return currentState.copyWith(bottles: newBottles);
  }
  
  GameState activateRemoveColor(GameState currentState) {
    return currentState.copyWith(
      isRemovingColor: true,
      clearSelectedBottle: true,
    );
  }
  
  GameState repositionBottles(GameState currentState, Size screenSize) {
    LevelService.repositionBottles(currentState.bottles, screenSize);
    return currentState;
  }
  
  Future<void> saveProgress(GameState gameState) async {
    if (gameState.isWon) {
      final level = GameLevel.getLevel(gameState.currentLevel);
      if (level != null) {
        final stars = level.calculateStars(gameState.moveCount);
        await StorageService.setLevelStars(gameState.currentLevel, stars);
        await StorageService.setBestMoves(gameState.currentLevel, gameState.moveCount);
        await StorageService.unlockNextLevel(gameState.currentLevel);
        
        // Play win sound
        SoundService.playWinSound();
        SoundService.vibrateSuccess();
        
        // Check achievements
        final elapsedTime = gameState.elapsedTimeInSeconds;
        await AchievementService.checkAchievements(
          gameState, 
          elapsedTime, 
          gameState.usedUndo,
        );
      }
    }
  }
  
  GameState useHint(GameState currentState) {
    return currentState.copyWith(
      hintsUsed: currentState.hintsUsed + 1,
    );
  }
  
  void _saveState(GameState state) {
    _undoStack.add(state.copyWith());
  }
  
  void clearUndoStack() {
    _undoStack.clear();
  }
}