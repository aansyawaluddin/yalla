import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Password salah');
    } else if (response.statusCode == 404) {
      throw Exception('Email tidak ditemukan');
    } else {
      throw Exception('Gagal melakukan login. Silakan coba lagi.');
    }
  }

  Future<bool> register(Map<String, dynamic> payload) async {
    final url = Uri.parse('$_baseUrl/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 400) {
      throw Exception(
        'Data tidak sesuai format (Error 400). Periksa kembali isian Anda.',
      );
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Gagal melakukan pendaftaran.');
    }
  }
}
