import 'dart:math';
import 'package:flutter/material.dart';
import '../models/bottle.dart';
import '../models/game_level.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class LevelService {
  static List<Bottle> generateLevel(GameLevel level, Size screenSize) {
    final bottles = <Bottle>[];
    
    // Create bottles
    for (int i = 0; i < level.bottleCount; i++) {
      bottles.add(Bottle(x: 0, y: 0));
    }
    
    // Create color pool - 每种颜色有4个液体单位
    final colorPool = <Color>[];
    for (int i = 0; i < level.colorCount; i++) {
      final color = GameColors.liquidColors[i % GameColors.liquidColors.length];
      for (int j = 0; j < GameConstants.maxLiquid; j++) {
        colorPool.add(color);
      }
    }
    
    // 使用更智能的混合算法
    _smartShuffle(colorPool, level.levelNumber);
    
    // Fill bottles with mixed colors
    // 只填充前 colorCount 个瓶子，留下空瓶子作为辅助
    int colorIndex = 0;
    for (int i = 0; i < level.colorCount && i < bottles.length; i++) {
      for (int j = 0; j < GameConstants.maxLiquid && colorIndex < colorPool.length; j++) {
        bottles[i].addLiquid(colorPool[colorIndex]);
        colorIndex++;
      }
    }
    
    // 确保至少有两个空瓶子用于移动液体
    final emptyBottleCount = level.bottleCount - level.colorCount;
    if (emptyBottleCount < 2 && level.colorCount > 2) {
      // 如果空瓶子不够，从最后一个有液体的瓶子中移除一些液体
      final lastBottleIndex = level.colorCount - 1;
      if (lastBottleIndex >= 0 && lastBottleIndex < bottles.length) {
        final lastBottle = bottles[lastBottleIndex];
        while (lastBottle.liquids.length > 2 && lastBottle.liquids.isNotEmpty) {
          lastBottle.removeTopLiquid();
        }
      }
    }
    
    // Position bottles
    _positionBottles(bottles, screenSize);
    
    return bottles;
  }
  
  // 智能混合算法，确保关卡有合理的难度
  static void _smartShuffle(List<Color> colorPool, int levelNumber) {
    final random = Random(levelNumber); // 使用关卡号作为种子，确保同一关卡生成相同布局
    
    // 基础混合
    colorPool.shuffle(random);
    
    // 根据关卡难度调整混合程度
    if (levelNumber > 10) {
      // 高级关卡：进行额外的混合，避免相同颜色聚集
      for (int i = 0; i < colorPool.length - 1; i++) {
        if (colorPool[i] == colorPool[i + 1] && random.nextBool()) {
          // 找到一个不同颜色的位置进行交换
          for (int j = i + 2; j < colorPool.length; j++) {
            if (colorPool[j] != colorPool[i]) {
              final temp = colorPool[i + 1];
              colorPool[i + 1] = colorPool[j];
              colorPool[j] = temp;
              break;
            }
          }
        }
      }
    }
  }
  
  static void _positionBottles(List<Bottle> bottles, Size screenSize) {
    final totalBottles = bottles.length;
    final bottlesPerRow = min(GameConstants.maxBottlesPerRow, 
        (screenSize.width / (GameConstants.bottleWidth + GameConstants.bottleSpacing)).floor());
    final rowCount = (totalBottles / bottlesPerRow).ceil();
    
    final totalWidth = bottlesPerRow * (GameConstants.bottleWidth + GameConstants.bottleSpacing) - GameConstants.bottleSpacing;
    final startX = (screenSize.width - totalWidth) / 2;
    final totalHeight = rowCount * (GameConstants.bottleHeight + 60) - 60;
    final startY = (screenSize.height - totalHeight) / 2 + 20;
    
    for (int i = 0; i < bottles.length; i++) {
      final row = i ~/ bottlesPerRow;
      final col = i % bottlesPerRow;
      
      bottles[i].x = startX + col * (GameConstants.bottleWidth + GameConstants.bottleSpacing);
      bottles[i].y = startY + row * (GameConstants.bottleHeight + 60);
    }
  }
  
  static void repositionBottles(List<Bottle> bottles, Size screenSize) {
    _positionBottles(bottles, screenSize);
  }
  
  static bool canPourLiquid(Bottle from, Bottle to) {
    // 检查基本条件
    if (from.isEmpty || to.isFull) return false;
    
    final topBlock = from.topBlock;
    
    // 如果目标瓶子是空的，可以倒入
    if (to.isEmpty) return true;
    
    // 如果目标瓶子不为空，检查颜色是否匹配
    if (to.topColor != topBlock.color) return false;
    
    // 检查是否有足够的空间容纳至少一个液体单位
    final availableSpace = GameConstants.maxLiquid - to.liquids.length;
    return availableSpace > 0;
  }
  
  static int calculateMoveAmount(Bottle from, Bottle to) {
    if (!canPourLiquid(from, to)) return 0;
    
    final topBlock = from.topBlock;
    final availableSpace = GameConstants.maxLiquid - to.liquids.length;
    
    // 返回实际可以移动的液体数量
    return topBlock.amount < availableSpace ? topBlock.amount : availableSpace;
  }
  
  static bool isLevelComplete(List<Bottle> bottles) {
    if (bottles.isEmpty) return false;
    
    // 统计所有液体的颜色种类
    final Set<String> allColors = {};
    for (final bottle in bottles) {
      for (final color in bottle.liquids) {
        allColors.add(color.toString());
      }
    }
    
    if (allColors.isEmpty) return false;
    
    // 统计已完成排序的瓶子数量
    int sortedBottleCount = 0;
    for (final bottle in bottles) {
      if (bottle.isSorted && !bottle.isEmpty) {
        sortedBottleCount++;
      }
    }
    
    // 胜利条件：已排序的瓶子数量等于颜色种类数量
    return sortedBottleCount == allColors.length;
  }
}