import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yalla/core/models/rating_model.dart';
import 'package:yalla/core/models/rating_stats_model.dart';

class RatingService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<bool> createRating({
    required String raterId,
    required String rateeId,
    required int score,
    required String comment,
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/ratings');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "rater_id": raterId,
        "ratee_id": rateeId,
        "score": score,
        "comment": comment,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception('Sesi login telah habis. Silakan login ulang.');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal mengirim ulasan.');
    }
  }

  Future<RatingStatsModel> fetchRatingStats({
    required String userId,
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/users/$userId/ratings/stats');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return RatingStatsModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Sesi login telah habis. Silakan login ulang.');
    } else {
      throw Exception(
        'Gagal memuat statistik ulasan. Status: ${response.statusCode}',
      );
    }
  }

  Future<List<RatingModel>> fetchRatings({
    required String userId,
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/users/$userId/ratings');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => RatingModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Sesi login telah habis. Silakan login ulang.');
    } else {
      throw Exception('Gagal memuat ulasan. Status: ${response.statusCode}');
    }
  }
}
