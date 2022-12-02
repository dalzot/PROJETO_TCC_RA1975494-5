import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../../../../core/theme/app_color.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/textfields/text_field_widget.dart';
import '../controller/edit_controller.dart';

class EditAddressTabFormWidget extends StatelessWidget {
  final EditController controller;
  final GlobalKey<FormState> formKey;
  const EditAddressTabFormWidget({
    required this.controller,
    required this.formKey,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      onChanged: () => controller.validateAddressForm(formKey.currentState),
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(defaultPadding16 / 2, 0, defaultPadding16 / 2, defaultPadding16),
          child: Column(
            children: [
//              const SizedBox(height: defaultPadding16),
              Text('Editar meu endereço',
                  textAlign: TextAlign.justify,
                  style: appStyle.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: defaultPadding16/2),
              Text('Informe seu novo endereço ou continue para a próxima tela.',
                  textAlign: TextAlign.justify,
                  style: appStyle.bodySmall),
              const SizedBox(height: defaultPadding16 / 2),
              Obx(() => TextFieldWidget(
                  label: "CEP",
                  hintText: '00000-000',
                  type: TextInputType.number,
                  controller: controller.cepController,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search_rounded,
                        color: controller.cepError.value != ''
                            ? appNormalGreyColor : appNormalPrimaryColor),
                    onPressed: controller.cepError.value != ''
                        ? null : () => controller.searchByCep(formKey.currentState),
                  ),
                  inputFormatter: [
                    maskFormatterCep,
                    FilteringTextInputFormatter.deny(RegExp('[ ]')),
                  ],
                  validator: controller.cepValidator),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFieldWidget(
                        label: "Cidade",
                        type: TextInputType.text,
                        controller: controller.cityController,
                        validator: (String value) => value.isEmpty
                            ? 'Informe uma cidade válida' : null),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    flex: 2,
                    child: TextFieldWidget(
                        label: "UF",
                        type: TextInputType.text,
                        controller: controller.provinceController,
                        validator: (String value) => value.isEmpty
                            ? 'UF inválido' : null),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFieldWidget(
                        label: "Rua",
                        type: TextInputType.text,
                        controller: controller.streetController,
                        validator: (String value) => value.isEmpty
                            ? 'Informe uma rua válida' : null),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    flex: 2,
                    child: TextFieldWidget(
                        label: "Número",
                        type: TextInputType.text,
                        controller: controller.numberController,
                        validator: (String value) => value.isEmpty
                            ? 'Inválido' : null),
                  ),
                ],
              ),
              TextFieldWidget(
                  label: "Bairro",
                  type: TextInputType.text,
                  controller: controller.districtController,
                  validator: (String value) => value.isEmpty
                      ? 'Informe um bairro válido' : null),
              TextFieldWidget(
                  label: "Complemento",
                  type: TextInputType.text,
                  controller: controller.complementController,
                  validator: (String value) => null),

            ],
          )
      ),
    );
  }
}
