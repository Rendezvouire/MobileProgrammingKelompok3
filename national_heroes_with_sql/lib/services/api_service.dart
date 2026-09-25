import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../models/hero_model.dart';

class ApiService {
  /// true  = pakai assets/national_heroes.json (sementara, tanpa server)
  /// false = pakai API PHP Luby -> MySQL (versi final)
  static const bool useLocalJson = false;

  static const String baseUrl = 'http://10.29.39.213:8000';
  static const _headers = {'Content-Type': 'application/json'};

  // Penyimpanan sementara di memori (hanya dipakai saat useLocalJson = true)
  static List<HeroModel>? _local;

  static Future<List<HeroModel>> _loadLocal() async {
    if (_local != null) return _local!;
    final raw = await rootBundle.loadString('assets/national_heroes.json');
    final list = jsonDecode(raw)['data'] as List;
    _local = list.map((e) => HeroModel.fromJson(Map<String, dynamic>.from(e))).toList();
    return _local!;
  }

  // READ
  static Future<List<HeroModel>> getHeroes() async {
    if (useLocalJson) return List.of(await _loadLocal());
    final data = await _send(() => http.get(Uri.parse('$baseUrl/read_heroes.php')));
    final list = data['data'] as List? ?? [];
    return list.map((e) => HeroModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  // CREATE
  static Future<void> createHero(HeroModel hero) async {
    if (useLocalJson) {
      final list = await _loadLocal();
      final newId = list.isEmpty
          ? 1
          : list.map((h) => int.tryParse(h.id) ?? 0).reduce((a, b) => a > b ? a : b) + 1;
      list.add(HeroModel.fromJson({...hero.toJson(), 'id': '$newId'}));
      return;
    }
    await _send(() => http.post(Uri.parse('$baseUrl/create_hero.php'),
        headers: _headers, body: jsonEncode(hero.toJson())));
  }

  // UPDATE
  static Future<void> updateHero(HeroModel hero) async {
    if (useLocalJson) {
      final list = await _loadLocal();
      final i = list.indexWhere((h) => h.id == hero.id);
      if (i == -1) throw Exception('Pahlawan tidak ditemukan');
      list[i] = hero;
      return;
    }
    await _send(() => http.post(Uri.parse('$baseUrl/update_hero.php'),
        headers: _headers, body: jsonEncode(hero.toJson())));
  }

  // DELETE
  static Future<void> deleteHero(String id) async {
    if (useLocalJson) {
      (await _loadLocal()).removeWhere((h) => h.id == id);
      return;
    }
    await _send(() => http.post(Uri.parse('$baseUrl/delete_hero.php'),
        headers: _headers, body: jsonEncode({'id': id})));
  }

  static Future<Map<String, dynamic>> _send(Future<http.Response> Function() request) async {
    http.Response res;
    try {
      res = await request().timeout(const Duration(seconds: 10));
    } catch (_) {
      throw Exception('Tidak dapat terhubung ke server. Pastikan server PHP Luby berjalan.');
    }
    final Map<String, dynamic> body;
    try {
      body = Map<String, dynamic>.from(jsonDecode(res.body));
    } catch (_) {
      throw Exception('Respons server tidak valid (HTTP ${res.statusCode}).');
    }
    if (body['status'] != true) {
      throw Exception(body['message']?.toString() ?? 'Terjadi kesalahan.');
    }
    return body;
  }
}
