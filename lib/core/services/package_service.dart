import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yalla/core/models/package_model.dart';

class PackageService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<bool> createPackage(Map<String, dynamic> payload, String token) async {
    final url = Uri.parse('$_baseUrl/packages');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Gagal membuat paket baru.');
    }
  }

  Future<List<PackageModel>> fetchAllPackages(String token) async {
    final url = Uri.parse('$_baseUrl/packages');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PackageModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesi login telah habis. Silakan login ulang.');
    } else {
      throw Exception('Gagal memuat daftar penawaran paket.');
    }
  }

  Future<List<PackageModel>> fetchPackages(String userId, String token) async {
    final url = Uri.parse('$_baseUrl/travels/$userId/packages');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PackageModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesi login telah habis. Silakan login ulang.');
    } else {
      throw Exception('Gagal memuat daftar paket.');
    }
  }

  Future<PackageModel> fetchPackageById(String id, String token) async {
    final url = Uri.parse('$_baseUrl/packages/$id');

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return PackageModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Sesi login telah habis. Silakan login ulang.');
    } else {
      throw Exception('Gagal memuat detail paket.');
    }
  }
}
