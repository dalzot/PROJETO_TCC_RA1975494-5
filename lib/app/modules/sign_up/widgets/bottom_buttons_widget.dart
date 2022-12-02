import 'package:delivery_servicos/app/modules/sign_up/controller/sign_up_controller.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_color.dart';
import '../../../global/constants/constants.dart';
import '../../../global/constants/styles_const.dart';
import 'type_account_widget.dart';

class BottomButtonsWidget extends GetView<SignUpController> {
  const BottomButtonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: globalPadding16,
      child: SizedBox(
        height: 42,
        child: Row(
          children: [
            Obx(() => Visibility(
              visible: controller.signUpStep.value == 0,
              child: Expanded(
                child: TypeAccountWidget(type: controller.profileType.value),
              ),
            )),
            Obx(() => Visibility(
              visible: controller.signUpStep.value > 0,
              child: Expanded(
                child: InkWell(
                  onTap: () => controller.setPreviousSignUpStep(),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: defaultBorderRadius8,
                        border: Border.all(width: 2, color: appNormalPrimaryColor)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(Icons.arrow_back_ios_rounded, color: appNormalPrimaryColor),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Text('VOLTAR', style: appStyle.titleMedium
                                ?.copyWith(color: appNormalPrimaryColor)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
            const SizedBox(width: defaultPadding32/2),
            Expanded(
              child: Obx(() {
                bool validated = (checkUserType(controller.profileType.value)
                    ? (controller.isPersonalFormValidated.isTrue && controller.signUpStep.value == 0)
                    || (controller.isAddressFormValidated.isTrue && controller.signUpStep.value == 1)
                    || (controller.isExpertisesFormValidated.isTrue && controller.signUpStep.value == 2)
                    || (controller.isBioPaymentFormValidated.isTrue && controller.signUpStep.value == 3)
                    || (controller.signUpStep.value == 4)
                    : (controller.isPersonalFormValidated.isTrue && controller.signUpStep.value == 0)
                    || (controller.isAddressFormValidated.isTrue && controller.signUpStep.value == 1)
                    || (controller.signUpStep.value == 2));
                return InkWell(
                  onTap: validated ? () {
                    if(controller.signUpStep.value ==
                        (checkUserType(controller.profileType.value) ? 4 : 2)) {
                      controller.submitDataToFirebase();
                    } else {
                      controller.setNextSignUpStep();
                    }
                  } : null,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: defaultBorderRadius8,
                        border: Border.all(width: 2, color: validated
                            ? appNormalPrimaryColor : appNormalGreyColor)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(controller.signUpStep.value ==
                                (checkUserType(controller.profileType.value) ? 4 : 2)
                                ? 'FINALIZAR' : 'CONTINUAR', style: appStyle.titleMedium
                                ?.copyWith(color: validated
                                ? appNormalPrimaryColor : appNormalGreyColor)),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded, color: validated
                              ? appNormalPrimaryColor : appNormalGreyColor)
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
