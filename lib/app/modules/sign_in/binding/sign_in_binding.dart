import 'package:get/get.dart';

import '../controller/sign_in_controller.dart';

class SignInBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SignInController(), permanent: true);
  }
}
