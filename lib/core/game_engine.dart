import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'tile.dart';

enum GameDifficulty {
  easy(4, '简单'),
  medium(5, '中等'),
  hard(6, '困难');

  final int gridSize;
  final String label;
  const GameDifficulty(this.gridSize, this.label);
}

class GameEngine extends ChangeNotifier {
  GameDifficulty _difficulty;
  List<PuzzleTile> _tiles = [];
  int _moves = 0;
  DateTime? _startTime;
  bool _isPlaying = false;
  Duration? _bestTime;
  int? _bestMoves;

  GameEngine({GameDifficulty difficulty = GameDifficulty.easy})
      : _difficulty = difficulty;

  // Getters
  GameDifficulty get difficulty => _difficulty;
  int get gridSize => _difficulty.gridSize;
  List<PuzzleTile> get tiles => List.unmodifiable(_tiles);
  int get moves => _moves;
  bool get isPlaying => _isPlaying;
  Duration get playDuration => _startTime == null
      ? Duration.zero
      : DateTime.now().difference(_startTime!);
  bool get isSolved => _tiles.every((tile) => tile.isInCorrectPosition);
  Duration? get bestTime => _bestTime;
  int? get bestMoves => _bestMoves;

  void setDifficulty(GameDifficulty newDifficulty) {
    _difficulty = newDifficulty;
    initialize();
  }

  // Initialize game
  void initialize() {
    _generatePuzzle();
    _shuffleTiles();
    _moves = 0;
    _startTime = DateTime.now();
    _isPlaying = true;
    notifyListeners();
  }

  // Generate ordered puzzle
  void _generatePuzzle() {
    final totalTiles = gridSize * gridSize;
    _tiles = List.generate(
      totalTiles,
      (index) => PuzzleTile(
        value: index == totalTiles - 1 ? 0 : index + 1,
        correctPosition: index,
        currentPosition: index,
      ),
    );
  }

  // Shuffle tiles
  void _shuffleTiles() {
    final random = math.Random();
    for (var i = _tiles.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      if (i != j) {
        final currentPosI = _tiles[i].currentPosition;
        final currentPosJ = _tiles[j].currentPosition;

        _tiles[i] = _tiles[i].copyWith(currentPosition: currentPosJ);
        _tiles[j] = _tiles[j].copyWith(currentPosition: currentPosI);

        // Swap positions in the list
        final temp = _tiles[i];
        _tiles[i] = _tiles[j];
        _tiles[j] = temp;
      }
    }

    // Ensure puzzle is solvable
    if (!_isSolvable()) {
      _shuffleTiles();
    }
  }

  // Check if puzzle is solvable
  bool _isSolvable() {
    int inversions = 0;
    for (int i = 0; i < _tiles.length - 1; i++) {
      for (int j = i + 1; j < _tiles.length; j++) {
        if (!_tiles[i].isBlank &&
            !_tiles[j].isBlank &&
            _tiles[i].value > _tiles[j].value) {
          inversions++;
        }
      }
    }

    // For even grid sizes, blank tile's row position from bottom affects solvability
    if (gridSize % 2 == 0) {
      final blankTile = _tiles.firstWhere((tile) => tile.isBlank);
      final blankRow = blankTile.currentPosition ~/ gridSize;
      final blankRowFromBottom = gridSize - blankRow;
      return (inversions + blankRowFromBottom) % 2 == 0;
    }

    // For odd grid sizes, just check inversions
    return inversions % 2 == 0;
  }

  // Move tile
  bool moveTile(int position) {
    if (!_isPlaying) return false;

    final blankTile = _tiles.firstWhere((tile) => tile.isBlank);
    final blankPos = blankTile.currentPosition;

    if (!_isValidMove(position, blankPos)) return false;

    // Find tile at tapped position
    final tappedTile =
        _tiles.firstWhere((tile) => tile.currentPosition == position);

    // Swap positions
    final tappedIndex = _tiles.indexOf(tappedTile);
    final blankIndex = _tiles.indexOf(blankTile);

    _tiles[tappedIndex] = tappedTile.copyWith(currentPosition: blankPos);
    _tiles[blankIndex] = blankTile.copyWith(currentPosition: position);

    // Swap tiles in the list
    final temp = _tiles[tappedIndex];
    _tiles[tappedIndex] = _tiles[blankIndex];
    _tiles[blankIndex] = temp;

    _moves++;
    notifyListeners();

    if (isSolved) {
      _isPlaying = false;
      _updateBestScore();
    }

    return true;
  }

  void _updateBestScore() {
    if (_bestTime == null || playDuration < _bestTime!) {
      _bestTime = playDuration;
    }
    if (_bestMoves == null || _moves < _bestMoves!) {
      _bestMoves = _moves;
    }
  }

  bool _isValidMove(int tappedPosition, int blankPosition) {
    final tappedRow = tappedPosition ~/ gridSize;
    final tappedCol = tappedPosition % gridSize;
    final blankRow = blankPosition ~/ gridSize;
    final blankCol = blankPosition % gridSize;

    return (tappedRow == blankRow && (tappedCol - blankCol).abs() == 1) ||
        (tappedCol == blankCol && (tappedRow - blankRow).abs() == 1);
  }

  void reset() {
    initialize();
  }
}
