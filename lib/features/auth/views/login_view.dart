import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Title
                  const Text(
                    'Sign In',
                    style: AppTextStyles.h1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in to manage employees & products',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Login Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [AppColors.cardShadow],
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // API Error message banner if any
                          Obx(() {
                            if (controller.errorMessage.value.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColors.errorContainer,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.error.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      controller.errorMessage.value,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          // Username / Email Field
                          CustomTextField(
                            label: 'Username or Email',
                            hint: 'Enter your username or email',
                            controller: controller.usernameController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textSecondary),
                            validator: (val) => Validators.validateRequired(val, 'Username or Email'),
                          ),
                          const SizedBox(height: 18),

                          // Password Field
                          Obx(() => CustomTextField(
                                label: 'Password',
                                hint: 'Enter your password',
                                controller: controller.passwordController,
                                isPassword: true,
                                obscureText: controller.obscurePassword.value,
                                onTogglePassword: controller.togglePasswordVisibility,
                                textInputAction: TextInputAction.done,
                                prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary),
                                validator: Validators.validatePassword,
                              )),
                          const SizedBox(height: 14),

                          // Remember Me Checkbox
                          Row(
                            children: [
                              Obx(() => SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      value: controller.rememberMe.value,
                                      onChanged: controller.toggleRememberMe,
                                      activeColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  )),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => controller.toggleRememberMe(!controller.rememberMe.value),
                                child: Text(
                                  'Remember session',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Login Submit Button
                          Obx(() => CustomButton(
                                text: 'Sign In',
                                icon: Icons.login_rounded,
                                isLoading: controller.isLoading.value,
                                onPressed: controller.login,
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
