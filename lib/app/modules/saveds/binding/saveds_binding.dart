import 'package:get/get.dart';

import '../controller/saveds_controller.dart';

class SavedsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedsController>(() {
      return SavedsController();
    });
  }
}
