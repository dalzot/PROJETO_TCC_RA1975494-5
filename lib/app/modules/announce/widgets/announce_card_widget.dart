import 'package:date_time_format/date_time_format.dart';
import 'package:delivery_servicos/app/global/widgets/buttons/custom_inkwell.dart';
import 'package:delivery_servicos/app/global/widgets/small/custom_containers_widget.dart';
import 'package:delivery_servicos/app/modules/announce/announce_details_page.dart';
import 'package:delivery_servicos/app/modules/announce/controller/announce_controller.dart';
import 'package:delivery_servicos/app/modules/announce/controller/request_controller.dart';
import 'package:delivery_servicos/app/modules/announce/model/service_model.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../routes/app_pages.dart';
import '../../../global/constants/styles_const.dart';
import '../model/proposal_model.dart';

class AnnounceRequestCardWidget extends StatelessWidget {
  final ServiceModel service;
  final String? fromRoute;
  final RequestController? controller;
  AnnounceRequestCardWidget({
    required this.service,
    this.fromRoute,
    this.controller,
    Key? key}) : super(key: key);

  ProposalModel? myServiceProposal;
  @override
  Widget build(BuildContext context) {
    if(myServiceProposal == null && service.proposals.isNotEmpty
        && controller != null && checkUserType(controller!.userLogged.profileType)) {
      myServiceProposal = service.proposals.firstWhere(
              (e) => e.professionalId == controller!.userLogged.firebaseId);
    }
    return CustomInkWell(
      borderRadius: BorderRadius.zero,
      backgroundColor: appExtraLightGreyColor,
      onTap: () async {
        Get.lazyPut(() => AnnounceController(service: service));
        if(fromRoute == Routes.myRequests) {
          AnnounceController announceController = Get.find();
          await announceController.setServiceAndProposals(service);
        }
        Get.to(()=>AnnounceDetailsPage(
          service: service,
          myServiceProposal: myServiceProposal,
          fromRoute: fromRoute,
          onDeleteRequest: controller != null ? () async {
            Get.back();
            await controller!.removeMyRequest(service);
          } : null,
        ));
      },
      child: SizedBox(
        width: Get.width,
        child: Column(
          children: [
            Container(height: 1, color: appLightGreyColor),
            Container(height: 1, color: appExtraLightGreyColor),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('${service.clientName}', style: appStyle.bodyLarge
                            ?.copyWith(color: appNormalPrimaryColor, fontWeight: FontWeight.w600)),
                      ),
                      Icon(getIconByStatus(service.status), color: getColorByStatus(service.status)),
                      const Icon(Icons.open_in_new_rounded, color: appNormalPrimaryColor),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 24.0),
                    child: Divider(color: appLightGreyColor, thickness: 1, height: 8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('está contratando para:', style: appStyle.bodyMedium
                          ?.copyWith(color: appNormalGreyColor)),
                      Text('à ${dateTimeAt(service.dateCreated.toString())}',
                          style: appStyle.bodySmall?.copyWith(color: appNormalPrimaryColor, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: Get.width,
                    height: 24,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: service.serviceExpertise.length,
                      itemBuilder: (context, i) => Padding(
                        padding: EdgeInsets.only(right: i < service.serviceExpertise.length-1 ? 4 : 0),
                        child: SkillContainer(service.serviceExpertise[i]),
                      ),
                    ),
                  ),
                  const Divider(color: appLightGreyColor, thickness: 1, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          text: 'Oferta de:\n',
                          style: appStyle.bodySmall
                              ?.copyWith(color: appNormalGreyColor),
                          children: <TextSpan>[
                            TextSpan(text: 'R\$ ', style: appStyle.bodySmall),
                            TextSpan(text: '${service.minPrice}',
                              style: appStyle.bodyMedium?.copyWith(
                                  color: appNormalPrimaryColor, fontWeight: FontWeight.w600),
                            ),
                            TextSpan(text: ' ~ ', style: appStyle.bodySmall),
                            TextSpan(text: '${service.maxPrice}',
                              style: appStyle.bodyMedium?.copyWith(
                                  color: appNormalPrimaryColor, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(service.dateMin.toString().replaceAll(' ', '\nàs '),
                            style: appStyle.bodyMedium,
                            textAlign: TextAlign.center,),
                          if(service.dateMax.toString() != service.dateMin.toString())
                            ...[
                              Text(' até ', style: appStyle.bodyMedium?.copyWith(color: appNormalGreyColor)),
                              Text(service.dateMax.toString().replaceAll(' ', '\nàs '),
                                style: appStyle.bodyMedium,
                                textAlign: TextAlign.center),
                            ],
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 1, color: appNormalGreyColor),
            Container(height: 1, color: appNormalGreyColor.withOpacity(0.75)),
            Container(height: 1, color: appNormalGreyColor.withOpacity(0.5)),
            Container(height: 1, color: appNormalGreyColor.withOpacity(0.25)),
          ],
        ),
      ),
    );
  }

  Color getColorByStatus(status) {
    return status == 'disponível' ? appLightPrimaryColor // Disponível
        : status == 'finalizado' ? colorSuccess // Finalizada
        : status == 'avaliar' ? appNormalGreyColor // Não avaliado
        : colorWarning; // Executando
  }

  IconData getIconByStatus(status) {
    return status == 'disponível' ? Icons.stream // Disponível
        : status == 'finalizado' ? Icons.done_all_outlined // Finalizada
        : status == 'avaliar' ? Icons.star_outline_rounded // Não avaliado
        : Icons.wifi_protected_setup_rounded; // Executando
  }
}
