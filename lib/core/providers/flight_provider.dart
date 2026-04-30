import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/services/flight_service.dart';
import 'package:yalla/core/models/flight_model.dart';

class FlightProvider extends ChangeNotifier {
  final FlightService _flightService = FlightService();

  List<FlightModel> _flights = [];
  List<FlightModel> get flights => _flights;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchFlights() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception("Sesi habis, silakan login ulang.");
      }

      final data = await _flightService.getFlights(token);

      _flights = data;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      _isLoading = false;
      notifyListeners();
    }
  }

  FlightModel? _selectedFlight;
  FlightModel? get selectedFlight => _selectedFlight;

  bool _isDetailLoading = false;
  bool get isDetailLoading => _isDetailLoading;

  String _detailErrorMessage = '';
  String get detailErrorMessage => _detailErrorMessage;

  Future<void> fetchFlightDetail(String id) async {
    _isDetailLoading = true;
    _detailErrorMessage = '';
    _selectedFlight = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception("Sesi habis, silakan login ulang.");
      }

      final data = await _flightService.getFlightById(id, token);

      _selectedFlight = data;
      _isDetailLoading = false;
      notifyListeners();
    } catch (e) {
      _detailErrorMessage = e.toString().replaceAll("Exception: ", "");
      _isDetailLoading = false;
      notifyListeners();
    }
  }
}
