import 'package:get/get.dart';

import '../controller/settings_controller.dart';
import '../repository/settings_repository.dart';

class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() {
      return SettingsController(
        repository: SettingsRepository(),
      );
    });
  }
}
