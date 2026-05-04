import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yalla/core/models/travel_model.dart';

class TravelService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<List<TravelModel>> fetchAllTravels(String token) async {
    final url = Uri.parse('$_baseUrl/travels');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => TravelModel.fromJson(item)).toList();
    } else if (response.statusCode == 401) {
      throw Exception(
        'Sesi login telah habis (Error 401). Silakan login ulang.',
      );
    } else {
      throw Exception(
        'Gagal memuat daftar travel. Status: ${response.statusCode}',
      );
    }
  }
}
