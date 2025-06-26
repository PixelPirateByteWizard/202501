import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../models/game_piece_model.dart';

/// Widget that displays the synthesis rules for color combinations
class SynthesisRulesWidget extends StatelessWidget {
  const SynthesisRulesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Synthesis Rules',
            style: SafeFonts.imFellEnglishSc(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSynthesisRule(
                PieceColor.red,
                PieceColor.yellow,
                PieceColor.orange,
              ),
              _buildSynthesisRule(
                PieceColor.red,
                PieceColor.blue,
                PieceColor.purple,
              ),
              _buildSynthesisRule(
                PieceColor.yellow,
                PieceColor.blue,
                PieceColor.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSynthesisRule(
      PieceColor color1, PieceColor color2, PieceColor result) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildColorCircle(color1, 16),
        const Text(
          ' + ',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildColorCircle(color2, 16),
        const Text(
          ' → ',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildColorCircle(result, 16),
      ],
    );
  }

  Widget _buildColorCircle(PieceColor color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.get(color),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.get(color).withOpacity(0.6),
          width: 1,
        ),
      ),
    );
  }
}
