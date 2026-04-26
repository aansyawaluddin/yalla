import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/services/auth_service.dart';
import 'package:yalla/core/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  UserModel? _userData;
  UserModel? get userData => _userData;

  String _firstName = '';
  String get firstName => _firstName;

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
      final role = data['role'] ?? 'jamaah';
      final userId = data['userID'];

      if (token != null && token.toString().isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('auth_token', token);
        await prefs.setString('user_role', role);
        if (userId != null) {
          await prefs.setString('user_id', userId);
        }

        _userData = UserModel.fromJson(data);

        if (_userData?.profile?.firstName != null) {
          _firstName = _userData!.profile!.firstName!;
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Token tidak ditemukan dalam respons server.';
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

  Future<void> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getString('user_id');

    if (token == null || userId == null) return;
    if (_firstName.isNotEmpty) return;

    try {
      final fetchedUser = await _authService.getUserProfile(userId, token);

      _userData = fetchedUser;

      if (_userData?.profile?.firstName != null) {
        _firstName = _userData!.profile!.firstName!;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<String?> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final role = prefs.getString('user_role');

    if (token != null && token.isNotEmpty) {
      return role ?? 'jamaah';
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.remove('user_id');

    _userData = null;
    _firstName = '';

    notifyListeners();
  }
}
