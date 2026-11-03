import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/token_storage.dart';
import '../../data/providers/auth_api_provider.dart';
import '../../data/providers/employee_api_provider.dart';
import '../../data/providers/product_api_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/employee_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/dashboard/controllers/dashboard_controller.dart';
import '../../features/employees/controllers/employee_controller.dart';
import '../../features/products/controllers/product_controller.dart';
import '../../features/profile/controllers/profile_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Core Storage & Networking
    final tokenStorage = TokenStorage();
    Get.put<TokenStorage>(tokenStorage, permanent: true);

    final apiClient = ApiClient(tokenStorage: tokenStorage);
    Get.put<ApiClient>(apiClient, permanent: true);

    // 2. Data Providers
    final authApiProvider = AuthApiProvider(apiClient: apiClient);
    Get.put<AuthApiProvider>(authApiProvider, permanent: true);

    final productApiProvider = ProductApiProvider(apiClient: apiClient);
    Get.put<ProductApiProvider>(productApiProvider, permanent: true);

    final employeeApiProvider = EmployeeApiProvider(apiClient: apiClient);
    Get.put<EmployeeApiProvider>(employeeApiProvider, permanent: true);

    // 3. Repositories
    final authRepository = AuthRepository(
      authApiProvider: authApiProvider,
      tokenStorage: tokenStorage,
    );
    Get.put<AuthRepository>(authRepository, permanent: true);

    final productRepository = ProductRepository(
      productApiProvider: productApiProvider,
    );
    Get.put<ProductRepository>(productRepository, permanent: true);

    final employeeRepository = EmployeeRepository(
      employeeApiProvider: employeeApiProvider,
    );
    Get.put<EmployeeRepository>(employeeRepository, permanent: true);

    // 4. Feature Controllers
    Get.put<AuthController>(
      AuthController(authRepository: authRepository),
      permanent: true,
    );

    Get.put<ProductController>(
      ProductController(productRepository: productRepository),
      permanent: true,
    );

    Get.put<EmployeeController>(
      EmployeeController(employeeRepository: employeeRepository),
      permanent: true,
    );

    Get.put<DashboardController>(
      DashboardController(
        productRepository: productRepository,
        employeeRepository: employeeRepository,
      ),
      permanent: true,
    );

    Get.put<ProfileController>(
      ProfileController(),
      permanent: true,
    );
  }
}

