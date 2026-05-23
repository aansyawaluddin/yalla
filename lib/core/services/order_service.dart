import 'dart:convert';
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
}
