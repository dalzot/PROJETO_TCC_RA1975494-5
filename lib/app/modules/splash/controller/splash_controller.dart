import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    Get.offAllNamed(Routes.signIn);
    super.onReady();
  }
}
