import 'package:delivery_servicos/app/global/widgets/body/custom_scaffold.dart';
import 'package:delivery_servicos/app/global/widgets/buttons/custom_inkwell.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:delivery_servicos/app/modules/announce/controller/announce_controller.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/lists/global_list_view_widget.dart';
import 'widgets/add_request_page.dart';
import 'widgets/announce_card_widget.dart';

class MyRequestsPage extends GetView<AnnounceController> {
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
      body: Obx(() => controller.loadingMyRequests.isTrue ?
          const Center(child: CircularProgressIndicator()) :
      controller.myServicesRequests.isEmpty ?
      EmptyListWidget(
          onTap: () => openNewServicePage(),
          icon: Icons.add_circle,
          message: 'Crie sua primeira solicitação de serviço') :
      GlobalListViewBuilderWidget(
        itemCount: controller.myServicesRequests.length,
        itemBuilder: (context, i) => AnnounceRequestCardWidget(service: controller.myServicesRequests[i]),
      )),
    );
  }
}
