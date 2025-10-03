import 'dart:math';
import '../../domain/entities/game_entity.dart';
import 'constants.dart';

enum Direction { up, right, down, left }

class GameLogic {
  static const int BOARD_SIZE = GameConstants.BOARD_SIZE;

  // Initialize a new game
  static GameEntity initializeGame({int? bestScore = 0}) {
    // Create an empty board with explicit type annotation
    final List<List<TileEntity?>> board = List.generate(
      BOARD_SIZE,
      (_) => List<TileEntity?>.filled(BOARD_SIZE, null),
    );

    // Add two initial tiles
    _addRandomTile(board, forceValue: 1);
    _addRandomTile(board, forceValue: 2);

    return GameEntity(
      score: 0,
      bestScore: bestScore ?? 0,
      board: board,
      nextTile: TileEntity(value: _getRandomTileValue()),
      isGameOver: false,
    );
  }

  // Process a move in the specified direction
  static GameEntity processMove(GameEntity game, Direction direction) {
    // Create a deep copy of the board with explicit type annotation
    final List<List<TileEntity?>> newBoard = List<List<TileEntity?>>.generate(
      BOARD_SIZE,
      (i) => List<TileEntity?>.generate(
        BOARD_SIZE,
        (j) => game.board[i][j]?.resetState(),
      ),
    );

    // Use a wrapper for score to pass by reference
    final scoreWrapper = [0]; // [0] is the added score
    bool boardChanged = false;

    // Process the move based on direction
    switch (direction) {
      case Direction.up:
        boardChanged = _moveUp(newBoard, scoreWrapper);
        break;
      case Direction.right:
        boardChanged = _moveRight(newBoard, scoreWrapper);
        break;
      case Direction.down:
        boardChanged = _moveDown(newBoard, scoreWrapper);
        break;
      case Direction.left:
        boardChanged = _moveLeft(newBoard, scoreWrapper);
        break;
    }

    // If the board didn't change, return the original game state
    if (!boardChanged) {
      return game;
    }

    // Add a new tile from the opposite edge
    _addTileFromEdge(newBoard, direction, game.nextTile.value);

    // Generate the next tile value
    final nextTileValue = _getRandomTileValue();

    // Check if the game is over
    final isGameOver = _isGameOver(newBoard);

    // Update the score using the value from scoreWrapper
    final newScore = game.score + scoreWrapper[0];
    final newBestScore = max(game.bestScore, newScore);

    return GameEntity(
      score: newScore,
      bestScore: newBestScore,
      board: newBoard,
      nextTile: TileEntity(value: nextTileValue),
      isGameOver: isGameOver,
    );
  }

  // Move tiles up
  static bool _moveUp(List<List<TileEntity?>> board, List<int> scoreWrapper) {
    bool moved = false;

    // For each column
    for (int col = 0; col < BOARD_SIZE; col++) {
      // For each row (starting from the second row)
      for (int row = 1; row < BOARD_SIZE; row++) {
        if (board[row][col] != null) {
          int newRow = row;

          // Move the tile up only one grid if possible
          if (newRow > 0 && board[newRow - 1][col] == null) {
            newRow--;
          }

          // If the tile moved
          if (newRow != row) {
            // Save the previous position for animation
            final tile = board[row][col]!.withMovement(
              previousX: col,
              previousY: row,
            );

            // Move the tile
            board[newRow][col] = tile;
            board[row][col] = null;
            moved = true;
          }
          // Check if we can merge with the tile above
          else if (newRow > 0 &&
              _canMerge(board[newRow][col], board[newRow - 1][col])) {
            // Perform the merge
            final mergedValue = _getMergedValue(
              board[newRow][col]!.value,
              board[newRow - 1][col]!.value,
            );

            // Update the score in the wrapper
            scoreWrapper[0] += mergedValue;

            // Create the merged tile
            board[newRow - 1][col] = board[newRow - 1][col]!.withMerge(
              newValue: mergedValue,
            );

            // Remove the original tile
            board[newRow][col] = null;
            moved = true;
          }
        }
      }
    }

    return moved;
  }

