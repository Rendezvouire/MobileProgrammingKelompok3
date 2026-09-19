import 'package:flutter/material.dart';


class AppColors {
  AppColors._();

  // Hijau (Viridian)
  static const primary = Color(0xFF387B66);
  static const primaryDark = Color(0xFF2E6654); 
  static const primaryTint = Color(0xFFDCEDE6); 

  // Emas (Sunset)
  static const secondary = Color(0xFFFFCB82);
  static const secondarySoft = Color(0xFFFFDDB2); 
  static const secondaryDark = Color(0xFF7D5719); 
  static const onSecondary = Color(0xFF785215); 
  static const accent = Color(0x66FDC980); 

  // Krem (latar)
  static const canvas = Color(0xFFFAF5EC); 
  static const container = Color(0xFFF4EFE6); 
  static const outline = Color(0xFFEBE1D2); 

  // Cokelat tua (teks)
  static const bistre = Color(0xFF381E05); 
  static const bistreMuted = Color(0xFF675038); 
  static const bistreSoft = Color(0xFF605040); 

  static const shadow = Color(0x0F381E05); 
}

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