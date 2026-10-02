import 'package:flutter/material.dart';

import '../models/location_record.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'festival_widgets.dart';

/// Foto sebuah record. Kalau server belum diatur, foto kosong, atau gagal
/// dimuat, yang tampil adalah placeholder berwarna.
class RecordPhoto extends StatelessWidget {
  final LocationRecord record;
  final double? width;
  final double? height;
  final double radius;

  const RecordPhoto({
    super.key,
    required this.record,
    this.width,
    this.height,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentFor(record.id ?? 0);
    final placeholder = PhotoPlaceholder(color: accent);
    final url = record.imageUrl;

    Widget child = placeholder;
    if (apiBaseUrl.isNotEmpty && url != null && url.isNotEmpty) {
      child = Image.network(
        '$apiBaseUrl$url',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}

class PhotoPlaceholder extends StatelessWidget {
  final Color color;
  final IconData icon;

  const PhotoPlaceholder({
    super.key,
    required this.color,
    this.icon = Icons.photo_camera_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final small = constraints.maxHeight < 110;
        return Container(
          color: color,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: small ? 10 : 18,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: ZigzagPainter(
                      color: AppColors.yellow,
                      toothWidth: small ? 12 : 22,
                    ),
                  ),
                ),
              ),
              Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: small ? 26 : 44,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
