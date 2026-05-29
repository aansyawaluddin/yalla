import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla/core/models/user_profile_model.dart';
import 'package:yalla/core/services/user_profile_service.dart';

class UserProfileProvider extends ChangeNotifier {
  final UserProfileService _service = UserProfileService();

  UserProfileModel _profile = UserProfileModel.empty();
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isUploadingAvatar = false;
  String _errorMessage = '';
  String? _avatarUrl;

  UserProfileModel get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isUploadingAvatar => _isUploadingAvatar;
  String get errorMessage => _errorMessage;
  String? get avatarUrl => _avatarUrl;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final userId = prefs.getString('user_id') ?? '';

      if (userId.isEmpty) throw Exception('User ID tidak ditemukan.');

      _profile = await _service.fetchUserById(userId, token);
      _avatarUrl = _profile.avatarUrl;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
    required String nationality,
    required String gender,
  }) async {
    _isSaving = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final userId = prefs.getString('user_id') ?? '';

      if (userId.isEmpty) throw Exception('User ID tidak ditemukan.');

      final body = {
        "email": email,
        "profile": {
          "firstName": firstName,
          "lastName": lastName,
          "nationality": nationality,
          "gender": gender,
        },
      };

      final success = await _service.updateUser(
        id: userId,
        token: token,
        body: body,
      );

      if (success) {
        // Update local state
        _profile = UserProfileModel(
          userID: _profile.userID,
          email: email,
          role: _profile.role,
          avatarUrl: _profile.avatarUrl,
          firstName: firstName,
          lastName: lastName,
          birth: _profile.birth,
          gender: gender,
          nationality: nationality,
        );
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> uploadAvatar(File file) async {
    _isUploadingAvatar = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final userId = prefs.getString('user_id') ?? '';

      if (userId.isEmpty) throw Exception('User ID tidak ditemukan.');

      final newUrl = await _service.uploadAvatar(
        id: userId,
        token: token,
        file: file,
      );

      if (newUrl != null) {
        _avatarUrl = newUrl;
        _profile = UserProfileModel(
          userID: _profile.userID,
          email: _profile.email,
          role: _profile.role,
          avatarUrl: newUrl,
          firstName: _profile.firstName,
          lastName: _profile.lastName,
          birth: _profile.birth,
          gender: _profile.gender,
          nationality: _profile.nationality,
        );
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isUploadingAvatar = false;
      notifyListeners();
    }
  }
}
