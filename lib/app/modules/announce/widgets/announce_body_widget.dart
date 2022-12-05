import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/util/global_functions.dart';
import '../../../../core/values/enums.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/buttons/custom_inkwell.dart';
import '../../../global/widgets/lists/global_list_view_widget.dart';
import '../../../global/widgets/small/custom_containers_widget.dart';
import '../../profile/models/profile_model.dart';
import '../controller/announce_controller.dart';
import '../model/proposal_model.dart';
import '../model/service_model.dart';

class AnnounceBodyWidget extends GetView<AnnounceController> {
  final ServiceModel service;
  final bool? showCallButons;
  const AnnounceBodyWidget({
    required this.service,
    this.showCallButons = true,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollViewWidget(
            child: Padding(
              padding: globalPadding16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CurrentContact(context),

                  if(showCallButons == true) ...[
                      const SizedBox(height: 16,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: LongButton('Conversar', ContactButtonType.chat, context,
                              profileId: service.clientId ?? '')),
                          const SizedBox(width: defaultPadding16),
                          Expanded(child: LongButton('Ligar', ContactButtonType.call, context,
                              phoneNumber: getRawPhoneNumber(service.phone1.toString()),
                              phoneNumber2: getRawPhoneNumber(service.phone2 ?? ''))),
                          const SizedBox(width: defaultPadding16),
                          Expanded(child: LongButton('Compartilhar', ContactButtonType.share, context)),
                        ],
                      ),
                    ],

                  const SizedBox(height: 16,),
                  CurrentExpertises(context),

                  const SizedBox(height: 16,),
                  CurrentDate(context),

                  const SizedBox(height: 16,),
                  CurrentMoneyValues(context),

                  const SizedBox(height: 16,),
                  CurrentPayments(context),

                  const SizedBox(height: 16,),
                  CurrentAddress(context),

                  const SizedBox(height: 16,),
                  CurrentObservations(context),

//                  Obx(() => Visibility(
//                    visible: controller.myProposal.value.status != ProposalModel(status: 'deletada').status
//                        || myServiceProposal != null,
//                    child: Column(
//                      children: [
//                        const SizedBox(height: 16,),
//                        CurrentMyProposal(context, myServiceProposal ?? controller.myProposal.value),
//                      ],
//                    ),
//                  )),

//                  const SizedBox(height: 16,),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget TitleCard(String title, {double top = 24.0}) {
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: 4.0),
      child: Text(title,
          textAlign: TextAlign.start,
          style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
    );
  }

  // CONTACT
  Widget CurrentContact(context) {
    return CustomContainerTitle('Dados para contato',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ', style: appStyle.bodyMedium),
              Expanded(
                child: Text('${service.clientName.toString()}',
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
                child: Text(service.phone1.toString(),
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
                child: Text(service.phone2.toString().isNotEmpty
                    ? service.phone2.toString() : 'Não informado',
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
                child: Text(service.whatsapp.isNotEmpty
                    ? service.whatsapp : 'Não informado',
                    textAlign: TextAlign.end,
                    style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ],
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
                        child: Text(service.dateMin.toString().replaceAll(' ', '\n'),
                            softWrap: true,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500))
                    ),
                  )),
              const SizedBox(width: 8.0),
              Expanded(
                  child: CustomInkWell(
                    backgroundColor: appLightGreyColor.withOpacity(0.25),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(service.dateMax.toString().replaceAll(' ', '\n'),
                            softWrap: true,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500))
                    ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cidade: ', style: appStyle.bodyMedium),
              Expanded(
                child: Text('${service.city.toString()} - ${service.province.toString()} '
                    '(${getMaskedZipCode(service.cep.toString())})',
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
                child: Text('${service.street.toString()}',
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
                child: Text('${service.district.toString()}, '
                    'nº ${service.number.toString()}',
                    softWrap: true,
                    maxLines: 2,
                    textAlign: TextAlign.end,
                    style: appStyle.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          Visibility(
            visible: service.complement.toString().trim() != '',
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Complemento: '),
                  Text(service.complement.toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          OpenAddressOnMap(ProfileModel(
            addressCEP: service.cep.toString(),
            addressCity: service.city.toString(),
            addressComplement: service.complement.toString(),
            addressDistrict: service.district.toString(),
            addressNumber: service.number.toString(),
            addressProvince: service.province.toString(),
            addressStreet: service.street.toString(),
          )),
        ],
      ),
    );
  }

  // EXPERTISES
  Widget CurrentExpertises(context) {
    return CustomContainerTitle('Modalidade de serviço',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Serviços escolhidos', style: appStyle.bodySmall),
          const Divider(height: 16, thickness: 1, color: appWhiteColor),
          service.serviceExpertise.isEmpty ?
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
            children: service.serviceExpertise
                .map((e) => SkillContainer(e)).toList(),
          ),
        ],
      ),
    );
  }

  // PAYMENTS
  Widget CurrentPayments(context) {
    return CustomContainerTitle('Formas de pagamento aceita',
      child:  Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        runAlignment: WrapAlignment.start,
        runSpacing: 8,
        spacing: 8,
        children: service.servicePayment
            .map((e) => SkillContainer(e)).toList(),
      ),
    );
  }

  // OBSERVATIONS
  Widget CurrentObservations(context) {
    return CustomContainerTitle('Observações extras',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(service.observations.toString().isEmpty
                ? 'Não foi adicionado nenhuma informação extra' : service.observations.toString(),
                softWrap: true,
                textAlign: TextAlign.start,
                style: appStyle.bodySmall),
          ),
        ],
      ),
    );
  }

  // MONEY VALUES
  Widget CurrentMoneyValues(context) {
    return CustomContainerTitle('Oferta de preço',
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          text: 'Oferta de pagamento será de\n',
          style: appStyle.bodySmall,
          children: <TextSpan>[
            TextSpan(text: ' R\$ ${service.minPrice.toString()} ',
              style: appStyle.bodySmall?.copyWith(
                  color: appNormalPrimaryColor, fontWeight: FontWeight.w600),
            ),
            TextSpan(text: 'até', style: appStyle.bodySmall),
            TextSpan(text: ' R\$ ${service.maxPrice.toString()} ',
              style: appStyle.bodySmall?.copyWith(
                  color: appNormalPrimaryColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
