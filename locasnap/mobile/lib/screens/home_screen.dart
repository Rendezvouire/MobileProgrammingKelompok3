import 'package:flutter/material.dart';

import '../models/location_record.dart';
import '../utils/app_colors.dart';
import '../utils/record_store.dart';
import '../widgets/festival_widgets.dart';
import '../widgets/record_card.dart';
import '../widgets/server_status.dart';
import 'add_record_screen.dart';
import 'detail_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    RecordStore.refresh();
  }

  void _openAdd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddRecordScreen()),
    );
  }

  void _openHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HistoryScreen()),
    );
  }

  void _openDetail(BuildContext context, LocationRecord record) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(record: record)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: RecordStore.changes,
          builder: (context, _) {
            final records = RecordStore.records.value;
            final loading = RecordStore.loading.value;
            final error = RecordStore.error.value;
            final recent = RecordStore.newestFirst(records).take(3).toList();
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                const _Header(),
                const SizedBox(height: 18),
                _MapCard(count: records.length),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: FestivalButton(
                        label: 'Tambah',
                        icon: Icons.add_location_alt,
                        color: AppColors.orange,
                        onPressed: () => _openAdd(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FestivalButton(
                        label: 'Riwayat',
                        icon: Icons.map_outlined,
                        color: AppColors.purple,
                        onPressed: () => _openHistory(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const FestivalBanner('Terbaru'),
                    TextButton(
                      onPressed: () => _openHistory(context),
                      child: const Text(
                        'Lihat semua',
                        style: TextStyle(
                          color: AppColors.purple,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (error != null) ServerErrorCard(message: error),
                if (recent.isEmpty && loading)
                  const LoadingRecords()
                else if (recent.isEmpty && error == null)
                  const _EmptyHint()
                else
                  for (final record in recent)
                    RecordCard(
                      record: record,
                      onTap: () => _openDetail(context, record),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.purple,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.location_on, color: AppColors.yellow, size: 30),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LOCASNAP',
                style: TextStyle(
                  color: AppColors.purple,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  height: 1.1,
                ),
              ),
              Text(
                'Catat lokasi, simpan fotonya',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapCard extends StatelessWidget {
  final int count;

  const _MapCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 190,
        color: AppColors.darkGreen,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: _MiniMapPainter(pins: count)),
            Positioned(
              left: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$count',
                      style: const TextStyle(
                        color: AppColors.red,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'lokasi\ntercatat',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  final int pins;

  const _MiniMapPainter({required this.pins});

  static const _spots = [
    Offset(0.22, 0.34),
    Offset(0.47, 0.50),
    Offset(0.72, 0.30),
    Offset(0.84, 0.62),
    Offset(0.58, 0.20),
    Offset(0.36, 0.72),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Area hijau muda.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.05, h * 0.10, w * 0.90, h * 0.80),
        Radius.circular(h * 0.40),
      ),
      Paint()..color = AppColors.lightGreen,
    );

    // Jalan.
    final road = Path()
      ..moveTo(-10, h * 0.28)
      ..cubicTo(w * 0.30, h * 0.18, w * 0.22, h * 0.86, w * 0.50, h * 0.62)
      ..cubicTo(w * 0.72, h * 0.44, w * 0.76, h * 0.92, w + 10, h * 0.74);
    canvas.drawPath(
      road,
      Paint()
        ..color = AppColors.path
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round,
    );

    // Pohon kecil.
    final tree = Paint()..color = AppColors.darkGreen;
    for (final t in const [
      Offset(0.14, 0.62),
      Offset(0.40, 0.26),
      Offset(0.64, 0.72),
      Offset(0.90, 0.36),
    ]) {
      final c = Offset(t.dx * w, t.dy * h);
      canvas.drawPath(
        Path()
          ..moveTo(c.dx, c.dy - 10)
          ..lineTo(c.dx + 7, c.dy + 6)
          ..lineTo(c.dx - 7, c.dy + 6)
          ..close(),
        tree,
      );
    }

    // Pin lokasi, satu per data (maksimal sebanyak titik yang tersedia).
    final shown = pins.clamp(0, _spots.length);
    for (var i = 0; i < shown; i++) {
      final c = Offset(_spots[i].dx * w, _spots[i].dy * h);
      final color = AppColors.accentFor(i + 1);
      canvas.drawPath(
        Path()
          ..moveTo(c.dx - 7, c.dy + 8)
          ..lineTo(c.dx + 7, c.dy + 8)
          ..lineTo(c.dx, c.dy + 22)
          ..close(),
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(c, 14, Paint()..color = Colors.white);
      canvas.drawCircle(c, 10, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_MiniMapPainter oldDelegate) => oldDelegate.pins != pins;
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        'Belum ada dokumentasi. Tekan "Tambah" untuk mencatat lokasi pertamamu.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.muted, fontSize: 14),
      ),
    );
  }
}
