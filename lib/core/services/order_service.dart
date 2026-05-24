import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yalla/core/models/order_model.dart';

class OrderService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<Map<String, dynamic>> createOrder(
    Map<String, dynamic> payload,
    String token,
  ) async {
    final url = Uri.parse('$_baseUrl/orders');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("RESPONSE BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
        error['message'] ?? error['error'] ?? 'Gagal membuat pesanan tiket.',
      );
    }
  }

  Future<Map<String, dynamic>> initiatePayment(
    String orderId,
    String token,
  ) async {
    final url = Uri.parse('$_baseUrl/orders/$orderId/payment');

    final response = await http.post(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal memuat link pembayaran.');
    }
  }

  Future<OrderModel> fetchOrderById(String orderId, String token) async {
    final url = Uri.parse('$_baseUrl/orders/$orderId');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return OrderModel.fromJson(json);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal memeriksa status pesanan.');
    }
  }

  Future<List<OrderModel>> fetchOrders(String token) async {
    final url = Uri.parse('$_baseUrl/orders');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal mengambil data pesanan.');
    }
  }

  Future<void> approveOrder(String orderId, String token) async {
    final url = Uri.parse('$_baseUrl/orders/$orderId/approve');

    final response = await http.post(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal menyetujui pesanan.');
    }
  }

  Future<void> uploadManifest(String orderId, File file, String token) async {
    final url = Uri.parse('$_baseUrl/orders/$orderId/manifest');

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    print('MANIFEST STATUS: ${response.statusCode}');
    print('MANIFEST BODY: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal mengunggah manifest.');
      } catch (_) {
        throw Exception('Gagal mengunggah manifest. (${response.statusCode})');
      }
    }
  }

  Future<void> finishOrder(String orderId, String token) async {
    final url = Uri.parse('$_baseUrl/orders/$orderId/finish');
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal menyelesaikan pesanan.');
      } catch (_) {
        throw Exception(
          'Gagal menyelesaikan pesanan. (${response.statusCode})',
        );
      }
    }
  }

  Future<void> deleteManifest(String orderId, String token) async {
    final url = Uri.parse('$_baseUrl/orders/$orderId/manifest');
    final response = await http.delete(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal menghapus manifest.');
      } catch (_) {
        throw Exception('Gagal menghapus manifest. (${response.statusCode})');
      }
    }
  }

  Future<Uint8List> downloadManifest(String orderId, String token) async {
    final url = Uri.parse('$_baseUrl/orders/$orderId/manifest/download');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/pdf'},
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal mengunduh manifest.');
      } catch (_) {
        throw Exception('Gagal mengunduh manifest. (${response.statusCode})');
      }
    }
  }
}
