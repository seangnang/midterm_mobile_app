class ApiEndpoints {
  // Base URL - Can be easily modified to point to your backend server
  // Default: DummyJSON real REST API (fully functional with auth, products, users/employees CRUD)
  static String baseUrl = 'https://dummyjson.com';

  // Request Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String currentUser = '/auth/me';

  // Product Endpoints
  static const String products = '/products';
  static const String searchProducts = '/products/search';
  static const String categories = '/products/category-list';
  static String productsByCategory(String category) => '/products/category/$category';
  static String productDetail(dynamic id) => '/products/$id';

  // Employee (Users) Endpoints
  static const String employees = '/users';
  static const String searchEmployees = '/users/search';
  static const String addEmployee = '/users/add';
  static String employeeDetail(dynamic id) => '/users/$id';
  static String updateEmployee(dynamic id) => '/users/$id';
  static String deleteEmployee(dynamic id) => '/users/$id';
}

