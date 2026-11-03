import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_exceptions.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class ProductController extends GetxController {
  final ProductRepository _productRepository;

  ProductController({required ProductRepository productRepository})
      : _productRepository = productRepository;

  // State Observables
  final products = <ProductModel>[].obs;
  final categories = <String>['All'].obs;
  final selectedCategory = 'All'.obs;
  final isLoading = false.obs;
  final isCategoriesLoading = false.obs;
  final errorMessage = ''.obs;

  // Search & Filter
  final searchController = TextEditingController();
  final isGrid = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleViewLayout() {
    isGrid.value = !isGrid.value;
  }

  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      final fetched = await _productRepository.getCategories();
      categories.assignAll(['All', ...fetched]);
    } catch (_) {
      // Keep 'All' category fallback
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      List<ProductModel> result;
      if (selectedCategory.value != 'All') {
        result = await _productRepository.getProductsByCategory(selectedCategory.value);
      } else if (searchController.text.trim().isNotEmpty) {
        result = await _productRepository.searchProducts(searchController.text.trim());
      } else {
        result = await _productRepository.getProducts(limit: 50);
      }

      products.assignAll(result);
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to load products. Please check connection.';
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    if (selectedCategory.value == category) return;
    selectedCategory.value = category;
    searchController.clear();
    fetchProducts();
  }

  void onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      selectedCategory.value = 'All';
      fetchProducts();
      return;
    }
    // Search with query
    searchProducts(query);
  }

  Future<void> searchProducts(String query) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      selectedCategory.value = 'All';
      final result = await _productRepository.searchProducts(query.trim());
      products.assignAll(result);
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Failed searching products.';
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    fetchProducts();
  }

  Future<void> refreshProducts() async {
    await fetchCategories();
    await fetchProducts();
  }
}

