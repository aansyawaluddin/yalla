import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/models/package_model.dart';
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

  List<PackageModel> _globalPackages = [];
  List<PackageModel> get globalPackages => _globalPackages;

  bool _isGlobalFetching = false;
  bool get isGlobalFetching => _isGlobalFetching;

  Future<void> getAllPackages() async {
    _isGlobalFetching = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isNotEmpty) {
        _globalPackages = await _packageService.fetchAllPackages(token);
      }
    } catch (e) {
      print("Error fetching global packages: $e");
    } finally {
      _isGlobalFetching = false;
      notifyListeners();
    }
  }

  List<PackageModel> _packages = [];
  List<PackageModel> get packages => _packages;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  Future<void> getPackages(String userId) async {
    _isFetching = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) {
        throw Exception("Sesi login tidak ditemukan. Silakan login ulang.");
      }

      // Memanggil fungsi fetch dari service
      _packages = await _packageService.fetchPackages(userId, token);
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }
}
