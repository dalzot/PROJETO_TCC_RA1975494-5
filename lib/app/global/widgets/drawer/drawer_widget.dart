import 'package:delivery_servicos/app/global/constants/constants.dart';
import 'package:delivery_servicos/app/global/constants/styles_const.dart';
import 'package:delivery_servicos/app/global/widgets/modal_sheet/modal_bottom_sheet.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_style.dart';
import '../../../../core/util/global_functions.dart';
import '../../../../routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../body/global_list_view_widget.dart';
import 'drawer_list_tile_widget.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({Key? key}) : super(key: key);

  AuthServices authService = Get.find<AuthServices>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: GlobalListViewWidget(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                        Text(
                          'Menu',
                          style: AppStyle().appTextThemeLight.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 0.75,
                  color: appNormalGreyColor,
                ),
                DrawerListTileWidget(
                  text: 'Início',
                  icon: Icons.home_outlined,
                  currentRoute: Routes.home,
                  onTap: () {
                    Get.back();
                    Get.offNamed(Routes.home);
                  },
                ),
                if(checkUserType(authService.userLogged.profileType)) // SE FOR PROFISSIONAL MOSTRA O BOTÃO DE SERVIÇOS
                  DrawerListTileWidget(
                    text: 'Serviços',
                    icon: Icons.home_repair_service_rounded,
                    currentRoute: Routes.myServices,
                    onTap: () {
                      Get.back();
                      Get.offNamed(Routes.myServices);
                    },
                  ),
                if(!checkUserType(authService.userLogged.profileType)) // SE FOR PROFISSIONAL MOSTRA O BOTÃO DE SERVIÇOS
                  DrawerListTileWidget(
                    text: 'Meus Pedidos',
                    icon: Icons.receipt_long_rounded,
                    currentRoute: Routes.myRequests,
                    onTap: () {
                      Get.back();
                      Get.offNamed(Routes.myRequests);
                    },
                  ),
                DrawerListTileWidget(
                  text: 'Perfil',
                  icon: Icons.person_rounded,
                  currentRoute: Routes.profile,
                  onTap: () {
                    Get.back();
                    Get.offNamed(Routes.profile);
                  },
                ),
                DrawerListTileWidget(
                  text: 'Chat',
                  icon: Icons.chat_rounded,
                  currentRoute: Routes.chat,
                  onTap: () {
                    Get.back();
                    Get.offNamed(Routes.chat);
                  },
                ),
                DrawerListTileWidget(
                  text: 'Salvos',
                  icon: Icons.bookmark_rounded,
                  currentRoute: Routes.saveds,
                  onTap: () {
                    Get.back();
                    Get.toNamed(Routes.saveds);
                  },
                ),
//                DrawerListTileWidget(
//                  text: 'Generate Test',
//                  icon: Icons.generating_tokens_rounded,
//                  currentRoute: Routes.saveds,
//                  onTap: () {
//                    Get.back();
//                    openModalBottomSheet(context,
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceAround,
//                          children: [
//                            componentButtonPicker(
//                                label: 'Clientes',
//                                iconType: Icons.person_search_rounded,
//                                onTap: () {
//                                  generateRandom(2);
//                                }),
//                            componentButtonPicker(
//                                label: 'Profissionais',
//                                iconType: Icons.build_rounded,
//                                onTap: () {
//                                  generateRandom(1);
//                                }),
//                          ],
//                        ),
//                        title: "Gerar perfis de teste",
//                        textButton: "CANCELAR");
//                  },
//                ),
//                DrawerListTileWidget(
//                  text: 'Conteúdos Profissionalizantes',
//                  icon: Icons.local_library_rounded,
//                  currentRoute: Routes.educativeContent,
//                  onTap: () {
//                    Get.back();
//                    Get.offNamed(Routes.educativeContent);
//                  },
//                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 0.75,
            color: appNormalGreyColor,
          ),
          DrawerListTileWidget(
            text: 'Sobre',
            icon: Icons.info_outline_rounded,
            currentRoute: Routes.about,
            onTap: () {
              Get.back();
              Get.offNamed(Routes.about);
            },
          ),
          DrawerListTileWidget(
            text: 'Sair',
            icon: Icons.logout,
            currentRoute: '',
            onTap: () {
              globalAlertDialog(
                  title: 'Tem certeza que deseja sair?',
                  labelActionButton: 'sim',
                  onPressedAction: () async {
                    await logout();
                    Get.offAllNamed(Routes.initial);
                  });
            },
          ),
          const Divider(
            height: 1,
            thickness: 0.75,
            color: appLightGreyColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding16/2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Versão 1.0-mvp',
                  style: appStyle.bodySmall
                      ?.copyWith(color: appNormalGreyColor)),
                Text(
                  'Desenvolvido por (1975494-5)\nMatheus Dal Zot Nora\nTodos os direitos reservados ©',
                  textAlign: TextAlign.center,
                  style: appStyle.bodySmall?.copyWith(color: appNormalGreyColor.withOpacity(0.75))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
