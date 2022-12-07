import 'package:delivery_servicos/app/modules/sign_up/controller/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/util/global_functions.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/textfields/text_field_widget.dart';

class PersonalFormTabWidget extends StatelessWidget {
  final SignUpController controller;
  final GlobalKey<FormState> formKey;
  const PersonalFormTabWidget({
    required this.controller,
    required this.formKey,
    Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      onChanged: () => controller.validatePersonalForm(formKey.currentState),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          const SizedBox(height: defaultPadding16),
          Text('Muito bem, você está à um passo de se tornar um Profissional no HeyJobs!',
              textAlign: TextAlign.justify,
              style: appStyle.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: defaultPadding16),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: 'Para isso, precisamos coletar mais algumas informações sobre você',
              style: appStyle.bodySmall,
              children: <TextSpan>[
                TextSpan(text: ' ${controller.nameController.text}',
                  style: appStyle.bodySmall?.copyWith(
                      color: appNormalPrimaryColor, fontWeight: FontWeight.w500),
                ),
                TextSpan(text: '.\n\nPreencha as informações abaixo para continuar.',
                  style: appStyle.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: defaultPadding16/2),
          TextFieldWidget(
              label: "CPF",
              hintText: '000.000.000-00',
              textInputAction: TextInputAction.next,
              type: const TextInputType.numberWithOptions(),
              controller: controller.cpfController,
              icon: const Icon(Icons.badge),
              inputFormatter: [
                maskFormatterCpf,
                FilteringTextInputFormatter.deny(RegExp('[ ]')),
              ],
              validator: (String value) {
                return controller.validatorDocId(value);
              }),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: TextFieldWidget(
                    label: "RG",
                    hintText: '0.000.000 (-00)',
                    textInputAction: TextInputAction.next,
                    type: const TextInputType.numberWithOptions(),
                    controller: controller.rgController,
                    icon: const Icon(Icons.badge),
                    inputFormatter: [
                      maskFormatterRG,
                      FilteringTextInputFormatter.deny(RegExp('[ ]')),
                    ],
                    validator: (String value) => value.length < 9
                        ? 'Informe um RG válido' : null),
              ),
              const SizedBox(width: 8,),
              Expanded(
                flex: 2,
                child: TextFieldWidget(
                    label: "SSP/**",
                    hintText: 'SSP/**',
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: controller.rgEmitController,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatter: [
                      maskFormatterRGEmit,
                      FilteringTextInputFormatter.deny(RegExp('[ ]')),
                    ],
                    validator: (String value) => value.length < 6
                        ? 'Informe um SSP válido' : null),
              ),
            ],
          ),
          TextFieldWidget(
              label: "Data de Nascimento",
              hintText: '01/01/1990',
              type: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: controller.birthdayController,
              icon: const Icon(Icons.today_rounded),
              inputFormatter: [
                maskFormatterDate,
              ],
              validator: (String value) => value.length != 10
                  ? 'Informe uma data válida' : compareDateFromNow(value)
                  ? 'Você precisa ter mais de 18 anos' : null),
          TextFieldWidget(
              label: "Número Principal",
              hintText: '(49) 9 1234-5678',
              type: TextInputType.number,
              controller: controller.phoneController,
              textInputAction: TextInputAction.next,
              icon: const Icon(Icons.local_phone_rounded),
              inputFormatter: [
                maskFormatterPhone,
              ],
              validator: (String value) => value.length != 16
                  ? 'Informe um número válido' : null),
          TextFieldWidget(
              label: "Número Opcional",
              hintText: '(49) 9 1234-5678',
              type: TextInputType.number,
              textInputAction: TextInputAction.done,
              controller: controller.phone2Controller,
              icon: const Icon(Icons.local_phone_rounded),
              inputFormatter: [
                maskFormatterPhone,
              ],
              validator: (String value) => null),
          InkWell(
            onTap: () => globalAlertDialog(
                title: 'Por que coletamos essas informações?',
                text: '• Para garantirmos que nossos usuários são pessoas reais\n'
                    '• Para garantir a segurança do profissional e do cliente\n'
                    '• Para garatirmos de que você realmente irá utilizar o app\n\n'
                    'Para quem ficam disponíveis minhas informações?\n'
                    'Apenas para você, elas são criptografadas assim que '
                    'envia para o nosso banco de dados.\n\n'
                    'Posso excluir meus dados?\n'
                    'Sim, se você por algum motivo decidir não utilizar mais nossos '
                    'serviços gratuitos, você pode excluir sua conta, o que irá remover '
                    'todos seus dados de nosso banco de dados.',
                labelActionButton: 'entendi',
                onPressedAction: () => Get.back()),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Por que coletamos essas informações?',
                      textAlign: TextAlign.justify,
                      style: appStyle.bodySmall),
                  const SizedBox(width: 4,),
                  const Icon(Icons.help_outline_rounded, color: appNormalPrimaryColor,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
