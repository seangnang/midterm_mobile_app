import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class TokenStorage {
  static const String _keyAccessToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyUserData = 'auth_user_data';
  static const String _keyRememberMe = 'auth_remember_me';

  final GetStorage _storage;

  TokenStorage({GetStorage? storage}) : _storage = storage ?? GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  // Save tokens
  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    await _storage.write(_keyAccessToken, accessToken);
    if (refreshToken != null) {
      await _storage.write(_keyRefreshToken, refreshToken);
    }
  }

  // Get Access Token
  String? getAccessToken() {
    return _storage.read<String>(_keyAccessToken);
  }

  // Get Refresh Token
  String? getRefreshToken() {
    return _storage.read<String>(_keyRefreshToken);
  }

  // Save User profile data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(_keyUserData, jsonEncode(userData));
  }

  // Get User profile data
  Map<String, dynamic>? getUserData() {
    final raw = _storage.read<String>(_keyUserData);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // Remember Me flag
  Future<void> saveRememberMe(bool remember) async {
    await _storage.write(_keyRememberMe, remember);
  }

  bool getRememberMe() {
    return _storage.read<bool>(_keyRememberMe) ?? false;
  }

  // Authentication status
  bool hasToken() {
    final token = getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Clear session on logout
  Future<void> clearAuthData() async {
    final remember = getRememberMe();
    await _storage.remove(_keyAccessToken);
    await _storage.remove(_keyRefreshToken);
    await _storage.remove(_keyUserData);
    if (!remember) {
      await _storage.remove(_keyRememberMe);
    }
  }
}

