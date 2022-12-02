import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../global/widgets/textfields/password_field_widget.dart';
import '../../../global/widgets/textfields/text_field_widget.dart';
import '../controller/sign_in_controller.dart';

class GenerateFormFieldsSignInWidget extends StatelessWidget {
  final SignInController controller;

  const GenerateFormFieldsSignInWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
          label: "Email",
          type: TextInputType.emailAddress,
          controller: controller.emailController,
          onChanged: (value) => controller.verifyUser(value ?? ""),
          icon: Icon(Icons.mail_rounded),
          inputFormatter: [
            FilteringTextInputFormatter.deny(RegExp('[ ]')),
          ],
          validator: (String value) => value.isEmpty
              ? "Digite seu email" : null),
        PasswordFieldWidget(
            label: "Senha",
            type: TextInputType.text,
            icon: Icon(Icons.lock_rounded),
            controller: controller.passController,
            validator: (String value) => value.isEmpty
                ? "Digite sua senha" : null)
      ],
    );
  }
}
