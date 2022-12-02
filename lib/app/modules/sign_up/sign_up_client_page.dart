import 'package:delivery_servicos/app/global/widgets/buttons/action_button_widget.dart';
import 'package:delivery_servicos/app/global/widgets/lists/global_list_view_widget.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../../../core/util/global_functions.dart';
import '../../../routes/app_pages.dart';
import '../../global/constants/constants.dart';
import '../../global/constants/styles_const.dart';
import '../../global/widgets/body/custom_scaffold.dart';
import '../../global/widgets/textfields/password_field_widget.dart';
import '../../global/widgets/textfields/text_field_widget.dart';
import 'controller/sign_up_controller.dart';
import 'widgets/address_tab_form_widget.dart';
import 'widgets/bottom_buttons_widget.dart';
import 'widgets/personal_tab_form_widget.dart';
import 'widgets/social_tab_form_widget.dart';
import 'widgets/type_account_widget.dart';
import 'widgets/welcome_tab_widget.dart';

class SignUpClientPage extends GetView<SignUpController> {
  SignUpClientPage({Key? key})
      : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.callDialog(3);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Obx(() => Visibility(
          visible: (controller.signUpStep.value < 3),
          child: const BottomButtonsWidget(),
        )),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Obx(() {
              if(controller.signUpStep.value < 3) {
                return SingleChildScrollViewWidget(
                  child: getFormByStep(controller.signUpStep.value, context),
                );
              } else {
                return const WelcomeTabWidget(type: 'Cliente');
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget getFormByStep(int step, BuildContext context) {
    if(step == 0) {
      return PersonalFormTabWidget(
        controller: controller,
        formKey: _formKey,
      );
    } else if(step == 1) {
      return AddressTabFormWidget(
        controller: controller,
        formKey: _formKey,
      );
    } else if(step == 2) {
      return SocialTabFormWidget(
        controller: controller,
        formKey: _formKey,
      );
    } else {
      return const WelcomeTabWidget(type: 'Cliente');
    }
  }
}
