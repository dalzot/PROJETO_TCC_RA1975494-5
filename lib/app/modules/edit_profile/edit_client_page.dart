import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/edit_controller.dart';
import 'widgets/edit_address_tab_form_widget.dart';
import 'widgets/edit_bottom_buttons_widget.dart';
import 'widgets/edit_personal_tab_form_widget.dart';
import 'widgets/edit_social_tab_form_widget.dart';
import 'widgets/edit_welcome_tab_widget.dart';

class EditClientPage extends GetView<EditController> {
  EditClientPage({Key? key})
      : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.callDialog();
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(() => Visibility(
          visible: (controller.editStep.value < 3),
          child: const EditBottomButtonsWidget(),
        )),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Obx(() {
              if(controller.editStep.value < 3) {
                return SingleChildScrollViewWidget(
                  child: getFormByStep(controller.editStep.value, context),
                );
              } else {
                return const EditWelcomeTabWidget(type: 'Cliente');
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget getFormByStep(int step, BuildContext context) {
    if(step == 0) {
      return EditPersonalFormTabWidget(
        controller: controller,
        formKey: _formKey,
      );
    } else if(step == 1) {
      return EditAddressTabFormWidget(
        controller: controller,
        formKey: _formKey,
      );
    } else if(step == 2) {
      return EditSocialTabFormWidget(
        controller: controller,
        formKey: _formKey,
      );
    } else {
      return const EditWelcomeTabWidget(type: 'Cliente');
    }
  }
}
