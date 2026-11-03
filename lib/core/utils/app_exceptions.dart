import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  AppException(this.message, {this.statusCode, this.details});

  @override
  String toString() => message;

  factory AppException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(
          'Connection timeout. Please check your internet connection.',
          statusCode: 408,
        );

      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode;
        final data = dioError.response?.data;
        String errorMessage = 'Something went wrong. Please try again.';

        if (data is Map<String, dynamic>) {
          if (data['message'] != null && data['message'].toString().isNotEmpty) {
            errorMessage = data['message'].toString();
          } else if (data['error'] != null && data['error'].toString().isNotEmpty) {
            errorMessage = data['error'].toString();
          } else if (data['detail'] != null && data['detail'].toString().isNotEmpty) {
            errorMessage = data['detail'].toString();
          }
        } else if (data is String && data.isNotEmpty) {
          errorMessage = data;
        }

        switch (statusCode) {
          case 400:
            return AppException(errorMessage.isNotEmpty ? errorMessage : 'Invalid request.', statusCode: 400);
          case 401:
            return AppException('Session expired or unauthorized. Please log in again.', statusCode: 401);
          case 403:
            return AppException('Access forbidden. You do not have permission for this action.', statusCode: 403);
          case 404:
            return AppException('Resource not found.', statusCode: 404);
          case 422:
            return AppException(errorMessage.isNotEmpty ? errorMessage : 'Validation error occurred.', statusCode: 422);
          case 500:
          case 502:
          case 503:
            return AppException('Server error. Please try again later.', statusCode: statusCode);
          default:
            return AppException(errorMessage, statusCode: statusCode);
        }

      case DioExceptionType.cancel:
        return AppException('Request was cancelled.', statusCode: 499);

      case DioExceptionType.connectionError:
        return AppException(
          'Unable to reach server. Please check your network connection or server status.',
          statusCode: 503,
        );

      case DioExceptionType.unknown:
      default:
        return AppException(
          dioError.message ?? 'An unexpected network error occurred.',
          statusCode: 500,
        );
    }
  }
}

