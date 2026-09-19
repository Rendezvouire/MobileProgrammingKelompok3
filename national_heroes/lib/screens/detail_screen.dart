import 'package:flutter/material.dart';
import '../models/hero_model.dart';

class DetailScreen extends StatelessWidget {
  final HeroModel hero;

  const DetailScreen({
    super.key,
    required this.hero,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7FA),
      appBar: AppBar(
        title: const Text(
          'Detail Pahlawan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFE51B7A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 320,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Image.asset(
                hero.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFFFFF0F6),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 70,
                        color: Color(0xFFE51B7A),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hero.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25232A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoSection(
                    icon: Icons.location_on,
                    title: 'Daerah Asal',
                    content: hero.origin,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    icon: Icons.calendar_month,
                    title: 'Masa Hidup',
                    content: hero.birthDeath,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Biografi Singkat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25232A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hero.biography,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF77717A),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFE51B7A),
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF77717A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF25232A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}