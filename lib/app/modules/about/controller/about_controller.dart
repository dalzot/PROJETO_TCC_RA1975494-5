import 'package:delivery_servicos/core/mixin/loader_mixin.dart';
import 'package:delivery_servicos/core/services/auth_service.dart';
import 'package:get/get.dart';

class AboutController extends GetxController with LoaderMixin {
  AuthServices authServices = Get.find<AuthServices>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {

    super.onReady();
  }
}