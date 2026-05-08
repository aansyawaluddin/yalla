import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/services/package_service.dart';

class PackageProvider extends ChangeNotifier {
  final PackageService _packageService = PackageService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> createPackage(Map<String, dynamic> payload) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) {
        throw Exception("Sesi login tidak ditemukan. Silakan login ulang.");
      }

      final success = await _packageService.createPackage(payload, token);
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
