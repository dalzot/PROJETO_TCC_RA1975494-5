import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_servicos/app/modules/home/controller/home_controller.dart';
import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/app/modules/sign_up/controller/sign_up_controller.dart';
import 'package:delivery_servicos/core/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/global/constants/constants.dart';
import '../../app/modules/settings/repository/settings_repository.dart';
import '../../routes/app_pages.dart';
import '../util/global_functions.dart';

class AuthServices extends GetxService {
  final _settingsRepository = SettingsRepository();

  String token = '';
  String refreshToken = '';
  String statusId = '';
  static bool isLocked = false;

  final FirebaseAuth auth = FirebaseAuth.instance;
  String authServiceError = '';

  ProfileModel userLogged = ProfileModel();

  Future<AuthServices> init() async {
    return this;
  }

  Future<void> checkIfAuthOrSignIn() async {
    if(auth.currentUser != null) {
      ProfileModel? profileUser = await getUserByFirebaseData(auth.currentUser!.uid);
      handleSignInAccount(profileUser);
    } else {
      Get.offAllNamed(Routes.signIn);
    }
  }

  handleSignInAccount(ProfileModel? profileUser, {bool toHome = true}) async {
    if(profileUser != null) {
      if(profileUser.docCpf.isNotEmpty) {
        String? firebaseMessagingId = await FirebaseService.getFirebaseMessagingToken();
        userLogged = profileUser;
        userLogged.firebaseMessagingId = firebaseMessagingId ?? '';
        await FirebaseService.updateProfileData(userLogged.firebaseId, userLogged.toFirebaseToken());

        if(HomeController().initialized) {
          HomeController homeController = Get.find();
          homeController.setUserLogged(userLogged);
        } else {
          Get.lazyPut<HomeController>(() => HomeController());
          HomeController homeController = Get.find();
          homeController.setUserLogged(userLogged);
        }

        if(toHome) {
          snackBar('Login efetuado com sucesso');
          Get.offAllNamed(Routes.home);
        } else {
          snackBar('Cadastro efetuado com sucesso');
        }
      } else {
        SignUpController signUpController = Get.find<SignUpController>();
        signUpController.setTextFieldsTemp(profileUser);
        snackBar('Você precisa finalizar seu cadastro antes de utilizar o app');
        if(profileUser.profileType == 'profissional') {
          Get.offAllNamed(Routes.signUpProfessional);
        } else if(profileUser.profileType == 'cliente') {
          Get.offAllNamed(Routes.signUpClient);
        }
      }
    } else {
      Get.offAllNamed(Routes.signUp);
    }
  }

  Future<bool> checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int platformVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;
    String platformVersionName = packageInfo.version;

    versionCode = platformVersionCode;
    versionName = platformVersionName;
    final appVersion = await _settingsRepository.getVersion();
    final futureVersion =
    Platform.isIOS ? appVersion.iosVersion : appVersion.androidVersion;

    return platformVersionCode == futureVersion;
  }

  Future<UserCredential?> createUserByEmail(String email, String pass) async {
    try {
      UserCredential credentials = await auth.createUserWithEmailAndPassword(
          email: email,
          password: pass
      ).catchError((e, st) async {
        authServiceError = e.toString().split('] ')[0].split('/')[1];
      });
      return credentials;
    } catch(e,st) {
      return null;
    }
  }

  Future<UserCredential?> signInUserByEmail(String email, String pass) async {
    try {
      UserCredential? credentials = await auth.signInWithEmailAndPassword(
          email: email,
          password: pass
      ).catchError((e, st) async {
        authServiceError = e.toString().split('] ')[0].split('/')[1];
      });
      return credentials;
    } catch(e,st) {
      return null;
    }
  }

  Future<ProfileModel?> getUserByFirebaseData(String docId) async {
    DocumentSnapshot docUser = await FirebaseService.getProfileData(docId);
    if(docUser.exists) {
      return ProfileModel.fromJson(docUser.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<ProfileModel> setUserByFirebaseData(ProfileModel profileData) async {
    userLogged = profileData;
    await FirebaseService.setProfileData(profileData.firebaseId, profileData.toJson());
    handleSignInAccount(userLogged, toHome: false);
    return profileData;
  }

  Future<void> deleteUserData() async {
    await FirebaseService.deleteProfileData(auth.currentUser!.uid);
    await auth.currentUser!.delete();
    userLogged = ProfileModel();
  }
}
