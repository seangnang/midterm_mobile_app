import 'package:get/get.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/dashboard/views/dashboard_view.dart';
import '../../features/employees/views/employee_form_view.dart';
import '../../features/employees/views/employee_list_view.dart';
import '../../features/products/views/product_list_view.dart';
import '../../features/profile/views/profile_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.products,
      page: () => const ProductListView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.employees,
      page: () => const EmployeeListView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addEmployee,
      page: () => const EmployeeFormView(isEdit: false),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.editEmployee,
      page: () => const EmployeeFormView(isEdit: true),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      transition: Transition.rightToLeft,
    ),
  ];
}

