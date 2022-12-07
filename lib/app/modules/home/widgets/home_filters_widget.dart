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
import '../controller/home_controller.dart';

class HomeFiltersWidget extends GetView<HomeController> {
  final setTypeFilter;
  final setStatusFilter;
  final typeFilter;
  final statusFilter;
  final searchByCepController;
  final cepError;
  final searchByCep;
  final cepValidator;
  final searchCityController;
  final searchProvinceController;
  final searchStreetController;
  final searchDistrictController;
  final addProfessionalExpertises;
  final removeProfessionalExpertises;
  final expertisesFilter;
  final addPaymentsMethods;
  final removePaymentsMethods;
  final paymentsFilter;
  HomeFiltersWidget({
    this.setTypeFilter,
    this.typeFilter,
    this.statusFilter,
    this.setStatusFilter,
    required this.searchByCepController,
    required this.cepError,
    required this.searchByCep,
    required this.cepValidator,
    required this.searchCityController,
    required this.searchProvinceController,
    required this.searchStreetController,
    required this.searchDistrictController,
    required this.addProfessionalExpertises,
    required this.removeProfessionalExpertises,
    required this.expertisesFilter,
    required this.addPaymentsMethods,
    required this.removePaymentsMethods,
    required this.paymentsFilter,
    Key? key}) : super(key: key);
  
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GlobalListViewWidget(
      children: [
        Visibility(
            visible: checkUserType(controller.userLogged.profileType)
                && setTypeFilter != null && typeFilter != null,
            child: TypeFilter()),
        Visibility(
            visible: !checkUserType(controller.userLogged.profileType)
                && setStatusFilter != null && statusFilter != null,
            child: StatusFilter()),
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
    return Row(
      children: [
        Checkbox(
          onChanged: (b) => setTypeFilter(b!),
          value: typeFilter ?? false,
        ),
        Text('Buscar por ofertas de serviço'),
      ],
    );
  }

  Widget StatusFilter() {
    return Row(
      children: [
        Checkbox(
          onChanged: (b) => setStatusFilter(b!),
          value: statusFilter ?? false,
        ),
        Text('Somente profissionais online'),
      ],
    );
  }

  Widget AddressFilter() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Filtrar por endereço', style: appStyle.bodySmall)),
        const SizedBox(height: 8),
        TextFieldWidget(
            label: "CEP",
            hintText: '00000-000',
            type: TextInputType.number,
            controller: searchByCepController,
            suffixIcon: IconButton(
              icon: Icon(Icons.search_rounded,
                  color: cepError != '' ? appNormalGreyColor : appNormalPrimaryColor),
              onPressed: cepError != ''
                  ? null : () => searchByCep(_formKey.currentState),
            ),
            inputFormatter: [
              maskFormatterCep,
              FilteringTextInputFormatter.deny(RegExp('[ ]')),
            ],
            validator: cepValidator),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: TextFieldWidget(
                  label: "Cidade",
                  type: TextInputType.text,
                  controller: searchCityController,
                  validator: (String value) => null),
            ),
            const SizedBox(width: 8,),
            Expanded(
              flex: 2,
              child: TextFieldWidget(
                  label: "UF",
                  type: TextInputType.text,
                  controller: searchProvinceController,
                  validator: (String value) => null),
            ),
          ],
        ),
        Visibility(
          visible: searchStreetController.text.isNotEmpty
              && searchDistrictController.text.isNotEmpty,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Endereço: '),
                  Text('${searchStreetController.text}',
                    style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bairro: '),
                  Text('${searchDistrictController.text}',
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
                    onCheck: (checked) => addProfessionalExpertises(expertise: checked),
                    onUncheck: (unchecked) => removeProfessionalExpertises(expertise: unchecked),
                    parent: Text(expertise['title']),
                    checkList: expertisesFilter,
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
                    onCheck: (checked) => addPaymentsMethods(payment: checked),
                    onUncheck: (unchecked) => removePaymentsMethods(payment: unchecked),
                    checkList: paymentsFilter,
                    children: allPaymentMethods.map((e) =>
                        Text(e.toString())).toList());
              }),
        ],
      ),
    );
  }
}
