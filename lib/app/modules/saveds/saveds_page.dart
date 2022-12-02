import 'package:delivery_servicos/app/global/widgets/body/custom_scaffold.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:delivery_servicos/app/modules/saveds/controller/saveds_controller.dart';
import 'package:delivery_servicos/routes/routes.dart';
import 'package:flutter/material.dart';

import '../../global/widgets/lists/global_list_view_widget.dart';
import 'widgets/profile_saved_card_widget.dart';

class SavedsPage extends GetView<SavedsController> {
  const SavedsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: CustomScaffold(
        showBottomMenu: false,
        pageTitle: 'Salvos',
        body: Obx(() => controller.savedProfiles.isEmpty
            ? const EmptyListWidget(message: 'Você ainda não salvou nenhum perfil')
            : GlobalListViewBuilderWidget(
          itemCount: controller.savedProfiles.length,
          itemBuilder: (context, i) =>
              ProfilesSavedCardWidget(profile: controller.savedProfiles[i]),
        ),
      )),
    );
  }
}
