import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/game_button.dart';

class WinnerMessage extends StatelessWidget {
  final int winner;
  final int player1Score;
  final int player2Score;
  final VoidCallback onReset;

  const WinnerMessage({
    super.key,
    required this.winner,
    required this.player1Score,
    required this.player2Score,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final String winnerName =
        winner == 1 ? 'PLAYER 1' : 'PLAYER 2';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfacePink,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events_rounded,
            size: 48,
            color: AppColors.winner,
          ),

          const SizedBox(height: 12),

          Text(
            'MATCH FINISHED',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            '$winnerName WINS!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.winner,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '$player1Score - $player2Score',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 20),

          GameButton(
            label: 'RESET MATCH',
            icon: Icons.refresh_rounded,
            onPressed: onReset,
          ),
        ],
      ),
    );
  }
}
