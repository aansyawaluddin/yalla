import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/models/flight_passenger_response_model.dart';
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

  Future<bool> updateFlightData(String id, Map<String, dynamic> payload) async {
    _isDetailLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception("Sesi habis, silakan login ulang.");
      }

      final isSuccess = await _flightService.updateFlight(id, payload, token);

      if (isSuccess) {
        await fetchFlightDetail(id);
        await fetchFlights();
        return true;
      }
      return false;
    } catch (e) {
      _detailErrorMessage = e.toString().replaceAll("Exception: ", "");
      _isDetailLoading = false;
      notifyListeners();
      return false;
    }
  }

  FlightModel? get nearestFlight {
    if (_flights.isEmpty) return null;

    final now = DateTime.now();

    final upcomingFlights = _flights.where((flight) {
      if (flight.departureTime == null) return false;
      try {
        final depDate = DateTime.parse(flight.departureTime!);
        return depDate.isAfter(now);
      } catch (e) {
        return false;
      }
    }).toList();

    if (upcomingFlights.isEmpty) return null;

    upcomingFlights.sort((a, b) {
      final dateA = DateTime.parse(a.departureTime!);
      final dateB = DateTime.parse(b.departureTime!);
      return dateA.compareTo(dateB);
    });

    return upcomingFlights.first;
  }

  FlightPassengerResponseModel? _passengerData;
  FlightPassengerResponseModel? get passengerData => _passengerData;

  bool _isPassengerLoading = false;
  bool get isPassengerLoading => _isPassengerLoading;

  String _passengerErrorMessage = '';
  String get passengerErrorMessage => _passengerErrorMessage;

  // Fungsi untuk Fetch Passengers
  Future<void> fetchFlightPassengers(String flightId) async {
    _isPassengerLoading = true;
    _passengerErrorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception("Sesi habis, silakan login ulang.");
      }

      final data = await _flightService.getFlightPassengers(flightId, token);

      _passengerData = data;
      _isPassengerLoading = false;
      notifyListeners();
    } catch (e) {
      _passengerErrorMessage = e.toString().replaceAll("Exception: ", "");
      _isPassengerLoading = false;
      notifyListeners();
    }
  }

  Future<int> getPassengerCountFromDetail(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null || token.isEmpty) return 0;

      // Memanggil fungsi service yang sudah kamu buat sebelumnya
      final data = await _flightService.getFlightPassengers(id, token);
      return data.passengersCount;
    } catch (e) {
      print("Error mengambil jumlah penumpang: $e");
      return 0;
    }
  }
}
