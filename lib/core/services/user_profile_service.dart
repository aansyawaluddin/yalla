import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yalla/core/models/user_profile_model.dart';

class UserProfileService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<UserProfileModel> fetchUserById(String id, String token) async {
    final url = Uri.parse('$_baseUrl/users/$id');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserProfileModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception(
        'Sesi login telah habis (Error 401). Silakan login ulang.',
      );
    } else {
      throw Exception(
        'Gagal memuat profil pengguna. Status: ${response.statusCode}',
      );
    }
  }

  Future<bool> updateUser({
    required String id,
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('$_baseUrl/users/$id');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception(
        'Sesi login telah habis (Error 401). Silakan login ulang.',
      );
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal memperbarui profil.');
    }
  }

  Future<String?> uploadAvatar({
    required String id,
    required String token,
    required File file,
  }) async {
    final url = Uri.parse('$_baseUrl/users/$id/avatar');

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['avatarUrl'] ?? data['url'] ?? data['data']?['avatarUrl'];
    } else if (response.statusCode == 401) {
      throw Exception(
        'Sesi login telah habis (Error 401). Silakan login ulang.',
      );
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal mengunggah foto.');
    }
  }
}
