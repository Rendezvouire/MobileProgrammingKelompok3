import 'package:flutter/foundation.dart' show kIsWeb;

/// Alamat server Node.js (folder locasnap/server, port 3000).
///
/// - Chrome / web      : http://localhost:3000
/// - Emulator Android  : http://10.0.2.2:3000 (alamat laptop dari dalam emulator)
/// - HP asli           : ganti dengan IP laptop, contoh 'http://192.168.1.10:3000'
const String apiBaseUrl =
    kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
