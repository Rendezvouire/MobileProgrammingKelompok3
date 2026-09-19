import 'package:flutter/material.dart';

/// Palet warna aplikasi, diambil dari desain Stitch (DESIGN.md + code.html).
/// Dipakai bersama oleh dashboard_screen.dart dan detail_screen.dart.
class AppColors {
  AppColors._();

  // Hijau (Viridian)
  static const primary = Color(0xFF387B66);
  static const primaryDark = Color(0xFF2E6654); // garis bawah AppBar
  static const primaryTint = Color(0xFFDCEDE6); // latar ikon fakta

  // Emas (Sunset)
  static const secondary = Color(0xFFFFCB82);
  static const secondarySoft = Color(0xFFFFDDB2); // subjudul AppBar detail
  static const secondaryDark = Color(0xFF7D5719); // "15 Tokoh Ditampilkan"
  static const onSecondary = Color(0xFF785215); // tahun di kartu, ikon bintang
  static const accent = Color(0x66FDC980); // sudut dekoratif kartu biografi

  // Krem (latar)
  static const canvas = Color(0xFFFAF5EC); // latar halaman
  static const container = Color(0xFFF4EFE6); // tombol / placeholder netral
  static const outline = Color(0xFFEBE1D2); // border kartu

  // Cokelat tua (teks)
  static const bistre = Color(0xFF381E05); // teks utama
  static const bistreMuted = Color(0xFF675038); // teks label
  static const bistreSoft = Color(0xFF605040); // tagline di kartu galeri

  static const shadow = Color(0x0F381E05); // bayangan kartu (bistre 6%)
}

/// Gaya teks aplikasi (satu file dengan warna supaya tetap 3 file).
/// - serif = font berkait untuk judul dan nama tokoh
/// - sans  = font bawaan Flutter untuk isi dan label
/// Tanpa paket tambahan, jadi tidak perlu internet atau Developer Mode.
class AppText {
  AppText._();

  static TextStyle serif(
    double size, {
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.bistre,
    double? height,
  }) =>
      TextStyle(
        fontFamily: 'serif',
        fontFamilyFallback: const ['Georgia', 'Times New Roman', 'serif'],
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );

  static TextStyle sans(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.bistre,
    double? height,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
}