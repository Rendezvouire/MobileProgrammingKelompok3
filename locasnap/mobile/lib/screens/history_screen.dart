import 'package:flutter/material.dart';

import '../models/location_record.dart';
import '../utils/app_colors.dart';
import '../utils/record_store.dart';
import '../widgets/festival_widgets.dart';
import '../widgets/record_card.dart';
import 'add_record_screen.dart';
import 'detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const FestivalBanner('Riwayat Lokasi')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRecordScreen()),
          );
        },
        icon: const Icon(Icons.add_location_alt),
        label: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ValueListenableBuilder<List<LocationRecord>>(
        valueListenable: RecordStore.records,
        builder: (context, records, _) {
          if (records.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_outlined, size: 64, color: AppColors.purple),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada lokasi yang dicatat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final sorted = RecordStore.newestFirst(records);
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              final record = sorted[index];
              return RecordCard(
                record: record,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(record: record),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
