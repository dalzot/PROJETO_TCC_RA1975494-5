import 'package:get/get.dart';

import '../controller/forgot_password_controller.dart';

class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() {
      return ForgotPasswordController();
    });
  }
}
