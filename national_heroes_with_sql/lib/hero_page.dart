import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/hero_model.dart';

class HeroPage extends StatefulWidget {
  const HeroPage({super.key});

  @override
  State<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage> {
  List<HeroModel> listHeroes = [];
  bool isLoading = true;

  final String apiUrl = 'http://10.0.2.2:8000/read_heroes.php';

  @override
  void initState() {
    super.initState();
    fetchHeroes();
  }

  Future<void> fetchHeroes() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true) {
          final List listData = data['data'];

          setState(() {
            listHeroes = listData
                .map((e) => HeroModel.fromJson(e))
                .toList();

            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pahlawan Nasional'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : listHeroes.isEmpty
              ? const Center(
                  child: Text('Tidak ada data pahlawan.'),
                )
              : ListView.builder(
                  itemCount: listHeroes.length,
                  itemBuilder: (context, index) {
                    final hero = listHeroes[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          hero.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(hero.subtitle),
                        trailing: Text(
                          hero.origin,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}