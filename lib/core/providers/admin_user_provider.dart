import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/models/user_profile_model.dart';
import 'package:yalla/core/services/admin_user_service.dart';

class AdminUserProvider extends ChangeNotifier {
  final AdminUserService _service = AdminUserService();

  List<UserProfileModel> _allUsers = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';

  String? _activeRole;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String? get activeRole => _activeRole;

  int get totalJamaah => _allUsers.where((u) => u.role == 'jamaah').length;
  int get totalTravel => _allUsers.where((u) => u.role == 'travel').length;

  List<UserProfileModel> get displayedUsers {
    List<UserProfileModel> result = _allUsers;

    if (_activeRole != null) {
      result = result.where((u) => u.role == _activeRole).toList();
    }

    final query = _searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((u) {
        final fullName = '${u.firstName} ${u.lastName}'.toLowerCase();
        return fullName.contains(query) ||
            u.email.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  Future<void> fetchAllUsers() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty)
        throw Exception('Token tidak ditemukan. Silakan login ulang.');

      // Ambil semua user sekaligus (tanpa role filter) agar bisa filter lokal
      _allUsers = await _service.fetchAllUsers(token: token);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setRoleFilter(String? role) {
    _activeRole = role;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  String exportToCsv() {
    final buffer = StringBuffer();
    buffer.writeln(
      'userID,firstName,lastName,email,role,nationality,gender,birth',
    );
    for (final u in displayedUsers) {
      buffer.writeln(
        '${u.userID},${u.firstName},${u.lastName},${u.email},${u.role},${u.nationality},${u.gender},${u.birth}',
      );
    }
    return buffer.toString();
  }
}
