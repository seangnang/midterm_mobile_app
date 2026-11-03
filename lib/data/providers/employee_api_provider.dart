import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class EmployeeApiProvider {
  final ApiClient _apiClient;

  EmployeeApiProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Response> getEmployees({int limit = 30, int skip = 0}) async {
    return await _apiClient.get(
      ApiEndpoints.employees,
      queryParameters: {
        'limit': limit,
        'skip': skip,
      },
    );
  }

  Future<Response> searchEmployees(String query) async {
    return await _apiClient.get(
      ApiEndpoints.searchEmployees,
      queryParameters: {'q': query},
    );
  }

  Future<Response> addEmployee(Map<String, dynamic> data) async {
    return await _apiClient.post(
      ApiEndpoints.addEmployee,
      data: data,
    );
  }

  Future<Response> updateEmployee(dynamic id, Map<String, dynamic> data) async {
    return await _apiClient.put(
      ApiEndpoints.updateEmployee(id),
      data: data,
    );
  }

  Future<Response> deleteEmployee(dynamic id) async {
    return await _apiClient.delete(
      ApiEndpoints.deleteEmployee(id),
    );
  }
}

