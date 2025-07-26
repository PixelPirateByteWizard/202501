import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../utils/constants.dart';

const _uuid = Uuid();

class Bottle {
  final String id;
  List<Color> liquids;
  double x;
  double y;
  bool isShaking;
  DateTime? shakeStartTime;

  Bottle({
    required this.x,
    required this.y,
    List<Color>? liquids,
    String? id,
  }) : liquids = liquids ?? [],
       isShaking = false,
       id = id ?? _uuid.v4();

  bool get isEmpty => liquids.isEmpty;
  bool get isFull => liquids.length >= GameConstants.maxLiquid;
  
  Color? get topColor => isEmpty ? null : liquids.last;
  
  bool get isSorted {
    if (isEmpty) return false;
    if (!isFull) return false;
    final firstColor = liquids.first;
    return liquids.every((color) => color == firstColor);
  }

  bool get isSettled {
    if (isEmpty) return true;
    if (isFull) {
      final firstColor = liquids.first;
      return liquids.every((color) => color == firstColor);
    }
    return false;
  }

  TopBlock get topBlock {
    if (isEmpty) return TopBlock(color: null, amount: 0);
    
    final topColor = this.topColor!;
    int amount = 0;
    
    for (int i = liquids.length - 1; i >= 0; i--) {
      if (liquids[i] == topColor) {
        amount++;
      } else {
        break;
      }
    }
    
    return TopBlock(color: topColor, amount: amount);
  }

  bool addLiquid(Color color) {
    if (isFull) return false;
    liquids.add(color);
    return true;
  }

  Color? removeTopLiquid() {
    if (isEmpty) return null;
    return liquids.removeLast();
  }

  void triggerShake() {
    isShaking = true;
    shakeStartTime = DateTime.now();
  }

  bool get shouldStopShaking {
    if (!isShaking || shakeStartTime == null) return false;
    return DateTime.now().difference(shakeStartTime!) > GameConstants.shakeDuration;
  }

  void updateShakeState() {
    if (shouldStopShaking) {
      isShaking = false;
      shakeStartTime = null;
    }
  }

  Bottle copy() {
    return Bottle(
      id: id,
      x: x,
      y: y,
      liquids: List<Color>.from(liquids),
    );
  }
}

class TopBlock {
  final Color? color;
  final int amount;

  TopBlock({required this.color, required this.amount});
}