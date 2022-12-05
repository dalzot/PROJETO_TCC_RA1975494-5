import 'package:delivery_servicos/app/global/widgets/body/custom_scaffold.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:delivery_servicos/app/modules/announce/controller/request_controller.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../routes/app_pages.dart';
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
