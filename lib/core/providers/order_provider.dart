import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/services/order_service.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _gatewayUrl = '';
  String get gatewayUrl => _gatewayUrl;

  String _lastOrderId = '';
  String get lastOrderId => _lastOrderId;

  Future<bool> processCheckoutAndPayment(Map<String, dynamic> payload) async {
    _isLoading = true;
    _errorMessage = '';
    _gatewayUrl = '';
    _lastOrderId = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) {
        throw Exception("Sesi login tidak ditemukan. Silakan login ulang.");
      }

      final orderResponse = await _orderService.createOrder(payload, token);
      _lastOrderId = orderResponse['id'] ?? '';

      final paymentResponse = await _orderService.initiatePayment(
        _lastOrderId,
        token,
      );
      _gatewayUrl = paymentResponse['gateway_url'];

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> checkOrderStatus(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final orderData = await _orderService.fetchOrderById(orderId, token);
      return orderData['status'] ?? 'waiting_payment';
    } catch (e) {
      print("Error polling status: $e");
      return 'waiting_payment';
    }
  }

  List<dynamic> _orders = [];
  List<dynamic> get orders => _orders;

  List<dynamic> get activeOrders => _orders
      .where(
        (o) => o['status'] == 'waiting_payment' || o['status'] == 'on_process',
      )
      .toList();

  List<dynamic> get historyOrders =>
      _orders.where((o) => o['status'] == 'approved').toList();

  void setLastOrderId(String id) {
    _lastOrderId = id;
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) throw Exception("Silakan login terlebih dahulu.");

      _orders = await _orderService.fetchOrders(token);
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
