import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/employee_controller.dart';

class EmployeeFormView extends GetView<EmployeeController> {
  final bool isEdit;

  const EmployeeFormView({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    final title = isEdit ? 'Edit Employee' : 'Add New Employee';
    final buttonText = isEdit ? 'Save Changes' : 'Create Employee';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Form Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [AppColors.cardShadow],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Details',
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: 16),

                        // First Name & Last Name
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'First Name *',
                                hint: 'e.g. John',
                                controller: controller.firstNameController,
                                textInputAction: TextInputAction.next,
                                prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                                validator: (val) => Validators.validateRequired(val, 'First name'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                label: 'Last Name *',
                                hint: 'e.g. Doe',
                                controller: controller.lastNameController,
                                textInputAction: TextInputAction.next,
                                validator: (val) => Validators.validateRequired(val, 'Last name'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Email
                        CustomTextField(
                          label: 'Email Address *',
                          hint: 'e.g. john.doe@company.com',
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                          validator: Validators.validateStrictEmail,
                        ),
                        const SizedBox(height: 16),

                        // Phone
                        CustomTextField(
                          label: 'Phone Number *',
                          hint: 'e.g. +1 555-0199',
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                          validator: Validators.validatePhone,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Job & Department Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [AppColors.cardShadow],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Employment Information',
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: 16),

                        // Position / Title
                        CustomTextField(
                          label: 'Position / Role *',
                          hint: 'e.g. Senior Software Engineer',
                          controller: controller.positionController,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.textSecondary),
                          validator: (val) => Validators.validateRequired(val, 'Position'),
                        ),
                        const SizedBox(height: 16),

                        // Department
                        CustomTextField(
                          label: 'Department *',
                          hint: 'e.g. Engineering, Marketing, Sales',
                          controller: controller.departmentController,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.corporate_fare_outlined, color: AppColors.textSecondary),
                          validator: (val) => Validators.validateRequired(val, 'Department'),
                        ),
                        const SizedBox(height: 16),

                        // Office / Address
                        CustomTextField(
                          label: 'Address / Location',
                          hint: 'e.g. 123 Tech Park, San Jose, CA',
                          controller: controller.addressController,
                          textInputAction: TextInputAction.done,
                          prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  Obx(() => CustomButton(
                        text: buttonText,
                        icon: isEdit ? Icons.save_rounded : Icons.check_circle_outline_rounded,
                        isLoading: controller.isSubmitting.value,
                        onPressed: controller.submitEmployeeForm,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

