import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class AuthApiProvider {
  final ApiClient _apiClient;

  AuthApiProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Response> login({required String username, required String password}) async {
    return await _apiClient.post(
      ApiEndpoints.login,
      data: {
        'username': username,
        'password': password,
        'expiresInMins': 60,
      },
    );
  }

  Future<Response> getCurrentUser() async {
    return await _apiClient.get(ApiEndpoints.currentUser);
  }

  Future<Response> refreshToken(String refreshToken) async {
    return await _apiClient.post(
      ApiEndpoints.refreshToken,
      data: {
        'refreshToken': refreshToken,
        'expiresInMins': 60,
      },
    );
  }
}

