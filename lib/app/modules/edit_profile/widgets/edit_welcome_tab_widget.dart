import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/global/constants/styles_const.dart';
import 'package:delivery_servicos/core/theme/app_color.dart';
import 'package:delivery_servicos/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/util/global_functions.dart';
import '../../../global/widgets/buttons/action_button_widget.dart';

class EditWelcomeTabWidget extends StatelessWidget {
  final String type;
  const EditWelcomeTabWidget({required this.type, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/${checkUserType(type)
                ? 'professional_stars' : 'handshake_stars'}.png',
                width: 128, height: 128, fit: BoxFit.fitWidth),
            const SizedBox(height: defaultPadding16),
            Text("Seus dados foram atualizados no HeyJobs!",
              textAlign: TextAlign.center,
              style: appStyle.titleLarge?.copyWith(
                  color: appNormalPrimaryColor,
                  fontSize: 26)),
            const SizedBox(height: defaultPadding16),
            const Text("Agora você pode voltar ao app, seus dados já foram atualizados em nossa plataforma!",
                textAlign: TextAlign.justify),
            const SizedBox(height: defaultPadding32),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: defaultPadding32,
          child: ActionButtonWidget(
            title: 'VOLTAR AO PERFIL',
            function: () => Get.offAllNamed(Routes.profile),
          ),
        )
      ],
    );
  }
}
