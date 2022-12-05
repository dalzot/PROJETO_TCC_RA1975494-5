import 'package:delivery_servicos/app/modules/home/controller/home_controller.dart';
import 'package:delivery_servicos/app/modules/profile/controller/profile_controller.dart';
import 'package:delivery_servicos/app/modules/sign_up/controller/sign_up_controller.dart';

import '../../app/data/provider/http_client.dart';
import '../../app/data/provider/http_client_get_connect.dart';
import 'package:get/get.dart';

import '../../app/modules/edit_profile/controller/edit_controller.dart';
import '../services/auth_service.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HttpClient>(HttpClientGetConnect(), permanent: true);

    Get.putAsync<AuthServices>(() => AuthServices().init(), permanent: true);

    Get.put<EditController>(EditController(), permanent: true);

    Get.put<SignUpController>(SignUpController(), permanent: true);

    Get.lazyPut<HomeController>(() => HomeController());

    Get.putAsync<AuthServices>(() => AuthServices().init(), permanent: true);
  }
}
