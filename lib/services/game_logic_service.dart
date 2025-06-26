import 'dart:math';
import '../models/game_piece_model.dart';
import '../models/level_model.dart';

/// Enum to represent the current status of the game.
/// 代表当前游戏状态的枚举
enum GameStatus { playing, win, lose }

/// This service contains all the core game logic, detached from the UI.
/// 这个服务包含了所有核心游戏逻辑，与UI分离
class GameLogicService {
  Level? _currentLevel;
  List<List<GamePiece?>> _board = [];
  int _score = 0;
  int _movesLeft = 0;
  Map<PieceColor, int> _currentObjectives = {};

  Level get currentLevel => _currentLevel ?? Level.levels.first;
  List<List<GamePiece?>> get board => _board;
  int get score => _score;
  int get movesLeft => _movesLeft;
  Map<PieceColor, int> get objectives => _currentObjectives;

  final int rows = 8;
  final int cols = 8;
  int _nextPieceId = 0;
  final Random _random = Random();

  /// Loads a level and initializes the game state.
  /// 加载一个关卡并初始化游戏状态
  void loadLevel(Level level) {
    _currentLevel = level;
    _score = 0;
    _movesLeft = level.moves;
    _currentObjectives = Map<PieceColor, int>.from(level.objectives);
    _initializeBoard();
  }

