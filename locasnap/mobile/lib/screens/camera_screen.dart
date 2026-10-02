import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../services/camera_service.dart';
import '../utils/app_colors.dart';

/// Layar kamera. Mengembalikan foto sebagai bytes lewat Navigator.pop,
/// atau null kalau pengguna menekan tombol kembali.
///
/// Di HP memakai [CameraService] buatan Cath (izin kamera, inisialisasi,
/// ambil foto, simpan ke folder sementara). Di Chrome, bagian itu memakai
/// penyimpanan file HP yang tidak ada di browser, jadi kamera dibuka
/// langsung lewat plugin camera.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraService _cameraService = CameraService();

  CameraController? _controller;
  String? _error;
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    setState(() => _error = null);
    try {
      final CameraController? controller;
      if (kIsWeb) {
        final cameras = await availableCameras();
        if (cameras.isEmpty) {
          throw Exception('Kamera tidak ditemukan pada perangkat.');
        }
        controller = CameraController(
          cameras.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await controller.initialize();
      } else {
        await _cameraService.initializeCamera();
        controller = _cameraService.controller;
      }

      if (!mounted) {
        _releaseCamera(controller);
        return;
      }
      setState(() => _controller = controller);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _readable(e));
    }
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || _capturing) return;

    setState(() => _capturing = true);
    try {
      final Uint8List bytes;
      if (kIsWeb) {
        final shot = await controller.takePicture();
        bytes = await shot.readAsBytes();
      } else {
        final file = await _cameraService.takePicture();
        bytes = await file.readAsBytes();
      }
      if (!mounted) return;
      Navigator.pop(context, bytes);
    } catch (e) {
      if (!mounted) return;
      setState(() => _capturing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_readable(e))),
      );
    }
  }

  void _releaseCamera(CameraController? controller) {
    if (kIsWeb) {
      controller?.dispose();
    } else {
      _cameraService.dispose();
    }
  }

  String _readable(Object error) {
    if (error is CameraException) {
      return error.description ?? 'Kamera tidak bisa dibuka (${error.code}).';
    }
    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  void dispose() {
    _releaseCamera(_controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final error = _error;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Ambil Foto',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: error != null
            ? _CameraMessage(message: error, onRetry: _initCamera)
            : controller == null
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.yellow),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Center(child: CameraPreview(controller)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: _ShutterButton(
                          busy: _capturing,
                          onPressed: _capture,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _ShutterButton extends StatelessWidget {
  final bool busy;
  final VoidCallback onPressed;

  const _ShutterButton({required this.busy, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Ambil foto',
      child: GestureDetector(
        onTap: busy ? null : onPressed,
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: AppColors.orange, width: 6),
          ),
          child: busy
              ? const Padding(
                  padding: EdgeInsets.all(18),
                  child: CircularProgressIndicator(
                    color: AppColors.orange,
                    strokeWidth: 3,
                  ),
                )
              : const Icon(
                  Icons.photo_camera,
                  color: AppColors.purple,
                  size: 32,
                ),
        ),
      ),
    );
  }
}

class _CameraMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CameraMessage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.no_photography, color: Colors.white, size: 56),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: onRetry,
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
