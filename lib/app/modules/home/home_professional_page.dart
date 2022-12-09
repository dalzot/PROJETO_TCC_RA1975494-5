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
import '../../global/widgets/small/custom_containers_widget.dart';
import '../profile/widgets/professional_card_widget.dart';
import 'controller/home_controller.dart';
import 'controller/home_professional_controller.dart';
import 'widgets/home_banner_slider_widget.dart';

class HomeProfessionalPage extends GetView<HomeProfessionalController> {
  const HomeProfessionalPage({Key? key}) : super(key: key);

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
                title: 'Filtro de Serviços',
                onTapButton: () {
                  Get.back();
                  controller.getServicesByFilters();
                },
                textButton: 'Buscar',
                iconButton: Icons.search_rounded,
                child: HomeFiltersWidget(
//                      setTypeFilter: controller.setTypeFilter,
//                      typeFilter: controller.typeFilter.value,
                    searchByCepController: controller.searchByCepController,
                    cepError: controller.cepError,
                    searchByCep: controller.searchByCep,
                    cepValidator: controller.cepValidator,
                    searchCityController: controller.searchCityController,
                    searchProvinceController: controller.searchProvinceController,
                    searchStreetController: controller.searchStreetController,
                    searchDistrictController: controller.searchDistrictController,
                    addProfessionalExpertises: controller.addServiceExpertises,
                    removeProfessionalExpertises: controller.removeServiceExpertises,
                    expertisesFilter: controller.expertisesFilter,
                    addPaymentsMethods: controller.addPaymentsMethods,
                    removePaymentsMethods: controller.removePaymentsMethods,
                    paymentsFilter: controller.paymentsFilter),
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
            visible: controller.closeBannerMessage.isTrue && controller.filteringEnabled.isFalse,
              child: BannerText('Use os filtros para pesquisar por serviços',
                  onClose: () => controller.setCloseBannerMessage()),
          )),
          ListServicesFiltereds()
        ],
      ),
    );
  }

  Widget ListServicesFiltereds() {
    return Obx(() => Expanded(
      child: Visibility(
        visible: controller.loading.isTrue,
        replacement: Visibility(
          visible: controller.filteredServices.isEmpty && controller.filterEnabled.value,
          replacement: GlobalListViewBuilderWidget(
            itemCount: controller.filteredServices.length,
            itemBuilder: (context, i) => AnnounceRequestCardWidget(service: controller.filteredServices[i]),
          ),
          child: const EmptyListWidget(message: 'Nenhum serviço encontrado,\ntente alterar os filtros'),
        ),
        child: LoadingContent(),
      ),
    ));
  }
}
