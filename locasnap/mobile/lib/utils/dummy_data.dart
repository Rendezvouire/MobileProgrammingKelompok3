import '../models/location_record.dart';

/// Sama dengan 5 baris di tabel `locations`, dipakai selama API belum siap.
final List<LocationRecord> dummyRecords = [
  LocationRecord(
    id: 1,
    title: 'Gedung Robotika',
    description: 'Dokumentasi Gedung Robotika ITS',
    latitude: -7.27562,
    longitude: 112.7956,
    imageUrl: '/uploads/gedung_robotika.jpg',
    createdAt: DateTime(2026, 10, 2, 19, 57),
  ),
  LocationRecord(
    id: 2,
    title: 'Perpustakaan ITS',
    description: 'Dokumentasi area perpustakaan',
    latitude: -7.2791,
    longitude: 112.7895,
    imageUrl: '/uploads/perpustakaan.jpg',
    createdAt: DateTime(2026, 10, 2, 19, 57),
  ),
  LocationRecord(
    id: 3,
    title: 'Departemen Teknik Komputer',
    description: 'Dokumentasi Departemen Teknik Komputer ITS',
    latitude: -7.2812,
    longitude: 112.7951,
    imageUrl: '/uploads/tekom.jpg',
    createdAt: DateTime(2026, 10, 2, 19, 57),
  ),
  LocationRecord(
    id: 4,
    title: 'Tower 2 ITS',
    description: 'Dokumentasi Gedung Tower 2 ITS',
    latitude: -7.28562,
    longitude: 112.7756,
    imageUrl: '/uploads/tower_2.jpg',
    createdAt: DateTime(2026, 10, 2, 20, 22),
  ),
  LocationRecord(
    id: 5,
    title: 'Departemen Teknik Elektro',
    description: 'Dokumentasi Departemen Teknik Elektro ITS',
    latitude: -7.2891,
    longitude: 112.7795,
    imageUrl: '/uploads/tektro.jpg',
    createdAt: DateTime(2026, 10, 2, 20, 22),
  ),
];
