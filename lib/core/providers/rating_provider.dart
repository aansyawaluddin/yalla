import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/models/rating_model.dart';
import 'package:yalla/core/models/rating_stats_model.dart';
import 'package:yalla/core/services/rating_service.dart';

class RatingProvider extends ChangeNotifier {
  final RatingService _service = RatingService();

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<bool> submitRating({
    required String rateeId,
    required int score,
    required String comment,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final raterId = prefs.getString('user_id') ?? '';

      if (token.isEmpty || raterId.isEmpty) {
        throw Exception('Sesi login tidak ditemukan. Silakan login ulang.');
      }

      return await _service.createRating(
        raterId: raterId,
        rateeId: rateeId,
        score: score,
        comment: comment,
        token: token,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  RatingStatsModel _stats = RatingStatsModel.empty();
  bool _isStatsLoading = false;

  RatingStatsModel get stats => _stats;
  bool get isStatsLoading => _isStatsLoading;

  Future<void> fetchStats(String userId) async {
    _isStatsLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      _stats = await _service.fetchRatingStats(userId: userId, token: token);
    } catch (e) {
      _stats = RatingStatsModel.empty();
    } finally {
      _isStatsLoading = false;
      notifyListeners();
    }
  }

  List<RatingModel> _ratings = [];
  bool _isRatingsLoading = false;

  List<RatingModel> get ratings => _ratings;
  bool get isRatingsLoading => _isRatingsLoading;

  Future<void> fetchRatings(String userId) async {
    _isRatingsLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      _ratings = await _service.fetchRatings(userId: userId, token: token);
    } catch (e) {
      _ratings = [];
    } finally {
      _isRatingsLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateRating({
    required String ratingId,
    required int score,
    required String comment,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      if (token.isEmpty) {
        throw Exception('Sesi login tidak ditemukan. Silakan login ulang.');
      }

      final success = await _service.updateRating(
        ratingId: ratingId,
        score: score,
        comment: comment,
        token: token,
      );

      if (success) {
        final idx = _ratings.indexWhere((r) => r.id == ratingId);
        if (idx != -1) {
          _ratings[idx] = RatingModel(
            id: _ratings[idx].id,
            rateeId: _ratings[idx].rateeId,
            raterId: _ratings[idx].raterId,
            raterFullName: _ratings[idx].raterFullName,
            raterAvatarUrl: _ratings[idx].raterAvatarUrl,
            score: score,
            comment: comment,
            createdAt: _ratings[idx].createdAt,
          );
        }
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cek apakah user sudah pernah rating ratee ini
  RatingModel? findMyRating(String myUserId) {
    try {
      return _ratings.firstWhere((r) => r.raterId == myUserId);
    } catch (_) {
      return null;
    }
  }
}
