import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_color.dart';
import '../../global/constants/constants.dart';
import '../../global/constants/styles_const.dart';
import '../../global/widgets/buttons/action_button_widget.dart';
import '../../global/widgets/textfields/text_field_widget.dart';
import 'controller/forgot_password_controller.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  ForgotPasswordPage({Key? key})
      : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: appNormalGreyColor,),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollViewWidget(
          child: Form(
            key: _formKey,
            onChanged: () => controller.validateForm(_formKey.currentState),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding16 / 2, vertical: defaultPadding16),
                child: Column(
                  children: [
                    Image.asset('assets/icons/reset_password.png',
                        width: 128, height: 128, fit: BoxFit.fitWidth),
                    const SizedBox(height: defaultPadding16),
                    Text('Recuperação de senha',
                        textAlign: TextAlign.justify,
                        style: appStyle.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
                    const SizedBox(height: defaultPadding16),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        text: 'Informe o seu email abaixo para que possamos lhe enviar um email de ',
                        style: appStyle.bodySmall,
                        children: <TextSpan>[
                          TextSpan(text: 'recuperação de senha',
                            style: appStyle.bodySmall?.copyWith(
                                color: appNormalPrimaryColor, fontWeight: FontWeight.w500),
                          ),
                          TextSpan(text: '.',
                            style: appStyle.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: defaultPadding16/2),
                    TextFieldWidget(
                        label: "Email",
                        type: TextInputType.text,
                        controller: controller.emailController,
                        icon: const Icon(Icons.mail_rounded),
                        inputFormatter: [
                          FilteringTextInputFormatter.deny(RegExp('[ ]')),
                        ],
                        validator: (String value)
                        => (value.isNotEmpty && (!value.contains('@') || !value.contains('.')))
                            ? "Digite um email válido"
                            : value.isEmpty ? 'Informe seu melhor email' : null),
                    Obx(() => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ActionButtonWidget(
                          title: "RECUPERAR SENHA",
                          function: (controller.isFormValidated.value)
                              ? () => controller.submitForm()
                              : null,
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}
