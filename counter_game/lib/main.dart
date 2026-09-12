import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CounterGameApp());
}

class CounterGameApp extends StatelessWidget {
  const CounterGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Score Counter',

      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),

      home: const HomeScreen(),
    );
  }
}
