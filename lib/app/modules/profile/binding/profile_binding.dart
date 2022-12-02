import 'package:get/get.dart';

import '../controller/profile_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() {
      return ProfileController();
    });
  }
}
