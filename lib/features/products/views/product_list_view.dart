import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/product_model.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';

class ProductListView extends GetView<ProductController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Products Catalog'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.refreshProducts,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products by title or brand...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller.searchController,
                  builder: (context, value, _) {
                    if (value.text.isNotEmpty) {
                      return IconButton(
                        icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary, size: 20),
                        onPressed: controller.clearSearch,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Categories Filter Horizontal List
          Obx(() {
            if (controller.categories.isEmpty) {
              return const SizedBox.shrink();
            }
            return SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = controller.categories[index];
                  final isSelected = controller.selectedCategory.value.toLowerCase() == cat.toLowerCase();

                  return ChoiceChip(
                    label: Text(
                      cat.capitalizeFirst ?? cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => controller.selectCategory(cat),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 6),

          // Main Product List Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const LoadingWidget(message: 'Loading products...');
              }

              if (controller.errorMessage.value.isNotEmpty && controller.products.isEmpty) {
                return CustomErrorWidget(
                  message: controller.errorMessage.value,
                  onRetry: controller.refreshProducts,
                );
              }

              if (controller.products.isEmpty) {
                return EmptyStateWidget(
                  title: 'No Products Found',
                  message: 'We could not find any products matching your search or category filter.',
                  icon: Icons.inventory_2_outlined,
                  actionText: 'Reset Filters',
                  onAction: () {
                    controller.selectedCategory.value = 'All';
                    controller.clearSearch();
                  },
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshProducts,
                color: AppColors.primary,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.products.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () => _showProductDetails(context, product),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(BuildContext context, ProductModel product) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (product.displayImage.isNotEmpty)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      product.displayImage,
                      height: 180,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.inventory_2_outlined, size: 80, color: AppColors.textTertiary),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.title,
                      style: AppTextStyles.h2,
                    ),
                  ),
                  Text(
                    product.formattedPrice,
                    style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (product.brand.isNotEmpty) ...[
                    Text(
                      'Brand: ${product.brand}',
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Description', style: AppTextStyles.h3),
              const SizedBox(height: 6),
              Text(
                product.description,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
