import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/player_card.dart';
import '../widgets/game_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State sementara untuk skor & pengaturan
  int player1Score = 18; // Contoh angka awal seperti di desainmu
  int player2Score = 15;
  int maxScore = 21;
  int currentSet = 1;
  final int totalSets = 3;

  void addPointPlayer1() {
    setState(() {
      if (player1Score < maxScore) {
        player1Score++;
      }
    });
  }

  void subtractPointPlayer1() {
    setState(() {
      if (player1Score > 0) {
        player1Score--;
      }
    });
  }

  void addPointPlayer2() {
    setState(() {
      if (player2Score < maxScore) {
        player2Score++;
      }
    });
  }

  void subtractPointPlayer2() {
    setState(() {
      if (player2Score > 0) {
        player2Score--;
      }
    });
  }

  void resetGame() {
    setState(() {
      player1Score = 0;
      player2Score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header Atas (SCORE COUNTER & Opsi Titik Tiga)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Spacer seimbang denganicon kanan
                  const Text(
                    'SCORE COUNTER',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Aksi menu tambahan jika ada
                    },
                    icon: const Icon(Icons.more_vert_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Badge Set & Target Poin (SET 1/3 • Target: 21 Poin)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'SET $currentSet/$totalSets',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('•', style: TextStyle(color: Colors.grey)),
                    ),
                    Text(
                      'Target: $maxScore Poin',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Kartu Player 1
              PlayerCard(
                playerName: 'PLAYER 1',
                score: player1Score,
                isServing: true, // Contoh Player 1 sedang serving
                enabled: player1Score < maxScore && player2Score < maxScore,
                onAdd: addPointPlayer1,
                onSubtract: subtractPointPlayer1,
              ),

              const SizedBox(height: 16),

              // Indikator VS di tengah
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Kartu Player 2
              PlayerCard(
                playerName: 'PLAYER 2',
                score: player2Score,
                isServing: false, // Player 2 defending
                enabled: player1Score < maxScore && player2Score < maxScore,
                onAdd: addPointPlayer2,
                onSubtract: subtractPointPlayer2,
              ),

              const SizedBox(height: 28),

              // Baris Tombol Bawah (RESET & PENGATURAN)
              Row(
                children: [
                  Expanded(
                    child: GameButton(
                      label: 'RESET',
                      icon: Icons.refresh_rounded,
                      outlined: true,
                      onPressed: resetGame,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GameButton(
                      label: 'PENGATURAN',
                      icon: Icons.settings_rounded,
                      onPressed: () {
                        // Nanti diarahkan ke halaman Settings Screen
                      },
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