  void _initializeBoard() {
    _board = List.generate(rows, (_) => List.generate(cols, (_) => null));

    // Initialize with random primary pieces, avoiding initial matches
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        GamePiece newPiece;
        int attempts = 0;
        do {
          newPiece = _createRandomPrimaryPiece();
          attempts++;
        } while (attempts < 10 && _wouldCreateInitialMatch(r, c, newPiece));

        _board[r][c] = newPiece;
      }
    }
  }

  bool _wouldCreateInitialMatch(int r, int c, GamePiece piece) {
    // Check horizontal match
    if (c >= 2 &&
        _board[r][c - 1]?.color == piece.color &&
        _board[r][c - 2]?.color == piece.color) {
      return true;
    }

    // Check vertical match
    if (r >= 2 &&
        _board[r - 1][c]?.color == piece.color &&
        _board[r - 2][c]?.color == piece.color) {
      return true;
    }

    return false;
  }

  GamePiece _createRandomPrimaryPiece() {
    const primaries = [PieceColor.red, PieceColor.yellow, PieceColor.blue];
    return GamePiece(
      id: _nextPieceId++,
      type: PieceType.primary,
      color: primaries[_random.nextInt(primaries.length)],
    );
  }

  /// Attempts to perform a swap and returns true if the move was valid.
  /// 尝试执行交换，如果移动有效则返回 true
  bool attemptSwap(int r1, int c1, int r2, int c2) {
    if (_movesLeft <= 0) return false;

    GamePiece? piece1 = _board[r1][c1];
    GamePiece? piece2 = _board[r2][c2];

    if (piece1 == null || piece2 == null) return false;

    // Check if the pieces are adjacent
    if (!_areAdjacent(r1, c1, r2, c2)) return false;

    // --- Synthesis Logic ---
    // Two different primary elements -> Synthesis
    if (piece1.type == PieceType.primary &&
        piece2.type == PieceType.primary &&
        piece1.color != piece2.color) {
      _movesLeft--;
      _performSynthesis(r1, c1, r2, c2, piece1, piece2);
      _processBoard();
      return true;
    }

    // --- Match Logic ---
    // Try swapping secondary elements and check for matches
    if (piece1.type == PieceType.secondary ||
        piece2.type == PieceType.secondary) {
      // Temporarily swap to check for matches
      _board[r1][c1] = piece2;
      _board[r2][c2] = piece1;

      List<Point<int>> matches = _findAllMatches();

      if (matches.isNotEmpty) {
        _movesLeft--;
        _processBoard();
        return true;
      } else {
        // Swap back if no matches
        _board[r1][c1] = piece1;
        _board[r2][c2] = piece2;
        return false;
      }
    }

    return false;
  }

  bool _areAdjacent(int r1, int c1, int r2, int c2) {
    int deltaR = (r1 - r2).abs();
    int deltaC = (c1 - c2).abs();
    return (deltaR == 1 && deltaC == 0) || (deltaR == 0 && deltaC == 1);
  }

  void _performSynthesis(
      int r1, int c1, int r2, int c2, GamePiece p1, GamePiece p2) {
    PieceColor? newColor;
    if ((p1.color == PieceColor.red && p2.color == PieceColor.yellow) ||
        (p1.color == PieceColor.yellow && p2.color == PieceColor.red)) {
      newColor = PieceColor.orange;
    } else if ((p1.color == PieceColor.red && p2.color == PieceColor.blue) ||
        (p1.color == PieceColor.blue && p2.color == PieceColor.red)) {
      newColor = PieceColor.purple;
    } else if ((p1.color == PieceColor.yellow && p2.color == PieceColor.blue) ||
        (p1.color == PieceColor.blue && p2.color == PieceColor.yellow)) {
      newColor = PieceColor.green;
    }

    if (newColor != null) {
      _board[r1][c1] = GamePiece(
          id: _nextPieceId++, type: PieceType.secondary, color: newColor);
      _board[r2][c2] = GamePiece(
          id: _nextPieceId++, type: PieceType.secondary, color: newColor);
    }
  }

  void _processBoard() {
    bool changed;
    do {
      changed = false;
      List<Point<int>> matches = _findAllMatches();
      if (matches.isNotEmpty) {
        _clearMatches(matches);
        _applyGravity();
        _refillBoard();
        changed = true;
      }
    } while (changed);
  }

  List<Point<int>> _findAllMatches() {
    Set<Point<int>> matchedPoints = {};

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        GamePiece? piece = _board[r][c];
        if (piece == null || piece.type != PieceType.secondary) continue;

        // Horizontal match
        List<Point<int>> hMatch = [Point(c, r)];
        for (int i = c + 1; i < cols; i++) {
          GamePiece? nextPiece = _board[r][i];
          if (nextPiece?.color == piece.color &&
              nextPiece?.type == PieceType.secondary) {
            hMatch.add(Point(i, r));
          } else {
            break;
          }
        }
        if (hMatch.length >= 3) matchedPoints.addAll(hMatch);

        // Vertical match
        List<Point<int>> vMatch = [Point(c, r)];
        for (int i = r + 1; i < rows; i++) {
          GamePiece? nextPiece = _board[i][c];
          if (nextPiece?.color == piece.color &&
              nextPiece?.type == PieceType.secondary) {
            vMatch.add(Point(c, i));
          } else {
            break;
          }
        }
        if (vMatch.length >= 3) matchedPoints.addAll(vMatch);
      }
    }
    return matchedPoints.toList();
  }

  void _clearMatches(List<Point<int>> matches) {
    for (var point in matches) {
      GamePiece? piece = _board[point.y][point.x];
      if (piece != null) {
        _score += 10;
        if (_currentObjectives.containsKey(piece.color)) {
          _currentObjectives[piece.color] =
              max(0, _currentObjectives[piece.color]! - 1);
        }
        _board[point.y][point.x] = null;
      }
    }
  }

  void _applyGravity() {
    for (int c = 0; c < cols; c++) {
      int emptyRow = rows - 1;
      for (int r = rows - 1; r >= 0; r--) {
        if (_board[r][c] != null) {
          if (r != emptyRow) {
            _board[emptyRow][c] = _board[r][c];
            _board[r][c] = null;
          }
          emptyRow--;
        }
      }
    }
  }

  void _refillBoard() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (_board[r][c] == null) {
          _board[r][c] = _createRandomPrimaryPiece();
        }
      }
    }
  }

  GameStatus checkGameStatus() {
    if (objectives.values.every((count) => count <= 0)) {
      return GameStatus.win;
    }
    if (_movesLeft <= 0) {
      return GameStatus.lose;
    }
    return GameStatus.playing;
  }
}
