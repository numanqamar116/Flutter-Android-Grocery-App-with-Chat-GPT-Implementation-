import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../routes/app_pages.dart';
import '../../../../SignInUpScreen.dart';

class SplashController extends GetxController {

  @override
  void onInit() async {
    super.onInit();

    await Future.delayed(const Duration(seconds: 2));

    // Use Get.to to navigate to SignInUpScreen
    Get.off(() => SignInUpScreen());
  }
}
