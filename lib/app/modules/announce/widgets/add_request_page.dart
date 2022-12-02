import 'package:delivery_servicos/app/global/widgets/body/custom_scaffold.dart';
import 'package:delivery_servicos/app/modules/announce/controller/announce_controller.dart';
import 'package:delivery_servicos/app/modules/profile/models/profile_model.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/util/global_functions.dart';
import '../../../../core/values/expertises.dart';
import '../../../../core/values/payment_methods.dart';
import '../../../../routes/app_pages.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/buttons/action_button_widget.dart';
import '../../../global/widgets/buttons/custom_inkwell.dart';
import '../../../global/widgets/checkbox/custom_checkbox_widget.dart';
import '../../../global/widgets/lists/global_list_view_widget.dart';
import '../../../global/widgets/modal_sheet/modal_bottom_sheet.dart';
import '../../../global/widgets/small/custom_containers_widget.dart';
import '../../../global/widgets/textfields/text_field_widget.dart';

class AddRequestPage extends GetView<AnnounceController> {
  AddRequestPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: appBackgroundColorDark,
      showDrawerMenu: false,
      showBottomMenu: false,
      backRoute: Routes.myRequests,
      pageTitle: 'Nova Solicitação de Serviço',
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollViewWidget(
              child: Padding(
                padding: globalPadding16,
                child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CurrentContact(context),

                      TitleCard('Qual modalidade de serviço você deseja contratar?'),
                      CurrentExpertises(context),

                      Visibility(
                          visible: controller.createServiceStep.value > 0,
                          child: Column(
                              children: [
                                TitleCard('Para quando você quer o serviço?'),
                                CurrentDate(context),
                              ])),

                      Visibility(
                          visible: controller.createServiceStep.value > 1,
                          child: Column(
                              children: [
                                TitleCard('Qual o valor que você deseja pagar pelos serviços?'),
                                CurrentMoneyValues(context),
                              ])),

                      Visibility(
                          visible: controller.createServiceStep.value > 2,
                          child: Column(
                              children: [
                                TitleCard('Quais as formas de pagamento você quer utilizar?'),
                                CurrentPayments(context),
                              ])),

                      Visibility(
                          visible: controller.createServiceStep.value > 3,
                          child: Column(
                              children: [
                                TitleCard('Aonde você quer que o serviço seja realizado?'),
                                CurrentAddress(context),
                              ])),

                      Visibility(
                          visible: controller.createServiceStep.value > 4,
                          child: Column(
                              children: [
                                TitleCard('Você tem alguma observação extra que deseja informar aos profissionais?'),
                                CurrentObservations(context),
                                const SizedBox(height: 16,),
                                AcceptTerms(),
                              ])),

                      SizedBox(
                        key: widgetKey,
                        child: Visibility(
                          visible: controller.createServiceStep.value < 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16, bottom: 4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: appWhiteColor.withOpacity(0.5),
                                        borderRadius: defaultBorderRadius64
                                      ),
                                      child: IconButton(
                                          onPressed: () {
                                            controller.setNextStep();
                                            Future.delayed(Duration(milliseconds: 100), () {
                                              Scrollable.ensureVisible(widgetKey.currentContext!,
                                                  curve: Curves.linear, duration: Duration(milliseconds: 200));
                                            });
                                          },
                                          icon: const Icon(Icons.arrow_downward_rounded,
                                              color: appNormalPrimaryColor)),
                                    ),
                                  ),
                                  Text('Próximo passo', style: appStyle.bodySmall),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(() => Padding(
            padding: const EdgeInsets.all(16.0),
            child: ActionButtonWidget(
              title: 'FINALIZAR',
              function: controller.isValidatedPayments.isTrue
                  && controller.isValidatedExpertises.isTrue
                  && controller.isValidatedDateService.isTrue
                  && controller.isValidatedMoneyValues.isTrue
                  && controller.isTermsAccepted.isTrue
                  && controller.createServiceStep.value == 5
                  ? () {
                controller.submitServiceToFirebase();
                Get.back();
              } : null,
              color: appNormalPrimaryColor,
            ),
          )),
        ],
      ),
    );
  }

  Widget AcceptTerms() {
    return Obx(() => Row(
      children: [
        Checkbox(
          onChanged: (b) {
            if(b == true) {
              globalAlertDialog(title: 'Termos da solicitação',
                labelActionButton: 'ACEITAR',
                colorOk: colorSuccess,
                text: 'Ao enviar sua solicitação para realizar o serviço, você concorda com os seguintes termos:\n\n'
                    'Em caso da aceitação da sua proposta por um profissional, você confirma que\n'
                    '1) se compromete em pagar o profissional com o valor combinado\n'
                    '2) se compromete em pagar o profissional com uma das formas de pagamento combinadas\n'
                    '3) o serviço descrito é exatamente o serviço que eu preciso, sem adicionais\n'
                    '4) em caso de necessidade de adicionais, os mesmos serão negociados pessoalmente\n'
                    '5) não irá recusar o profissional após a aprovação da proposta\n'
                    '6) irá cumprir com o que foi acordado entre as partes\n'
                    '7) irá avisar o cliente com antecedência em caso de algum imprevisto acontecer\n\n'
                    'O descumprimento de um dos termos, resultará em penalidade para o usuário que descumprir os termos.\n'
                    'Essa penalidade poderá ser desde uma avaliação negativa em seu perfil, podendo chegar até a um '
                    'banimento permanente de sua conta.',
                onPressedAction: () {
                  controller.setTermsAccept(true);
                  Get.back();
                },
              );
            } else {
              controller.setTermsAccept(false);
            }
          },
          value: controller.isTermsAccepted.value,
        ),
        const Text('Li e concordo com os termos'),
      ],
    ));
  }

  Widget TitleCard(String title, {double top = 24.0}) {
    return
      Padding(
        padding: EdgeInsets.only(top: top, bottom: 4.0),
        child: Text(title,
            textAlign: TextAlign.start,
            style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
      );
  }

  // CONTACT
  Widget CurrentContact(context) {
    return CustomContainerTitle('Dados para contato',
      child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ', style: appStyle.bodyMedium),
                Expanded(
                  child: Text('${controller.serviceClientName.value}',
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.end,
                      style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Número principal: ', style: appStyle.bodyMedium),
                Expanded(
                  child: Text('${getMaskedPhoneNumber(controller.servicePhone1.value)}',
                      textAlign: TextAlign.end,
                      style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Número opcional: ', style: appStyle.bodyMedium),
                Expanded(
                  child: Text(controller.servicePhone2.value.isNotEmpty
                      ? '${getMaskedPhoneNumber(controller.servicePhone2.value)}' : 'Não informado',
                      textAlign: TextAlign.end,
                      style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Whatsapp: ', style: appStyle.bodyMedium),
                Expanded(
                  child: Text(controller.serviceWhatsapp.value.isNotEmpty
                      ? '${getMaskedPhoneNumber(controller.serviceWhatsapp.value)}' : 'Não informado',
                      textAlign: TextAlign.end,
                      style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // DATE
  Widget CurrentDate(context) {
    return CustomContainerTitle('Horário do serviço',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text('Data inicial',
                  textAlign: TextAlign.center,
                  style: appStyle.bodyMedium)),
              const SizedBox(width: 8.0),
              Expanded(child: Text('Data limite',
                  textAlign: TextAlign.center,
                  style: appStyle.bodyMedium)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: CustomInkWell(
                    backgroundColor: appLightGreyColor.withOpacity(0.25),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(()=>Text('${dateTimeFormat(controller.serviceDateMin.value).replaceAll(' ', '\n')}',
                          softWrap: true,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500))),
                    ),
                    onTap: () async {
                      DateTime? picked = await showDialog(
                          context: context,
                          builder: (context) => DatePickerDialog(
                            initialDate: controller.serviceDateMin.value,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 365)),
                          ));
                      TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now());

                      if(picked != null && time != null) {
                        picked = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
                        controller.setServiceDateMin(picked);
                        if(controller.serviceDateMax.value.isBefore(picked)) {
                          controller.setServiceDateMax(picked);
                        }
                      }
                    },
                  )),
              const SizedBox(width: 8.0),
              Expanded(
                  child: CustomInkWell(
                    backgroundColor: appLightGreyColor.withOpacity(0.25),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(()=>Text('${dateTimeFormat(controller.serviceDateMax.value).replaceAll(' ', '\n')}',
                          softWrap: true,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500))),
                    ),
                    onTap: () async {
                      DateTime? picked = await showDialog(
                          context: context,
                          builder: (context) => DatePickerDialog(
                            initialDate: controller.serviceDateMax.value,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 365)),
                          ));
                      TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now());

                      if(picked != null && time != null) {
                        picked = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
                        controller.setServiceDateMax(picked);
                      }
                    },
                  )),
            ],
          ),
        ],
      ),
    );
  }

  // ADDRESS
  Widget CurrentAddress(context) {
    return CustomContainerTitle('Endereço onde o serviço será prestado',
      help: 'Você pode selecionar o seu endereço pessoal ou '
          'cadastrar um novo somente para esse serviço.',
      child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Endereço selecionado', style: appStyle.bodySmall),
                CustomInkWell(
                  borderRadius: defaultBorderRadius4,
                  backgroundColor: appNormalPrimaryColor.withOpacity(0.75),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text('Alterar endereço',
                        style: appStyle.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: appWhiteColor)),
                  ),
                  onTap: () {
                    openModalBottomSheet(context,
                      title: 'Alterar endereço do serviço',
                      child: EditCurrentAddress(),
                      showClose: true,
                      expandedBody: true,
                      textButton: 'ATUALIZAR ENDEREÇO',
//                      heightModal: 548,
                      hideButton: true,
                    );
                  },
                ),
              ],
            ),
            const Divider(height: 16, thickness: 1, color: appWhiteColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cidade: ', style: appStyle.bodyMedium),
                Expanded(
                  child: Text('${controller.serviceCity.value} - ${controller.serviceProvince.value} '
                      '(${getMaskedZipCode(controller.serviceCep.value)})',
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.end,
                      style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Logradouro: ', style: appStyle.bodyMedium),
                Expanded(
                  child: Text('${controller.serviceStreet.value}',
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.end,
                      style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bairro: ', style: appStyle.bodyMedium),
                Expanded(
                  child: Text('${controller.serviceDistrict.value}, '
                      'nº ${controller.serviceNumber.value}',
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.end,
                      style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            Visibility(
              visible: controller.serviceComplement.value.trim() != '',
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Complemento: '),
                    Text(controller.serviceComplement.value),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            OpenAddressOnMap(ProfileModel(
              addressCEP: controller.serviceCep.value,
              addressCity: controller.serviceCity.value,
              addressComplement: controller.serviceComplement.value,
              addressDistrict: controller.serviceDistrict.value,
              addressNumber: controller.serviceNumber.value,
              addressProvince: controller.serviceProvince.value,
              addressStreet: controller.serviceStreet.value,
            )),
          ],
        ),
      ),
    );
  }

  Widget EditCurrentAddress() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Buscar novo endereço por CEP', style: appStyle.bodySmall)),
          const SizedBox(height: 8),
          Obx(() => TextFieldWidget(
              label: "CEP",
              hintText: '00000-000',
              type: TextInputType.number,
              controller: controller.serviceCepController,
              suffixIcon: IconButton(
                icon: Icon(Icons.search_rounded,
                    color: controller.cepError.value != ''
                        ? appNormalGreyColor : appNormalPrimaryColor),
                onPressed: controller.cepError.value != ''
                    ? null : () => controller.searchByCep(_formKey.currentState),
              ),
              onChanged: (s) => controller.checkToEnableUpdateAddress(),
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
                    controller: controller.serviceCityController,
                    onChanged: (s) => controller.checkToEnableUpdateAddress(),
                    validator: (String value) => value.isEmpty
                        ? 'Preencha corretamente' : null),
              ),
              const SizedBox(width: 8,),
              Expanded(
                flex: 2,
                child: TextFieldWidget(
                    label: "UF",
                    type: TextInputType.text,
                    controller: controller.serviceProvinceController,
                    onChanged: (s) => controller.checkToEnableUpdateAddress(),
                    validator: (String value) => value.isEmpty
                        ? 'Preencha corretamente' : null),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: TextFieldWidget(
                    label: "Logradouro/Rua",
                    type: TextInputType.text,
                    controller: controller.serviceStreetController,
                    onChanged: (s) => controller.checkToEnableUpdateAddress(),
                    validator: (String value) => value.isEmpty
                        ? 'Preencha corretamente' : null),
              ),
              const SizedBox(width: 8,),
              Expanded(
                flex: 2,
                child: TextFieldWidget(
                    label: "Número",
                    type: TextInputType.text,
                    controller: controller.serviceNumberController,
                    onChanged: (s) => controller.checkToEnableUpdateAddress(),
                    validator: (String value) => value.isEmpty
                        ? 'Preencha corretamente' : null),
              ),
            ],
          ),
          TextFieldWidget(
              label: "Bairro",
              type: TextInputType.text,
              controller: controller.serviceDistrictController,
              validator: (String value) => value.isEmpty
                  ? 'Preencha corretamente' : null),
          TextFieldWidget(
              label: "Complemento",
              type: TextInputType.text,
              controller: controller.serviceComplementController,
              onChanged: (s) => controller.checkToEnableUpdateAddress(),
              validator: (String value) => null),
          const Spacer(),
          Obx(() => Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ActionButtonWidget(
              title: 'CONFIRMAR ALTERAÇÃO',
              function: controller.isValidatedForm.isTrue ? () {
                controller.updateCurrentAddress();
                Get.back();
              } : null,
              color: appNormalPrimaryColor,
            ),
          )),
        ],
      ),
    );
  }

  // EXPERTISES
  Widget CurrentExpertises(context) {
    return CustomContainerTitle('Modalidade de serviço',
      help: 'Selecione a modalidade de serviço a qual você precisa de um profissional para realizá-lo',
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Serviços escolhidos', style: appStyle.bodySmall),
              CustomInkWell(
                borderRadius: defaultBorderRadius4,
                backgroundColor: appNormalPrimaryColor.withOpacity(0.75),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text('Adicionar',
                      style: appStyle.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: appWhiteColor)),
                ),
                onTap: () {
                  openModalBottomSheet(context,
                    title: 'Adicionar modalidade de serviço',
                    child: EditExpertises(),
                    showClose: true,
                    expandedBody: true,
                    hideButton: true,
                    textButton: 'ATUALIZAR',
                  );
                },
              ),
            ],
          ),
          const Divider(height: 16, thickness: 1, color: appWhiteColor),
          controller.serviceExpertise.isEmpty ?
          Text('Nenhum serviço selecionado, clique em adicionar',
              softWrap: true,
              textAlign: TextAlign.center,
              style: appStyle.bodySmall) :
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.start,
            runSpacing: 8,
            spacing: 8,
            children: controller.serviceExpertise
                .map((e) => SkillContainer(e)).toList(),
          ),
        ],
      ),
      ),
    );
  }

  Widget EditExpertises() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(defaultPadding16 / 2, 0, defaultPadding16 / 2, defaultPadding16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selecione a modalidade de serviço que você quer contratar', style: appStyle.bodySmall,),
          Expanded(
            child: GlobalListViewBuilderWidget(
                itemCount: allExpertises.length,
                itemBuilder: (_, index) {
                  var expertise = allExpertises[index];
                  var subExpertises = expertise['value'];
                  return CustomCheckboxWidget(
                      onCheck: (checked) => controller.addProfessionalExpertises(expertise: checked),
                      onUncheck: (unchecked) => controller.removeProfessionalExpertises(expertise: unchecked),
                      parent: Text(expertise['title']),
                      checkList: controller.serviceExpertise,
                      children: subExpertises.map((e) =>
                          Text(e.toString())).toList());
                }),
          ),
          Obx(() => Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ActionButtonWidget(
              title: 'CONFIRMAR ALTERAÇÃO',
              function: controller.isValidatedExpertises.isTrue ? () {
                Get.back();
              } : null,
              color: appNormalPrimaryColor,
            ),
          )),
        ],
      ),
    );
  }

  // PAYMENTS
  Widget CurrentPayments(context) {
    return CustomContainerTitle('Formas de pagamento',
      help: 'Selecione quais formas de pagamento você deseja utilizar para pagar os serviços',
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pagamentos escolhidos', style: appStyle.bodySmall),
              CustomInkWell(
                borderRadius: defaultBorderRadius4,
                backgroundColor: appNormalPrimaryColor.withOpacity(0.75),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text('Adicionar',
                      style: appStyle.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: appWhiteColor)),
                ),
                onTap: () {
                  openModalBottomSheet(context,
                    title: 'Adicionar formas de pagamento',
                    child: PaymentFormWidget(),
                    showClose: true,
                    expandedBody: true,
                    hideButton: true,
                    textButton: 'ATUALIZAR',
                  );
                },
              ),
            ],
          ),
          const Divider(height: 16, thickness: 1, color: appWhiteColor),
          controller.servicePayment.isEmpty ?
          Text('Nenhuma forma selecionada, clique em adicionar',
              softWrap: true,
              textAlign: TextAlign.center,
              style: appStyle.bodySmall) :
          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.start,
            runSpacing: 8,
            spacing: 8,
            children: controller.servicePayment
                .map((e) => SkillContainer(e)).toList(),
          ),
        ],
      )),
    );
  }

  Widget PaymentFormWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(defaultPadding16 / 2, 0, defaultPadding16 / 2, defaultPadding16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selecione as formas de pagamento que você deseja', style: appStyle.bodySmall,),
          Expanded(
            child: GlobalListViewBuilderWidget(
                itemCount: 1,
                itemBuilder: (_, index) {
                  return CustomCheckbox(
                      onCheck: (checked) => controller.addPaymentsMethods(payment: checked),
                      onUncheck: (unchecked) => controller.removePaymentsMethods(payment: unchecked),
                      checkList: controller.servicePayment,
                      children: allPaymentMethods.map((e) =>
                          Text(e.toString())).toList());
                }),
          ),
          Obx(() => Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ActionButtonWidget(
              title: 'CONFIRMAR ALTERAÇÃO',
              function: controller.isValidatedPayments.isTrue ? () {
                Get.back();
              } : null,
              color: appNormalPrimaryColor,
            ),
          )),
        ],
      ),
    );
  }

  // OBSERVATIONS
  Widget CurrentObservations(context) {
    return CustomContainerTitle('Observações extras',
      help: 'Informações extras referente aos serviços que você deseja contratar.',
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Informe mais detalhes', style: appStyle.bodySmall),
              CustomInkWell(
                borderRadius: defaultBorderRadius4,
                backgroundColor: appNormalPrimaryColor.withOpacity(0.75),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text('Editar',
                      style: appStyle.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: appWhiteColor)),
                ),
                onTap: () {
                  openModalBottomSheet(context,
                    title: 'Editar informações extras',
                    child: EditObservations(),
                    showClose: true,
                    expandedBody: true,
                    textButton: 'ATUALIZAR',
                    hideButton: true,
                  );
                },
              ),
            ],
          ),
          const Divider(height: 16, thickness: 1, color: appWhiteColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(controller.serviceObservations.value.isNotEmpty
                    ? '${controller.serviceObservations.value}'
                    : 'Clique em editar pra adicionar uma informação',
                    softWrap: true,
                    textAlign: TextAlign.start,
                    style: appStyle.bodySmall),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget EditObservations() {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Aqui você pode detalhar melhor o que você precisa, '
                'assim o profissional saberá exatamente o que precisará fazer '
                'se aceitar a sua solicitação.',
                style: appStyle.bodySmall)),
        const SizedBox(height: 8),
        TextFieldWidget(
            label: "Observações",
            maxLines: 7,
            minLines: 7,
            type: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: controller.serviceObservationsController,
            validator: (String value) => null),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ActionButtonWidget(
            title: 'ATUALIZAR',
            function: () {
              controller.updateObservations();
              Get.back();
            },
            color: appNormalPrimaryColor,
          ),
        ),
      ],
    );
  }

  // MONEY VALUES
  Widget CurrentMoneyValues(context) {
    return CustomContainerTitle('Oferta de preço',
      help: 'Informe qual o valor mínimo e máximo que você quer pagar pelo serviço.',
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Sua oferta de pagamento será de\n',
                    style: appStyle.bodySmall,
                    children: <TextSpan>[
                      TextSpan(text: ' R\$ ${controller.serviceMinPrice.value} ',
                        style: appStyle.bodySmall?.copyWith(
                            color: appNormalPrimaryColor, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: 'até', style: appStyle.bodySmall),
                      TextSpan(text: ' R\$ ${controller.serviceMaxPrice.value} ',
                        style: appStyle.bodySmall?.copyWith(
                            color: appNormalPrimaryColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CustomInkWell(
                borderRadius: defaultBorderRadius4,
                backgroundColor: appNormalPrimaryColor.withOpacity(0.75),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text('Editar',
                      style: appStyle.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: appWhiteColor)),
                ),
                onTap: () {
                  openModalBottomSheet(context,
                    title: 'Editar oferta de preço',
                    child: EditMoneyValues(),
                    showClose: true,
                    textButton: 'ATUALIZAR',
                    hideButton: true,
                    heightModal: 496,
                  );
                },
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget EditMoneyValues() {
    return Obx(() => Form(
        key: _formKey,
        onChanged: controller.validateMoneyValues(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Expanded(
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Informe uma oferta de preço que você deseja pagar '
                      'pelo serviço realizado.\n\n'
                      'Esse valor irá ajudar os profissionais a decidirem se irão '
                      'aceitar a oferta ou recusar.',
                      style: appStyle.bodySmall)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                        label: "Valor mínimo",
                        type: TextInputType.number,
                        controller: controller.serviceMinPriceController,
                        onChanged: controller.setMoneyValues,
                        inputFormatter: [
                          maskFormatterMoney
                        ],
                        validator: (String value) => value.isEmpty
                            ? 'Preencha um valor mínimo' : null),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFieldWidget(
                        label: "Valor máximo",
                        type: TextInputType.number,
                        controller: controller.serviceMaxPriceController,
                        onChanged: controller.setMoneyValues,
                        inputFormatter: [
                          maskFormatterMoney
                        ],
                        validator: (String value) => value.isEmpty
                            ? 'Preencha um valor máximo' : null),
                  ),
                ],
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ActionButtonWidget(
                    title: 'ATUALIZAR',
                    function: controller.isValidatedMoneyValues.isTrue ? () {
                      controller.updateMinMaxPrices();
                      Get.back();
                    } : null,
                    color: appNormalPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
