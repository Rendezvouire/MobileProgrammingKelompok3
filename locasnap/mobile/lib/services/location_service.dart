import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Mengecek apakah layanan GPS/lokasi pada perangkat aktif.
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Meminta izin akses lokasi dari pengguna.
  Future<LocationPermission> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  /// Mengambil lokasi GPS perangkat saat ini.
  ///
  /// Mengembalikan objek [Position] yang berisi:
  /// - latitude
  /// - longitude
  /// - accuracy
  /// - altitude
  /// - speed
  /// dan informasi lokasi lainnya.
  Future<Position> getCurrentLocation() async {
    // Cek apakah GPS/lokasi perangkat aktif
    final serviceEnabled = await isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception(
        'GPS/lokasi tidak aktif. Silakan aktifkan GPS pada perangkat.',
      );
    }

    // Cek permission lokasi
    LocationPermission permission = await Geolocator.checkPermission();

    // Jika permission belum diberikan, minta permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Jika permission ditolak
    if (permission == LocationPermission.denied) {
      throw Exception(
        'Izin lokasi ditolak oleh pengguna.',
      );
    }

    // Jika permission ditolak secara permanen
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Izin lokasi ditolak secara permanen. '
        'Silakan aktifkan izin lokasi melalui Settings.',
      );
    }

    // Mengambil posisi GPS saat ini
    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    return position;
  }

  /// Mengambil latitude saat ini.
  Future<double> getLatitude() async {
    final Position position = await getCurrentLocation();
    return position.latitude;
  }

  /// Mengambil longitude saat ini.
  Future<double> getLongitude() async {
    final Position position = await getCurrentLocation();
    return position.longitude;
  }

  /// Mengambil latitude dan longitude sekaligus.
  Future<Map<String, double>> getCoordinates() async {
    final Position position = await getCurrentLocation();

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }
}