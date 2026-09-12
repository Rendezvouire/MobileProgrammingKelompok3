import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ScoreHeader extends StatelessWidget {
  const ScoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SCORE COUNTER',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Track your game score',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
