import 'package:get/get.dart';

import '../controller/about_controller.dart';

class AboutBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutController>(() {
      return AboutController();
    });
  }
}
