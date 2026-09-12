import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'score_button.dart';

class PlayerCard extends StatelessWidget {
  final String playerName;
  final int score;
  final Color playerColor;
  final VoidCallback? onAdd;
  final VoidCallback? onSubtract;

  const PlayerCard({
    super.key,
    required this.playerName,
    required this.score,
    required this.playerColor,
    required this.onAdd,
    required this.onSubtract,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: playerColor,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                playerName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              '$score',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: playerColor,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 52,
                height: 48,
                child: OutlinedButton(
                  onPressed: onSubtract,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(
                      color: AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    '−',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              ScoreButton(
                onPressed: onAdd,
                label: '+1 POINT',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
