import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/models/admin_stats_model.dart';
import 'package:yalla/core/services/admin_stats_service.dart';

class AdminStatsProvider extends ChangeNotifier {
  final AdminStatsService _service = AdminStatsService();

  AdminStatsModel _stats = AdminStatsModel.empty();
  bool _isLoading = false;
  String _errorMessage = '';

  AdminStatsModel get stats => _stats;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchStats() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      _stats = await _service.fetchStats(token);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
