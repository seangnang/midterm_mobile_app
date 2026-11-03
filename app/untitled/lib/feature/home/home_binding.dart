

import 'package:get/get.dart';
import 'package:untitled/feature/home/home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> HomeController());
  }

}