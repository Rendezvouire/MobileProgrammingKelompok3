import 'package:flutter/material.dart';

/// Palet warna LocaSnap (gaya peta festival).
class AppColors {
  static const green = Color(0xFF6FC276); // latar utama
  static const lightGreen = Color(0xFFA9DB7A); // area peta
  static const path = Color(0xFFE3EC8A); // jalan di peta
  static const darkGreen = Color(0xFF1E8A5A);
  static const purple = Color(0xFF6B2D90); // warna teks judul / utama
  static const orange = Color(0xFFF7941D); // tombol aksi
  static const yellow = Color(0xFFFFD83B);
  static const blue = Color(0xFF27AAE1);
  static const red = Color(0xFFE9423F);
  static const ink = Color(0xFF3B1A52); // teks gelap
  static const muted = Color(0xFF7A6A86); // teks sekunder
  static const field = Color(0xFFF4F1F7); // latar input

  static const _accents = [blue, red, darkGreen, orange, purple];

  /// Warna aksen per data, supaya tiap lokasi punya warna "stage" sendiri.
  static Color accentFor(int seed) => _accents[seed.abs() % _accents.length];
}
