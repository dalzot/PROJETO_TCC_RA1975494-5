import 'package:delivery_servicos/app/modules/announce/controller/request_controller.dart';
import 'package:delivery_servicos/app/modules/announce/controller/service_controller.dart';
import 'package:delivery_servicos/app/modules/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

import '../controller/announce_controller.dart';

class AnnounceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnnounceController>(() {
      return AnnounceController();
    });

    Get.lazyPut<ServiceController>(() {
      return ServiceController();
    });

    Get.lazyPut<RequestController>(() {
      return RequestController();
    });

    Get.lazyPut<ProfileController>(() {
      return ProfileController();
    });

    Get.put<AnnounceController>(AnnounceController());
  }
}
