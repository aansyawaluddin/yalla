import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Map<String, dynamic>? _userProfile;
  Map<String, dynamic>? get userProfile => _userProfile;

  Future<bool> register(Map<String, dynamic> payload) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final success = await _authService.register(payload);
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final data = await _authService.login(email, password);

      final token = data['userToken'];

      if (token != null && token.toString().isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        _userProfile = data['profile'];

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Token tidak dikembalikan oleh server.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _userProfile = null;
    notifyListeners();
  }
}
