import 'package:delivery_servicos/app/modules/profile/models/profile_saved_model.dart';
import 'package:delivery_servicos/core/mixin/loader_mixin.dart';
import 'package:delivery_servicos/core/services/auth_service.dart';
import 'package:get/get.dart';


class SavedsController extends GetxController with LoaderMixin {
  AuthServices authServices = Get.find<AuthServices>();
  RxBool loading = false.obs;

  RxList<ProfileSavedModel> savedProfiles = <ProfileSavedModel>[].obs;

  @override
  void onInit() {
    loaderListener(loading);
    super.onInit();
  }

  @override
  void onReady() {
    loadSavedProfiles();
    super.onReady();
  }

  loadSavedProfiles() {
    savedProfiles.value = authServices.userLogged.profilesSaved;
  }
}