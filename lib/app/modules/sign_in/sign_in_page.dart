import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/mixin/loader_content.dart';
import '../../../routes/app_pages.dart';
import '../../global/constants/constants.dart';
import '../../global/constants/styles_const.dart';
import 'controller/sign_in_controller.dart';
import 'widgets/generate_form_buttons_sign_in_widget.dart';
import 'widgets/generate_form_fields_sign_in_widget.dart';
import 'widgets/generate_form_head_sign_in_widget.dart';

class SignInPage extends GetView<SignInController> {
  SignInPage({Key? key})
      : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollViewWidget(
            child: Form(
              key: _formKey,
              onChanged: () => controller.validateForm(_formKey.currentState),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const GenerateFormHeadSignInWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding16 * 2,
                        vertical: defaultPadding16 * 1.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        GenerateFormFieldsSignInWidget(controller: controller),
                        Obx(() => controller.loading.isTrue ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: LoadingContent(),
                        ) :
                        GenerateFormButtonsSignInWidget(controller: controller)),
                        GenerateFormSignUp(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget GenerateFormSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Não tem conta?",
          style: fontStyleBody1.copyWith(color: colorGrey[500]),
        ),
        TextButton(
          onPressed: () {
            controller.clearFields();
            Get.toNamed(Routes.signUp);
          },
          child: const Text("CADASTRE-SE"),
        ),
      ],
    );
  }
}
