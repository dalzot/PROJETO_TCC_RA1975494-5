import 'package:get/get.dart';

import '../controller/sign_up_controller.dart';

class SignUpBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SignUpController(), permanent: true);
  }
}