  // Move tiles right
  static bool _moveRight(
    List<List<TileEntity?>> board,
    List<int> scoreWrapper,
  ) {
    bool moved = false;

    // For each row
    for (int row = 0; row < BOARD_SIZE; row++) {
      // For each column (starting from the second-to-last column)
      for (int col = BOARD_SIZE - 2; col >= 0; col--) {
        if (board[row][col] != null) {
          int newCol = col;

          // Move the tile right only one grid if possible
          if (newCol < BOARD_SIZE - 1 && board[row][newCol + 1] == null) {
            newCol++;
          }

          // If the tile moved
          if (newCol != col) {
            // Save the previous position for animation
            final tile = board[row][col]!.withMovement(
              previousX: col,
              previousY: row,
            );

            // Move the tile
            board[row][newCol] = tile;
            board[row][col] = null;
            moved = true;
          }
          // Check if we can merge with the tile to the right
          else if (newCol < BOARD_SIZE - 1 &&
              _canMerge(board[row][newCol], board[row][newCol + 1])) {
            // Perform the merge
            final mergedValue = _getMergedValue(
              board[row][newCol]!.value,
              board[row][newCol + 1]!.value,
            );

            // Update the score in the wrapper
            scoreWrapper[0] += mergedValue;

            // Create the merged tile
            board[row][newCol + 1] = board[row][newCol + 1]!.withMerge(
              newValue: mergedValue,
            );

            // Remove the original tile
            board[row][newCol] = null;
            moved = true;
          }
        }
      }
    }

    return moved;
  }

  // Move tiles down
  static bool _moveDown(List<List<TileEntity?>> board, List<int> scoreWrapper) {
    bool moved = false;

    // For each column
    for (int col = 0; col < BOARD_SIZE; col++) {
      // For each row (starting from the second-to-last row)
      for (int row = BOARD_SIZE - 2; row >= 0; row--) {
        if (board[row][col] != null) {
          int newRow = row;

          // Move the tile down only one grid if possible
          if (newRow < BOARD_SIZE - 1 && board[newRow + 1][col] == null) {
            newRow++;
          }

          // If the tile moved
          if (newRow != row) {
            // Save the previous position for animation
            final tile = board[row][col]!.withMovement(
              previousX: col,
              previousY: row,
            );

            // Move the tile
            board[newRow][col] = tile;
            board[row][col] = null;
            moved = true;
          }
          // Check if we can merge with the tile below
          else if (newRow < BOARD_SIZE - 1 &&
              _canMerge(board[newRow][col], board[newRow + 1][col])) {
            // Perform the merge
            final mergedValue = _getMergedValue(
              board[newRow][col]!.value,
              board[newRow + 1][col]!.value,
            );

            // Update the score in the wrapper
            scoreWrapper[0] += mergedValue;

            // Create the merged tile
            board[newRow + 1][col] = board[newRow + 1][col]!.withMerge(
              newValue: mergedValue,
            );

            // Remove the original tile
            board[newRow][col] = null;
            moved = true;
          }
        }
      }
    }

    return moved;
  }

  // Move tiles left
  static bool _moveLeft(List<List<TileEntity?>> board, List<int> scoreWrapper) {
    bool moved = false;

    // For each row
    for (int row = 0; row < BOARD_SIZE; row++) {
      // For each column (starting from the second column)
      for (int col = 1; col < BOARD_SIZE; col++) {
        if (board[row][col] != null) {
          int newCol = col;

          // Move the tile left only one grid if possible
          if (newCol > 0 && board[row][newCol - 1] == null) {
            newCol--;
          }

          // If the tile moved
          if (newCol != col) {
            // Save the previous position for animation
            final tile = board[row][col]!.withMovement(
              previousX: col,
              previousY: row,
            );

            // Move the tile
            board[row][newCol] = tile;
            board[row][col] = null;
            moved = true;
          }
          // Check if we can merge with the tile to the left
          else if (newCol > 0 &&
              _canMerge(board[row][newCol], board[row][newCol - 1])) {
            // Perform the merge
            final mergedValue = _getMergedValue(
              board[row][newCol]!.value,
              board[row][newCol - 1]!.value,
            );

            // Update the score in the wrapper
            scoreWrapper[0] += mergedValue;

            // Create the merged tile
            board[row][newCol - 1] = board[row][newCol - 1]!.withMerge(
              newValue: mergedValue,
            );

            // Remove the original tile
            board[row][newCol] = null;
            moved = true;
          }
        }
      }
    }

    return moved;
  }

