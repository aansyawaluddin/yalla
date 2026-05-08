import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
}
