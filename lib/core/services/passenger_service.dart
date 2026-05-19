import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yalla/core/models/flight_passenger_response_model.dart';

class PassengerService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<FlightPassengerResponseModel> fetchFlightPassengers({
    required String flightId,
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/flights/$flightId/passengers');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        return FlightPassengerResponseModel.fromJson(jsonBody);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal mengambil data penumpang.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan pada server: $e');
    }
  }
}
