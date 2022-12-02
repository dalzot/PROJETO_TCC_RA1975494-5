import 'package:delivery_servicos/app/global/widgets/body/custom_tabs.dart';
import 'package:delivery_servicos/app/global/widgets/lists/empty_list_widget.dart';
import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:delivery_servicos/app/modules/profile/client_details_page.dart';
import 'package:delivery_servicos/app/modules/profile/professional_details_page.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/widgets/body/custom_scaffold.dart';
import 'controller/profile_controller.dart';
import 'models/profile_model.dart';

class ProfilePage extends GetView<ProfileController> {
  ProfileModel? profileView;
  String? backRoute;
  ProfilePage({
    this.profileView,
    this.backRoute,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showDrawerMenu: profileView == null,
      showBottomMenu: profileView == null,
      backRoute: backRoute,
      actions: [
        Visibility(
          visible: profileView != null,
          child: Obx(() {
            controller.checkProfileSaved(profileView!.firebaseId);
            return IconButton(
              icon: controller.viewProfileSaved.isTrue
                  ? const Icon(Icons.bookmark_rounded) 
                  : const Icon(Icons.bookmark_border_rounded),
              onPressed: () async {
                if(controller.viewProfileSaved.isTrue) {
                  await controller.removeProfileToSaved(profileView!.firebaseId);
                } else {
                  await controller.addProfileToSaved(profileView!);
                }
              },
            );
          }),
        ),
        Visibility(
          visible: profileView == null,
          child: IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () async {
              controller.gotToEditProfile();
            },
          ),
        ),
      ],
      pageTitle: checkUserType(profileView != null ? profileView!.profileType : controller.profileModel.profileType)
          ? 'Perfil Profissional'
          : 'Perfil Cliente',
      body: checkUserType(profileView != null ? profileView!.profileType : controller.profileModel.profileType)
          ? ProfessionalDetailsPage(profileView: profileView)
          : ClientDetailsPage(profileView: profileView),
    );
  }
}
