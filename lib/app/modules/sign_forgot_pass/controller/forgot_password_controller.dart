import 'package:delivery_servicos/core/mixin/loader_mixin.dart';
import 'package:delivery_servicos/core/services/auth_service.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../../core/util/firebase_exceptions.dart';

class ForgotPasswordController extends GetxController with LoaderMixin {

  AuthServices authServices = Get.find<AuthServices>();
  static late AuthStatus _status;

  final emailController = TextEditingController();

  late RxBool isFormValidated = false.obs;
  final loading = false.obs;

  @override
  void onInit() {
    loaderListener(loading);
    super.onInit();
  }

  void validateForm(FormState? form) {
    if (form != null && form.validate()
        && (emailController.text.isNotEmpty
            && (!emailController.text.contains('@') || !emailController.text.contains('.')))) {
      isFormValidated.value = true;
    } else {
      isFormValidated.value = false;
    }
  }

  submitForm() async {
    loading.value = true;
    await authServices.auth
        .sendPasswordResetEmail(email: emailController.text)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));
    loading.value = false;
    if(_status == AuthStatus.successful) {
      Get.back();
      snackBar('Enviamos um email de recuperação de senha, confira a caixa de entrada do seu email, spam ou lixeira');
    } else {
      snackBar('Confira seu email e tente novamente');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}