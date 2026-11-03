import '../models/product_model.dart';
import '../providers/product_api_provider.dart';

class ProductRepository {
  final ProductApiProvider _productApiProvider;

  ProductRepository({required ProductApiProvider productApiProvider})
      : _productApiProvider = productApiProvider;

  Future<List<ProductModel>> getProducts({int limit = 30, int skip = 0}) async {
    final response = await _productApiProvider.getProducts(limit: limit, skip: skip);
    return _parseProductList(response.data);
  }

  Future<int> getTotalProductsCount() async {
    try {
      final response = await _productApiProvider.getProducts(limit: 1, skip: 0);
      if (response.data is Map<String, dynamic>) {
        return (response.data['total'] as int?) ?? 0;
      }
    } catch (_) {}
    return 0;
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return getProducts();
    }
    final response = await _productApiProvider.searchProducts(query);
    return _parseProductList(response.data);
  }

  Future<List<String>> getCategories() async {
    final response = await _productApiProvider.getCategories();
    final data = response.data;
    List<String> result = [];

    if (data is List) {
      for (final item in data) {
        if (item is String) {
          result.add(item);
        } else if (item is Map && item['slug'] != null) {
          result.add(item['slug'].toString());
        } else if (item is Map && item['name'] != null) {
          result.add(item['name'].toString());
        }
      }
    }
    return result;
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    if (category.toLowerCase() == 'all') {
      return getProducts();
    }
    final response = await _productApiProvider.getProductsByCategory(category);
    return _parseProductList(response.data);
  }

  Future<ProductModel> getProductById(dynamic id) async {
    final response = await _productApiProvider.getProductById(id);
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }

  List<ProductModel> _parseProductList(dynamic data) {
    if (data is Map<String, dynamic> && data['products'] is List) {
      final list = data['products'] as List;
      return list.map((item) => ProductModel.fromJson(item as Map<String, dynamic>)).toList();
    } else if (data is List) {
      return data.map((item) => ProductModel.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }
}

