import 'dart:io';

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;

  /// 1. Menangani Permission Camera
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return false;
  }

  /// 2. Integrasi Camera Flutter (Inisialisasi Controller)
  Future<void> initializeCamera() async {
    final hasPermission = await requestCameraPermission();
    if (!hasPermission) {
      throw Exception('Izin kamera tidak diberikan.');
    }

    _cameras = await availableCameras();
    if (_cameras.isEmpty) {
      throw Exception('Kamera tidak ditemukan pada perangkat.');
    }

    // Menggunakan kamera belakang secara default
    _controller = CameraController(
      _cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    _isInitialized = true;
  }

  /// 3. Mengambil Foto & 4. Menyimpan Temporary Image
  Future<File> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Kamera belum siap.');
    }

    if (_controller!.value.isTakingPicture) {
      throw Exception('Prosedur pengambilan gambar sedang berlangsung.');
    }

    // Ambil gambar ke XFile
    final XFile imageXFile = await _controller!.takePicture();

    // Pastikan path/format file benar dan disimpan di Temporary Directory
    final Directory tempDir = await getTemporaryDirectory();
    final String fileName = 'SNAP_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String targetPath = path.join(tempDir.path, fileName);

    // Simpan/salin file ke direktori temp
    final File savedImage = await File(imageXFile.path).copy(targetPath);
    return savedImage;
  }

  /// 5. Mengirim Image ke API
  Future<bool> uploadImage(
    String apiUrl,
    File imageFile,
    Map<String, String> extraData,
  ) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Tambahkan header atau field data jika diperlukan
      request.fields.addAll(extraData);

      // Lampirkan file gambar
      final multipartFile = await http.MultipartFile.fromPath(
        'image', // sesuaikan key field gambar dengan endpoint backend API
        imageFile.path,
      );
      request.files.add(multipartFile);

      final response = await request.send();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error uploading image: $e');
      return false;
    }
  }

  /// Cleanup resource kamera ketika widget di-dispose
  void dispose() {
    _controller?.dispose();
    _isInitialized = false;
  }
}
