import 'package:get/get.dart';

import '../controller/edit_controller.dart';

class EditProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(EditController());
  }
}
