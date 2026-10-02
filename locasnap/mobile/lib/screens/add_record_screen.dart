import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../services/location_service.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../utils/record_store.dart';
import '../widgets/festival_widgets.dart';
import 'camera_screen.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _locationService = LocationService();

  double? _latitude;
  double? _longitude;
  bool _loadingLocation = false;
  Uint8List? _photoBytes;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    setState(() => _loadingLocation = true);
    try {
      final position = await _locationService.getCurrentLocation().timeout(
        const Duration(seconds: 20),
        onTimeout: () => throw Exception(
          'Lokasi belum didapat. Cek izin lokasi dan GPS, lalu coba lagi.',
        ),
      );
      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  Future<void> _takePhoto() async {
    final bytes = await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(builder: (_) => const CameraScreen()),
    );
    if (bytes == null || !mounted) return;
    setState(() => _photoBytes = bytes);
  }

  Future<void> _save() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final messenger = ScaffoldMessenger.of(context);
    final latitude = _latitude;
    final longitude = _longitude;
    if (latitude == null || longitude == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Ambil lokasi dulu sebelum menyimpan')),
      );
      return;
    }

    final description = _descriptionController.text.trim();

    setState(() => _saving = true);
    try {
      await RecordStore.add(
        title: _titleController.text.trim(),
        description: description.isEmpty ? null : description,
        latitude: latitude,
        longitude: longitude,
        imageBytes: _photoBytes,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }

    if (!mounted) return;
    messenger.showSnackBar(
      const SnackBar(content: Text('Dokumentasi tersimpan')),
    );
    Navigator.pop(context);
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.muted),
      filled: true,
      fillColor: AppColors.field,
      counterText: '',
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.purple, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final latitude = _latitude;
    final longitude = _longitude;
    final hasLocation = latitude != null && longitude != null;
    final photoBytes = _photoBytes;

    return Scaffold(
      appBar: AppBar(title: const FestivalBanner('Dokumentasi Baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            _Section(
              label: 'Judul',
              child: TextFormField(
                controller: _titleController,
                maxLength: 100,
                textCapitalization: TextCapitalization.words,
                decoration: _decoration('Contoh: Gedung Robotika'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul wajib diisi';
                  }
                  return null;
                },
              ),
            ),
            _Section(
              label: 'Deskripsi (opsional)',
              child: TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: _decoration('Ceritakan singkat tentang tempat ini'),
              ),
            ),
            _Section(
              label: 'Lokasi',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.field,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: hasLocation ? AppColors.red : AppColors.muted,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            latitude != null && longitude != null
                                ? formatCoords(latitude, longitude)
                                : 'Lokasi belum diambil',
                            style: TextStyle(
                              color:
                                  hasLocation ? AppColors.ink : AppColors.muted,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FestivalButton(
                    label: _loadingLocation
                        ? 'Mengambil lokasi...'
                        : hasLocation
                            ? 'Ambil ulang lokasi'
                            : 'Ambil lokasi',
                    icon: Icons.my_location,
                    color: AppColors.blue,
                    onPressed: _loadingLocation ? null : _getLocation,
                  ),
                ],
              ),
            ),
            _Section(
              label: 'Foto',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: photoBytes != null
                          ? Image.memory(photoBytes, fit: BoxFit.cover)
                          : Container(
                              color: AppColors.field,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.photo_camera_outlined,
                                    size: 44,
                                    color: AppColors.muted,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Belum ada foto',
                                    style: TextStyle(color: AppColors.muted),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FestivalButton(
                    label: photoBytes != null ? 'Ambil ulang foto' : 'Ambil foto',
                    icon: Icons.photo_camera,
                    color: AppColors.yellow,
                    foreground: AppColors.ink,
                    onPressed: _takePhoto,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            FestivalButton(
              label: _saving ? 'Menyimpan...' : 'Simpan dokumentasi',
              icon: Icons.save,
              color: AppColors.orange,
              onPressed: _saving ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String label;
  final Widget child;

  const _Section({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.purple,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
