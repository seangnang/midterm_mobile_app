import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  UserModel? get currentUser => _authController.currentUser.value;

  void logout() {
    _authController.logout();
  }
}

