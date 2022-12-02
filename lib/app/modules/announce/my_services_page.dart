import 'package:delivery_servicos/app/global/widgets/body/custom_scaffold.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:delivery_servicos/app/modules/announce/controller/announce_controller.dart';
import 'package:delivery_servicos/app/modules/announce/controller/service_controller.dart';
import 'package:delivery_servicos/app/modules/announce/widgets/my_service_card_widget.dart';
import 'package:delivery_servicos/app/modules/home/controller/home_controller.dart';
import 'package:delivery_servicos/app/modules/profile/controller/profile_controller.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../../core/mixin/loader_content.dart';
import '../../global/widgets/lists/global_list_view_widget.dart';
import 'widgets/announce_card_widget.dart';

class MyServicesPage extends GetView<ServiceController> {
  const MyServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        pageTitle: 'Meus Serviços',
        body: ListOfMyServices()
    );
  }

  Widget ListOfMyServices() {
    return Obx(() => controller.myServicesProposal.isEmpty
        ? const EmptyListWidget(message: 'Não encontramos nenhum\nserviço em sua região',)
        : controller.loadingMyServices.value
        ? LoadingContent() : GlobalListViewBuilderWidget(
      itemCount: controller.myServicesProposal.length,
      itemBuilder: (context, i) => MyServiceCardWidget(service: controller.myServicesProposal[i]),
    ),
    );
  }
}
