import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../widgets/score_header.dart';
import '../widgets/player_card.dart';
import '../widgets/game_button.dart';
import '../widgets/winner_message.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int player1Score = 0;
  int player2Score = 0;
  int currentMaxScore = AppConstants.defaultMaxScore;

  // Cek apakah game sudah selesai (salah satu mencapai target)
  bool get isGameOver =>
      player1Score >= currentMaxScore || player2Score >= currentMaxScore;

  // Menentukan siapa pemenangnya (1 atau 2)
  int get winner => player1Score >= currentMaxScore
      ? 1
      : (player2Score >= currentMaxScore ? 2 : 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const ScoreHeader(),
              const SizedBox(height: 28),

              // Kartu Player 1
              PlayerCard(
                playerName: AppConstants.player1Name,
                score: player1Score,
                isServing: true,
                enabled: !isGameOver,
                onAdd: () {
                  if (!isGameOver) {
                    setState(() {
                      player1Score++;
                    });
                  }
                },
                onSubtract: () {
                  if (player1Score > 0 && !isGameOver) {
                    setState(() {
                      player1Score--;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Kartu Player 2
              PlayerCard(
                playerName: AppConstants.player2Name,
                score: player2Score,
                isServing: false,
                enabled: !isGameOver,
                onAdd: () {
                  if (!isGameOver) {
                    setState(() {
                      player2Score++;
                    });
                  }
                },
                onSubtract: () {
                  if (player2Score > 0 && !isGameOver) {
                    setState(() {
                      player2Score--;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // Jika Game Over, tampilkan WinnerMessage. Jika belum, tampilkan target & tombol bawah.
              if (isGameOver) ...[
                const SizedBox(height: 10),
                WinnerMessage(
                  winner: winner,
                  player1Score: player1Score,
                  player2Score: player2Score,
                  onReset: () {
                    setState(() {
                      player1Score = 0;
                      player2Score = 0;
                    });
                  },
                ),
              ] else ...[
                Text(
                  'Target: $currentMaxScore Point',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GameButton(
                        label: 'RESET',
                        icon: Icons.refresh_rounded,
                        outlined: true,
                        onPressed: () {
                          setState(() {
                            player1Score = 0;
                            player2Score = 0;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GameButton(
                        label: 'PENGATURAN',
                        icon: Icons.settings_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(
                                initialMaxScore: currentMaxScore,
                                onSave: (newScore) {
                                  setState(() {
                                    currentMaxScore = newScore;
                                    player1Score = 0;
                                    player2Score = 0;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
