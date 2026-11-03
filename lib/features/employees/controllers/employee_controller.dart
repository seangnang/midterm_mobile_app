import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/app_exceptions.dart';
import '../../../data/models/employee_model.dart';
import '../../../data/repositories/employee_repository.dart';

class EmployeeController extends GetxController {
  final EmployeeRepository _employeeRepository;

  EmployeeController({required EmployeeRepository employeeRepository})
      : _employeeRepository = employeeRepository;

  // Reactive State
  final employees = <EmployeeModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;

  // Search
  final searchController = TextEditingController();

  // Form Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final positionController = TextEditingController();
  final departmentController = TextEditingController();
  final addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  EmployeeModel? editingEmployee;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  @override
  void onClose() {
    searchController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    positionController.dispose();
    departmentController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> fetchEmployees() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _employeeRepository.getEmployees(limit: 50);
      employees.assignAll(result);
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Failed to load employees. Please check your network.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchEmployees(String query) async {
    if (query.trim().isEmpty) {
      fetchEmployees();
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _employeeRepository.searchEmployees(query.trim());
      employees.assignAll(result);
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (_) {
      errorMessage.value = 'Search failed. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    fetchEmployees();
  }

  Future<void> refreshEmployees() async {
    await fetchEmployees();
  }

  // Pre-fill form when editing
  void prepareFormForEdit(EmployeeModel employee) {
    editingEmployee = employee;
    firstNameController.text = employee.firstName;
    lastNameController.text = employee.lastName;
    emailController.text = employee.email;
    phoneController.text = employee.phone;
    positionController.text = employee.position;
    departmentController.text = employee.department;
    addressController.text = employee.address;
  }

  // Clear form when adding fresh
  void prepareFormForAdd() {
    editingEmployee = null;
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    positionController.clear();
    departmentController.clear();
    addressController.clear();
  }

  // Submit Add or Edit
  Future<void> submitEmployeeForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    isSubmitting.value = true;

    try {
      if (editingEmployee == null) {
        // Create (POST)
        final newEmployee = EmployeeModel(
          id: 0,
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          position: positionController.text.trim(),
          department: departmentController.text.trim(),
          address: addressController.text.trim(),
        );

        final created = await _employeeRepository.addEmployee(newEmployee);

        // Prepend created employee to list
        employees.insert(0, created);

        Get.back(); // Return to employee list
        Get.snackbar(
          'Employee Added',
          '${created.fullName} was successfully created.',
          backgroundColor: AppColors.successContainer,
          colorText: AppColors.success,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
        );
      } else {
        // Update (PUT)
        final updatedData = editingEmployee!.copyWith(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          position: positionController.text.trim(),
          department: departmentController.text.trim(),
          address: addressController.text.trim(),
        );

        final updated = await _employeeRepository.updateEmployee(updatedData);

        // Update item in reactive list
        final index = employees.indexWhere((e) => e.id == updatedData.id);
        if (index != -1) {
          employees[index] = updated;
        }

        Get.back(); // Return to employee list
        Get.snackbar(
          'Employee Updated',
          '${updated.fullName} was successfully updated.',
          backgroundColor: AppColors.successContainer,
          colorText: AppColors.success,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
        );
      }
    } on AppException catch (e) {
      Get.snackbar(
        'Submission Failed',
        e.message,
        backgroundColor: AppColors.errorContainer,
        colorText: AppColors.error,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: AppColors.error),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save employee information.',
        backgroundColor: AppColors.errorContainer,
        colorText: AppColors.error,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Delete Confirmation and API call
  void confirmDeleteEmployee(EmployeeModel employee) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Delete Employee', style: AppTextStyles.h3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to delete the employee record for:',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                employee.fullName,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This action will send a DELETE request to the API and remove this employee.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close dialog
              await _executeDeleteEmployee(employee);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textWhite,
              minimumSize: const Size(100, 42),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _executeDeleteEmployee(EmployeeModel employee) async {
    try {
      final success = await _employeeRepository.deleteEmployee(employee.id);
      if (success) {
        employees.removeWhere((e) => e.id == employee.id);
        Get.snackbar(
          'Deleted Successfully',
          'Employee "${employee.fullName}" was removed.',
          backgroundColor: AppColors.successContainer,
          colorText: AppColors.success,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
        );
      } else {
        throw AppException('Could not delete employee record.');
      }
    } on AppException catch (e) {
      Get.snackbar(
        'Delete Failed',
        e.message,
        backgroundColor: AppColors.errorContainer,
        colorText: AppColors.error,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (_) {
      Get.snackbar(
        'Error',
        'An error occurred while deleting the employee.',
        backgroundColor: AppColors.errorContainer,
        colorText: AppColors.error,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}

