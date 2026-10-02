import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../utils/record_store.dart';
import '../widgets/festival_widgets.dart';
import '../widgets/record_photo.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  double? _latitude;
  double? _longitude;
  bool _hasPhoto = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _getLocation() {
    // TODO(Taya): ganti dengan LocationService.getCurrentLocation().
    setState(() {
      _latitude = -7.28190;
      _longitude = 112.79530;
    });
  }

  void _takePhoto() {
    // TODO(Cath): ganti dengan CameraService.takePicture() dan tampilkan
    // hasilnya lewat widget image_preview.dart.
    setState(() => _hasPhoto = true);
  }

  void _save() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final latitude = _latitude;
    final longitude = _longitude;
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ambil lokasi dulu sebelum menyimpan')),
      );
      return;
    }

    final description = _descriptionController.text.trim();

    // TODO(Tika): ganti dengan ApiService (POST /api/locations, multipart).
    RecordStore.add(
      title: _titleController.text.trim(),
      description: description.isEmpty ? null : description,
      latitude: latitude,
      longitude: longitude,
    );

    ScaffoldMessenger.of(context).showSnackBar(
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
                    label: hasLocation ? 'Ambil ulang lokasi' : 'Ambil lokasi',
                    icon: Icons.my_location,
                    color: AppColors.blue,
                    onPressed: _getLocation,
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
                      child: _hasPhoto
                          ? const PhotoPlaceholder(
                              color: AppColors.darkGreen,
                              icon: Icons.check_circle_outline,
                            )
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
                    label: _hasPhoto ? 'Ambil ulang foto' : 'Ambil foto',
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
              label: 'Simpan dokumentasi',
              icon: Icons.save,
              color: AppColors.orange,
              onPressed: _save,
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
