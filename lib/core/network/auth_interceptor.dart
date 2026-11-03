import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../storage/token_storage.dart';
import 'api_endpoints.dart';
import '../../app/routes/app_routes.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  bool _isRefreshing = false;

  AuthInterceptor({required TokenStorage tokenStorage, required Dio dio})
      : _tokenStorage = tokenStorage,
        _dio = dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final isAuthEndpoint = err.requestOptions.path.contains(ApiEndpoints.login) ||
        err.requestOptions.path.contains(ApiEndpoints.refreshToken);

    if (statusCode == 401 && !isAuthEndpoint) {
      final refreshToken = _tokenStorage.getRefreshToken();

      if (refreshToken != null && !_isRefreshing) {
        _isRefreshing = true;
        try {
          // Attempt token refresh
          final response = await _dio.post(
            '${ApiEndpoints.baseUrl}${ApiEndpoints.refreshToken}',
            data: {'refreshToken': refreshToken, 'expiresInMins': 60},
            options: Options(headers: {'Authorization': ''}),
          );

          if (response.statusCode == 200 && response.data != null) {
            final newAccessToken = response.data['token'] ?? response.data['accessToken'];
            final newRefreshToken = response.data['refreshToken'] ?? refreshToken;

            if (newAccessToken != null) {
              await _tokenStorage.saveTokens(
                accessToken: newAccessToken.toString(),
                refreshToken: newRefreshToken?.toString(),
              );

              // Retry original request with new token
              final opts = Options(
                method: err.requestOptions.method,
                headers: Map<String, dynamic>.from(err.requestOptions.headers)
                  ..['Authorization'] = 'Bearer $newAccessToken',
              );

              final cloneReq = await _dio.request(
                err.requestOptions.path,
                options: opts,
                data: err.requestOptions.data,
                queryParameters: err.requestOptions.queryParameters,
              );
              _isRefreshing = false;
              return handler.resolve(cloneReq);
            }
          }
        } catch (_) {
          // Refresh failed
        } finally {
          _isRefreshing = false;
        }
      }

      // If refresh failed or not available, clear storage and redirect
      await _tokenStorage.clearAuthData();
      getx.Get.offAllNamed(AppRoutes.login);
      getx.Get.snackbar(
        'Session Expired',
        'Your session has expired. Please log in again.',
        snackPosition: getx.SnackPosition.BOTTOM,
      );
    }

    return handler.next(err);
  }
}

