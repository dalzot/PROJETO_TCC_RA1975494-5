import 'package:delivery_servicos/app/global/widgets/body/global_list_view_widget.dart';
import 'package:delivery_servicos/app/modules/announce/controller/announce_controller.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/util/global_functions.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';
import '../../../global/widgets/buttons/custom_inkwell.dart';
import '../../../global/widgets/lists/empty_list_widget.dart';
import '../../../global/widgets/small/custom_containers_widget.dart';
import '../model/proposal_model.dart';
import '../model/service_model.dart';

class ProposalReceivedWidget extends GetView<AnnounceController> {
  final ServiceModel service;
  const ProposalReceivedWidget({
    required this.service,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
        children: [
          const SizedBox(height: 16),
          if(controller.myProposal != null)
            CurrentMyProposal(context, controller.myProposal!.value),
          if(controller.myProposal == null)
            controller.myServicesProposals.isEmpty ?
            const Expanded(
                child: Center(
                    child: EmptyListWidget(
                        message: 'Nenhuma proposta recebida'))) :
            Expanded(
              child: GlobalListViewWidget(
                children: controller.myServicesProposals.map((e) =>
                    ProposalWidget(context, e)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // PROPOSAL CARD
  Widget ProposalWidget(context, ProposalModel proposal) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: CustomContainerTitle(proposal.professionalName.toString(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: 'Oferta de pre??o',
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
            Text('Observa????es informadas:',
                textAlign: TextAlign.center,
                style: appStyle.bodySmall?.copyWith(
                  decoration: TextDecoration.underline,
                )),
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
                if(proposal.status == 'enviada')...[
                  Expanded(
                    child: CustomInkWell(
                      onTap: () => globalAlertDialog(
                          title: 'Recusar proposta',
                          text: 'Voc?? deseja recusar essa proposta?',
                          labelActionButton: 'SIM',
                          onPressedAction: () async {
                            //Get.back();
                            await controller.acceptOrRecuseProposal(service, proposal, false,
                                reason: 'Ainda n??o encontrou uma proposta adequada para o servi??o solicitado.');
                          }),
                      backgroundColor: colorDanger.withOpacity(0.75),
                      borderRadius: defaultBorderRadius8,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.close_rounded, color: appExtraLightGreyColor,),
                            const SizedBox(width: 8),
                            Text('RECUSAR',
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
                  child: CustomInkWell(
                    onTap: proposal.status == 'enviada' ? () => globalAlertDialog(
                        title: 'Aceitar proposta',
                        text: 'Voc?? deseja aceitar essa proposta?',
                        labelActionButton: 'SIM',
                        colorOk: colorSuccess,
                        onPressedAction: () async {
                          //Get.back();
                          await controller.acceptOrRecuseProposal(service, proposal, true);
                        }) : null,
                    backgroundColor: proposal.status == 'recusada'
                        ? colorDanger.withOpacity(0.5) : colorSuccess.withOpacity(0.5),
                    borderRadius: defaultBorderRadius8,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            proposal.status == 'recusada'
                                ? Icons.close_rounded : Icons.check_rounded,
                            color: appExtraLightGreyColor),
                          const SizedBox(width: 8),
                          Text(proposal.status == 'enviada' ? 'ACEITAR'
                              : proposal.status == 'aprovada' ? 'APROVADA' : 'RECUSADA',
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  // MY PROPOSAL
  Widget CurrentMyProposal(context, ProposalModel proposal) {
    return CustomContainerTitle('Minha proposta',
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: 'Oferta de pre??o enviada',
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
          Text('Observa????es informadas:',
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
              if((controller.checkMyProposalStatus()/* && myServiceProposal == null) ||
                  (myServiceProposal != null && myServiceProposal!.status == 'enviada'*/)) ...[
                Expanded(
                  child: CustomInkWell(
                    onTap: () => globalAlertDialog(
                        title: 'Remover proposta',
                        text: 'Voc?? deseja remover sua proposta dessa solicita????o de servi??o?',
                        labelActionButton: 'CONFIRMAR',
                        onPressedAction: () async {
                          await controller.removeMyProposal(service);
//                            Get.offAllNamed(Routes.home);
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
    );
  }
}
