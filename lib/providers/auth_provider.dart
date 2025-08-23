import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _accessToken;
  bool _isLoading = false;

  User? get user => _user;
  String? get accessToken => _accessToken;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _accessToken != null;

  final ApiService _apiService = ApiService();

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');

    if (_accessToken != null) {
      await _loadUserInfo();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _apiService.login(username, password);
      if (result != null) {
        _accessToken = result['accessToken'];
        await _loadUserInfo();
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Login error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> _loadUserInfo() async {
    try {
      final userData = await _apiService.getCurrentUser();
      if (userData != null) {
        _user = User.fromJson(userData);
      }
    } catch (e) {
      print('Load user info error: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');

    _user = null;
    _accessToken = null;
    notifyListeners();
  }
}