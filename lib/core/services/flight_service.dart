import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yalla/core/models/flight_model.dart';

class FlightService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<bool> uploadFlightExcel(String filePath, String token) async {
    final url = Uri.parse('$_baseUrl/upload-flights');

    try {
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var multipartFile = await http.MultipartFile.fromPath('file', filePath);
      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final responseData = await response.stream.bytesToString();
        print("Gagal upload: ${response.statusCode} - $responseData");
        return false;
      }
    } catch (e) {
      print("Error koneksi saat upload file: $e");
      throw Exception('Terjadi kesalahan jaringan saat mengunggah file.');
    }
  }

  Future<List<FlightModel>> getFlights(String token) async {
    final url = Uri.parse('$_baseUrl/flights');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => FlightModel.fromJson(json)).toList();
      } else {
        throw Exception(
          'Gagal mengambil daftar penerbangan. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error koneksi saat mengambil data flights: $e");
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  Future<FlightModel> getFlightById(String id, String token) async {
    final url = Uri.parse('$_baseUrl/flights/$id');

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return FlightModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Gagal mengambil detail penerbangan. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Error koneksi saat mengambil detail flight: $e");
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}
