import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/record_store.dart';

/// Kartu pesan saat data gagal diambil dari server, dengan tombol coba lagi.
class ServerErrorCard extends StatelessWidget {
  final String message;

  const ServerErrorCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.red, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off, color: AppColors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: RecordStore.refresh,
            child: const Text(
              'Coba lagi',
              style: TextStyle(
                color: AppColors.purple,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingRecords extends StatelessWidget {
  const LoadingRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: CircularProgressIndicator(color: AppColors.purple),
      ),
    );
  }
}
