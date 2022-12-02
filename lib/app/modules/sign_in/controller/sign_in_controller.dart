import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/app/modules/settings/pages/check_version_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/mixin/loader_mixin.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/util/global_functions.dart';

class SignInController extends GetxController with LoaderMixin {
  final loading = false.obs;

  final emailController = TextEditingController();
  final passController = TextEditingController();

  late RxBool isFormValidated = false.obs;
  final _authService = Get.find<AuthServices>();

  Future<SignInController> init() async {
    return this;
  }

  @override
  void onInit() {
    loaderListener(loading);
    loading.value = false;
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    loading.value = false;

    loading.value = true;
    if (await _authService.checkVersion()) {
      await _authService.checkIfAuthOrSignIn();
    } else {
      Get.offAll(() => const CheckVersionPage());
    }
    loading.value = false;
  }

  void validateForm(FormState? form) {
    if (form != null && form.validate()) {
      isFormValidated.value = true;
    } else {
      isFormValidated.value = false;
    }
  }

  void setFormState(bool state) {
    isFormValidated = state.obs;
  }

  submitForm() async {
    loading.value = false;
    if (Get.isSnackbarOpen || emailController.text.isEmpty || passController.text.isEmpty) {
      return;
    }
    loading.value = true;

    UserCredential? credentials = await _authService.signInUserByEmail(
        emailController.text, passController.text);

    if(credentials != null) {
      ProfileModel? profileUser = await _authService.getUserByFirebaseData(credentials.user!.uid);
      loading.value = false;
      clearFields();
      _authService.handleSignInAccount(profileUser);
    } else {
      loading.value = false;
      if(_authService.authServiceError == 'wrong-password') {
        snackBar('Senha incorreta, por favor, verifique');
      } else if(_authService.authServiceError == 'user-not-found') {
        snackBar('Email não cadastrado');
      } else {
        snackBar('Erro inesperado. Tente novamente mais tarde.');
      }
    }
  }

  void signInWithGoogle() async {
    loading.value = true;

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      loading.value = false;
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//    if (googleAuth != null) {
//      // Create a new credential
//      final credential = GoogleAuthProvider.credential(
//        accessToken: googleAuth.accessToken,
//        idToken: googleAuth.idToken,
//      );
//
//      // print("accessToken: ${googleAuth?.accessToken}");
//      // print("idToken: ${googleAuth?.idToken}");
//
//      // Once signed in, return the UserCredential
//      // final UserCredential response =
//      //     await
//      FirebaseAuth.instance
//          .signInWithCredential(credential)
//          .then((response) async {
//        final accessToken = googleAuth.accessToken;
//        dataSourceApi.loginGoogle(accessToken!).then((response) async {
//          if (response.statusCode == 200) {
//            _authService.typeRegistration = RegistrationType.social;
//
//            if(response.data['user']['phone'].contains("Google")) {
//              _authService.user = UserModel(
//                  docId: '',
//                  email: response.data['user']['email'],
//                  name: response.data['user']['name'],
//                  phoneNumber: '',
//                  id: null,
//                  paymentCassolUser: false,
//                  facebookId: '');
//              callRouteByStatusId('4');
//              return;
//            }
//            old_user_model.UserModel user =
//            old_user_model.UserModel.fromRequestJson(response.data['user']);
//
//            _authService.user = getUserModelByOld(
//                user, response.data["user"]["paymentCassolUser"] ?? false);
//
//            savePrefs(response.data, user);
//
//            final isOldRegister =
//            await repository.checkStatus(_authService.user.id!);
//
//            dataSourceApi.updateUserFirebaseToken();
//
//            await Analytics.logLogin(loginMethod: 'sign_in_google');
//            await Analytics.setUserId(userId: user.email);
//
//            callRouteByStatusId(
//                isOldRegister ? "4" : response.data['user']['statusId']);
//          } else if (response.statusCode == 401) {
//            loading.value = false;
//            if ("Invalid Credentials." == response.data["message"]) {
//              snackBar("Login ou senha inválidos");
//            } else if ("error.http.401" == response.data["message"]) {
//              snackBar(
//                  "Acesso não autorizado. \nContate o administrador do sistema!",
//                  color: colorDanger);
//            } else if (response.data["message"] ==
//                "The user phone is not verified" &&
//                response.data["phone"].toString().contains("Google")) {
//              snackBar("Cadastro incompleto.");
//              callRouteByStatusId("4");
//            } else {
//              callWelcomePage(response.data);
//            }
//          } else {
//            snackBar(
//                "Erro inesperado. Código 500 - ${response.data["message"]}");
//          }
//        });
//      }).onError((error, stackTrace) {});
//    } else {
//      snackBar("Usuário não encontrado.");
//    }
    // Close loading dialog
    loading.value = false;
  }

  void logout() async {
    final User? user = _authService.auth.currentUser;
    if (user == null) return;
    final _prefs = await prefs();
    _prefs.clear();
    await _authService.auth.signOut();
  }

  Future<void> verifyUser(String str) async {

  }

  clearFields() {
    emailController.clear();
    passController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passController.dispose();
    super.onClose();
  }
}
