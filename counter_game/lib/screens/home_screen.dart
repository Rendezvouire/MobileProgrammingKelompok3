import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../widgets/score_header.dart';
import '../widgets/player_card.dart';
import '../widgets/game_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int player1Score = 0;
  int player2Score = 0;

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

              PlayerCard(
                playerName: AppConstants.player1Name,
                score: player1Score,
                playerColor: AppColors.player1,
                onAdd: () {
                  setState(() {
                    player1Score++;
                  });
                },
                onSubtract: () {
                  if (player1Score > 0) {
                    setState(() {
                      player1Score--;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              PlayerCard(
                playerName: AppConstants.player2Name,
                score: player2Score,
                playerColor: AppColors.player2,
                onAdd: () {
                  setState(() {
                    player2Score++;
                  });
                },
                onSubtract: () {
                  if (player2Score > 0) {
                    setState(() {
                      player2Score--;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              Text(
                'Target: ${AppConstants.defaultMaxScore} Point',
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
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
