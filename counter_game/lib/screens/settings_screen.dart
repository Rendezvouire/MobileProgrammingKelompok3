import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/game_button.dart';

class SettingsScreen extends StatefulWidget {
  final int initialMaxScore;
  final Function(int) onSave;

  const SettingsScreen({
    super.key,
    required this.initialMaxScore,
    required this.onSave,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int targetScore;
  bool isDeuceActive = true;

  @override
  void initState() {
    super.initState();
    targetScore = widget.initialMaxScore;
  }

  void incrementTarget() {
    setState(() {
      targetScore++;
    });
  }

  void decrementTarget() {
    setState(() {
      if (targetScore > 1) targetScore--;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:
                        const Icon(Icons.arrow_back, color: AppColors.primary),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.border),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'PENGATURAN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'SKOR MAKSIMAL UNTUK MENANG',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 54,
                          width: 54,
                          child: OutlinedButton(
                            onPressed: decrementTarget,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.remove,
                                color: AppColors.primary, size: 24),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '$targetScore',
                              style: const TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const Text(
                              'POIN TARGET',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 54,
                          width: 54,
                          child: ElevatedButton(
                            onPressed: incrementTarget,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.add, size: 24),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'PRESET STANDAR PERTANDINGAN:',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildPresetButton(21, 'Bulu Tangkis')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildPresetButton(25, 'Bola Voli')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildPresetButton(11, 'Tenis Meja')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'ATURAN TAMBAHAN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selisih 2 Poin (Deuce)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Wajib selisih dua angka untuk memenangkan game.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isDeuceActive,
                      activeThumbColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          isDeuceActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              GameButton(
                label: 'SIMPAN PENGATURAN',
                icon: Icons.check_rounded,
                onPressed: () {
                  widget.onSave(targetScore);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetButton(int score, String label) {
    bool isSelected = targetScore == score;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          targetScore = score;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : Colors.white,
        foregroundColor: isSelected ? Colors.white : AppColors.textPrimary,
        side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Column(
        children: [
          Text(
            '$score',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isSelected ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
