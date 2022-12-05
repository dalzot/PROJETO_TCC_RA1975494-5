import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/core/services/auth_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  AuthServices authServices = Get.find<AuthServices>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool loading = false.obs;

  late ProfileModel userLogged;

  @override
  void onInit() {
    setUserLogged(authServices.userLogged);
    super.onInit();
  }

  @override
  void onReady() {
    setUserLogged(authServices.userLogged);
    super.onReady();
  }

  setUserLogged(ProfileModel newProfile) {
    userLogged = newProfile;
  }
}