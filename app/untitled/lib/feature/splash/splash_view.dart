import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/feature/splash/splash_controller.dart';
import 'package:untitled/widgets/loading_widget.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        backgroundColor: Colors.lightGreen,
        body: controller.loading.value == true
            ? LoadingWidget(color: Colors.white)
            : Text(""),
      );
    });
  }
}
