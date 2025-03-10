import 'package:flutter/foundation.dart';

@immutable
class PuzzleTile {
  final int value;
  final int correctPosition;
  final int currentPosition;
  final bool isBlank;

  const PuzzleTile({
    required this.value,
    required this.correctPosition,
    required this.currentPosition,
  }) : isBlank = value == 0;

  PuzzleTile copyWith({
    int? value,
    int? correctPosition,
    int? currentPosition,
  }) {
    return PuzzleTile(
      value: value ?? this.value,
      correctPosition: correctPosition ?? this.correctPosition,
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }

  bool get isInCorrectPosition => currentPosition == correctPosition;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PuzzleTile &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          correctPosition == other.correctPosition &&
          currentPosition == other.currentPosition;

  @override
  int get hashCode =>
      value.hashCode ^ correctPosition.hashCode ^ currentPosition.hashCode;
}
