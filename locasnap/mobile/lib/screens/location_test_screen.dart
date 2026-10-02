import 'package:flutter/material.dart';
import '../services/location_service.dart';

class LocationTestScreen extends StatefulWidget {
  const LocationTestScreen({super.key});

  @override
  State<LocationTestScreen> createState() => _LocationTestScreenState();
}

class _LocationTestScreenState extends State<LocationTestScreen> {
  final LocationService _locationService = LocationService();

  double? latitude;
  double? longitude;

  String message = 'Tekan tombol untuk mengambil lokasi';

  Future<void> getLocation() async {
    try {
      setState(() {
        message = 'Mengambil lokasi...';
      });

      final position = await _locationService.getCurrentLocation();

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        message = 'Lokasi berhasil ditemukan';
      });
    } catch (e) {
      setState(() {
        message = 'Gagal mendapatkan lokasi: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test GPS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),

            const SizedBox(height: 20),

            Text(
              'Latitude: ${latitude ?? "-"}',
            ),

            Text(
              'Longitude: ${longitude ?? "-"}',
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: getLocation,
              child: const Text('Ambil Lokasi'),
            ),
          ],
        ),
      ),
    );
  }
}