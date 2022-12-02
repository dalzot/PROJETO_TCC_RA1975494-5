import 'package:delivery_servicos/app/modules/home/controller/home_controller.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/values/expertises.dart';
import '../../../../core/values/payment_methods.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/checkbox/custom_checkbox_widget.dart';
import '../../../global/widgets/lists/global_list_view_widget.dart';
import '../../../global/widgets/textfields/text_field_widget.dart';

class HomeFiltersWidget extends GetView<HomeController> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GlobalListViewWidget(
      children: [
        Visibility(
            visible: controller.userLogged.profileType == 'profissional',
            child: TypeFilter()),
        StatusFilter(),
        const Divider(height: 1, thickness: 1, color: appLightGreyColor),
        const SizedBox(height: 8),
        AddressFilter(),
        const Divider(height: 16, thickness: 1, color: appLightGreyColor),
        PaymentFormWidget(),
        const Divider(height: 16, thickness: 1, color: appLightGreyColor),
        ExpertisesFilter(),
      ],
    );
  }

  Widget TypeFilter() {
    return Obx(() => Row(
      children: [
        Checkbox(
          onChanged: controller.statusFilter.value
              ? null : (b) => controller.setTypeFilter(b!),
          value: controller.typeFilter.value,
        ),
        Text('Buscar por ofertas de serviço'),
      ],
    ));
  }

  Widget StatusFilter() {
    return Obx(() => Row(
      children: [
        Checkbox(
          onChanged: controller.typeFilter.value
              ? null : (b) => controller.setStatusFilter(b!),
          value: controller.statusFilter.value,
        ),
        Text('Somente profissionais online'),
      ],
    ));
  }

  Widget AddressFilter() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Filtrar por endereço', style: appStyle.bodySmall)),
        const SizedBox(height: 8),
        Obx(() => TextFieldWidget(
            label: "CEP",
            hintText: '00000-000',
            type: TextInputType.number,
            controller: controller.searchByCepController,
            suffixIcon: IconButton(
              icon: Icon(Icons.search_rounded,
                  color: controller.cepError.value != ''
                      ? appNormalGreyColor : appNormalPrimaryColor),
              onPressed: controller.cepError.value != ''
                  ? null : () => controller.searchByCep(_formKey.currentState),
            ),
            inputFormatter: [
              maskFormatterCep,
              FilteringTextInputFormatter.deny(RegExp('[ ]')),
            ],
            validator: controller.cepValidator)),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: TextFieldWidget(
                  label: "Cidade",
                  type: TextInputType.text,
                  controller: controller.searchCityController,
                  validator: (String value) => null),
            ),
            const SizedBox(width: 8,),
            Expanded(
              flex: 2,
              child: TextFieldWidget(
                  label: "UF",
                  type: TextInputType.text,
                  controller: controller.searchProvinceController,
                  validator: (String value) => null),
            ),
          ],
        ),
        Visibility(
          visible: controller.searchStreetController.text.isNotEmpty
              && controller.searchDistrictController.text.isNotEmpty,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Endereço: '),
                  Text('${controller.searchStreetController.text}',
                    style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bairro: '),
                  Text('${controller.searchDistrictController.text}',
                    style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget ExpertisesFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(defaultPadding16 / 2, 0, defaultPadding16 / 2, defaultPadding16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filtrar por habilidades & serviços', style: appStyle.bodySmall,),
          GlobalListViewBuilderWidget(
              itemCount: allExpertises.length,
              itemBuilder: (_, index) {
                var expertise = allExpertises[index];
                var subExpertises = expertise['value'];
                return CustomCheckboxWidget(
                    onCheck: (checked) => controller.addProfessionalExpertises(expertise: checked),
                    onUncheck: (unchecked) => controller.removeProfessionalExpertises(expertise: unchecked),
                    parent: Text(expertise['title']),
                    checkList: controller.expertisesFilter,
                    children: subExpertises.map((e) =>
                        Text(e.toString())).toList());
              }),
        ],
      ),
    );
  }

  Widget PaymentFormWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(defaultPadding16 / 2, 0, defaultPadding16 / 2, defaultPadding16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filtrar por formas de pagamento', style: appStyle.bodySmall,),
          GlobalListViewBuilderWidget(
              itemCount: 1,
              itemBuilder: (_, index) {
                return CustomCheckbox(
                    onCheck: (checked) => controller.addPaymentsMethods(payment: checked),
                    onUncheck: (unchecked) => controller.removePaymentsMethods(payment: unchecked),
                    checkList: controller.paymentsFilter,
                    children: allPaymentMethods.map((e) =>
                        Text(e.toString())).toList());
              }),
        ],
      ),
    );
  }
}
