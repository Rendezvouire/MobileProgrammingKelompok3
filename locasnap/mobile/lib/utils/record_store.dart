import 'package:flutter/foundation.dart';

import '../models/location_record.dart';
import 'dummy_data.dart';

/// Sumber data sementara untuk semua layar.
/// Saat integrasi, isi fungsi di sini diganti dengan panggilan ke
/// api_service.dart (GET /api/locations dan POST /api/locations).
class RecordStore {
  RecordStore._();

  static final ValueNotifier<List<LocationRecord>> records =
      ValueNotifier<List<LocationRecord>>(List.of(dummyRecords));

  static void add({
    required String title,
    String? description,
    required double latitude,
    required double longitude,
    String? imageUrl,
  }) {
    final current = records.value;
    var nextId = 1;
    for (final r in current) {
      if ((r.id ?? 0) >= nextId) nextId = (r.id ?? 0) + 1;
    }
    records.value = [
      ...current,
      LocationRecord(
        id: nextId,
        title: title,
        description: description,
        latitude: latitude,
        longitude: longitude,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      ),
    ];
  }

  /// Data terbaru di atas.
  static List<LocationRecord> newestFirst(List<LocationRecord> list) {
    final sorted = List.of(list);
    sorted.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    return sorted;
  }
}
