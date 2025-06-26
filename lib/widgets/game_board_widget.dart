import 'package:flutter/material.dart';
import '../models/game_piece_model.dart';
import '../utils/colors.dart';

/// Callback type for when a swap gesture is completed.
typedef OnSwapCallback = void Function(
    int fromRow, int fromCol, int toRow, int toCol);

/// The widget that renders the game board and handles user input gestures.
class GameBoardWidget extends StatefulWidget {
  final List<List<GamePiece?>> board;
  final OnSwapCallback onSwap;
  final int rows;
  final int cols;

  const GameBoardWidget({
    Key? key,
    required this.board,
    required this.onSwap,
    this.rows = 8,
    this.cols = 8,
  }) : super(key: key);

  @override
  _GameBoardWidgetState createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget>
    with TickerProviderStateMixin {
  Point? _dragStartPoint;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double boardSize = constraints.maxWidth;
      final double cellSize = boardSize / widget.cols;

      return GestureDetector(
        onPanStart: (details) {
          _dragStartPoint =
              _getPointFromOffset(details.localPosition, cellSize);
        },
        onPanUpdate: (details) {
          if (_dragStartPoint == null) return;

          Point currentPoint =
              _getPointFromOffset(details.localPosition, cellSize);
          if (currentPoint != _dragStartPoint) {
            // Check for adjacent swipe
            if ((currentPoint.x - _dragStartPoint!.x).abs() +
                    (currentPoint.y - _dragStartPoint!.y).abs() ==
                1) {
              widget.onSwap(
                _dragStartPoint!.y,
                _dragStartPoint!.x,
                currentPoint.y,
                currentPoint.x,
              );
            }
            _dragStartPoint = null; // Reset after one swap attempt
          }
        },
        onPanEnd: (_) => _dragStartPoint = null,
        child: Container(
          width: boardSize,
          height: boardSize,
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Grid lines
              _buildGridLines(boardSize, cellSize),
              // Game pieces
              ..._buildBoardPieces(cellSize),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildGridLines(double boardSize, double cellSize) {
    return CustomPaint(
      size: Size(boardSize, boardSize),
      painter: GridPainter(
        cellSize: cellSize,
        rows: widget.rows,
        cols: widget.cols,
      ),
    );
  }

  Point _getPointFromOffset(Offset offset, double cellSize) {
    final int col = (offset.dx / cellSize).floor();
    final int row = (offset.dy / cellSize).floor();
    return Point(col, row);
  }

  List<Widget> _buildBoardPieces(double cellSize) {
    final List<Widget> pieces = [];
    for (int r = 0; r < widget.rows; r++) {
      for (int c = 0; c < widget.cols; c++) {
        final GamePiece? piece = widget.board[r][c];
        if (piece != null) {
          pieces.add(
            AnimatedPositioned(
              key: ValueKey(piece.id), // Crucial for smooth animation
              duration: const Duration(milliseconds: 400),
              curve: Curves.bounceOut,
              left: c * cellSize,
              top: r * cellSize,
              width: cellSize,
              height: cellSize,
              child: _buildGamePiece(piece, cellSize),
            ),
          );
        }
      }
    }
    return pieces;
  }

  Widget _buildGamePiece(GamePiece piece, double cellSize) {
    return Padding(
      padding: EdgeInsets.all(cellSize * 0.08),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale:
                piece.type == PieceType.secondary ? _pulseAnimation.value : 1.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.3),
                  radius: 1.0,
                  colors: [
                    AppColors.get(piece.color).withOpacity(0.3),
                    AppColors.get(piece.color),
                    AppColors.get(piece.color).withOpacity(0.8),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.get(piece.color).withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Main highlight
                  Positioned(
                    top: cellSize * 0.15,
                    left: cellSize * 0.15,
                    child: Container(
                      width: cellSize * 0.25,
                      height: cellSize * 0.25,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Secondary highlight
                  Positioned(
                    top: cellSize * 0.25,
                    left: cellSize * 0.25,
                    child: Container(
                      width: cellSize * 0.15,
                      height: cellSize * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Type indicator for secondary pieces
                  if (piece.type == PieceType.secondary)
                    Center(
                      child: Container(
                        width: cellSize * 0.1,
                        height: cellSize * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter for drawing grid lines
class GridPainter extends CustomPainter {
  final double cellSize;
  final int rows;
  final int cols;

  GridPainter({
    required this.cellSize,
    required this.rows,
    required this.cols,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.background.withOpacity(0.3)
      ..strokeWidth = 1.0;

    // Draw vertical lines
    for (int i = 0; i <= cols; i++) {
      final x = i * cellSize;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (int i = 0; i <= rows; i++) {
      final y = i * cellSize;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simple class to represent a point on the grid.
class Point {
  final int x;
  final int y;
  const Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
