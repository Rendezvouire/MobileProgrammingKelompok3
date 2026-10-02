import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const LocaSnapApp());
}

class LocaSnapApp extends StatelessWidget {
  const LocaSnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocaSnap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.purple,
          primary: AppColors.purple,
          secondary: AppColors.orange,
        ),
        scaffoldBackgroundColor: AppColors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.purple,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.purple,
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
