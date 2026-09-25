import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../services/api_service.dart';
import 'add_hero_screen.dart';
import 'edit_hero_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<HeroModel> heroes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadHeroes();
  }

  // READ
  Future<void> loadHeroes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final result = await ApiService.getHeroes();
      if (!mounted) return;
      setState(() => heroes = result);
    } catch (e) {
      if (!mounted) return;
      setState(() => errorMessage = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // CREATE
  Future<void> openAdd() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddHeroScreen()),
    );
    if (saved == true) loadHeroes();
  }

  // UPDATE
  Future<void> openEdit(HeroModel hero) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditHeroScreen(hero: hero)),
    );
    if (saved == true) loadHeroes();
  }

  // DELETE
  Future<void> confirmDelete(HeroModel hero) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus pahlawan?'),
        content: Text('Data "${hero.name}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ApiService.deleteHero(hero.id);
      if (!mounted) return;
      setState(() => heroes.removeWhere((h) => h.id == hero.id));
      messenger.showSnackBar(SnackBar(content: Text('${hero.name} berhasil dihapus')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Pahlawan'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: loadHeroes),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAdd,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pahlawan'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: loadHeroes, child: const Text('Coba lagi')),
          ],
        ),
      );
    }
    if (heroes.isEmpty) {
      return const Center(child: Text('Belum ada data pahlawan.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 90),
      itemCount: heroes.length,
      itemBuilder: (context, index) {
        final hero = heroes[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: Image.asset(
              hero.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 50),
            ),
            title: Text(hero.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(hero.origin),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () => openEdit(hero),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => confirmDelete(hero),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}