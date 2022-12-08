import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:delivery_servicos/app/global/widgets/modal_sheet/modal_bottom_sheet.dart';
import 'package:delivery_servicos/app/modules/home/controller/home_client_controller.dart';
import 'package:delivery_servicos/app/modules/home/widgets/home_filters_widget.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../core/mixin/loader_content.dart';
import '../../../core/theme/app_color.dart';
import '../../global/constants/styles_const.dart';
import '../../global/widgets/body/custom_scaffold.dart';
import '../../global/widgets/small/custom_containers_widget.dart';
import '../profile/widgets/professional_card_widget.dart';
import 'widgets/home_banner_slider_widget.dart';

class HomeClientPage extends GetView<HomeClientController> {
  const HomeClientPage({Key? key}) : super(key: key);

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
                  controller.submitProfessionalFilterToFirebase();
                },
                textButton: 'Buscar',
                iconButton: Icons.search_rounded,
                child: Obx(() => HomeFiltersWidget(
                      statusFilter: controller.statusFilter.value,
                      setStatusFilter: controller.setStatusFilter,
                      searchByCepController: controller.searchByCepController,
                      cepError: controller.cepError.value,
                      searchByCep: controller.searchByCep,
                      cepValidator: controller.cepValidator,
                      searchCityController: controller.searchCityController,
                      searchProvinceController: controller.searchProvinceController,
                      searchStreetController: controller.searchStreetController,
                      searchDistrictController: controller.searchDistrictController,
                      addProfessionalExpertises: controller.addProfessionalExpertises,
                      removeProfessionalExpertises: controller.removeProfessionalExpertises,
                      expertisesFilter: controller.expertisesFilter,
                      addPaymentsMethods: controller.addPaymentsMethods,
                      removePaymentsMethods: controller.removePaymentsMethods,
                      paymentsFilter: controller.paymentsFilter),
                ),
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
            child: BannerText('Use os filtros para pesquisar por serviços',
                onClose: () => controller.setCloseBannerMessage()),
          )),
          ListProfessionalsFiltereds()
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
          itemBuilder: (context, i) =>
              ProfessionalCardWidget(profile: controller.filteredProfessionals[i]),
        ),
      ),
    );
  }
}
