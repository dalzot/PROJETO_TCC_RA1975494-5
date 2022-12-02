import 'package:delivery_servicos/app/global/widgets/buttons/action_button_widget.dart';
import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../global/constants/constants.dart';
import '../../global/constants/styles_const.dart';
import '../../global/widgets/body/custom_scaffold.dart';
import '../../global/widgets/textfields/password_field_widget.dart';
import '../../global/widgets/textfields/text_field_widget.dart';
import 'controller/sign_up_controller.dart';

class SignUpPage extends GetView<SignUpController> {
  SignUpPage({Key? key})
      : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: globalPadding16,
        child: SizedBox(
          height: 42,
          child: Row(
            children: [
              Expanded(child: GenerateFormSignUp()),
              Expanded(
                child: Obx(() => InkWell(
                    onTap: controller.isAccountFormValidated.value ? () {
                      controller.submitSignUpEmailAccount();
                    } : null,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: defaultBorderRadius8,
                        border: Border.all(width: 2, color: controller.isAccountFormValidated.value
                            ? appNormalPrimaryColor : appNormalGreyColor)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text('CONTINUAR', style: appStyle.titleMedium
                                  ?.copyWith(color: controller.isAccountFormValidated.value
                                  ? appNormalPrimaryColor : appNormalGreyColor)),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, color: controller.isAccountFormValidated.value
                                ? appNormalPrimaryColor : appNormalGreyColor)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollViewWidget(
            child: Form(
              key: _formKey,
              onChanged: () => controller.validateAccountForm(_formKey.currentState),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding16 / 2, vertical: defaultPadding16),
                  child: Column(
                    children: [
                      Text('Crie sua conta para começar a receber serviços ou '
                          'encontrar os melhores profissionais para seu serviço!',
                          textAlign: TextAlign.justify,
                          style: appStyle.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w500)),
                      const SizedBox(height: defaultPadding16),
                      Text('Cadastre-se abaixo para continuar',
                          textAlign: TextAlign.justify,
                          style: appStyle.bodyMedium
                              ?.copyWith()),
                      const SizedBox(height: defaultPadding16),
                      TextFieldWidget(
                          label: "Nome",
                          type: TextInputType.text,
                          controller: controller.nameController,
                          icon: const Icon(Icons.person_rounded),
//                          onChanged: controller.setNameTemp,
                          validator: (String value)
                          => value.length < 6 || !value.trim().contains(' ')
                              ? 'Informe seu nome completo' : null),
                      TextFieldWidget(
                          label: "Email",
                          type: TextInputType.text,
                          controller: controller.emailController,
                          icon: const Icon(Icons.mail_rounded),
//                          onChanged: controller.setEmailTemp,
                          inputFormatter: [
                            FilteringTextInputFormatter.deny(RegExp('[ ]')),
                          ],
                          validator: (String value)
                          => (value.isNotEmpty && (!value.contains('@') || !value.contains('.')))
                              ? "Digite um email válido"
                              : value.isEmpty ? 'Informe seu melhor email' : null),
                      PasswordFieldWidget(
                          label: "Senha",
                          type: TextInputType.text,
                          icon: Icon(Icons.lock_rounded),
                          controller: controller.passController,
                          validator: (String value)
                          => (value.length < 8 && controller.passChanged.value)
                              ? "Mínimo de 8 caracteres" : null),
                      PasswordFieldWidget(
                          label: "Confirmar senha",
                          type: TextInputType.text,
                          icon: Icon(Icons.lock_rounded),
                          controller: controller.passConfirmController,
                          validator: (String value) => controller.passChanged.value
                              ? (value.length < 8) ? "Mínimo de 8 caracteres"
                              : controller.passEquals.isFalse ? "As senhas devem ser iguais"
                              : null : null),
                      const SizedBox(height: defaultPadding16/2),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Escolha o que deseja no app',
                            textAlign: TextAlign.start,
                            style: appStyle.titleMedium
                                ?.copyWith()),
                      ),
                      Obx(() {
                        bool isSelected = controller.profileType.value == 'cliente';
                        Color colorSelected = isSelected ? appWhiteColor : appNormalPrimaryColor;
                        return Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor: isSelected
                                        ? MaterialStateProperty.all(appNormalPrimaryColor) : null,
                                    side: isSelected
                                        ? MaterialStateProperty.all(BorderSide(color: appNormalPrimaryColor, width: 1.5)) : null,
                                  ),
                                  onPressed: () {
                                    controller.setProfileType('cliente', _formKey.currentState);
                                  },
                                  icon: Icon(Icons.person_search_rounded, color: colorSelected),
                                  label: Text('ENCONTRAR PROFISSIONAIS',
                                    style: appStyle.bodySmall?.copyWith(
                                      color: colorSelected,
                                      fontWeight: FontWeight.bold
                                    ))),
                            ),
                          ],
                        );
                      }),
                      Obx(() {
                        bool isSelected = controller.profileType.value == 'profissional';
                        Color colorSelected = isSelected ? appWhiteColor : appNormalPrimaryColor;
                        return Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor: isSelected
                                        ? MaterialStateProperty.all(appNormalPrimaryColor) : null,
                                    side: isSelected
                                        ? MaterialStateProperty.all(
                                        const BorderSide(color: appNormalPrimaryColor, width: 1.5)) : null,
                                  ),
                                  onPressed: () {
                                    controller.setProfileType('profissional', _formKey.currentState);
                                  },
                                  icon: Icon(Icons.build_rounded, color: colorSelected),
                                  label: Text('SER UM PROFISSIONAL',
                                    style: appStyle.bodySmall?.copyWith(
                                      color: colorSelected,
                                      fontWeight: FontWeight.bold,
                                    ))),
                            ),
                          ],
                        );
                      })
                    ],
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget GenerateFormSignUp() {
    return InkWell(
      onTap: () {
        controller.clearTextFields();
        Get.toNamed(Routes.signIn);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Já tenho conta",
            style: fontStyleBody1.copyWith(color: colorGrey[500]),
          ),
          const SizedBox(height: 4,),
          Text("ENTRAR",
            style: fontStyleBody1.copyWith(color: appNormalPrimaryColor),
          ),
        ],
      ),
    );
  }
}
