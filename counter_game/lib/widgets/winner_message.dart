import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'game_button.dart';

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
    final String winnerName = winner == 1 ? 'PLAYER 1' : 'PLAYER 2';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon piala
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'MATCH FINISHED',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$winnerName MENANG!',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'SKOR AKHIR: $player1Score - $player2Score',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          GameButton(
            label: 'MAIN LAGI / RESET MATCH',
            icon: Icons.refresh_rounded,
            onPressed: onReset,
          ),
        ],
      ),
    );
  }
}
