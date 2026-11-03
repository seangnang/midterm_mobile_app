import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/app_exceptions.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../shared/constants/app_constants.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  // Form Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Reactive State
  final obscurePassword = true.obs;
  final rememberMe = true.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    // Default demo credentials for quick and easy testing
    usernameController.text = AppConstants.demoUsername;
    passwordController.text = AppConstants.demoPassword;
    _loadCurrentUser();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> _loadCurrentUser() async {
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      currentUser.value = user;
    }
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Dismiss keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final user = await _authRepository.login(
        username: usernameController.text.trim(),
        password: passwordController.text,
        rememberMe: rememberMe.value,
      );

      currentUser.value = user;

      Get.offAllNamed(AppRoutes.dashboard);

      Get.snackbar(
        'Welcome Back!',
        'Successfully signed in as ${user.fullName}',
        backgroundColor: AppColors.successContainer,
        colorText: AppColors.success,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle_outline, color: AppColors.success),
        duration: const Duration(seconds: 3),
      );
    } on AppException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar(
        'Login Failed',
        e.message,
        backgroundColor: AppColors.errorContainer,
        colorText: AppColors.error,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.error_outline, color: AppColors.error),
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: AppColors.errorContainer,
        colorText: AppColors.error,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
    Get.snackbar(
      'Signed Out',
      'You have been logged out successfully.',
      backgroundColor: AppColors.infoContainer,
      colorText: AppColors.info,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  bool get isAuthenticated => _authRepository.isLoggedIn();
}

