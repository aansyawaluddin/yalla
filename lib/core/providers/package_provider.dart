import 'dart:core';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/models/package_model.dart';
import 'package:yalla/core/models/facility_model.dart';
import 'package:yalla/core/models/package_passenger_model.dart';
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

      _packages = await _packageService.fetchPackages(userId, token);
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  PackageModel? _selectedPackage;
  PackageModel? get selectedPackage => _selectedPackage;

  bool _isDetailFetching = false;
  bool get isDetailFetching => _isDetailFetching;

  Future<void> getPackageById(String id) async {
    _isDetailFetching = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isNotEmpty) {
        _selectedPackage = await _packageService.fetchPackageById(id, token);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isDetailFetching = false;
      notifyListeners();
    }
  }

  List<FacilityModel> _facilities = [];
  List<FacilityModel> get facilities => _facilities;

  bool _isFacilitiesLoading = false;
  bool get isFacilitiesLoading => _isFacilitiesLoading;

  Future<void> getFacilities() async {
    _isFacilitiesLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      _facilities = await _packageService.fetchFacilities(token);
    } catch (e) {
      print("Error fetching facilities: $e");
    } finally {
      _isFacilitiesLoading = false;
      notifyListeners();
    }
  }

  List<PackagePassengerModel> _passengers = [];
  bool _isFetchingPassengers = false;
  String _passengersError = '';

  List<PackagePassengerModel> get passengers => _passengers;
  bool get isFetchingPassengers => _isFetchingPassengers;
  String get passengersError => _passengersError;

  Future<void> fetchPackagePassengers(String packageId) async {
    _isFetchingPassengers = true;
    _passengersError = '';
    _passengers = [];
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      _passengers = await _packageService.fetchPackagePassengers(
        packageId,
        token,
      );
    } catch (e) {
      _passengersError = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isFetchingPassengers = false;
      notifyListeners();
    }
  }

  Map<String, int> _jamaahCounts = {};
  Map<String, int> get jamaahCounts => _jamaahCounts;

  Future<void> fetchAllJamaahCounts(List<String> packageIds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      for (final id in packageIds) {
        if (id.isEmpty) continue;
        try {
          final passengers = await _packageService.fetchPackagePassengers(
            id,
            token,
          );
          _jamaahCounts[id] = passengers.length;
        } catch (_) {
          _jamaahCounts[id] = 0;
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> updatePackage(
    String packageId,
    Map<String, dynamic> payload,
  ) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) {
        throw Exception("Sesi login tidak ditemukan. Silakan login ulang.");
      }

      return await _packageService.updatePackage(packageId, payload, token);
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
