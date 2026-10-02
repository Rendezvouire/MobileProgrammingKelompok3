import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/record_store.dart';
import '../widgets/festival_widgets.dart';
import '../widgets/record_card.dart';
import '../widgets/server_status.dart';
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
      body: ListenableBuilder(
        listenable: RecordStore.changes,
        builder: (context, _) {
          final records = RecordStore.records.value;
          final loading = RecordStore.loading.value;
          final error = RecordStore.error.value;
          final sorted = RecordStore.newestFirst(records);

          return RefreshIndicator(
            color: AppColors.purple,
            onRefresh: RecordStore.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
              children: [
                if (error != null) ServerErrorCard(message: error),
                if (sorted.isEmpty && loading)
                  const LoadingRecords()
                else if (sorted.isEmpty && error == null)
                  const _EmptyHistory()
                else
                  for (final record in sorted)
                    RecordCard(
                      record: record,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(record: record),
                          ),
                        );
                      },
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 64),
      child: Column(
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
    );
  }
}
