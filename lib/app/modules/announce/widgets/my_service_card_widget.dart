import 'package:date_time_format/date_time_format.dart';
import 'package:delivery_servicos/app/global/widgets/buttons/custom_inkwell.dart';
import 'package:delivery_servicos/app/global/widgets/small/custom_containers_widget.dart';
import 'package:delivery_servicos/app/modules/announce/announce_details_page.dart';
import 'package:delivery_servicos/app/modules/announce/controller/announce_controller.dart';
import 'package:delivery_servicos/app/modules/announce/controller/service_controller.dart';
import 'package:delivery_servicos/app/modules/announce/model/proposal_model.dart';
import 'package:delivery_servicos/app/modules/announce/model/service_model.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:delivery_servicos/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';

class MyServiceCardWidget extends GetView<ServiceController> {
  final ServiceModel service;
  MyServiceCardWidget({
    required this.service,
    Key? key}) : super(key: key);

  ProposalModel? myServiceProposal;
  @override
  Widget build(BuildContext context) {
    if(myServiceProposal == null && service.proposals!.isNotEmpty) {
      myServiceProposal = service.proposals!.firstWhere(
              (e) => e.professionalId == controller.userLogged.firebaseId);
    }
    return CustomInkWell(
      borderRadius: BorderRadius.zero,
      backgroundColor: appExtraLightGreyColor,
      onTap: () {
        Get.to(()=>AnnounceDetailsPage(service: service, myServiceProposal: myServiceProposal, fromRoute: Routes.myServices));
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
                      Text('Serviço', style: appStyle.bodyMedium?.copyWith(
                          color: appNormalGreyColor, fontWeight: FontWeight.w500)),
                      Text('${service.city} - ${service.province}',
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
                      itemCount: service.serviceExpertise!.length,
                      itemBuilder: (context, i) => Padding(
                        padding: EdgeInsets.only(right: i < service.serviceExpertise!.length-1 ? 4 : 0),
                        child: SkillContainer(service.serviceExpertise![i]),
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
                          text: 'Sua proposta:\n',
                          style: appStyle.bodySmall
                              ?.copyWith(color: appNormalGreyColor),
                          children: <TextSpan>[
                            TextSpan(text: 'R\$', style: appStyle.bodySmall),
                            TextSpan(text: myServiceProposal!.price ?? '--',
                              style: appStyle.bodyMedium?.copyWith(
                                  color: appNormalPrimaryColor, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
//                          Row(
//                            children: [
//                              Text(myServiceProposal!.dateCreated.toString().replaceAll(' ', ' às '),
//                                style: appStyle.bodyMedium,
//                                textAlign: TextAlign.end),
//                            ],
//                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GetIconByStatus(myServiceProposal!.status.toString(), size: 24),
                              const SizedBox(width: 4,),
                              Text(myServiceProposal!.status.toString(),
                                  style: appStyle.bodySmall, textAlign: TextAlign.end),
                            ],
                          ),
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
    return status == 1 ? colorSuccess : colorDanger;
  }
}
