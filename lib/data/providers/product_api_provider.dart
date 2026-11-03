import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

class ProductApiProvider {
  final ApiClient _apiClient;

  ProductApiProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Response> getProducts({int limit = 20, int skip = 0}) async {
    return await _apiClient.get(
      ApiEndpoints.products,
      queryParameters: {
        'limit': limit,
        'skip': skip,
      },
    );
  }

  Future<Response> searchProducts(String query) async {
    return await _apiClient.get(
      ApiEndpoints.searchProducts,
      queryParameters: {'q': query},
    );
  }

  Future<Response> getCategories() async {
    return await _apiClient.get(ApiEndpoints.categories);
  }

  Future<Response> getProductsByCategory(String category) async {
    return await _apiClient.get(ApiEndpoints.productsByCategory(category));
  }

  Future<Response> getProductById(dynamic id) async {
    return await _apiClient.get(ApiEndpoints.productDetail(id));
  }
}

