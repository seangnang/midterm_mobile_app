import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../employees/controllers/employee_controller.dart';
import '../controllers/dashboard_controller.dart';

class HomeTabView extends GetView<DashboardController> {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadDashboardData,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: Welcome Banner (Blue Gradient with White Text)
                Obx(() {
                  final user = controller.currentUser;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: (user?.image != null && user!.image!.isNotEmpty)
                              ? CircleAvatar(
                                  radius: 26,
                                  backgroundColor: AppColors.primaryContainer,
                                  backgroundImage: NetworkImage(user.image!),
                                )
                              : const CircleAvatar(
                                  radius: 26,
                                  backgroundColor: AppColors.primaryContainer,
                                  child: Icon(Icons.person, color: AppColors.primary, size: 28),
                                ),
                        ),
                        const SizedBox(width: 16),

                        // Greetings
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'WELCOME BACK',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textWhite.withValues(alpha: 0.8),
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user?.fullName ?? 'Administrator',
                                style: AppTextStyles.h2.copyWith(
                                  color: AppColors.textWhite,
                                  fontSize: 20,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Enterprise Management Console',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textWhite.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Logout icon button
                        IconButton(
                          icon: const Icon(Icons.logout_rounded, color: AppColors.textWhite),
                          tooltip: 'Logout',
                          onPressed: () => _confirmLogout(context),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),

                // Metrics / Summary Cards (White cards, Blue icons & numbers)
                const Text('Overview & Metrics', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Total Products Card
                    Expanded(
                      child: Obx(() => _statCard(
                            title: 'Total Products',
                            count: controller.totalProducts.value.toString(),
                            subtitle: 'In catalog & inventory',
                            icon: Icons.inventory_2_rounded,
                            iconColor: AppColors.primary,
                            iconBg: AppColors.primaryContainer,
                            onTap: () => controller.changeTab(1),
                          )),
                    ),
                    const SizedBox(width: 14),

                    // Total Employees Card
                    Expanded(
                      child: Obx(() => _statCard(
                            title: 'Total Employees',
                            count: controller.totalEmployees.value.toString(),
                            subtitle: 'Active staff members',
                            icon: Icons.people_alt_rounded,
                            iconColor: AppColors.primary,
                            iconBg: AppColors.primaryContainer,
                            onTap: () => controller.changeTab(2),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Quick Navigation Actions
                const Text('Quick Actions', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _quickActionTile(
                      icon: Icons.person_add_rounded,
                      label: 'Add Employee',
                      color: AppColors.primary,
                      onTap: () {
                        final empCtrl = Get.find<EmployeeController>();
                        empCtrl.prepareFormForAdd();
                        Get.toNamed(AppRoutes.addEmployee);
                      },
                    ),
                    const SizedBox(width: 12),
                    _quickActionTile(
                      icon: Icons.storefront_rounded,
                      label: 'Products',
                      color: AppColors.primary,
                      onTap: () => controller.changeTab(1),
                    ),
                    const SizedBox(width: 12),
                    _quickActionTile(
                      icon: Icons.badge_rounded,
                      label: 'Staff List',
                      color: AppColors.primary,
                      onTap: () => controller.changeTab(2),
                    ),
                    const SizedBox(width: 12),
                    _quickActionTile(
                      icon: Icons.account_circle_rounded,
                      label: 'Profile',
                      color: AppColors.primary,
                      onTap: () => controller.changeTab(3),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Recent Employees Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Employees', style: AppTextStyles.h3),
                    TextButton(
                      onPressed: () => controller.changeTab(2),
                      child: Text(
                        'View All',
                        style: AppTextStyles.buttonSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Recent Employees List
                Obx(() {
                  if (controller.isLoadingStats.value && controller.recentEmployees.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (controller.recentEmployees.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Center(
                        child: Text(
                          'No recent employee records available.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.recentEmployees.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final employee = controller.recentEmployees[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [AppColors.cardShadow],
                        ),
                        child: Row(
                          children: [
                            // Initials Avatar
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(21),
                              ),
                              child: Center(
                                child: Text(
                                  employee.initials,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Name & Position
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    employee.fullName,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    employee.position,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            // Department Tag
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                employee.department,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String count,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: iconColor, size: 22),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  count,
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickActionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [AppColors.cardShadow],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out', style: AppTextStyles.h3),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
