import 'package:flutter/material.dart';
import '../models/bottle.dart';
import '../models/game_state.dart';
import '../services/level_service.dart';

class HintMove {
  final Bottle fromBottle;
  final Bottle toBottle;
  final String description;

  HintMove({
    required this.fromBottle,
    required this.toBottle,
    required this.description,
  });
}

class HintService {
  static HintMove? getHint(GameState gameState) {
    final bottles = gameState.bottles;
    
    // Strategy 1: Look for bottles that can be completed
    for (final bottle in bottles) {
      if (bottle.isEmpty || bottle.isSorted) continue;
      
      final topColor = bottle.topColor!;
      final topBlock = bottle.topBlock;
      
      // Find a bottle with the same color that can accept this liquid
      for (final targetBottle in bottles) {
        if (targetBottle == bottle) continue;
        
        if (LevelService.canPourLiquid(bottle, targetBottle)) {
          // Check if this move would help complete a bottle
          if (targetBottle.isEmpty || 
              (targetBottle.topColor == topColor && 
               targetBottle.liquids.length + topBlock.amount == 4)) {
            return HintMove(
              fromBottle: bottle,
              toBottle: targetBottle,
              description: targetBottle.isEmpty 
                  ? '將${_getColorName(topColor)}倒入空瓶'
                  : '完成${_getColorName(topColor)}瓶子',
            );
          }
        }
      }
    }
    
    // Strategy 2: Look for moves that consolidate colors
    for (final bottle in bottles) {
      if (bottle.isEmpty || bottle.isSorted) continue;
      
      final topColor = bottle.topColor!;
      
      for (final targetBottle in bottles) {
        if (targetBottle == bottle) continue;
        
        if (LevelService.canPourLiquid(bottle, targetBottle)) {
          // Check if target bottle has more of the same color
          if (!targetBottle.isEmpty && targetBottle.topColor == topColor) {
            final sameColorCount = targetBottle.liquids
                .where((color) => color == topColor).length;
            
            if (sameColorCount > 1) {
              return HintMove(
                fromBottle: bottle,
                toBottle: targetBottle,
                description: '合併${_getColorName(topColor)}液體',
              );
            }
          }
        }
      }
    }
    
    // Strategy 3: Look for any valid move to free up space
    for (final bottle in bottles) {
      if (bottle.isEmpty || bottle.isSorted) continue;
      
      for (final targetBottle in bottles) {
        if (targetBottle == bottle) continue;
        
        if (LevelService.canPourLiquid(bottle, targetBottle)) {
          return HintMove(
            fromBottle: bottle,
            toBottle: targetBottle,
            description: '移動液體以創造空間',
          );
        }
      }
    }
    
    return null;
  }
  
  static String _getColorName(Color color) {
    // Map colors to Chinese names
    final colorMap = {
      0xFFFF5722: '橙色',
      0xFFFFEB3B: '黃色',
      0xFF4CAF50: '綠色',
      0xFF2196F3: '藍色',
      0xFFE91E63: '粉色',
      0xFF9C27B0: '紫色',
      0xFFFF9800: '琥珀色',
      0xFF00BCD4: '青色',
      0xFF8BC34A: '淺綠色',
      0xFF3F51B5: '靛藍色',
    };
    
    return colorMap[color.value] ?? '液體';
  }
  
  static bool isOptimalMove(GameState gameState, Bottle fromBottle, Bottle toBottle) {
    final hint = getHint(gameState);
    return hint != null && 
           hint.fromBottle == fromBottle && 
           hint.toBottle == toBottle;
  }
}