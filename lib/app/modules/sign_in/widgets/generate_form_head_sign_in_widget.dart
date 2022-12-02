import 'package:delivery_servicos/app/global/widgets/small/logo_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/constants/constants.dart';

class GenerateFormHeadSignInWidget extends StatelessWidget {
  const GenerateFormHeadSignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        smallLogoAppWithBack(),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Seu app de serviços",
              style: Get.textTheme.bodyLarge,
            ),
          ),
        ),
      ],
    );
  }
}