  // Check if two tiles can be merged
  static bool _canMerge(TileEntity? tile1, TileEntity? tile2) {
    if (tile1 == null || tile2 == null) {
      return false;
    }

    // Special case: 1 + 2 = 3
    if ((tile1.value == 1 && tile2.value == 2) ||
        (tile1.value == 2 && tile2.value == 1)) {
      return true;
    }

    // Regular case: n + n = 2n (where n ≥ 3)
    return tile1.value == tile2.value && tile1.value >= 3;
  }

  // Get the value of a merged tile
  static int _getMergedValue(int value1, int value2) {
    // Special case: 1 + 2 = 3
    if ((value1 == 1 && value2 == 2) || (value1 == 2 && value2 == 1)) {
      return 3;
    }

    // Regular case: n + n = 2n (where n ≥ 3)
    if (value1 == value2) {
      return value1 * 2;
    }

    // This should never happen
    return max(value1, value2);
  }

  // Add a random tile to the board
  static void _addRandomTile(List<List<TileEntity?>> board, {int? forceValue}) {
    final emptyCells = <List<int>>[];

    // Find all empty cells
    for (int row = 0; row < BOARD_SIZE; row++) {
      for (int col = 0; col < BOARD_SIZE; col++) {
        if (board[row][col] == null) {
          emptyCells.add([row, col]);
        }
      }
    }

    if (emptyCells.isEmpty) {
      return;
    }

    // Choose a random empty cell
    final random = Random();
    final cell = emptyCells[random.nextInt(emptyCells.length)];

    // Add a new tile
    board[cell[0]][cell[1]] = TileEntity(
      value: forceValue ?? _getRandomTileValue(),
      isNew: true,
    );
  }

  // Add a new tile from the specified edge
  static void _addTileFromEdge(
    List<List<TileEntity?>> board,
    Direction direction,
    int value,
  ) {
    final random = Random();

    // 修正：滑动方向和新牌出现的位置是相反的
    // 例如：向上滑动，新牌应该从底部出现
    Direction oppositeDirection = _getOppositeDirection(direction);

    switch (oppositeDirection) {
      case Direction.down: // 向上滑动时，从底部出现
        // Add from the bottom edge
        final availableCols = <int>[];
        for (int col = 0; col < BOARD_SIZE; col++) {
          if (board[BOARD_SIZE - 1][col] == null) {
            availableCols.add(col);
          }
        }

        if (availableCols.isNotEmpty) {
          final col = availableCols[random.nextInt(availableCols.length)];
          board[BOARD_SIZE - 1][col] = TileEntity(
            value: value,
            isNew: true,
            // No previous position since it's coming from outside the board
          );
        }
        break;

      case Direction.left: // 向右滑动时，从左侧出现
        // Add from the left edge
        final availableRows = <int>[];
        for (int row = 0; row < BOARD_SIZE; row++) {
          if (board[row][0] == null) {
            availableRows.add(row);
          }
        }

        if (availableRows.isNotEmpty) {
          final row = availableRows[random.nextInt(availableRows.length)];
          board[row][0] = TileEntity(
            value: value,
            isNew: true,
            // No previous position since it's coming from outside the board
          );
        }
        break;

      case Direction.up: // 向下滑动时，从顶部出现
        // Add from the top edge
        final availableCols = <int>[];
        for (int col = 0; col < BOARD_SIZE; col++) {
          if (board[0][col] == null) {
            availableCols.add(col);
          }
        }

        if (availableCols.isNotEmpty) {
          final col = availableCols[random.nextInt(availableCols.length)];
          board[0][col] = TileEntity(
            value: value,
            isNew: true,
            // No previous position since it's coming from outside the board
          );
        }
        break;

      case Direction.right: // 向左滑动时，从右侧出现
        // Add from the right edge
        final availableRows = <int>[];
        for (int row = 0; row < BOARD_SIZE; row++) {
          if (board[row][BOARD_SIZE - 1] == null) {
            availableRows.add(row);
          }
        }

        if (availableRows.isNotEmpty) {
          final row = availableRows[random.nextInt(availableRows.length)];
          board[row][BOARD_SIZE - 1] = TileEntity(
            value: value,
            isNew: true,
            // No previous position since it's coming from outside the board
          );
        }
        break;
    }
  }

