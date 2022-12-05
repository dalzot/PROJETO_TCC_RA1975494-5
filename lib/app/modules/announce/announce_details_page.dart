import 'package:delivery_servicos/app/global/widgets/body/custom_scaffold.dart';
import 'package:delivery_servicos/app/global/widgets/body/custom_tabs.dart';
import 'package:delivery_servicos/app/global/widgets/modal_sheet/modal_bottom_sheet.dart';
import 'package:delivery_servicos/app/modules/announce/model/proposal_model.dart';
import 'package:delivery_servicos/app/modules/announce/widgets/announce_body_widget.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../core/util/global_functions.dart';
import '../../global/constants/constants.dart';
import '../../global/constants/styles_const.dart';
import '../../global/widgets/buttons/action_button_widget.dart';
import '../../global/widgets/buttons/custom_inkwell.dart';
import '../../global/widgets/small/custom_containers_widget.dart';
import '../../global/widgets/textfields/text_field_widget.dart';
import 'controller/announce_controller.dart';
import 'model/service_model.dart';
import 'widgets/proposal_received_widget.dart';

class AnnounceDetailsPage extends GetView<AnnounceController> {
  final ServiceModel service;
  final Function()? onDeleteRequest;
  final ProposalModel? myServiceProposal;
  final String? fromRoute;
  const AnnounceDetailsPage({
    required this.service,
    this.myServiceProposal,
    this.fromRoute,
    this.onDeleteRequest,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: appBackgroundColorDark,
      showDrawerMenu: false,
      showBottomMenu: false,
      backRoute: fromRoute,
      actions: controller.checkIfMyRequest(service.clientId)
          && controller.checkStatusService(service.status) ? [
        IconButton(
            onPressed: () {
              globalAlertDialog(
                title: 'Deletar solicitação de serviço',
                labelActionButton: 'confirmar',
                text: 'Você tem certeza de que deseja deletar sua solicitação de serviço?',
                onPressedAction: onDeleteRequest ?? () {});
            },
            icon: const Icon(Icons.delete_forever_rounded))
      ] : null,
      pageTitle: 'Solicitação de Serviço',
      bottomBar: checkUserType(controller.userLogged.profileType)
          ? (myServiceProposal != null ?
      CurrentMyProposal(context, myServiceProposal!) :
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ActionButtonWidget(
          title: 'ENVIAR PROPOSTA',
          function: () {
            openModalBottomSheet(context,
                title: 'Enviar proposta',
                showClose: true,
                hideButton: true,
                expandedBody: true,
                child: ProposalWidget(context));
          },
          color: appNormalPrimaryColor,
        ),
      )) : null,
      body: controller.checkIfMyRequest(service.clientId) ?
      CustomTabs(
        labels: [
          'Dados da Solicitação',
          'Propostas Recebidas'
        ],
        tabs: [
          AnnounceBodyWidget(service: service, showCallButons: false),
          ProposalReceivedWidget(service: service),
        ],
      ) :
      AnnounceBodyWidget(service: service),
    );
  }

  Widget AcceptTerms(context) {
    return Obx(() => Row(
      children: [
        Checkbox(
          onChanged: (b) {
            if(b == true) {
              globalAlertDialog(title: 'Termos da proposta',
                labelActionButton: 'ACEITAR',
                colorOk: colorSuccess,
                text: 'Ao enviar a proposta para realizar o serviço solicitado, você concorda com os seguintes termos:\n\n'
                    'Em caso da aprovação da sua proposta, você confirma que\n'
                    '1) se compromete em executar o serviço aqui descritos\n'
                    '2) se compromete em realizar um serviço de qualidade\n'
                    '3) se compromete em avaliar o cliente após a finalização do serviço\n'
                    '4) não irá cancelar o serviço do cliente sem aviso prévio'
                    '5) irá cumprir o serviço, honrando com o que foi acordado\n'
                    '6) irá avisar o cliente com antecedência em caso de algum imprevisto acontecer\n\n'
                    'O descumprimento de um dos termos, resultará em penalidade para o usuário que descumprir os termos.\n'
                    'Essa penalidade poderá ser desde uma avaliação negativa em seu perfil, podendo chegar até a um '
                    'banimento permanente de sua conta.',
                onPressedAction: () {
                  FocusScope.of(context).unfocus();
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
        const Text('Li e concordo com os termos de serviço'),
      ],
    ));
  }

  // PROPOSAL WIDGET
  Widget ProposalWidget(context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Informe sua proposta de valor para o cliente.',
                style: appStyle.bodySmall)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFieldWidget(
                  label: "Valor da proposta",
                  type: TextInputType.number,
                  controller: controller.proposalPriceController,
                  onChanged: controller.setServiceProposalPrice,
                  inputFormatter: [
                    maskFormatterMoney
                  ],
                  validator: (String value) => value.isEmpty
                      ? 'Preencha um valor' : null),
            ),
            const SizedBox(width: 8),
            const Expanded(child: SizedBox()),
          ],
        ),

        Align(
            alignment: Alignment.centerLeft,
            child: Text('Você quer enviar alguma mensagem para o cliente?',
                style: appStyle.bodySmall)),
        const SizedBox(height: 8),
        TextFieldWidget(
            label: "Observações",
            maxLines: 5,
            minLines: 5,
            type: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: controller.proposalObservationsController,
            validator: (String value) => null),

        AcceptTerms(context),

        const Spacer(),
        Obx(() => ActionButtonWidget(
          title: 'ENVIAR PROPOSTA',
          function: controller.isValidatedProposalPrice.isTrue
              && controller.isTermsAccepted.isTrue ? ()  async {
            Get.back();
            await controller.submitProposalToClient(service);
//              Get.offAllNamed(Routes.myServices);
          } : null,
          color: appNormalPrimaryColor,
        ),
        ),
      ],
    );
  }

  // MY PROPOSAL
  Widget CurrentMyProposal(context, ProposalModel proposal) {
    return Container(
      color: appLightGreyColor.withOpacity(0.75),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomContainerTitle('Minha proposta',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: 'Oferta de preço enviada',
                  style: appStyle.bodySmall,
                  children: <TextSpan>[
                    TextSpan(text: ' R\$ ${proposal.price.toString()} ',
                      style: appStyle.bodySmall?.copyWith(
                          color: appNormalPrimaryColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Divider(height: 16, thickness: 1, color: appLightGreyColor),
              Text('Observações informadas:',
                  textAlign: TextAlign.center,
                  style: appStyle.bodySmall),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(proposal.observations.toString(),
                        softWrap: true,
                        textAlign: TextAlign.start,
                        style: appStyle.bodySmall),
                  ),
                ],
              ),
              const Divider(height: 16, thickness: 1, color: appLightGreyColor),
              Row(
                children: [
                  if((myServiceProposal != null && myServiceProposal!.status == 'enviada')) ...[
                    Expanded(
                      child: CustomInkWell(
                        onTap: () => globalAlertDialog(
                            title: 'Remover proposta',
                            text: 'Você deseja remover sua proposta dessa solicitação de serviço?',
                            labelActionButton: 'CONFIRMAR',
                            onPressedAction: () async {
                              await controller.removeMyProposal(service);
                            }),
                        backgroundColor: colorDanger.withOpacity(0.5),
                        borderRadius: defaultBorderRadius8,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.remove_circle_outline_rounded, color: appExtraLightGreyColor,),
                              const SizedBox(width: 8),
                              Text('REMOVER',
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  style: appStyle.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: appExtraLightGreyColor)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: appLightGreyColor.withOpacity(0.5),
                          borderRadius: defaultBorderRadius8
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GetIconByStatus(proposal.status.toString()),
                            const SizedBox(width: 8),
                            Text(proposal.status.toString().toUpperCase(),
                                softWrap: true,
                                textAlign: TextAlign.start,
                                style: appStyle.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
