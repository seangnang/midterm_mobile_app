import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/employee_model.dart';
import '../controllers/employee_controller.dart';
import '../widgets/employee_card.dart';

class EmployeeListView extends GetView<EmployeeController> {
  const EmployeeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Employees Directory'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.refreshEmployees,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.prepareFormForAdd();
          Get.toNamed(AppRoutes.addEmployee);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add Employee', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.searchEmployees,
              decoration: InputDecoration(
                hintText: 'Search by name, position, or department...',
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

          // Main Employee List Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.employees.isEmpty) {
                return const LoadingWidget(message: 'Loading employees directory...');
              }

              if (controller.errorMessage.value.isNotEmpty && controller.employees.isEmpty) {
                return CustomErrorWidget(
                  message: controller.errorMessage.value,
                  onRetry: controller.refreshEmployees,
                );
              }

              if (controller.employees.isEmpty) {
                return EmptyStateWidget(
                  title: 'No Employees Found',
                  message: 'No employee records match your search query.',
                  icon: Icons.people_outline_rounded,
                  actionText: 'Add New Employee',
                  onAction: () {
                    controller.prepareFormForAdd();
                    Get.toNamed(AppRoutes.addEmployee);
                  },
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshEmployees,
                color: AppColors.primary,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 80),
                  itemCount: controller.employees.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final employee = controller.employees[index];
                    return EmployeeCard(
                      employee: employee,
                      onTap: () => _showEmployeeDetails(context, employee),
                      onEdit: () {
                        controller.prepareFormForEdit(employee);
                        Get.toNamed(AppRoutes.editEmployee);
                      },
                      onDelete: () => controller.confirmDeleteEmployee(employee),
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

  void _showEmployeeDetails(BuildContext context, EmployeeModel employee) {
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
              Row(
                children: [
                  if (employee.image.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        employee.image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(employee),
                      ),
                    )
                  else
                    _buildFallbackAvatar(employee),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(employee.fullName, style: AppTextStyles.h2),
                        const SizedBox(height: 4),
                        Text(
                          employee.position,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 16),
              _detailRow(Icons.business_rounded, 'Department', employee.department),
              _detailRow(Icons.email_outlined, 'Email Address', employee.email),
              _detailRow(Icons.phone_outlined, 'Phone Number', employee.phone),
              if (employee.address.isNotEmpty)
                _detailRow(Icons.location_on_outlined, 'Office Location / Address', employee.address),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit'),
                      onPressed: () {
                        Get.back();
                        controller.prepareFormForEdit(employee);
                        Get.toNamed(AppRoutes.editEmployee);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                      onPressed: () {
                        Get.back();
                        controller.confirmDeleteEmployee(employee);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFallbackAvatar(EmployeeModel employee) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          employee.initials,
          style: AppTextStyles.h2.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : 'Not provided',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
