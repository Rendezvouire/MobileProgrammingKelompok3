import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../services/api_service.dart';

/// Halaman TAMBAH pahlawan
class AddHeroScreen extends StatelessWidget {
  const AddHeroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HeroFormScreen();
  }
}

/// Form untuk TAMBAH (hero == null) dan EDIT (hero != null)
class HeroFormScreen extends StatefulWidget {
  final HeroModel? hero;
  const HeroFormScreen({super.key, this.hero});

  @override
  State<HeroFormScreen> createState() => _HeroFormScreenState();
}

class _HeroFormScreenState extends State<HeroFormScreen> {
  static const images = [
    'assets/images/ahmad_yani.jpg',
    'assets/images/bung_tomo.jpg',
    'assets/images/cut_nyak_dien.jpg',
    'assets/images/cut_nyak_meutia.jpg',
    'assets/images/diponegoro.jpg',
    'assets/images/dr_sutomo.jpg',
    'assets/images/imam_bonjol.jpg',
    'assets/images/kartini.jpg',
    'assets/images/ki_hajar.jpg',
    'assets/images/martha_tiahahu.jpg',
    'assets/images/ngurah_rai.jpg',
    'assets/images/otto_iskandardinata.jpg',
    'assets/images/pattimura.jpg',
    'assets/images/sudirman.jpg',
    'assets/images/sultan_hasannudin.jpg',
  ];

  final formKey = GlobalKey<FormState>();
  late final TextEditingController name;
  late final TextEditingController fullName;
  late final TextEditingController subtitle;
  late final TextEditingController origin;
  late final TextEditingController birthDeath;
  late final TextEditingController biography;
  String imagePath = '';
  bool isSaving = false;

  bool get isEdit => widget.hero != null;

  @override
  void initState() {
    super.initState();
    final h = widget.hero;
    name = TextEditingController(text: h?.name ?? '');
    fullName = TextEditingController(text: h?.fullName ?? '');
    subtitle = TextEditingController(text: h?.subtitle ?? '');
    origin = TextEditingController(text: h?.origin ?? '');
    birthDeath = TextEditingController(text: h?.birthDeath ?? '');
    biography = TextEditingController(text: h?.biography ?? '');
    imagePath = h?.image ?? '';
  }

  @override
  void dispose() {
    name.dispose();
    fullName.dispose();
    subtitle.dispose();
    origin.dispose();
    birthDeath.dispose();
    biography.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(12),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: images
            .map((img) => InkWell(
                  onTap: () => Navigator.pop(context, img),
                  child: Image.asset(img, fit: BoxFit.cover),
                ))
            .toList(),
      ),
    );
    if (selected != null) setState(() => imagePath = selected);
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;

    final hero = HeroModel(
      id: widget.hero?.id ?? '',
      name: name.text.trim(),
      fullName: fullName.text.trim(),
      subtitle: subtitle.text.trim(),
      image: imagePath,
      origin: origin.text.trim(),
      birthDeath: birthDeath.text.trim(),
      biography: biography.text.trim(),
    );

    setState(() => isSaving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (isEdit) {
        await ApiService.updateHero(hero);
      } else {
        await ApiService.createHero(hero);
      }
      messenger.showSnackBar(SnackBar(
        content: Text(isEdit ? 'Data berhasil diperbarui' : 'Pahlawan berhasil ditambahkan'),
      ));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      messenger.showSnackBar(SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  Widget field(TextEditingController c, String label, {bool required = false, int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        minLines: lines,
        maxLines: lines == 1 ? 1 : 10,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          border: const OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Pahlawan' : 'Tambah Pahlawan'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: GestureDetector(
                onTap: pickImage,
                child: Image.asset(
                  imagePath,
                  width: 120,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 120,
                    height: 150,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.add_a_photo, size: 40),
                  ),
                ),
              ),
            ),
            TextButton(onPressed: pickImage, child: const Text('Pilih foto')),
            field(name, 'Nama', required: true),
            field(fullName, 'Nama lengkap', required: true),
            field(subtitle, 'Julukan / peran'),
            field(origin, 'Asal daerah'),
            field(birthDeath, 'Masa hidup (mis. 1783 – 1817)'),
            field(biography, 'Biografi', lines: 5),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: isSaving ? null : save,
              child: Text(isSaving ? 'Menyimpan...' : (isEdit ? 'Perbarui' : 'Simpan')),
            ),
          ],
        ),
      ),
    );
  }
}