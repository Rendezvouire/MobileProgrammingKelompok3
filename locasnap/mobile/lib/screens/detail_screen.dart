import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/location_record.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/festival_widgets.dart';
import '../widgets/record_photo.dart';

class DetailScreen extends StatelessWidget {
  final LocationRecord record;

  const DetailScreen({super.key, required this.record});

  Future<void> _copyCoords(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(
      ClipboardData(text: '${record.latitude}, ${record.longitude}'),
    );
    messenger.showSnackBar(
      const SnackBar(content: Text('Koordinat disalin')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentFor(record.id ?? 0);
    final description = record.description;
    final hasDescription = description != null && description.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const FestivalBanner('Detail Lokasi')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: RecordPhoto(record: record, radius: 24),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: const TextStyle(
                    color: AppColors.purple,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 16,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatDate(record.createdAt),
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  hasDescription ? description : 'Tidak ada deskripsi.',
                  style: TextStyle(
                    color: hasDescription ? AppColors.ink : AppColors.muted,
                    fontSize: 15,
                    height: 1.4,
                    fontStyle:
                        hasDescription ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _CoordTile(
                        label: 'Latitude',
                        value: record.latitude.toStringAsFixed(5),
                        color: accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CoordTile(
                        label: 'Longitude',
                        value: record.longitude.toStringAsFixed(5),
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FestivalButton(
            label: 'Salin koordinat',
            icon: Icons.copy,
            color: AppColors.purple,
            onPressed: () => _copyCoords(context),
          ),
        ],
      ),
    );
  }
}

class _CoordTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _CoordTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
