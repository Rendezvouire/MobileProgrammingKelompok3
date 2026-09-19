import 'package:flutter/material.dart';
import '../data/hero_data.dart';
import '../models/hero_model.dart';
import '../widgets/hero_card.dart';
import '../widgets/search_bar.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<HeroModel> _filteredHeroes = [];

  @override
  void initState() {
    super.initState();
    _filteredHeroes = heroes;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredHeroes = heroes
          .where((hero) =>
              hero.name.toLowerCase().contains(query.toLowerCase()) ||
              hero.origin.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pahlawan Nasional'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: HeroSearchBar(
              onChanged: _onSearchChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Total: ${_filteredHeroes.length} Pahlawan',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: _filteredHeroes.isEmpty
                ? const Center(
                    child: Text('Pahlawan tidak ditemukan'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredHeroes.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final hero = _filteredHeroes[index];
                      return HeroCard(
                        hero: hero,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(hero: hero),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}