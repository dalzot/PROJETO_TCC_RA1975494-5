import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:delivery_servicos/app/global/widgets/modal_sheet/modal_bottom_sheet.dart';
import 'package:delivery_servicos/app/modules/announce/widgets/announce_card_widget.dart';
import 'package:delivery_servicos/app/modules/home/widgets/home_banner_ads_widget.dart';
import 'package:delivery_servicos/app/modules/home/widgets/home_filters_widget.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../core/mixin/loader_content.dart';
import '../../../core/theme/app_color.dart';
import '../../global/constants/styles_const.dart';
import '../../global/widgets/body/custom_scaffold.dart';
import '../profile/widgets/professional_card_widget.dart';
import 'controller/home_controller.dart';
import 'widgets/home_banner_slider_widget.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageTitle: '',
      pageTitleWidget: SizedBox(
        height: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("HeyJobs"),
            Text('Seu app de serviços',
                style: appStyle.bodySmall?.copyWith(color: appWhiteColor)),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(appWhiteColor.withOpacity(0.15))
            ),
            icon: Icon(Icons.filter_list_rounded, color: appWhiteColor),
            label: Text('Filtros', style: TextStyle(color: appWhiteColor),),
            onPressed: () {
              openModalBottomSheet(
                context,
                title: 'Filtro de Profissionais',
                onTapButton: () {
                  Get.back();
                  if(controller.typeFilter.value) {
                    controller.getServicesByFilters();
                  } else {
                    controller.getProfessionalByFilters();
                  }
                },
                textButton: 'Buscar',
                iconButton: Icons.search_rounded,
                child: HomeFiltersWidget(),
                expandedBody: true,
                showClose: true,
                clearFilters: controller.filteringEnabled.value ? () {
                  Get.back();
                  controller.cleanFilter();
                } : null
              );
            },
          ),
        )
      ],
      body: Column(
        children: [
          Obx(() => Visibility(
              visible: controller.filteredProfessionalsAds.isNotEmpty,
              child: Container(
                width: Get.width,
                height: 196,
                color: appDarkPrimaryColor,
                child: Padding(
                  padding: const EdgeInsets
                      .fromLTRB(defaultPadding16 / 2, 0, defaultPadding16 / 2, defaultPadding16 / 2),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Profissionais em Destaque',
                          style: appStyle.titleSmall
                              ?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: appWhiteColor
                          ),
                        ),
                      ),
                      const HomeBannerProfessionalWidget(),
                    ],
                  ),
                ),
              ),
            )),
          Obx(() => Visibility(
            visible: controller.closeBannerMessage.isTrue && controller.filteringEnabled.isFalse,
              child: Container(
                color: appLightGreyColor.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Lista de ${controller.typeFilter.value ? 'serviços' : 'profissionais'} na sua região',
                          style: appStyle.bodyMedium?.copyWith(
                              color: appNormalGreyColor.withOpacity(0.75))),
                      IconButton(
                          onPressed: () => controller.setCloseBannerMessage(),
                          icon: Icon(Icons.close_rounded,
                            color: appNormalGreyColor.withOpacity(0.75)))
                    ],
                  ),
                ),
              ),
          )),
          Obx(() => controller.typeFilter.value
              ? ListServicesFiltereds() : ListProfessionalsFiltereds())
        ],
      ),
    );
  }

  Widget ListProfessionalsFiltereds() {
    return Obx(() => Expanded(
        child:controller.filteredProfessionals.isEmpty
            && controller.filterEnabled.value
            ? const EmptyListWidget(message: 'Nenhum profissional encontrado,\ntente alterar os filtros')
            : controller.filteredProfessionals.isEmpty
            ? const EmptyListWidget(message: 'Não encontramos nenhum\nprofissional em sua região',)
            : controller.loading.value
            ? LoadingContent() : GlobalListViewBuilderWidget(
          itemCount: controller.filteredProfessionals.length,
          itemBuilder: (context, i) => ProfessionalCardWidget(profile: controller.filteredProfessionals[i]),
        ),
      ),
    );
  }

  Widget ListServicesFiltereds() {
    return Obx(() => Expanded(
        child:controller.filteredServices.isEmpty && controller.filterEnabled.value
            ? const EmptyListWidget(message: 'Nenhum serviço encontrado,\ntente alterar os filtros')
            : controller.filteredServices.isEmpty
            ? const EmptyListWidget(message: 'Não encontramos nenhum\nserviço em sua região',)
            : controller.loading.value
            ? LoadingContent() : GlobalListViewBuilderWidget(
          itemCount: controller.filteredServices.length,
          itemBuilder: (context, i) => AnnounceRequestCardWidget(service: controller.filteredServices[i]),
        ),
      ),
    );
  }
}
