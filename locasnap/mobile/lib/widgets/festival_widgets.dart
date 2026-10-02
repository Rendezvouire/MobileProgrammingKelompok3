import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// Label judul bergaya papan "FESTIVAL MAP": kotak putih, garis ungu,
/// dengan bayangan kotak di belakangnya.
class FestivalBanner extends StatelessWidget {
  final String text;
  final double fontSize;

  const FestivalBanner(this.text, {super.key, this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.purple, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.purple, offset: Offset(4, 4)),
        ],
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: AppColors.purple,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

/// Tombol datar berwarna dengan bayangan tegas di bawahnya.
class FestivalButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color foreground;
  final VoidCallback? onPressed;

  const FestivalButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.foreground = Colors.white,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: foreground, size: 22),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: foreground,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Deretan segitiga seperti bendera/tenda festival.
class ZigzagPainter extends CustomPainter {
  final Color color;
  final double toothWidth;

  const ZigzagPainter({required this.color, this.toothWidth = 16});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()..moveTo(0, size.height);
    var x = 0.0;
    while (x < size.width) {
      path.lineTo(x + toothWidth / 2, 0);
      path.lineTo(x + toothWidth, size.height);
      x += toothWidth;
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ZigzagPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.toothWidth != toothWidth;
}
