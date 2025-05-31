import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ProgressBar extends StatelessWidget {
  final double value; // Progress value, range 0.0 to 1.0
  final double height;
  final Gradient? gradient;
  final Color backgroundColor;
  final String? label;
  final TextStyle? labelStyle;
  final bool showPercentage;

  const ProgressBar({
    Key? key,
    required this.value,
    this.height = 16.0,
    this.gradient,
    this.backgroundColor = const Color(0x4D000000), // Semi-transparent black
    this.label,
    this.labelStyle,
    this.showPercentage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);
    final effectiveGradient = gradient ?? AppConstants.progressBarGradient;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label!,
                  style: labelStyle ?? AppConstants.bodyMedium,
                ),
                if (showPercentage)
                  Text(
                    '${(clampedValue * 100).toInt()}%',
                    style: labelStyle ?? AppConstants.bodyMedium,
                  ),
              ],
            ),
          ),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2 - 1),
            child: Stack(
              children: [
                // Progress bar fill
                FractionallySizedBox(
                  widthFactor: clampedValue,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: effectiveGradient,
                    ),
                  ),
                ),
                // Shine effect
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor: clampedValue,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.5),
                            Colors.white.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.5],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
