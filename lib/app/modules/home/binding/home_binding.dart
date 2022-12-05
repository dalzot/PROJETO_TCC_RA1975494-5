import 'package:get/get.dart';

import '../controller/home_client_controller.dart';
import '../controller/home_controller.dart';
import '../controller/home_professional_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);

    Get.put<HomeClientController>(HomeClientController(), permanent: true);

    Get.put<HomeProfessionalController>(HomeProfessionalController(), permanent: true);
  }
}
