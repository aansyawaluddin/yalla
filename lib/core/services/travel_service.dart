import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yalla/core/models/travel_detail_model.dart';
import 'package:yalla/core/models/travel_model.dart';
import 'package:yalla/core/models/travel_profile_model.dart'; 

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

  Future<TravelProfileModel> fetchTravelProfileById(
    String id,
    String token,
  ) async {
    final url = Uri.parse('$_baseUrl/travels/$id');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return TravelProfileModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Sesi login telah habis. Silakan login ulang.');
    } else {
      throw Exception('Gagal memuat profil travel (${response.statusCode}).');
    }
  }

  Future<TravelDetailModel> fetchTravelDetail(
    String userId,
    String token,
  ) async {
    final url = Uri.parse('$_baseUrl/travel/$userId/details');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return TravelDetailModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Sesi login telah habis. Silakan login ulang.');
    } else {
      throw Exception('Gagal memuat detail travel (${response.statusCode}).');
    }
  }

  Future<bool> updateTravelDetail({
    required String userId,
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('$_baseUrl/travel/$userId/details');

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
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Gagal memperbarui profil.');
    }
  }
}
