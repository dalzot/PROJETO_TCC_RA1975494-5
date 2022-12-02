import 'package:delivery_servicos/app/modules/sign_up/controller/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/util/global_functions.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/textfields/text_field_widget.dart';
import '../controller/edit_controller.dart';

class EditPersonalFormTabWidget extends StatelessWidget {
  final EditController controller;
  final GlobalKey<FormState> formKey;
  const EditPersonalFormTabWidget({
    required this.controller,
    required this.formKey,
    Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      onChanged: () => controller.validatePersonalForm(formKey.currentState),
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(defaultPadding16 / 2, 0, defaultPadding16 / 2, defaultPadding16),
          child: Column(
            children: [
              Text('Editar dados pessoais',
                  textAlign: TextAlign.justify,
                  style: appStyle.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: defaultPadding16),
              RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  text: 'Deseja atualizar suas informações\n',
                  style: appStyle.bodySmall,
                  children: <TextSpan>[
                    TextSpan(text: '${controller.nameController.text}',
                      style: appStyle.bodySmall?.copyWith(
                          color: appNormalPrimaryColor, fontWeight: FontWeight.w500),
                    ),
                    TextSpan(text: '?\nPreencha as informações abaixo para continuar.',
                      style: appStyle.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding16/2),
              TextFieldWidget(
                  label: "CPF",
                  hintText: '000.000.000-00',
                  type: const TextInputType.numberWithOptions(),
                  controller: controller.cpfController,
                  icon: const Icon(Icons.badge),
                  enableField: false,
                  validator: (String value) => null),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFieldWidget(
                        label: "RG",
                        hintText: '0.000.000 (-0)',
                        type: const TextInputType.numberWithOptions(),
                        controller: controller.rgController,
                        icon: const Icon(Icons.badge),
                        enableField: false,
                        validator: (String value) => null),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    flex: 2,
                    child: TextFieldWidget(
                        label: "SSP/**",
                        hintText: 'SSP/**',
                        type: TextInputType.text,
                        controller: controller.rgEmitController,
                        textCapitalization: TextCapitalization.characters,
                        enableField: false,
                        validator: (String value) => null),
                  ),
                ],
              ),
              TextFieldWidget(
                  label: "Data de Nascimento",
                  hintText: '01/01/1990',
                  type: TextInputType.number,
                  controller: controller.birthdayController,
                  icon: const Icon(Icons.today_rounded),
                  enableField: false,
                  validator: (String value) => null),
              TextFieldWidget(
                  label: "Número Principal",
                  hintText: '(49) 9 1234-5678',
                  type: TextInputType.number,
                  controller: controller.phoneController,
                  icon: const Icon(Icons.local_phone_rounded),
                  inputFormatter: [
                    maskFormatterPhone,
                  ],
                  validator: (String value) => value.length != 16
                      ? 'Informe um número válido' : null),
              Obx(() => TextFieldWidget(
                    label: "Número Opcional",
                    hintText: '(49) 9 1234-5678',
                    type: TextInputType.number,
                    controller: controller.phone2Controller,
                    icon: const Icon(Icons.local_phone_rounded),
                    inputFormatter: [
                      controller.maskPhone.value,
                    ],
                    onChanged: controller.changeMaskPhone,
                    validator: (String value) => null),
              ),
              const SizedBox(height: defaultPadding16/2),
            ],
          )
      ),
    );
  }
}
