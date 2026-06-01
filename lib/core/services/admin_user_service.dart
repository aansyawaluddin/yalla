import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:yalla/core/models/user_profile_model.dart';

class AdminUserService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<List<UserProfileModel>> fetchAllUsers({
    required String token,
    String? role,
  }) async {
    final queryParams = <String, String>{};
    if (role != null && role.isNotEmpty) {
      queryParams['role'] = role;
    }

    final uri = Uri.parse(
      '$_baseUrl/users',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((json) => UserProfileModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      throw Exception(
        'Sesi login telah habis (Error 401). Silakan login ulang.',
      );
    } else if (response.statusCode == 403) {
      throw Exception('Akses ditolak. Hanya admin yang dapat melihat data ini.');
    } else {
      throw Exception(
        'Gagal memuat data pengguna. Status: ${response.statusCode}',
      );
    }
  }
}