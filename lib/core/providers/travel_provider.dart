import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:yalla/core/models/travel_model.dart';
import 'package:yalla/core/services/travel_service.dart';

class TravelProvider extends ChangeNotifier {
  final TravelService _travelService = TravelService();

  List<TravelModel> _travels = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<TravelModel> get travels => _travels;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchTravels() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      _travels = await _travelService.fetchAllTravels(token);
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
