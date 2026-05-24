import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/models/order_model.dart';
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

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  List<OrderModel> get activeOrders => _orders
      .where((o) => o.status == 'waiting_payment' || o.status == 'on_process')
      .toList();

  List<OrderModel> get historyOrders =>
      _orders.where((o) => o.status == 'approved').toList();

  void setLastOrderId(String id) {
    _lastOrderId = id;
    notifyListeners();
  }

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
      _gatewayUrl = paymentResponse['gateway_url'] ?? '';

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

      final OrderModel orderData = await _orderService.fetchOrderById(
        orderId,
        token,
      );
      return orderData.status;
    } catch (e) {
      print("Error polling status: $e");
      return 'waiting_payment';
    }
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

  Future<void> approveOrder(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) throw Exception("Sesi login tidak ditemukan.");

      await _orderService.approveOrder(orderId, token);
      await fetchOrders();
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> uploadManifest(String orderId, File file) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) throw Exception("Sesi login tidak ditemukan.");

      await _orderService.uploadManifest(orderId, file, token);
      await fetchOrders();
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> finishOrder(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) throw Exception("Sesi login tidak ditemukan.");

      await _orderService.finishOrder(orderId, token);
      await fetchOrders();
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> deleteManifest(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) throw Exception("Sesi login tidak ditemukan.");

      await _orderService.deleteManifest(orderId, token);
      await fetchOrders();
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<Uint8List> downloadManifest(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) throw Exception("Sesi login tidak ditemukan.");

      return await _orderService.downloadManifest(orderId, token);
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