  // 获取相反的方向
  static Direction _getOppositeDirection(Direction direction) {
    switch (direction) {
      case Direction.up:
        return Direction.down;
      case Direction.down:
        return Direction.up;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
    }
  }

  // Generate a random tile value (1, 2, or occasionally 3)
  static int _getRandomTileValue() {
    final random = Random().nextInt(100);

    if (random < GameConstants.SPAWN_CHANCE_ONE) {
      return 1;
    } else if (random <
        GameConstants.SPAWN_CHANCE_ONE + GameConstants.SPAWN_CHANCE_TWO) {
      return 2;
    } else {
      return 3;
    }
  }

  // Check if the game is over
  static bool _isGameOver(List<List<TileEntity?>> board) {
    // First, check if there are any empty cells
    for (int row = 0; row < BOARD_SIZE; row++) {
      for (int col = 0; col < BOARD_SIZE; col++) {
        if (board[row][col] == null) {
          return false; // Game is not over if there are empty cells
        }
      }
    }

    // If we get here, the board is full. Now check for possible merges in all directions

    // Check horizontal merges
    for (int row = 0; row < BOARD_SIZE; row++) {
      for (int col = 0; col < BOARD_SIZE - 1; col++) {
        if (_canMerge(board[row][col], board[row][col + 1])) {
          return false; // Found a possible horizontal merge
        }
      }
    }

    // Check vertical merges
    for (int col = 0; col < BOARD_SIZE; col++) {
      for (int row = 0; row < BOARD_SIZE - 1; row++) {
        if (_canMerge(board[row][col], board[row + 1][col])) {
          return false; // Found a possible vertical merge
        }
      }
    }

    // Double check with the special case for 1+2=3
    for (int row = 0; row < BOARD_SIZE; row++) {
      for (int col = 0; col < BOARD_SIZE; col++) {
        // Check right
        if (col < BOARD_SIZE - 1) {
          if ((board[row][col]!.value == 1 &&
                  board[row][col + 1]!.value == 2) ||
              (board[row][col]!.value == 2 &&
                  board[row][col + 1]!.value == 1)) {
            return false;
          }
        }

        // Check down
        if (row < BOARD_SIZE - 1) {
          if ((board[row][col]!.value == 1 &&
                  board[row + 1][col]!.value == 2) ||
              (board[row][col]!.value == 2 &&
                  board[row + 1][col]!.value == 1)) {
            return false;
          }
        }
      }
    }

    // No empty cells and no possible merges, game over
    return true;
  }

  // Convert between domain entities and data models
  static List<List<int?>> boardToModel(List<List<TileEntity?>> board) {
    return List<List<int?>>.generate(
      BOARD_SIZE,
      (row) => List<int?>.generate(BOARD_SIZE, (col) => board[row][col]?.value),
    );
  }

  static List<List<TileEntity?>> boardFromModel(List<List<int?>> board) {
    return List<List<TileEntity?>>.generate(
      BOARD_SIZE,
      (row) => List<TileEntity?>.generate(
        BOARD_SIZE,
        (col) => board[row][col] != null
            ? TileEntity(value: board[row][col]!)
            : null,
      ),
    );
  }
}
