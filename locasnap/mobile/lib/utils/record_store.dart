import 'package:flutter/foundation.dart';

import '../models/location_record.dart';
import '../services/api_service.dart';

/// Sumber data untuk semua layar. Isinya diambil dari server lewat
/// [ApiService], lalu layar mendengarkan perubahan di sini.
class RecordStore {
  RecordStore._();

  static final ApiService _api = ApiService();

  static final ValueNotifier<List<LocationRecord>> records =
      ValueNotifier<List<LocationRecord>>(const []);

  /// true selama data sedang diambil dari server.
  static final ValueNotifier<bool> loading = ValueNotifier<bool>(false);

  /// Pesan error terakhir, null kalau pengambilan terakhir berhasil.
  static final ValueNotifier<String?> error = ValueNotifier<String?>(null);

  /// Gabungan ketiga notifier, untuk ListenableBuilder.
  static final Listenable changes = Listenable.merge([records, loading, error]);

  /// Ambil ulang semua lokasi dari server (GET /locations).
  static Future<void> refresh() async {
    loading.value = true;
    try {
      records.value = await _api.fetchLocations();
      error.value = null;
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  /// Simpan lokasi baru ke server (POST /locations), lalu muat ulang daftar.
  /// Melempar [ApiException] kalau gagal.
  static Future<void> add({
    required String title,
    String? description,
    required double latitude,
    required double longitude,
    Uint8List? imageBytes,
  }) async {
    await _api.createLocation(
      title: title,
      description: description,
      latitude: latitude,
      longitude: longitude,
      imageBytes: imageBytes,
    );
    await refresh();
  }

  /// Data terbaru di atas.
  static List<LocationRecord> newestFirst(List<LocationRecord> list) {
    final sorted = List.of(list);
    sorted.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    return sorted;
  }
}
