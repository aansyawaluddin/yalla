import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yalla/core/models/admin_stats_model.dart';

class AdminStatsService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<AdminStatsModel> fetchStats(String token) async {
    final url = Uri.parse('$_baseUrl/admin/stats');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return AdminStatsModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception(
        'Sesi login telah habis (Error 401). Silakan login ulang.',
      );
    } else {
      throw Exception(
        'Gagal memuat statistik dashboard. Status: ${response.statusCode}',
      );
    }
  }
}
