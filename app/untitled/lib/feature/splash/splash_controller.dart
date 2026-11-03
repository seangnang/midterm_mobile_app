import 'package:get/get.dart';

class SplashController extends GetxController {
  var loading = true.obs;



  _checkLogin() async{
    loading.value = true;
    await Future.delayed(Duration(seconds: 3));
    loading.value = false;
  }

  @override
  void onInit() {
    _checkLogin();
    super.onInit();
  }
}