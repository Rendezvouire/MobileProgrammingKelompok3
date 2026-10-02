import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../models/location_record.dart';
import '../utils/constants.dart';

/// Error dari server atau koneksi, dengan pesan yang bisa langsung
/// ditampilkan ke pengguna.
class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

/// Penghubung aplikasi ke server LocaSnap (server.js).
///
/// Endpoint yang dipakai:
/// - GET  /locations  -> daftar semua lokasi
/// - POST /locations  -> tambah lokasi (multipart, foto di field `image`)
class ApiService {
  static const _timeout = Duration(seconds: 10);

  Future<List<LocationRecord>> fetchLocations() async {
    final http.Response response;
    try {
      response = await http
          .get(Uri.parse('$apiBaseUrl/locations'))
          .timeout(_timeout);
    } catch (_) {
      throw const ApiException(
        'Tidak bisa terhubung ke server. Pastikan server sudah dijalankan.',
      );
    }

    if (response.statusCode != 200) {
      throw ApiException(_errorMessage(response));
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data is! List) {
      throw const ApiException('Format data dari server tidak sesuai.');
    }

    return data
        .map(
          (item) => LocationRecord.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<void> createLocation({
    required String title,
    String? description,
    required double latitude,
    required double longitude,
    Uint8List? imageBytes,
    String imageName = 'photo.jpg',
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiBaseUrl/locations'),
    );
    request.fields['title'] = title;
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    if (description != null && description.isNotEmpty) {
      request.fields['description'] = description;
    }
    if (imageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes('image', imageBytes, filename: imageName),
      );
    }

    final http.Response response;
    try {
      final streamed = await request.send().timeout(_timeout);
      response = await http.Response.fromStream(streamed);
    } catch (_) {
      throw const ApiException(
        'Tidak bisa terhubung ke server. Pastikan server sudah dijalankan.',
      );
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException(_errorMessage(response));
    }
  }

  /// server.js mengirim error dalam bentuk {"error": "..."}.
  String _errorMessage(http.Response response) {
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is Map && body['error'] != null) {
        return body['error'].toString();
      }
    } catch (_) {
      // Bukan JSON, pakai pesan umum di bawah.
    }
    return 'Server mengembalikan error (${response.statusCode}).';
  }
}
