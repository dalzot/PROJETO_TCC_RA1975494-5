import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/textfields/text_field_widget.dart';
import '../controller/sign_up_controller.dart';

class AddressTabFormWidget extends StatelessWidget {
  final SignUpController controller;
  final GlobalKey<FormState> formKey;
  const AddressTabFormWidget({
    required this.controller,
    required this.formKey,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      onChanged: () => controller.validateAddressForm(formKey.currentState),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding16 / 2, vertical: defaultPadding16),
          child: Column(
            children: [
              const SizedBox(height: defaultPadding16),
              Text('Muito bem, agora você precisa nos informar seu endereço',
                  textAlign: TextAlign.justify,
                  style: appStyle.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: defaultPadding16/2),
              Text('Preencha seu endereço ou de seu escritório.\n\n'
                  'Sua cidade e estado serão sempre públicos para que o '
                  '${checkUserType(controller.profileType.value)
                  ? 'cliente saiba qual região você atende.'
                  : 'profissional saiba onde você está ou adicione um endereço novo na hora de solicitar um serviço.'}',
                  textAlign: TextAlign.justify,
                  style: appStyle.bodySmall),
//              const SizedBox(height: defaultPadding),
//              InkWell(
//                onTap: () {
//                  showDialog(
//                      context: context,
//                      builder: (dContext) => PlacePicker(
//                        autocompleteLanguage: 'pt_BR',
//                        hintText: 'Buscar endereço',
//                        apiKey: googleMapsAPI,
//                        onPlacePicked: (result) {
//                          print(result);
//                        },
//                        initialPosition: const LatLng(-27.5698055,-49.0445881),
//                        useCurrentLocation: true,
//                        resizeToAvoidBottomInset: false,
//                      )
//                  );
//                },
//                child: Container(
//                  decoration: BoxDecoration(
//                      borderRadius: defaultBorderRadius8,
//                      border: Border.all(width: 2, color: appNormalPrimaryColor)
//                  ),
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: [
//                        const Icon(Icons.search_rounded, color: appNormalPrimaryColor),
//                        Padding(
//                          padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding/2),
//                          child: Text('BUSCAR ENDEREÇO', style: appStyle.titleMedium
//                              ?.copyWith(color: appNormalPrimaryColor)),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//              const SizedBox(height: defaultPadding / 2),
//              Text('ou insira manualmente',
//                  textAlign: TextAlign.justify,
//                  style: appStyle.bodySmall),
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
