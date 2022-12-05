import 'package:delivery_servicos/core/services/auth_service.dart';
import 'package:delivery_servicos/core/util/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';

import '../../../../core/theme/app_color.dart';
import '../../constants/styles_const.dart';

class BottomMenuWidget extends StatelessWidget {
  BottomMenuWidget({Key? key}) : super(key: key);

  AuthServices authService = Get.find<AuthServices>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 1,
          width: Get.width,
          color: appLightGreyColor,
        ),
        Container(
          color: appExtraLightGreyColor,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(0),
          width: Get.width,
          height: 62,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                generateButton(
                  label: 'INÍCIO',
                  icon: Icons.home_rounded,
                  color: getColor(Routes.home),
                  showLabel: showLabel(Routes.home),
                  onPressed: () async {
                    Get.offNamed(Routes.home);
                  },
                ),
                if(checkUserType(authService.userLogged.profileType)) // SE FOR PROFISSIONAL MOSTRA O BOTÃO DE SERVIÇOS
                  generateButton(
                    label: 'SERVIÇOS',
                    icon: Icons.home_repair_service_rounded,
                    color: getColor(Routes.myServices),
                    showLabel: showLabel(Routes.myServices),
                    onPressed: () async {
                      Get.offNamed(Routes.myServices);
                    },
                  ),
                if(!checkUserType(authService.userLogged.profileType)) // SE FOR CLIENTE MOSTRA O BOTÃO DOS ANÚNCIOS QUE ELE FEZ
                  generateButton(
                    label: 'MEUS PEDIDOS',
                    icon: Icons.receipt_long_rounded,
                    color: getColor(Routes.myRequests),
                    showLabel: showLabel(Routes.myRequests),
                    onPressed: () async {
                      Get.offNamed(Routes.myRequests);
                    },
                  ),
                generateButton(
                  label: 'PERFIL',
                  icon: Icons.person_rounded,
                  color: getColor(Routes.profile),
                  showLabel: showLabel(Routes.profile),
                  onPressed: () async {
                    Get.offNamed(Routes.profile);
                  },
                ),
                generateButton(
                  label: 'CHAT',
                  icon: Icons.chat_rounded,
                  color: getColor(Routes.chat),
                  showLabel: showLabel(Routes.chat),
                  onPressed: () async {
                    Get.offNamed(Routes.chat);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget generateButton({
  required String label,
  required IconData icon,
  required Color color,
  required bool showLabel,
  Function()? onPressed,
}) {
  double iconSize = Get.width * 0.06 > 30 ? 30 : Get.width * 0.06;
  double fontSize = Get.width * 0.025 > 10 ? 10 : Get.width * 0.025;
  return SizedBox(
    width: Get.width / 4.5,
    height: 42,
    child: IconButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(0),
      alignment: Alignment.center,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: iconSize,
          ),
          const SizedBox(height: 4),
          Text(label.toUpperCase(),
            style: appStyle.bodySmall?.copyWith(
                color: color,
                fontSize: fontSize,
                fontWeight: showLabel ? FontWeight.w400 : FontWeight.w700
            ),
          ),
        ],
      ),
    ),
  );
}

Color getColor(String routeName) {
  if (routeName == Get.currentRoute) {
    return appNormalPrimaryColor;
  } else {
    return appNormalGreyColor;
  }
}

bool showLabel(String routeName) => (routeName == Get.currentRoute);