import '../models/employee_model.dart';
import '../providers/employee_api_provider.dart';

class EmployeeRepository {
  final EmployeeApiProvider _employeeApiProvider;

  EmployeeRepository({required EmployeeApiProvider employeeApiProvider})
      : _employeeApiProvider = employeeApiProvider;

  Future<List<EmployeeModel>> getEmployees({int limit = 30, int skip = 0}) async {
    final response = await _employeeApiProvider.getEmployees(limit: limit, skip: skip);
    return _parseEmployeeList(response.data);
  }

  Future<int> getTotalEmployeesCount() async {
    try {
      final response = await _employeeApiProvider.getEmployees(limit: 1, skip: 0);
      if (response.data is Map<String, dynamic>) {
        return (response.data['total'] as int?) ?? 0;
      }
    } catch (_) {}
    return 0;
  }

  Future<List<EmployeeModel>> searchEmployees(String query) async {
    if (query.trim().isEmpty) {
      return getEmployees();
    }
    final response = await _employeeApiProvider.searchEmployees(query);
    return _parseEmployeeList(response.data);
  }

  Future<EmployeeModel> addEmployee(EmployeeModel employee) async {
    final response = await _employeeApiProvider.addEmployee(employee.toJson());
    return EmployeeModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<EmployeeModel> updateEmployee(EmployeeModel employee) async {
    final response = await _employeeApiProvider.updateEmployee(
      employee.id,
      employee.toJson(),
    );
    return EmployeeModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<bool> deleteEmployee(dynamic id) async {
    final response = await _employeeApiProvider.deleteEmployee(id);
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    }
    return false;
  }

  List<EmployeeModel> _parseEmployeeList(dynamic data) {
    if (data is Map<String, dynamic> && data['users'] is List) {
      final list = data['users'] as List;
      return list.map((item) => EmployeeModel.fromJson(item as Map<String, dynamic>)).toList();
    } else if (data is List) {
      return data.map((item) => EmployeeModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }
}

