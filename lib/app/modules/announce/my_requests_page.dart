import 'package:delivery_servicos/app/global/widgets/body/custom_scaffold.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:delivery_servicos/app/modules/announce/controller/request_controller.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../routes/app_pages.dart';
import '../../global/constants/styles_const.dart';
import '../../global/widgets/lists/global_list_view_widget.dart';
import 'widgets/add_request_page.dart';
import 'widgets/announce_card_widget.dart';

class MyRequestsPage extends GetView<RequestController> {
  const MyRequestsPage({Key? key}) : super(key: key);

  openNewServicePage() {
    Get.dialog(AddRequestPage());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageTitle: 'Minhas Solicitações',
      floatingActionButton: IconButton(
        icon: const Center(
          child: Icon(Icons.add_circle_rounded,
            color: appNormalPrimaryColor,
            size: 32),
        ),
        onPressed: () => openNewServicePage(),
      ),
      actions: [
        IconButton(
            onPressed: () {
              globalAlertDialog(
                  title: 'Legenda do Status',
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.stream, color: appLightPrimaryColor),
                          SizedBox(width: 12, height: 32),
                          Text('Disponível'),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.wifi_protected_setup_rounded, color: colorWarning),
                          SizedBox(width: 12, height: 32),
                          Text('Executando'),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.star_outline_rounded, color: appNormalGreyColor),
                          SizedBox(width: 12, height: 32),
                          Text('Não Avaliado'),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.done_all_outlined, color: colorSuccess),
                          SizedBox(width: 12, height: 32),
                          Text('Finalizado'),
                        ],
                      ),
                    ],
                  ),
                  labelActionButton: 'entendi',
                  onPressedAction: () => Get.back());
            },
            icon: Icon(Icons.help_outline_rounded))
      ],
      body: Obx(() => controller.loadingMyRequests.isTrue ?
      const Center(child: CircularProgressIndicator()) :
      controller.myRequestsList.isEmpty ?
      EmptyListWidget(
          onTap: () => openNewServicePage(),
          icon: Icons.add_circle,
          message: 'Crie sua primeira solicitação de serviço') :
      GlobalListViewBuilderWidget(
        itemCount: controller.myRequestsList.length+1,
        itemBuilder: (context, i) {
          if(i == controller.myRequestsList.length) return const SizedBox(height: 64,);
          return AnnounceRequestCardWidget(
            service: controller.myRequestsList[i],
            fromRoute: Routes.myRequests,
            controller: controller,
          );
        },
      )),
    );
  }
}
