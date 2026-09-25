import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import 'add_hero_screen.dart';

/// Halaman EDIT pahlawan (memakai form yang sama dengan tambah)
class EditHeroScreen extends StatelessWidget {
  final HeroModel hero;
  const EditHeroScreen({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return HeroFormScreen(hero: hero);
  }
}